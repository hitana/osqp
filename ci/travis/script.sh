#!/bin/bash
set -e

# Add MKL shared libraries to the path
# This unfortunately does not work in travis OSX if I put the export command
# in the install.sh (it works on linux though)
#export MKL_SHARED_LIB_DIR=`ls -rd ${CONDA_ROOT}/pkgs/*/ | grep mkl-2 | head -n 1`lib:`ls -rd ${CONDA_ROOT}/pkgs/*/ | grep intel-openmp- | head -n 1`lib

#echo "MKL shared library path: ${MKL_SHARED_LIB_DIR}"

#if [[ "${TRAVIS_OS_NAME}" == "linux" ]]; then
#    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MKL_SHARED_LIB_DIR}
#else if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
#    export DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${MKL_SHARED_LIB_DIR}
#fi
#fi


echo "Testing D interface with arguments-> arch=${ARCH}, DFLOAT=${DFLOAT}, DLONG=${DLONG}, USE_EMBEDDED=${USE_EMBEDDED} EMBEDDED=${EMBEDDED}"
cd ${TRAVIS_BUILD_DIR}
rm -rf build
meson -D NDEBUG=true -DUNITTESTS=${UNITTESTS} -DPRINTING=${PRINTING} -DPROFILING=${PROFILING} -DCTRLC=${CTRLC} -DDFLOAT=${DFLOAT} -DDLONG=${DLONG} -DCOVERAGE=${COVERAGE} -DUSE_EMBEDDED=${USE_EMBEDDED} -DEMBEDDED=${EMBEDDED} build
ninja -C build -j8

if [[ "${USE_EMBEDDED}" == false ]]; then
    echo "Running OSQP demo"
    ${TRAVIS_BUILD_DIR}/build/osqp_demo
    echo "Running OSQP tester"
    ${TRAVIS_BUILD_DIR}/build/osqp_tester
fi


# Perform code coverage (only in Linux case)
# ---------------------------------------------------
#if [[ $TRAVIS_OS_NAME == "linux" ]]; then
#    cd ${TRAVIS_BUILD_DIR}/build
#    lcov --directory . --capture -o coverage.info # capture coverage info
#    lcov --remove coverage.info "${TRAVIS_BUILD_DIR}/tests/*" \
#        "${TRAVIS_BUILD_DIR}/lin_sys/direct/qdldl/amd/*" \
#        "${TRAVIS_BUILD_DIR}/lin_sys/direct/qdldl/qdldl_sources/*" \
#        "/usr/include/x86_64-linux-gnu/**/*" \
#        -o coverage.info # filter out tests and unnecessary files
#    lcov --list coverage.info # debug before upload
#    coveralls-lcov coverage.info # uploads to coveralls
#fi

# Valgrind
# ---------------------------------------------------
#if [[ $TRAVIS_OS_NAME == "linux" ]]; then
#    echo "Testing OSQP with valgrind (disabling MKL pardiso for memory allocation issues)"
#    cd ${TRAVIS_BUILD_DIR}
#    rm -rf build
#    #disable PARDISO since intel instructions in MKL cause valgrind 3.11 to fail
#    # cmake -G "Unix Makefiles" -DENABLE_MKL_PARDISO=OFF -DUNITTESTS=ON ..
#    # make
#
#    meson -D ENABLE_MKL_PARDISO=false -D UNITTESTS=true build
#    ninja -C build -j8
#    valgrind --suppressions=${TRAVIS_BUILD_DIR}/.valgrind-suppress.supp --leak-check=full --gen-suppressions=all --track-origins=yes --error-exitcode=42 ${TRAVIS_BUILD_DIR}/build/osqp_tester
#fi


# Test custom memory management
# ---------------------------------------------------
#echo "Test OSQP custom allocators"
#cd ${TRAVIS_BUILD_DIR}
#rm -rf build
#mkdir build
#cd build
#cmake -DUNITTESTS=ON -DOSQP_CUSTOM_MEMORY=${TRAVIS_BUILD_DIR}/tests/custom_memory/custom_memory.h ..
#make osqp_tester_custom_memory
# todo : fails. add -DOSQP_CUSTOM_MEMORY=true
#meson -D UNITTESTS=true -DOSQP_CUSTOM_MEMORY=true -D OSQP_CUSTOM_MEMORY_HEADER=${TRAVIS_BUILD_DIR}/tests/custom_memory/custom_memory.h -D NDEBUG=true build
#ninja -C build -j8 test
#${TRAVIS_BUILD_DIR}/build/osqp_tester_custom_memory


#cd ${TRAVIS_BUILD_DIR}

set +e

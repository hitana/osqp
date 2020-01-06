# Minimum version required
# Project name
project('osqp', 'c', default_options : ['default_library=static'])
add_project_arguments('-lxc++', language: 'c')

c_compiler = meson.get_compiler('c')
system_name = get_option('SYSTEM_NAME')

# Some non-standard CMake modules
# list(['APPEND', 'CMAKE_MODULE_PATH', project_source_dir, '/configure/cmake'])
# include(FindMKL)  # Find MKL module
# Detect operating system
# ----------------------------------------------
# todo : trasfer it to C headers automatically
message(['STATUS', 'We are on a @0@ system'.format(system_name)])
if system_name == 'Linux'
  IS_LINUX = 'ON'
elif system_name == 'Darwin'
  IS_MAC = 'ON'
elif system_name == 'Windows'
  IS_WINDOWS = 'ON'
endif

# Set options
# ----------------------------------------------
# Are unittests generated?
# Is the code generated for embedded platforms?
embedded = get_option('EMBEDDED')
#   1 :   Yes. Matrix update not allowed.
#   2 :   Yes. Matrix update allowed.
#message('embedded=@0@'.format(embedded))

if not embedded
  # message(['STATUS', 'Embedded is OFF'])
else
  # message(['STATUS', 'Embedded is ${EMBEDDED}'])
  # message(['STATUS', 'Disabling printing for embedded'])
  printing = 'OFF'
  # message(['STATUS', 'Disabling profiling for embedded'])
  profiling = 'OFF'
  # message(['STATUS', 'Disabling user interrupt for embedded'])
  ctrlc = 'OFF'
endif

# message(['STATUS', 'User interrupt is ${CTRLC}'])
# Use floats instead of integers
# message(['STATUS', 'Floats are ${DFLOAT}'])
# Use long integers for indexing
dfloat = get_option('DFLOAT')
debug = get_option('DEBUG')

if get_option('CMAKE_SIZEOF_VOID_P') != 8
  # message(['STATUS', 'Disabling long integers (64bit) on 32bit machine'])
  dlong = 'OFF'
endif
# message(['STATUS', 'Long integers (64bit) are ${DLONG}'])
if debug
  debug = 'ON'
  # message(['STATUS', 'Debug mode is ${DEBUG}'])
endif
# Add code coverage
# message(['STATUS', 'Code coverage is ${COVERAGE}'])
# Memory allocators
# ----------------------------------------------
#Report on custom user header options.  This is intended to allow
#users to provide definitions of their own memory functions
# The header should define the functions as follows
#
# define c_malloc mymalloc
# define c_calloc mycalloc
# define c_realloc myrealloc
# define c_free myfree
if get_option('OSQP_CUSTOM_MEMORY')
  # message(['STATUS', 'User custom memory management header: ${OSQP_CUSTOM_MEMORY}'])
endif
# Linear solvers dependencies
# ---------------------------------------------
if dfloat
  # message(['STATUS', 'Disabling MKL Pardiso Solver with floats'])
  enable_mkl_pardiso = 'OFF'
elif embedded
  # message(['STATUS', 'Disabling MKL Pardiso Solver for embedded'])
  enable_mkl_pardiso = 'OFF'
endif
# message(['STATUS', 'MKL Pardiso: ${ENABLE_MKL_PARDISO}'])
# Generate header file with the global options
# ---------------------------------------------
# configure_file([cmake_current_source_dir, '/configure/osqp_configure.h.in', cmake_current_source_dir, '/include/osqp_configure.h', 'NEWLINE_STYLE', 'LF'])
# Set Compiler flags
# ----------------------------------------------




#************************************************************************************
current_source_dir = meson.current_source_dir()
# Add the OSQP headers
osqp_headers = ['include/auxil.h', 
                'include/constants.h', 
                'include/error.h', 
                'include/glob_opts.h', 
                'include/lin_alg.h', 
                'include/osqp.h', 
                #'include/osqp_configure.h', 
                'include/proj.h', 
                'include/scaling.h', 
                'include/types.h', 
                'include/util.h']

# Add the OSQP sources
osqp_src = ['src/auxil.c', 
            'src/error.c', 
            'src/lin_alg.c', 
            'src/osqp.c', 
            'src/proj.c', 
            'src/scaling.c', 
            'src/util.c']

# Add the KKT update only in normal mode and matrix-updating embedded mode (not mode 1)
# todo : make embedded not bool
#if embedded != 1  
if not embedded  
  osqp_src = [osqp_src, 'src/kkt.c']
endif
# Add more files that should only be in non-embedded code
if not embedded
  osqp_src = [osqp_src, 'src/cs.c', 'src/polish.c', 'src/lin_sys.c']
endif
# Add the ctrl-c handler if enabled
if get_option('CTRLC')
  osqp_src = [osqp_src, 'src/ctrlc.c']
endif

message ('osqp_src = @0@'.format(osqp_src))
#************************************************************************************
# Create Static Library

# ----------------------------------------------
# Add linear system solvers cumulative library
subdir('lin_sys')
# Static library
osqpstatic_lib = shared_library('osqpstatic', 
                                osqp_src, 
                                osqp_headers,
                                include_directories: ['include', 'lin_sys/direct/qdldl/', 'lin_sys/direct/qdldl/qdldl_sources/include', 'lin_sys/direct/pardiso'],
                                dependencies: [c_compiler.find_library('m'), c_compiler.find_library('rt'), c_compiler.find_library('dl')],
                                #dependecies: dependency_list    # WARNING: Passed invalid keyword argument "dependecies". WARNING: This will become a hard error in the future.
                                link_with: linsys_solvers
                                )
# Give same name to static library output
# set_target_properties(['osqpstatic', 'PROPERTIES', 'OUTPUT_NAME', 'osqp'])
# ----------------------------------------------

c_compiler = meson.get_compiler('c')
dependency_list = []

# -fPIC
if not get_option('MSVC')
  if get_option('COVERAGE')
    #cmake_c_flags = '${CMAKE_C_FLAGS} --coverage'
    if get_option('FORTRAN')
      #cmake_fortran_flags = '${CMAKE_FORTRAN_FLAGS} --coverage'
    endif
  endif
  if get_option('DEBUG')
    #cmake_c_flags = '${CMAKE_C_FLAGS} -O0 -g'
  else
   # cmake_c_flags = '${CMAKE_C_FLAGS} -O3'
  endif
  #cmake_c_standard_libraries = '${CMAKE_C_STANDARD_LIBRARIES} -lm'
  # Include math
  # Include real time library in linux
  if system_name == 'Linux'
    #cmake_c_standard_libraries = '${CMAKE_C_STANDARD_LIBRARIES} -lrt -ldl'
    dependency_list = [c_compiler.find_library('m'), c_compiler.find_library('rt'), c_compiler.find_library('dl')]
  else
    dependency_list = [c_compiler.find_library('m')]
  endif
endif

# todo : wrong argument in dependecies
message('deps = @0@'.format(dependency_list))
message('msvc = @0@, DEBUG = @1@, FORTRAN= @2@, system_name = @3@'.format(get_option('MSVC'), get_option('DEBUG'), get_option('FORTRAN'), system_name))

# ----------------------------------------------
python = get_option('PYTHON')
matlab = get_option('MATLAB')
r_lang = get_option('R_LANG')
# install(['FILES', osqp_headers, 'DESTINATION', '${CMAKE_INSTALL_INCLUDEDIR}/osqp'])
if matlab
  # target_link_libraries(['osqpstatic', matlab_libraries])
endif
# If we are building Python/Matlab/R interface:
#   - do not build shared library
#   - do not build demo
if not python and not matlab and not r_lang and not embedded
  # Create osqp shared library
  # NB: Add all the linear system solvers here

  osqp_lib = shared_library('osqp', 
                            osqp_src, 
                            osqp_headers,
                            include_directories: ['include', 'lin_sys/direct/qdldl/', 'lin_sys/direct/qdldl/qdldl_sources/include', 'lin_sys/direct/pardiso'],
                            dependencies: [c_compiler.find_library('m'), c_compiler.find_library('rt'), c_compiler.find_library('dl')],
                            #dependecies: dependency_list    # WARNING: Passed invalid keyword argument "dependecies". WARNING: This will become a hard error in the future.                            
                            link_with: linsys_solvers
                            )
  # Install osqp shared library
  # install(['TARGETS', 'osqp', 'EXPORT', project_name, 'LIBRARY', 'DESTINATION', '${CMAKE_INSTALL_LIBDIR}', 'ARCHIVE', 'DESTINATION', '${CMAKE_INSTALL_LIBDIR}', 'RUNTIME', 'DESTINATION', '${CMAKE_INSTALL_BINDIR}'])
  # Create demo executable (linked to static library)
  osqp_demo_exe = executable('osqp_demo', 
                            'examples/osqp_demo.c',
                            include_directories: ['include'],
                            link_with: osqp_lib
                            #link_with: osqpstatic_lib
                            )  
endif
# Create CMake packages for the build directory
# ----------------------------------------------
# todo : review it
# export(['EXPORT', project_name, 'FILE', '${CMAKE_CURRENT_BINARY_DIR}/osqp-targets.cmake', 'NAMESPACE', 'osqp::'])
#if not 'EXISTS', cmake_current_binary_dir, '/osqp-config.cmake'
  # file(['WRITE', cmake_current_binary_dir, '/osqp-config.cmake', 'include(\"\${CMAKE_CURRENT_LIST_DIR}/osqp-targets.cmake\")\n'])
#endif
# Create CMake packages for the install directory
# ----------------------------------------------
configpackagelocation = 'lib/cmake/osqp'
# install(['EXPORT', project_name, 'FILE', 'osqp-targets.cmake', 'NAMESPACE', 'osqp::', 'DESTINATION', configpackagelocation])
# install(['FILES', cmake_current_binary_dir, '/osqp-config.cmake', 'DESTINATION', configpackagelocation])
# Add uninstall command
# ----------------------------------------------
# todo : review it
#if not 'TARGET', 'uninstall'
  # configure_file(['${CMAKE_CURRENT_SOURCE_DIR}/configure/cmake/cmake_uninstall.cmake.in', '${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake', 'IMMEDIATE', '@ONLY'])
  # add_custom_target(['uninstall', 'COMMAND', cmake_command, '-P', cmake_current_binary_dir, '/cmake_uninstall.cmake'])
#endif
# Add testing
# ----------------------------------------------
# Add custom command to generate tests
unittests_opt = get_option('UNITTESTS')
if unittests_opt
  # todo: add checks
   
  # Add test_headers and codegen_test_headers
  subdir('tests')
  # Generating tests.stamp so that the test data are not always generated
  # set(data_timestamp ${PROJECT_SOURCE_DIR}/tests/tests_data.stamp)
  # add_custom_command(['WORKING_DIRECTORY', project_source_dir, '/tests', 'COMMAND', python_executable, 'generate_tests_data.py', 'DEPENDS', project_source_dir, '/tests/generate_tests_data.py', 'OUTPUT', codegen_test_headers, 'COMMENT', 'Generating unittests data files using Python'])
  # Direct linear solver testing
  # include_directories('tests')
  osqp_tester_exe = executable('osqp_tester', 
                               ['/tests/osqp_tester.c', '/tests/osqp_tester.h', '/tests/minunit.h', test_headers, codegen_test_headers],
                               link_with: osqp_lib
                               )
  # target_link_libraries(['osqp_tester', 'osqpstatic'])
  # Add custom memory target
  osqp_tester_custom_memory_exe = executable('osqp_tester_custom_memory', 
                                            #'EXCLUDE_FROM_ALL', 
                                            ['/tests/osqp_tester.c', '/tests/osqp_tester.h', '/tests/minunit.h', test_headers, codegen_test_headers, '/tests/custom_memory/custom_memory.c', '/tests/custom_memory/custom_memory.h'],
                                            link_with: osqp_lib)
  # target_link_libraries(['osqp_tester_custom_memory', 'osqpstatic'])
  # Add testing
  test('NAME', 'tester', 'COMMAND', '$<TARGET_FILE:osqp_tester>')
endif

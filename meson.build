# Minimum version required
# Project name
project('osqp', 'c', default_options : ['default_library=static'])
add_project_arguments('-lxc++', language: 'c')

c_compiler = meson.get_compiler('c')

conf_data = configuration_data({
  'UNITTESTS' : get_option('UNITTESTS'),
  'PRINTING' : get_option('PRINTING'),
  'PROFILING' : get_option('PROFILING'),
  'CTRLC' : get_option('CTRLC'),
  'DFLOAT': get_option('DFLOAT'),
  'DLONG': get_option('DLONG'),
  'DEBUG': get_option('DEBUG'),
  'COVERAGE': get_option('COVERAGE'),
  'ENABLE_MKL_PARDISO': get_option('ENABLE_MKL_PARDISO'),
  #'SYSTEM_NAME': get_option('SYSTEM_NAME'),
  'EMBEDDED': get_option('USE_EMBEDDED'),
  'OSQP_CUSTOM_MEMORY': get_option('OSQP_CUSTOM_MEMORY'),
  'OSQP_CUSTOM_MEMORY_HEADER': get_option('OSQP_CUSTOM_MEMORY_HEADER'),
  'CMAKE_SIZEOF_VOID_P': get_option('CMAKE_SIZEOF_VOID_P'),
  'MATLAB': get_option('MATLAB'),
  'PYTHON': get_option('PYTHON'),
  'R_LANG': get_option('R_LANG'),
  'PYTHON_INCLUDE_DIRS': get_option('PYTHON_INCLUDE_DIRS'),
  'MSVC': get_option('MSVC'),
  'FORTRAN': get_option('FORTRAN')
})

# Detect operating system
# ----------------------------------------------
system_name = get_option('SYSTEM_NAME')
message(['STATUS', 'We are on a @0@ system'.format(system_name)])
if system_name == 'Linux'
  conf_data.set('IS_LINUX', true)
elif system_name == 'Darwin'
  conf_data.set('IS_MAC', true)
elif system_name == 'Windows'
  conf_data.set('IS_WINDOWS', true)
endif

# Set options
# ----------------------------------------------
# Are unittests generated?
# Is the code generated for embedded platforms?
embedded = get_option('EMBEDDED')
#   0 :   Default. Not for embedded platforms.
#   1 :   Yes. Matrix update not allowed.
#   2 :   Yes. Matrix update allowed.

if embedded == '0'
  message(['STATUS', 'Embedded is OFF'])
  conf_data.set('USE_EMBEDDED', false)
else
  message(['STATUS', 'Disabling printing for embedded'])
  conf_data.set('PRINTING', false)
  message(['STATUS', 'Disabling profiling for embedded'])
  conf_data.set('PROFILING', false)
  message(['STATUS', 'Disabling user interrupt for embedded'])
  conf_data.set('CTRLC', false)
  conf_data.set('USE_EMBEDDED', true)

  if embedded == '1'
    conf_data.set('EMBEDDED', 1)
  else
    conf_data.set('EMBEDDED', 2)
  endif
endif
message(['STATUS', 'User interrupt is @0@'.format(get_option('CTRLC'))])

# Use floats instead of integers
message(['STATUS', 'Floats are @0@'.format(get_option('DFLOAT'))])

# Use long integers for indexing
if get_option('CMAKE_SIZEOF_VOID_P') != '8'
  message(['STATUS', 'Disabling long integers (64bit) on 32bit machine'])
  conf_data.set('DLONG', false)
endif
message(['STATUS', 'Long integers (64bit) are @0@'.format(get_option('DLONG'))])


if get_option('DEBUG')
  conf_data.set('DEBUG', true)
  message(['STATUS', 'Debug mode is ON'])
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
  message(['STATUS', 'User custom memory management header: @0@'.format(et_option('OSQP_CUSTOM_MEMORY_HEADER'))])
   
  # TODO: make sure of correct quotes
  conf_data.set('OSQP_CUSTOM_MEMORY', get_option('OSQP_CUSTOM_MEMORY'))
  conf_data.set('OSQP_CUSTOM_MEMORY_HEADER', get_option('OSQP_CUSTOM_MEMORY_HEADER'))
else
  conf_data.set('OSQP_CUSTOM_MEMORY', false)
endif

# Linear solvers dependencies
# ---------------------------------------------
if get_option('DFLOAT')
  message(['STATUS', 'Disabling MKL Pardiso Solver with floats'])
  conf_data.set('ENABLE_MKL_PARDISO', false)
elif embedded != '0'
  message(['STATUS', 'Disabling MKL Pardiso Solver for embedded'])
  conf_data.set('ENABLE_MKL_PARDISO', false)
endif
message(['STATUS', 'MKL Pardiso: @0@'.format(conf_data.get('ENABLE_MKL_PARDISO', false))])

# Generate header file with the global options
# ---------------------------------------------
configure_file(input : 'configure/osqp_configure.h.in',
  output : 'osqp_configure.h',
  configuration : conf_data)

# todo : get build directory name here
run_command('cp', 'build/osqp_configure.h', 'include/osqp_configure.h')


# Set Compiler flags
c_compiler = meson.get_compiler('c')
# ----------------------------------------------
# todo : set some default CMAKE_C_FLAGS|CMAKE_FORTRAN_FLAGS|CMAKE_C_STANDARD_LIBRARIES
c_args = []
gcov_lib = []
rt_lib = []
m_lib = []
dl_lib = []
if not conf_data.get('MSVC')
  if conf_data.get('COVERAGE')
    c_args += '--coverage'
    gcov_lib = c_compiler.find_library('gcov')
    #c_args += '-fprofile-arcs -ftest-coverage --enable-profile -lgcov'
	  if conf_data.get('FORTRAN')
      #c_args += '--coverage'
	  endif
  endif

  if conf_data.get('DEBUG')
    c_args += '-O0 -g'
  else
    c_args += '-O3'
  endif

  # Include math
  #c_args += '-lm'
  m_lib = c_compiler.find_library('m')
  if system_name == 'Linux'
    # Include real time library in linux
    #c_args += '-lrt -ldl'
    rt_lib = c_compiler.find_library('rt')
    dl_lib = c_compiler.find_library('dl')
  endif
endif

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
# todo : EMBEDDED also requires these files
#if embedded != '1'
  osqp_src += 'src/kkt.c'
#endif
# Add more files that should only be in non-embedded code
# todo : EMBEDDED also requires these files
#if not conf_data.get('USE_EMBEDDED')
  osqp_src += ['src/cs.c', 'src/polish.c', 'src/lin_sys.c']
#endif
# Add the ctrl-c handler if enabled
if conf_data.get('CTRLC')
  osqp_src += 'src/ctrlc.c'
endif

#************************************************************************************
# Create Static Library

# ----------------------------------------------
# Add linear system solvers cumulative library
subdir('lin_sys')
# Static library
# '.' include directory is for generated osqp_configure.h
osqpstatic_lib = shared_library('osqpstatic', 
                                osqp_src, 
                                osqp_headers,
                                include_directories: ['include', 'lin_sys/direct/qdldl/', 'lin_sys/direct/qdldl/qdldl_sources/include', 'lin_sys/direct/pardiso', '.'],
                                #dependencies: [c_compiler.find_library('m'), c_compiler.find_library('rt'), c_compiler.find_library('dl'), c_compiler.find_library('gcov')],
                                dependencies: [m_lib, rt_lib, dl_lib, gcov_lib],
                                #dependecies: dependency_list    # WARNING: Passed invalid keyword argument "dependecies". WARNING: This will become a hard error in the future.
                                link_with: linsys_solvers,
                                c_args: c_args
                                )
# Give same name to static library output
# set_target_properties(['osqpstatic', 'PROPERTIES', 'OUTPUT_NAME', 'osqp'])
# ----------------------------------------------

# ----------------------------------------------
python = conf_data.get('PYTHON')
matlab = conf_data.get('MATLAB')
r_lang = conf_data.get('R_LANG')
# install(['FILES', osqp_headers, 'DESTINATION', '${CMAKE_INSTALL_INCLUDEDIR}/osqp'])
if matlab
  # target_link_libraries(['osqpstatic', matlab_libraries])
endif
# If we are building Python/Matlab/R interface:
#   - do not build shared library
#   - do not build demo
if not python and not matlab and not r_lang and (embedded == '0')
  # Create osqp shared library
  # NB: Add all the linear system solvers here

  osqp_lib = shared_library('osqp', 
                            osqp_src, 
                            osqp_headers,
                            include_directories: ['include', 'lin_sys/direct/qdldl/', 'lin_sys/direct/qdldl/qdldl_sources/include', 'lin_sys/direct/pardiso'],
                            #dependencies: [c_compiler.find_library('m'), c_compiler.find_library('rt'), c_compiler.find_library('dl'), gcov_lib],
                            dependencies: [m_lib, rt_lib, dl_lib, gcov_lib],
                            #dependecies: dependency_list    # WARNING: Passed invalid keyword argument "dependecies". WARNING: This will become a hard error in the future.                            
                            link_with: linsys_solvers,
                            c_args: c_args
                            )
  # Install osqp shared library
  # install(['TARGETS', 'osqp', 'EXPORT', project_name, 'LIBRARY', 'DESTINATION', '${CMAKE_INSTALL_LIBDIR}', 'ARCHIVE', 'DESTINATION', '${CMAKE_INSTALL_LIBDIR}', 'RUNTIME', 'DESTINATION', '${CMAKE_INSTALL_BINDIR}'])
  # Create demo executable (linked to static library)
  osqp_demo_exe = executable('osqp_demo', 
                            'examples/osqp_demo.c',
                            include_directories: ['include'],
                            dependencies: [gcov_lib],
                            link_with: osqp_lib,
                            #link_with: osqpstatic_lib,
                            c_args: c_args
                            )  
endif

# ----------------------------------------------
# Add custom command to generate tests
if conf_data.get('UNITTESTS')

  # Add test_headers and codegen_test_headers
  subdir('tests')
  # Generating tests.stamp so that the test data are not always generated
  # set(data_timestamp ${PROJECT_SOURCE_DIR}/tests/tests_data.stamp)
  # add_custom_command(['WORKING_DIRECTORY', project_source_dir, '/tests', 'COMMAND', python_executable, 'generate_tests_data.py', 'DEPENDS', project_source_dir, '/tests/generate_tests_data.py', 'OUTPUT', codegen_test_headers, 'COMMENT', 'Generating unittests data files using Python'])
  # Direct linear solver testing
  # include_directories('tests')
  osqp_tester_exe = executable('osqp_tester', 
                               ['tests/osqp_tester.c', 'tests/osqp_tester.h', 'tests/minunit.h', test_headers, codegen_test_headers],
                               include_directories: ['include', 'tests'],
                               dependencies: [gcov_lib],
                               link_with: osqpstatic_lib,
                               c_args: c_args
                               )
  
  # Add custom memory target
  osqp_tester_custom_memory_exe = executable('osqp_tester_custom_memory', 
                                            #'EXCLUDE_FROM_ALL', 
                                            ['tests/osqp_tester.c', 'tests/osqp_tester.h', 'tests/minunit.h', 
                                            test_headers, codegen_test_headers, 
                                            'tests/custom_memory/custom_memory.c', 'tests/custom_memory/custom_memory.h'],
                                            include_directories: ['include', 'tests'],
                                            dependencies: [gcov_lib],
                                            link_with: osqpstatic_lib,
                                            c_args: c_args
                                            )
  test('osqp_tester', osqp_tester_exe)
  test('osqp_tester_custom_memory', osqp_tester_custom_memory_exe)
endif

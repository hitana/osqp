# Add qdldl
#subdir('qdldl_sources')
current_source_dir = meson.current_source_dir()
qdldl_interface_src = ['qdldl_interface.h', 'qdldl_interface.c']
if embedded == '0'
  amd_sources = ['amd/include/amd_internal.h', 
				'amd/include/amd.h', 
				'amd/include/SuiteSparse_config.h', 
				'amd/src/amd_1.c', 
				'amd/src/amd_2.c', 
				'amd/src/amd_aat.c', 
				'amd/src/amd_control.c', 
				'amd/src/amd_defaults.c', 
				'amd/src/amd_info.c', 
				'amd/src/amd_order.c', 
				'amd/src/amd_post_tree.c', 
				'amd/src/amd_postorder.c', 
				'amd/src/amd_preprocess.c', 
				'amd/src/amd_valid.c', 
				'amd/src/SuiteSparse_config.c']

  qdldl_interface_src += amd_sources
endif

# Create object library for linear system solver interface
message ('making object library linsys_qdldl_lib ...')
linsys_qdldl_lib = library('linsys_qdldl', 
                            qdldl_interface_src,
							include_directories: ['../../../include', '../../../configure', 'amd/include', 'qdldl_sources/include'])

# Generate header file with the global options
# ---------------------------------------------
conf_qdldl = configuration_data()

# numeric types
if conf_data.get('DFLOAT')
  conf_qdldl.set('QDLDL_FLOAT_TYPE', 'float')
else
  conf_qdldl.set('QDLDL_FLOAT_TYPE', 'double')
endif
if conf_data.get('DLONG')
  conf_qdldl.set('QDLDL_INT_TYPE', 'long long')
  conf_qdldl.set('QDLDL_INT_TYPE_MAX', 'LLONG_MAX')
else
  conf_qdldl.set('QDLDL_INT_TYPE', 'int')
  conf_qdldl.set('QDLDL_INT_TYPE_MAX', 'INT_MAX')
endif
#boolean type is always unsigned char
#for now, since _Bool does not exist in
#C89 and we want to avoid interoperability
#problems when calling QDLDL from C++
conf_qdldl.set('QDLDL_BOOL_TYPE', 'unsigned char')

configure_file(input : 'qdldl_sources/configure/qdldl_types.h.in',
  output : 'qdldl_types.h',
  configuration : conf_qdldl)

# todo : get build directory name here
run_command('cp', '../../../build/lin_sys/direct/qdldl/qdldl_types.h', 'qdldl_sources/include/qdldl_types.h')


# Set sources
# ----------------------------------------------
qdldl_src = 'qdldl_sources/src/qdldl.c'
qdldl_headers = ['qdldl_sources/include/qdldl.h']

# Create object library
message ('making object library qdldlobject_lib ...')
# ----------------------------------------------
qdldlobject_lib = library('qdldlobject', 
                          qdldl_src, 
						  qdldl_headers,
						  include_directories: ['qdldl_sources/include'],
						  c_args: c_args)

# ----------------------------------------------
# Create Static Library
message ('making static_library qdldlstatic_lib ...')
qdldlstatic_lib = static_library('qdldlstatic', 
                                qdldl_src, 
                                qdldl_headers,
                            	include_directories: ['qdldl_sources/include'],
								c_args: c_args)
# Give same name to static library output
# set_target_properties(['qdldlstatic', 'PROPERTIES', 'OUTPUT_NAME', 'qdldl'])
# Install Static Library
# install(['TARGETS', 'qdldlstatic', 'EXPORT', project_name, 'ARCHIVE', 'DESTINATION', '${CMAKE_INSTALL_LIBDIR}', 'LIBRARY', 'DESTINATION', '${CMAKE_INSTALL_LIBDIR}', 'RUNTIME', 'DESTINATION', '${CMAKE_INSTALL_BINDIR}'])

# ----------------------------------------------
# Create qdldl shared library
message ('making shared_library qdldlstqdldl_libatic_lib ...')
qdldl_lib = shared_library('qdldl', 
                           qdldl_src, 
                           qdldl_headers,
						   include_directories: ['qdldl_sources/include'],
						   dependencies: [meson.get_compiler('c').find_library('gcov')],
						   c_args: c_args)
# Install qdldl shared library
# install(['TARGETS', 'qdldl', 'EXPORT', project_name, 'LIBRARY', 'DESTINATION', '${CMAKE_INSTALL_LIBDIR}', 'ARCHIVE', 'DESTINATION', '${CMAKE_INSTALL_LIBDIR}', 'RUNTIME', 'DESTINATION', '${CMAKE_INSTALL_BINDIR}'])

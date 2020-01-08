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
# numeric types
if conf_data.get('DFLOAT')
  qdldl_float_type = 'float'
else
  qdldl_float_type = 'double'
endif
if conf_data.get('DLONG')
  qdldl_int_type = 'long long'
  qdldl_int_type_max = 'LLONG_MAX'
else
  qdldl_int_type = 'int'
  qdldl_int_type_max = 'INT_MAX'
endif
#boolean type is always unsigned char
#for now, since _Bool does not exist in
#C89 and we want to avoid interoperability
#problems when calling QDLDL from C++
qdldl_bool_type = 'unsigned char'
# configure_file([cmake_current_source_dir, '/configure/qdldl_types.h.in', cmake_current_source_dir, '/include/qdldl_types.h', 'NEWLINE_STYLE', 'LF'])
# Set sources
# ----------------------------------------------
qdldl_src = 'qdldl_sources/src/qdldl.c'

#'include/qdldl_types.h'
qdldl_headers = ['qdldl_sources/include/qdldl.h', 'qdldl_sources/include/qdldl_types.h']
# Create object library
message ('making object library qdldlobject_lib ...')
# ----------------------------------------------
qdldlobject_lib = library('qdldlobject', 
                          qdldl_src, 
						  qdldl_headers,
						  include_directories: ['qdldl_sources/include'])
# target_include_directories(['qdldlobject', 'PRIVATE', project_source_dir, '/include'])
# Create Static Library
# ----------------------------------------------
# Static library
message ('making static_library qdldlstatic_lib ...')
qdldlstatic_lib = static_library('qdldlstatic', 
                                qdldl_src, 
                                qdldl_headers,
                            	include_directories: ['qdldl_sources/include'])
# Give same name to static library output
# set_target_properties(['qdldlstatic', 'PROPERTIES', 'OUTPUT_NAME', 'qdldl'])
# Declare include directories for the cmake exported target
# target_include_directories(['qdldlstatic', 'PUBLIC', '$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>', '$<INSTALL_INTERFACE:$<INSTALL_PREFIX>/${CMAKE_INSTALL_INCLUDEDIR}/qdldl>'])
# Install Static Library
# ----------------------------------------------
# install(['TARGETS', 'qdldlstatic', 'EXPORT', project_name, 'ARCHIVE', 'DESTINATION', '${CMAKE_INSTALL_LIBDIR}', 'LIBRARY', 'DESTINATION', '${CMAKE_INSTALL_LIBDIR}', 'RUNTIME', 'DESTINATION', '${CMAKE_INSTALL_BINDIR}'])
# Install Headers
# ----------------------------------------------
# install(['FILES', qdldl_headers, 'DESTINATION', '${CMAKE_INSTALL_INCLUDEDIR}/qdldl'])
# Install Shared Library
# ----------------------------------------------
# Create qdldl shared library
message ('making shared_library qdldlstqdldl_libatic_lib ...')
qdldl_lib = shared_library('qdldl', 
                           qdldl_src, 
                           qdldl_headers,
						   include_directories: ['qdldl_sources/include'])
# Declare include directories for the cmake exported target
# target_include_directories(['qdldl', 'PUBLIC', '$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>', '$<INSTALL_INTERFACE:$<INSTALL_PREFIX>/${CMAKE_INSTALL_INCLUDEDIR}/qdldl>'])
# Install qdldl shared library
# install(['TARGETS', 'qdldl', 'EXPORT', project_name, 'LIBRARY', 'DESTINATION', '${CMAKE_INSTALL_LIBDIR}', 'ARCHIVE', 'DESTINATION', '${CMAKE_INSTALL_LIBDIR}', 'RUNTIME', 'DESTINATION', '${CMAKE_INSTALL_BINDIR}'])

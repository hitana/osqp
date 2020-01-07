
# Direct solver
subdir('direct')
# Add linsys handler if not embedded
linsys_lib_handler = []
if embedded == 0
  message ('making static_library linsys_lib_handler ...')
  linsys_lib_handler = static_library('linsys_lib_handler', 
                                ['lib_handler.c'], 
                                ['lib_handler.h'],
                                include_directories: ['../include', 'direct/qdldl']
                            	  )
                        
endif
# Combine solvers
# TODO: Add indirect ones
# Add library handler if desktop version
linsys_solvers = [direct_linsys_solvers, linsys_lib_handler]
# Combine solvers external libraries
linsys_solvers_includes = [direct_linsys_solvers_includes]

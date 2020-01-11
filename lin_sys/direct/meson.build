current_source_dir = meson.current_source_dir()

# Add direct linear systems solvers
# -------------------------
subdir('qdldl')

# Need to add qdldlobject only here because it cannot be included in another object library such as linsys_qdldl
direct_linsys_solvers = [linsys_qdldl_lib, qdldlobject_lib]

# Add other solvers if embedded option is false
if embedded == '0'
  # If MKL Pardiso is enabled, include pardiso directory
  if conf_data.get('ENABLE_MKL_PARDISO')
    # Add Pardiso interface
    message ('making library linsys_pardiso_lib ...')
    linsys_pardiso_lib = library('linsys_pardiso', 
                                 ['pardiso/pardiso_interface.c', 'pardiso/pardiso_loader.c'],
                                 include_directories: ['pardiso', '../../include', '../'],
                                 c_args: c_args)
    
	  direct_linsys_solvers = [direct_linsys_solvers, linsys_pardiso_lib]
  endif
endif

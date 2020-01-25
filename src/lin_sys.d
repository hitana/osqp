
import types;
import glob_opts;
import constants;
import qdldl_interface;  // Include only this solver in the same directory

 enum LINSYS_SOLVER_NAME = [  // const char * []
  "qdldl", "mkl pardiso"
 ];

version(ENABLE_MKL_PARDISO){
//# include "pardiso_interface.h"
//# include "pardiso_loader.h"
import pardiso_interface;
import pardiso_loader;
} /* ifdef ENABLE_MKL_PARDISO */

// Load linear system solver shared library
c_int load_linsys_solver(linsys_solver_type linsys_solver) {
  switch (linsys_solver) {
  case QDLDL_SOLVER:

    // We do not load  QDLDL solver. We have the source.
    return 0;

version(ENABLE_MKL_PARDISO){
  case MKL_PARDISO_SOLVER:

    // Load Pardiso library
    return lh_load_pardiso(OSQP_NULL);

} /* ifdef ENABLE_MKL_PARDISO */
  default: // QDLDL
    return 0;
  }
}

// Unload linear system solver shared library
c_int unload_linsys_solver(linsys_solver_type linsys_solver) {
  switch (linsys_solver) {
  case QDLDL_SOLVER:

    // We do not load QDLDL solver. We have the source.
    return 0;

version(ENABLE_MKL_PARDISO){
  case MKL_PARDISO_SOLVER:

    // Unload Pardiso library
    return lh_unload_pardiso();

} /* ifdef ENABLE_MKL_PARDISO */
  default: //  QDLDL
    return 0;
  }
}

// Initialize linear system solver structure
// NB: Only the upper triangular part of P is stuffed!
c_int init_linsys_solver(LinSysSolver          **s,
                         const csc              *P,
                         const csc              *A,
                         c_float                 sigma,
                         const c_float          *rho_vec,
                         linsys_solver_type      linsys_solver,
                         c_int                   polish) {
  switch (linsys_solver) {
  case QDLDL_SOLVER:
    return init_linsys_solver_qdldl(cast(qdldl_solver **)s, P, A, sigma, rho_vec, polish);

version(ENABLE_MKL_PARDISO){
  case MKL_PARDISO_SOLVER:
    return init_linsys_solver_pardiso(cast(pardiso_solver **)s, P, A, sigma, rho_vec, polish);

} /* ifdef ENABLE_MKL_PARDISO */
  default: // QDLDL
    return init_linsys_solver_qdldl(cast(qdldl_solver **)s, P, A, sigma, rho_vec, polish);
  }
}

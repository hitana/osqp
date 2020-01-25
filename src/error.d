import types;
import glob_opts;
import constants;

/* OSQP error macro */
//# if __STDC_VERSION__ >= 199901L      // true
/* The C99 standard gives the __func__ macro, which is preferred over __FUNCTION__ */


//#  define osqp_error(error_code) _osqp_error(error_code, __func__);
// todo : review it
alias _osqp_error = osqp_error;

//#else
//#  define osqp_error(error_code) _osqp_error(error_code, __FUNCTION__);
//#endif

enum OSQP_ERROR_MESSAGE = [  // const char *[] 
  "Problem data validation.",
  "Solver settings validation.",
  //"Linear system solver not available.\nTried to obtain it from shared library.",
  "Linear system solver not available. Tried to obtain it from shared library.",
  "Linear system solver initialization.",
  //"KKT matrix factorization.\nThe problem seems to be non-convex.",
  "KKT matrix factorization. The problem seems to be non-convex.",
  "Memory allocation.",
  "Solver workspace not initialized."
];

c_int _osqp_error(osqp_error_type error_code,
		 const char * function_name) {
version(PRINTING){
  c_print("ERROR in %s: %s\n", function_name, OSQP_ERROR_MESSAGE[error_code-1]);
}
  return cast(c_int)error_code;
}


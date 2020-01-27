module error;

nothrow @nogc extern(C):

import types;
import glob_opts;
import constants;

/* OSQP error macro */
//# if __STDC_VERSION__ >= 199901L      // true
/* The C99 standard gives the __func__ macro, which is preferred over __FUNCTION__ */
//#  define osqp_error(error_code) _osqp_error(error_code, __func__);
//#else
//#  define osqp_error(error_code) _osqp_error(error_code, __FUNCTION__);
//#endif

string[7] OSQP_ERROR_MESSAGE = [
  "Problem data validation.",
  "Solver settings validation.",
  "Linear system solver not available.\nTried to obtain it from shared library.",
  "Linear system solver initialization.",
  "KKT matrix factorization.\nThe problem seems to be non-convex.",
  "Memory allocation.",
  "Solver workspace not initialized."
];

import core.stdc.stdarg;
import core.vararg;
//c_int _osqp_error(osqp_error_type error_code, const char * function_name)
c_int _osqp_error(osqp_error_type error_code, ...)
{
version(PRINTING){  
  char * function_name = va_arg!(char * )(_argptr);
  char * text = cast(char*)(OSQP_ERROR_MESSAGE[error_code-1]);
  c_print("ERROR in %s: %s\n", function_name, text));
}
  return cast(c_int)error_code;
}

//#  define osqp_error(error_code) _osqp_error(error_code, __func__);
// todo : review it
alias osqp_error = _osqp_error;


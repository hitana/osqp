#ifndef OSQP_CONFIGURE_H
# define OSQP_CONFIGURE_H

# ifdef __cplusplus
extern "C" {
# endif /* ifdef __cplusplus */

/* DEBUG */
#define DEBUG

/* Operating system */
// vika : todo - set automatically
#define IS_LINUX
//#define IS_MAC
//#define IS_WINDOWS

/* EMBEDDED */
//#define EMBEDDED

/* PRINTING */
//#define PRINTING

/* PROFILING */
//#define PROFILING

/* CTRLC */
//#define CTRLC

/* DFLOAT */
#define DFLOAT

/* DLONG */
#define DLONG

/* ENABLE_MKL_PARDISO */
#define ENABLE_MKL_PARDISO

/* MEMORY MANAGEMENT */
//#define OSQP_CUSTOM_MEMORY
//#ifdef OSQP_CUSTOM_MEMORY
//#include "@OSQP_CUSTOM_MEMORY@"
//#endif

// vika
#define c_malloc malloc
#define c_calloc calloc
#define c_realloc realloc
#define c_free free


# ifdef __cplusplus
}
# endif /* ifdef __cplusplus */

#endif /* ifndef OSQP_CONFIGURE_H */

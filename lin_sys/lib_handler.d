module lib_handler;

import glob_opts;
//#include <ctype.h> // Needed for tolower functions

import constants;
import util;

version(IS_WINDOWS){
//#include <windows.h>
alias soHandle_t = HINSTANCE;
} else {
//#include <unistd.h>
//#include <dlfcn.h>
// todo
alias soHandle_t = void *;
}

version(IS_WINDOWS)
{
    enum string SHAREDLIBEXT = "dll";
} else {
    version(IS_MAC){
        enum string SHAREDLIBEXT = "dylib";
    } else {
    enum string SHAREDLIBEXT = "so";
    }
}

enum OSQP_NULL = null;

soHandle_t lh_load_lib(const char *libName) {
    soHandle_t h = OSQP_NULL;

    if (!libName) {
        version(PRINTING){
        c_eprint("no library name given");
        }
        return OSQP_NULL;
    }

version(IS_WINDOWS){
    h = LoadLibrary (libName);
    if (!h) {
        version(PRINTING){
        c_eprint("Windows error while loading dynamic library %s, error = %d",
                libName, cast(int)GetLastError());
        }
    }
} else {
    h = dlopen (libName, RTLD_LAZY);
    if (!h) {
        version(PRINTING){
        c_eprint("Error while loading dynamic library %s: %s", libName, dlerror());
        }
    }
}

    return h;
} /* lh_load_lib */


c_int lh_unload_lib (soHandle_t h) {
    c_int rc = 1;

version (IS_WINDOWS){
    rc = FreeLibrary (h);
    rc = ! rc;
} else {
    rc = dlclose (h);
}

    return rc;
} /* LSL_unLoadLib */


version (IS_WINDOWS){
    alias symtype = FARPROC;
} else {
    //typedef void* symtype;
    alias symtype = void*;
}
/** Loads a symbol from a dynamically linked library.
 * This function is not defined in the header to allow a workaround for the problem that dlsym returns an object instead of a function pointer.
 * However, Windows also needs special care.
 *
 * The method does six attempts to load the symbol. Next to its given name, it also tries variations of lower case and upper case form and with an extra underscore.
 * @param h Handle of dynamically linked library.
 * @param symName Name of the symbol to load.
 * @return A pointer to the symbol, or OSQP_NULL if not found.
 */
symtype lh_load_sym (soHandle_t h, const char *symName) {
    symtype s;
    const char *from;
    char *to;
    const char *tripSym;
    char* err;
    char [257] lcbuf;
    char [257]ucbuf;
    char [257]ocbuf;
    size_t symLen;
    int trip;

    s = OSQP_NULL;
    err = OSQP_NULL;

    /* search in this order:
     *  1. original
     *  2. lower_
     *  3. upper_
     *  4. original_
     *  5. lower
     *  6. upper
     */

    symLen = 0;
    for (trip = 1;  trip <= 6;  trip++) {
        switch (trip) {
        case 1:                             /* original */
            tripSym = symName;
            break;
        case 2:                             /* lower_ */
            for (from = symName, to = lcbuf;  *from;  from++, to++) {
                *to = tolower(*from);
            }
            symLen = from - symName;
            *to++ = '_';
            *to = '\0';
            tripSym = lcbuf;
            break;
        case 3:                             /* upper_ */
            for (from = symName, to = ucbuf;  *from;  from++, to++) {
                *to = toupper(*from);
            }
            *to++ = '_';
            *to = '\0';
            tripSym = ucbuf;
            break;
        case 4:                             /* original_ */
            c_strcpy(ocbuf, symName);
            ocbuf[symLen] = '_';
            ocbuf[symLen+1] = '\0';
            tripSym = ocbuf;
            break;
        case 5:                             /* lower */
            lcbuf[symLen] = '\0';
            tripSym = lcbuf;
            break;
        case 6:                             /* upper */
            ucbuf[symLen] = '\0';
            tripSym = ucbuf;
            break;
        default:
            tripSym = symName;
        } /* end switch */
version(IS_WINDOWS){
        s = GetProcAddress (h, tripSym);
        if (s) {
            return s;
        } else {
            version(PRINTING){
            c_eprint("Cannot find symbol %s in dynamic library, error = %d",
                    symName, cast(int)GetLastError());
            }
        }
} else {
        s = dlsym (h, tripSym);
        err = dlerror();  /* we have only one chance; a successive call to dlerror() returns OSQP_NULL */
        if (err) {
            version(PRINTING){
            c_eprint("Cannot find symbol %s in dynamic library, error = %s",
                    symName, err);
            }
        } else {
            return s;
        }
}
    } /* end loop over symbol name variations */

    return OSQP_NULL;
} /* lh_load_sym */

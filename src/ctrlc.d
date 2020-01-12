/*
 * Implements signal handling (ctrl-c) for OSQP.
 *
 * Under Windows, we use SetConsoleCtrlHandler.
 * Under Unix systems, we use sigaction.
 * For Mex files, we use utSetInterruptEnabled/utIsInterruptPending.
 *
 */

import glob_opts;

version(MATLAB)
{
/* No header file available here; define the prototypes ourselves */
  //bool utIsInterruptPending(void);
  //bool utSetInterruptEnabled(bool);
}
else {
  version(IS_WINDOWS){  // todo : use native Windows
    /* Use Windows SetConsoleCtrlHandler for signal handling */
    //#  include <windows.h>
    import windows;
  }
  else {
    /* Use sigaction for signal handling on non-Windows machines */
    //#  include <signal.h>
    import signal;
  }
}


version(MATLAB)
{
  static int istate;

  void osqp_start_interrupt_listener(void) {
    istate = utSetInterruptEnabled(1);
  }

  void osqp_end_interrupt_listener(void) {
    utSetInterruptEnabled(istate);
  }

  int osqp_is_interrupted(void) {
    return utIsInterruptPending();
  }
}
else {
  version(IS_WINDOWS)  // todo : use native Windows
  {
    static int int_detected;
    static BOOL WINAPI handle_ctrlc(DWORD dwCtrlType) {
      if (dwCtrlType != CTRL_C_EVENT) return FALSE;

      int_detected = 1;
      return TRUE;
    }

    void osqp_start_interrupt_listener(void) {
      int_detected = 0;
      SetConsoleCtrlHandler(handle_ctrlc, TRUE);
    }

    void osqp_end_interrupt_listener(void) {
      SetConsoleCtrlHandler(handle_ctrlc, FALSE);
    }

    int osqp_is_interrupted(void) {
      return int_detected;
    }
  }
  else { /* Unix */

    //# include <signal.h>
    import signal;
    static int int_detected;
    struct sigaction oact;
    static void handle_ctrlc(int dummy) {
      int_detected = dummy ? dummy : -1;
    }

    void osqp_start_interrupt_listener(void) {
      struct sigaction act;

      int_detected = 0;
      act.sa_flags = 0;
      sigemptyset(&act.sa_mask);
      act.sa_handler = handle_ctrlc;
      sigaction(SIGINT, &act, &oact);
    }

    void osqp_end_interrupt_listener(void) {
      struct sigaction act;

      sigaction(SIGINT, &oact, &act);
    }

    int osqp_is_interrupted(void) {
      return int_detected;
    }
  }
}  /* END IF IS_MATLAB / WINDOWS */
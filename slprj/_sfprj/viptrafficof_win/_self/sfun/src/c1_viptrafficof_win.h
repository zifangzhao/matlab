#ifndef __c1_viptrafficof_win_h__
#define __c1_viptrafficof_win_h__

/* Include files */
#include "sfc_sf.h"
#include "sfc_mex.h"
#include "rtwtypes.h"

/* Type Definitions */
typedef struct {
  uint8_T c1_is_active_c1_viptrafficof_win;
  real_T c1_scaleFactor;
  SimStruct *S;
  ChartInfoStruct chartInfo;
  real_T c1_first_time;
  boolean_T c1_first_time_not_empty;
  real_T c1_X[713];
  boolean_T c1_X_not_empty;
  real_T c1_Y[713];
  boolean_T c1_Y_not_empty;
  real_T c1_RV[23];
  boolean_T c1_RV_not_empty;
  real_T c1_CV[31];
  boolean_T c1_CV_not_empty;
} SFc1_viptrafficof_winInstanceStruct;

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c1_viptrafficof_win_get_eml_resolved_functions_info
  (void);

/* Function Definitions */
extern void sf_c1_viptrafficof_win_get_check_sum(mxArray *plhs[]);
extern void c1_viptrafficof_win_method_dispatcher(SimStruct *S, int_T method,
  void *data);

#endif

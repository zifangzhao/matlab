/* Include files */

#include "blascompat32.h"
#include "viptrafficof_win_sfun.h"
#include "c1_viptrafficof_win.h"

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
static void initialize_c1_viptrafficof_win(SFc1_viptrafficof_winInstanceStruct
  *chartInstance);
static void initialize_params_c1_viptrafficof_win
  (SFc1_viptrafficof_winInstanceStruct *chartInstance);
static void enable_c1_viptrafficof_win(SFc1_viptrafficof_winInstanceStruct
  *chartInstance);
static void disable_c1_viptrafficof_win(SFc1_viptrafficof_winInstanceStruct
  *chartInstance);
static const mxArray *get_sim_state_c1_viptrafficof_win
  (SFc1_viptrafficof_winInstanceStruct *chartInstance);
static void set_sim_state_c1_viptrafficof_win
  (SFc1_viptrafficof_winInstanceStruct *chartInstance, const mxArray *c1_st);
static void finalize_c1_viptrafficof_win(SFc1_viptrafficof_winInstanceStruct
  *chartInstance);
static void sf_c1_viptrafficof_win(SFc1_viptrafficof_winInstanceStruct
  *chartInstance);
static void c1_chartstep_c1_viptrafficof_win(SFc1_viptrafficof_winInstanceStruct
  *chartInstance);
static void initSimStructsc1_viptrafficof_win
  (SFc1_viptrafficof_winInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c1_machineNumber, uint32_T
  c1_chartNumber);
static void c1_meshgrid(SFc1_viptrafficof_winInstanceStruct *chartInstance,
  real_T c1_x[31], real_T c1_y[23], real_T c1_xx[713], real_T c1_yy[713]);
static void c1_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_vel_Lines, const char_T *c1_identifier,
  real32_T c1_y[2852]);
static void c1_b_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId,
  real32_T c1_y[2852]);
static void c1_c_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_b_CV, const char_T *c1_identifier, real_T
  c1_y[31]);
static void c1_d_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId,
  real_T c1_y[31]);
static void c1_e_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_b_RV, const char_T *c1_identifier, real_T
  c1_y[23]);
static void c1_f_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId,
  real_T c1_y[23]);
static void c1_g_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_b_X, const char_T *c1_identifier, real_T
  c1_y[713]);
static void c1_h_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId,
  real_T c1_y[713]);
static void c1_i_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_b_Y, const char_T *c1_identifier, real_T
  c1_y[713]);
static void c1_j_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId,
  real_T c1_y[713]);
static real_T c1_k_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_b_first_time, const char_T *c1_identifier);
static real_T c1_l_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId);
static uint8_T c1_m_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_b_is_active_c1_viptrafficof_win, const
  char_T *c1_identifier);
static uint8_T c1_n_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId);
static void init_dsm_address_info(SFc1_viptrafficof_winInstanceStruct
  *chartInstance);

/* Function Definitions */
static void initialize_c1_viptrafficof_win(SFc1_viptrafficof_winInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c1_first_time_not_empty = FALSE;
  chartInstance->c1_X_not_empty = FALSE;
  chartInstance->c1_Y_not_empty = FALSE;
  chartInstance->c1_RV_not_empty = FALSE;
  chartInstance->c1_CV_not_empty = FALSE;
  chartInstance->c1_is_active_c1_viptrafficof_win = 0U;
}

static void initialize_params_c1_viptrafficof_win
  (SFc1_viptrafficof_winInstanceStruct *chartInstance)
{
  real_T c1_d0;
  sf_set_error_prefix_string(
    "Error evaluating data 'scaleFactor' in the parent workspace.\n");
  sf_mex_import_named("scaleFactor", sf_mex_get_sfun_param(chartInstance->S, 0,
    0), &c1_d0, 0, 0, 0U, 0, 0U, 0);
  chartInstance->c1_scaleFactor = c1_d0;
  sf_set_error_prefix_string("Stateflow Runtime Error (chart): ");
}

static void enable_c1_viptrafficof_win(SFc1_viptrafficof_winInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c1_viptrafficof_win(SFc1_viptrafficof_winInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static const mxArray *get_sim_state_c1_viptrafficof_win
  (SFc1_viptrafficof_winInstanceStruct *chartInstance)
{
  const mxArray *c1_st;
  const mxArray *c1_y = NULL;
  int32_T c1_i0;
  real32_T c1_u[2852];
  const mxArray *c1_b_y = NULL;
  real_T c1_b_u[31];
  const mxArray *c1_c_y = NULL;
  real_T c1_c_u[23];
  const mxArray *c1_d_y = NULL;
  real_T c1_d_u[713];
  const mxArray *c1_e_y = NULL;
  real_T c1_e_u[713];
  const mxArray *c1_f_y = NULL;
  real_T c1_f_u;
  const mxArray *c1_g_y = NULL;
  uint8_T c1_g_u;
  const mxArray *c1_h_y = NULL;
  real32_T (*c1_vel_Lines)[2852];
  c1_vel_Lines = (real32_T (*)[2852])ssGetOutputPortSignal(chartInstance->S, 1);
  c1_st = NULL;
  c1_y = NULL;
  sf_mex_assign(&c1_y, sf_mex_createcellarray(7), FALSE);
  for (c1_i0 = 0; c1_i0 < 2852; c1_i0++) {
    c1_u[c1_i0] = (*c1_vel_Lines)[c1_i0];
  }

  c1_b_y = NULL;
  sf_mex_assign(&c1_b_y, sf_mex_create("y", c1_u, 1, 0U, 1U, 0U, 2, 713, 4),
                FALSE);
  sf_mex_setcell(c1_y, 0, c1_b_y);
  for (c1_i0 = 0; c1_i0 < 31; c1_i0++) {
    c1_b_u[c1_i0] = chartInstance->c1_CV[c1_i0];
  }

  c1_c_y = NULL;
  if (!chartInstance->c1_CV_not_empty) {
    sf_mex_assign(&c1_c_y, sf_mex_create("y", NULL, 0, 0U, 1U, 0U, 2, 0, 0),
                  FALSE);
  } else {
    sf_mex_assign(&c1_c_y, sf_mex_create("y", c1_b_u, 0, 0U, 1U, 0U, 2, 1, 31),
                  FALSE);
  }

  sf_mex_setcell(c1_y, 1, c1_c_y);
  for (c1_i0 = 0; c1_i0 < 23; c1_i0++) {
    c1_c_u[c1_i0] = chartInstance->c1_RV[c1_i0];
  }

  c1_d_y = NULL;
  if (!chartInstance->c1_RV_not_empty) {
    sf_mex_assign(&c1_d_y, sf_mex_create("y", NULL, 0, 0U, 1U, 0U, 2, 0, 0),
                  FALSE);
  } else {
    sf_mex_assign(&c1_d_y, sf_mex_create("y", c1_c_u, 0, 0U, 1U, 0U, 2, 1, 23),
                  FALSE);
  }

  sf_mex_setcell(c1_y, 2, c1_d_y);
  for (c1_i0 = 0; c1_i0 < 713; c1_i0++) {
    c1_d_u[c1_i0] = chartInstance->c1_X[c1_i0];
  }

  c1_e_y = NULL;
  if (!chartInstance->c1_X_not_empty) {
    sf_mex_assign(&c1_e_y, sf_mex_create("y", NULL, 0, 0U, 1U, 0U, 2, 0, 0),
                  FALSE);
  } else {
    sf_mex_assign(&c1_e_y, sf_mex_create("y", c1_d_u, 0, 0U, 1U, 0U, 2, 23, 31),
                  FALSE);
  }

  sf_mex_setcell(c1_y, 3, c1_e_y);
  for (c1_i0 = 0; c1_i0 < 713; c1_i0++) {
    c1_e_u[c1_i0] = chartInstance->c1_Y[c1_i0];
  }

  c1_f_y = NULL;
  if (!chartInstance->c1_Y_not_empty) {
    sf_mex_assign(&c1_f_y, sf_mex_create("y", NULL, 0, 0U, 1U, 0U, 2, 0, 0),
                  FALSE);
  } else {
    sf_mex_assign(&c1_f_y, sf_mex_create("y", c1_e_u, 0, 0U, 1U, 0U, 2, 23, 31),
                  FALSE);
  }

  sf_mex_setcell(c1_y, 4, c1_f_y);
  c1_f_u = chartInstance->c1_first_time;
  c1_g_y = NULL;
  if (!chartInstance->c1_first_time_not_empty) {
    sf_mex_assign(&c1_g_y, sf_mex_create("y", NULL, 0, 0U, 1U, 0U, 2, 0, 0),
                  FALSE);
  } else {
    sf_mex_assign(&c1_g_y, sf_mex_create("y", &c1_f_u, 0, 0U, 0U, 0U, 0), FALSE);
  }

  sf_mex_setcell(c1_y, 5, c1_g_y);
  c1_g_u = chartInstance->c1_is_active_c1_viptrafficof_win;
  c1_h_y = NULL;
  sf_mex_assign(&c1_h_y, sf_mex_create("y", &c1_g_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c1_y, 6, c1_h_y);
  sf_mex_assign(&c1_st, c1_y, FALSE);
  return c1_st;
}

static void set_sim_state_c1_viptrafficof_win
  (SFc1_viptrafficof_winInstanceStruct *chartInstance, const mxArray *c1_st)
{
  const mxArray *c1_u;
  real32_T c1_fv0[2852];
  int32_T c1_i1;
  real_T c1_dv0[31];
  real_T c1_dv1[23];
  real_T c1_dv2[713];
  real32_T (*c1_vel_Lines)[2852];
  c1_vel_Lines = (real32_T (*)[2852])ssGetOutputPortSignal(chartInstance->S, 1);
  c1_u = sf_mex_dup(c1_st);
  c1_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c1_u, 0)),
                      "vel_Lines", c1_fv0);
  for (c1_i1 = 0; c1_i1 < 2852; c1_i1++) {
    (*c1_vel_Lines)[c1_i1] = c1_fv0[c1_i1];
  }

  c1_c_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c1_u, 1)), "CV",
                        c1_dv0);
  for (c1_i1 = 0; c1_i1 < 31; c1_i1++) {
    chartInstance->c1_CV[c1_i1] = c1_dv0[c1_i1];
  }

  c1_e_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c1_u, 2)), "RV",
                        c1_dv1);
  for (c1_i1 = 0; c1_i1 < 23; c1_i1++) {
    chartInstance->c1_RV[c1_i1] = c1_dv1[c1_i1];
  }

  c1_g_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c1_u, 3)), "X",
                        c1_dv2);
  for (c1_i1 = 0; c1_i1 < 713; c1_i1++) {
    chartInstance->c1_X[c1_i1] = c1_dv2[c1_i1];
  }

  c1_i_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c1_u, 4)), "Y",
                        c1_dv2);
  for (c1_i1 = 0; c1_i1 < 713; c1_i1++) {
    chartInstance->c1_Y[c1_i1] = c1_dv2[c1_i1];
  }

  chartInstance->c1_first_time = c1_k_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getcell(c1_u, 5)), "first_time");
  chartInstance->c1_is_active_c1_viptrafficof_win = c1_m_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c1_u, 6)),
     "is_active_c1_viptrafficof_win");
  sf_mex_destroy(&c1_u);
  sf_mex_destroy(&c1_st);
}

static void finalize_c1_viptrafficof_win(SFc1_viptrafficof_winInstanceStruct
  *chartInstance)
{
}

static void sf_c1_viptrafficof_win(SFc1_viptrafficof_winInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  c1_chartstep_c1_viptrafficof_win(chartInstance);
}

static void c1_chartstep_c1_viptrafficof_win(SFc1_viptrafficof_winInstanceStruct
  *chartInstance)
{
  int32_T c1_i2;
  int32_T c1_i3;
  creal32_T c1_tmp[713];
  real32_T (*c1_vel_Lines)[2852];
  creal32_T (*c1_vel_Values)[19200];
  c1_vel_Lines = (real32_T (*)[2852])ssGetOutputPortSignal(chartInstance->S, 1);
  c1_vel_Values = (creal32_T (*)[19200])ssGetInputPortSignal(chartInstance->S, 0);
  if (!chartInstance->c1_first_time_not_empty) {
    chartInstance->c1_first_time = 1.0;
    chartInstance->c1_first_time_not_empty = TRUE;
    for (c1_i2 = 0; c1_i2 < 23; c1_i2++) {
      chartInstance->c1_RV[c1_i2] = 5.0 + 5.0 * (real_T)c1_i2;
    }

    chartInstance->c1_RV_not_empty = TRUE;
    for (c1_i2 = 0; c1_i2 < 31; c1_i2++) {
      chartInstance->c1_CV[c1_i2] = 5.0 + 5.0 * (real_T)c1_i2;
    }

    chartInstance->c1_CV_not_empty = TRUE;
    c1_meshgrid(chartInstance, chartInstance->c1_CV, chartInstance->c1_RV,
                chartInstance->c1_Y, chartInstance->c1_X);
    chartInstance->c1_Y_not_empty = TRUE;
    chartInstance->c1_X_not_empty = TRUE;
  }

  for (c1_i2 = 0; c1_i2 < 23; c1_i2++) {
    sf_mex_lw_bounds_check((int32_T)chartInstance->c1_RV[c1_i2], 1, 120);
  }

  for (c1_i2 = 0; c1_i2 < 31; c1_i2++) {
    sf_mex_lw_bounds_check((int32_T)chartInstance->c1_CV[c1_i2], 1, 160);
  }

  for (c1_i2 = 0; c1_i2 < 31; c1_i2++) {
    for (c1_i3 = 0; c1_i3 < 23; c1_i3++) {
      c1_tmp[c1_i3 + 23 * c1_i2].re = (real32_T)chartInstance->c1_scaleFactor *
        (*c1_vel_Values)[((int32_T)chartInstance->c1_RV[c1_i3] + 120 * ((int32_T)
        chartInstance->c1_CV[c1_i2] - 1)) - 1].re;
      c1_tmp[c1_i3 + 23 * c1_i2].im = (real32_T)chartInstance->c1_scaleFactor *
        (*c1_vel_Values)[((int32_T)chartInstance->c1_RV[c1_i3] + 120 * ((int32_T)
        chartInstance->c1_CV[c1_i2] - 1)) - 1].im;
    }
  }

  for (c1_i2 = 0; c1_i2 < 713; c1_i2++) {
    (*c1_vel_Lines)[c1_i2] = (real32_T)chartInstance->c1_Y[c1_i2];
    (*c1_vel_Lines)[c1_i2 + 713] = (real32_T)chartInstance->c1_X[c1_i2];
    (*c1_vel_Lines)[c1_i2 + 1426] = (real32_T)chartInstance->c1_Y[c1_i2] +
      c1_tmp[c1_i2].re;
    (*c1_vel_Lines)[c1_i2 + 2139] = (real32_T)chartInstance->c1_X[c1_i2] +
      c1_tmp[c1_i2].im;
  }
}

static void initSimStructsc1_viptrafficof_win
  (SFc1_viptrafficof_winInstanceStruct *chartInstance)
{
}

static void init_script_number_translation(uint32_T c1_machineNumber, uint32_T
  c1_chartNumber)
{
}

const mxArray *sf_c1_viptrafficof_win_get_eml_resolved_functions_info(void)
{
  const mxArray *c1_nameCaptureInfo = NULL;
  c1_nameCaptureInfo = NULL;
  sf_mex_assign(&c1_nameCaptureInfo, sf_mex_create("nameCaptureInfo", NULL, 0,
    0U, 1U, 0U, 2, 0, 1), FALSE);
  return c1_nameCaptureInfo;
}

static void c1_meshgrid(SFc1_viptrafficof_winInstanceStruct *chartInstance,
  real_T c1_x[31], real_T c1_y[23], real_T c1_xx[713], real_T c1_yy[713])
{
  int32_T c1_ia;
  int32_T c1_ib;
  int32_T c1_iacol;
  int32_T c1_jcol;
  int32_T c1_itilerow;
  c1_ia = 1;
  c1_ib = 1;
  c1_iacol = 1;
  for (c1_jcol = 0; c1_jcol < 31; c1_jcol++) {
    for (c1_itilerow = 0; c1_itilerow < 23; c1_itilerow++) {
      c1_xx[sf_mex_lw_bounds_check(c1_ib, 1, 713) - 1] =
        c1_x[sf_mex_lw_bounds_check(c1_iacol, 1, 31) - 1];
      c1_ia = c1_iacol + 1;
      c1_ib++;
    }

    c1_iacol = c1_ia;
  }

  c1_ib = 1;
  for (c1_iacol = 0; c1_iacol < 31; c1_iacol++) {
    c1_ia = 1;
    for (c1_jcol = 0; c1_jcol < 23; c1_jcol++) {
      c1_yy[sf_mex_lw_bounds_check(c1_ib, 1, 713) - 1] =
        c1_y[sf_mex_lw_bounds_check(c1_ia, 1, 23) - 1];
      c1_ia++;
      c1_ib++;
    }
  }
}

static void c1_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_vel_Lines, const char_T *c1_identifier,
  real32_T c1_y[2852])
{
  emlrtMsgIdentifier c1_thisId;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_vel_Lines), &c1_thisId,
                        c1_y);
  sf_mex_destroy(&c1_vel_Lines);
}

static void c1_b_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId,
  real32_T c1_y[2852])
{
  real32_T c1_fv1[2852];
  int32_T c1_i4;
  sf_mex_import(c1_parentId, sf_mex_dup(c1_u), c1_fv1, 1, 1, 0U, 1, 0U, 2, 713,
                4);
  for (c1_i4 = 0; c1_i4 < 2852; c1_i4++) {
    c1_y[c1_i4] = c1_fv1[c1_i4];
  }

  sf_mex_destroy(&c1_u);
}

static void c1_c_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_b_CV, const char_T *c1_identifier, real_T
  c1_y[31])
{
  emlrtMsgIdentifier c1_thisId;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_d_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_b_CV), &c1_thisId, c1_y);
  sf_mex_destroy(&c1_b_CV);
}

static void c1_d_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId,
  real_T c1_y[31])
{
  real_T c1_dv3[31];
  int32_T c1_i5;
  if (mxIsEmpty(c1_u)) {
    chartInstance->c1_CV_not_empty = FALSE;
  } else {
    chartInstance->c1_CV_not_empty = TRUE;
    sf_mex_import(c1_parentId, sf_mex_dup(c1_u), c1_dv3, 1, 0, 0U, 1, 0U, 2, 1,
                  31);
    for (c1_i5 = 0; c1_i5 < 31; c1_i5++) {
      c1_y[c1_i5] = c1_dv3[c1_i5];
    }
  }

  sf_mex_destroy(&c1_u);
}

static void c1_e_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_b_RV, const char_T *c1_identifier, real_T
  c1_y[23])
{
  emlrtMsgIdentifier c1_thisId;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_f_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_b_RV), &c1_thisId, c1_y);
  sf_mex_destroy(&c1_b_RV);
}

static void c1_f_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId,
  real_T c1_y[23])
{
  real_T c1_dv4[23];
  int32_T c1_i6;
  if (mxIsEmpty(c1_u)) {
    chartInstance->c1_RV_not_empty = FALSE;
  } else {
    chartInstance->c1_RV_not_empty = TRUE;
    sf_mex_import(c1_parentId, sf_mex_dup(c1_u), c1_dv4, 1, 0, 0U, 1, 0U, 2, 1,
                  23);
    for (c1_i6 = 0; c1_i6 < 23; c1_i6++) {
      c1_y[c1_i6] = c1_dv4[c1_i6];
    }
  }

  sf_mex_destroy(&c1_u);
}

static void c1_g_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_b_X, const char_T *c1_identifier, real_T
  c1_y[713])
{
  emlrtMsgIdentifier c1_thisId;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_h_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_b_X), &c1_thisId, c1_y);
  sf_mex_destroy(&c1_b_X);
}

static void c1_h_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId,
  real_T c1_y[713])
{
  real_T c1_dv5[713];
  int32_T c1_i7;
  if (mxIsEmpty(c1_u)) {
    chartInstance->c1_X_not_empty = FALSE;
  } else {
    chartInstance->c1_X_not_empty = TRUE;
    sf_mex_import(c1_parentId, sf_mex_dup(c1_u), c1_dv5, 1, 0, 0U, 1, 0U, 2, 23,
                  31);
    for (c1_i7 = 0; c1_i7 < 713; c1_i7++) {
      c1_y[c1_i7] = c1_dv5[c1_i7];
    }
  }

  sf_mex_destroy(&c1_u);
}

static void c1_i_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_b_Y, const char_T *c1_identifier, real_T
  c1_y[713])
{
  emlrtMsgIdentifier c1_thisId;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_j_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_b_Y), &c1_thisId, c1_y);
  sf_mex_destroy(&c1_b_Y);
}

static void c1_j_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId,
  real_T c1_y[713])
{
  real_T c1_dv6[713];
  int32_T c1_i8;
  if (mxIsEmpty(c1_u)) {
    chartInstance->c1_Y_not_empty = FALSE;
  } else {
    chartInstance->c1_Y_not_empty = TRUE;
    sf_mex_import(c1_parentId, sf_mex_dup(c1_u), c1_dv6, 1, 0, 0U, 1, 0U, 2, 23,
                  31);
    for (c1_i8 = 0; c1_i8 < 713; c1_i8++) {
      c1_y[c1_i8] = c1_dv6[c1_i8];
    }
  }

  sf_mex_destroy(&c1_u);
}

static real_T c1_k_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_b_first_time, const char_T *c1_identifier)
{
  real_T c1_y;
  emlrtMsgIdentifier c1_thisId;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_y = c1_l_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_b_first_time),
    &c1_thisId);
  sf_mex_destroy(&c1_b_first_time);
  return c1_y;
}

static real_T c1_l_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId)
{
  real_T c1_y;
  real_T c1_d1;
  if (mxIsEmpty(c1_u)) {
    chartInstance->c1_first_time_not_empty = FALSE;
  } else {
    chartInstance->c1_first_time_not_empty = TRUE;
    sf_mex_import(c1_parentId, sf_mex_dup(c1_u), &c1_d1, 1, 0, 0U, 0, 0U, 0);
    c1_y = c1_d1;
  }

  sf_mex_destroy(&c1_u);
  return c1_y;
}

static uint8_T c1_m_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_b_is_active_c1_viptrafficof_win, const
  char_T *c1_identifier)
{
  uint8_T c1_y;
  emlrtMsgIdentifier c1_thisId;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_y = c1_n_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c1_b_is_active_c1_viptrafficof_win), &c1_thisId);
  sf_mex_destroy(&c1_b_is_active_c1_viptrafficof_win);
  return c1_y;
}

static uint8_T c1_n_emlrt_marshallIn(SFc1_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId)
{
  uint8_T c1_y;
  uint8_T c1_u0;
  sf_mex_import(c1_parentId, sf_mex_dup(c1_u), &c1_u0, 1, 3, 0U, 0, 0U, 0);
  c1_y = c1_u0;
  sf_mex_destroy(&c1_u);
  return c1_y;
}

static void init_dsm_address_info(SFc1_viptrafficof_winInstanceStruct
  *chartInstance)
{
}

/* SFunction Glue Code */
void sf_c1_viptrafficof_win_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(1308613944U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(3839662568U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(1105748481U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(3760067550U);
}

mxArray *sf_c1_viptrafficof_win_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("clUPEt6u1QjTGrFvdcavbF");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(120);
      pr[1] = (double)(160);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(9));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(1));
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxData);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxData);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(713);
      pr[1] = (double)(4);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(9));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  return(mxAutoinheritanceInfo);
}

static const mxArray *sf_get_sim_state_info_c1_viptrafficof_win(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x7'type','srcId','name','auxInfo'{{M[1],M[5],T\"vel_Lines\",},{M[4],M[0],T\"CV\",S'l','i','p'{{M1x2[197 199],M[0],}}},{M[4],M[0],T\"RV\",S'l','i','p'{{M1x2[182 184],M[0],}}},{M[4],M[0],T\"X\",S'l','i','p'{{M1x2[154 155],M[0],}}},{M[4],M[0],T\"Y\",S'l','i','p'{{M1x2[168 169],M[0],}}},{M[4],M[0],T\"first_time\",S'l','i','p'{{M1x2[131 141],M[0],}}},{M[8],M[0],T\"is_active_c1_viptrafficof_win\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 7, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c1_viptrafficof_win_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static const char* sf_get_instance_specialization()
{
  return "jwB3WxtMF4SAT3pxaXFOBG";
}

static void sf_opaque_initialize_c1_viptrafficof_win(void *chartInstanceVar)
{
  initialize_params_c1_viptrafficof_win((SFc1_viptrafficof_winInstanceStruct*)
    chartInstanceVar);
  initialize_c1_viptrafficof_win((SFc1_viptrafficof_winInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_enable_c1_viptrafficof_win(void *chartInstanceVar)
{
  enable_c1_viptrafficof_win((SFc1_viptrafficof_winInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_disable_c1_viptrafficof_win(void *chartInstanceVar)
{
  disable_c1_viptrafficof_win((SFc1_viptrafficof_winInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_gateway_c1_viptrafficof_win(void *chartInstanceVar)
{
  sf_c1_viptrafficof_win((SFc1_viptrafficof_winInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c1_viptrafficof_win(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c1_viptrafficof_win
    ((SFc1_viptrafficof_winInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c1_viptrafficof_win();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_raw2high'.\n");
  }

  return plhs[0];
}

extern void sf_internal_set_sim_state_c1_viptrafficof_win(SimStruct* S, const
  mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c1_viptrafficof_win();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c1_viptrafficof_win((SFc1_viptrafficof_winInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c1_viptrafficof_win(SimStruct* S)
{
  return sf_internal_get_sim_state_c1_viptrafficof_win(S);
}

static void sf_opaque_set_sim_state_c1_viptrafficof_win(SimStruct* S, const
  mxArray *st)
{
  sf_internal_set_sim_state_c1_viptrafficof_win(S, st);
}

static void sf_opaque_terminate_c1_viptrafficof_win(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc1_viptrafficof_winInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
    }

    finalize_c1_viptrafficof_win((SFc1_viptrafficof_winInstanceStruct*)
      chartInstanceVar);
    free((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }

  unload_viptrafficof_win_optimization_info();
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc1_viptrafficof_win((SFc1_viptrafficof_winInstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c1_viptrafficof_win(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c1_viptrafficof_win((SFc1_viptrafficof_winInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c1_viptrafficof_win(SimStruct *S)
{
  /* Actual parameters from chart:
     scaleFactor
   */
  const char_T *rtParamNames[] = { "p1" };

  ssSetNumRunTimeParams(S,ssGetSFcnParamsCount(S));

  /* registration for scaleFactor*/
  ssRegDlgParamAsRunTimeParam(S, 0, 0, rtParamNames[0], SS_DOUBLE);
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_viptrafficof_win_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      1);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,1,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,1,
      "gatewayCannotBeInlinedMultipleTimes"));
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,1,1);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,1,1);
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,1);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(789101784U));
  ssSetChecksum1(S,(914710301U));
  ssSetChecksum2(S,(1304027021U));
  ssSetChecksum3(S,(3429839852U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
}

static void mdlRTW_c1_viptrafficof_win(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
  }
}

static void mdlStart_c1_viptrafficof_win(SimStruct *S)
{
  SFc1_viptrafficof_winInstanceStruct *chartInstance;
  chartInstance = (SFc1_viptrafficof_winInstanceStruct *)malloc(sizeof
    (SFc1_viptrafficof_winInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc1_viptrafficof_winInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 1;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway =
    sf_opaque_gateway_c1_viptrafficof_win;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c1_viptrafficof_win;
  chartInstance->chartInfo.terminateChart =
    sf_opaque_terminate_c1_viptrafficof_win;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c1_viptrafficof_win;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c1_viptrafficof_win;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c1_viptrafficof_win;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c1_viptrafficof_win;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c1_viptrafficof_win;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c1_viptrafficof_win;
  chartInstance->chartInfo.mdlStart = mdlStart_c1_viptrafficof_win;
  chartInstance->chartInfo.mdlSetWorkWidths =
    mdlSetWorkWidths_c1_viptrafficof_win;
  chartInstance->chartInfo.extModeExec = NULL;
  chartInstance->chartInfo.restoreLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.restoreBeforeLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.storeCurrentConfiguration = NULL;
  chartInstance->S = S;
  ssSetUserData(S,(void *)(&(chartInstance->chartInfo)));/* register the chart instance with simstruct */
  init_dsm_address_info(chartInstance);
  if (!sim_mode_is_rtw_gen(S)) {
  }

  sf_opaque_init_subchart_simstructs(chartInstance->chartInfo.chartInstance);
}

void c1_viptrafficof_win_method_dispatcher(SimStruct *S, int_T method, void
  *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c1_viptrafficof_win(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c1_viptrafficof_win(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c1_viptrafficof_win(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c1_viptrafficof_win_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}

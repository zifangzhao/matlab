/* Include files */

#include "blascompat32.h"
#include "viptrafficof_win_sfun.h"
#include "c2_viptrafficof_win.h"
#include "mwmathutil.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "viptrafficof_win_sfun_debug_macros.h"

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)
#define c2_b_line_row                  (22.0)

/* Variable Declarations */

/* Variable Definitions */
static const char * c2_debug_family_names[7] = { "dim", "repVector", "line_row",
  "nargin", "nargout", "u", "y" };

/* Function Declarations */
static void initialize_c2_viptrafficof_win(SFc2_viptrafficof_winInstanceStruct
  *chartInstance);
static void initialize_params_c2_viptrafficof_win
  (SFc2_viptrafficof_winInstanceStruct *chartInstance);
static void enable_c2_viptrafficof_win(SFc2_viptrafficof_winInstanceStruct
  *chartInstance);
static void disable_c2_viptrafficof_win(SFc2_viptrafficof_winInstanceStruct
  *chartInstance);
static void c2_update_debugger_state_c2_viptrafficof_win
  (SFc2_viptrafficof_winInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c2_viptrafficof_win
  (SFc2_viptrafficof_winInstanceStruct *chartInstance);
static void set_sim_state_c2_viptrafficof_win
  (SFc2_viptrafficof_winInstanceStruct *chartInstance, const mxArray *c2_st);
static void finalize_c2_viptrafficof_win(SFc2_viptrafficof_winInstanceStruct
  *chartInstance);
static void sf_c2_viptrafficof_win(SFc2_viptrafficof_winInstanceStruct
  *chartInstance);
static void initSimStructsc2_viptrafficof_win
  (SFc2_viptrafficof_winInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c2_machineNumber, uint32_T
  c2_chartNumber);
static const mxArray *c2_sf_marshallOut(void *chartInstanceVoid, int32_T
  c2_inData_data[320], int32_T c2_inData_sizes[2]);
static void c2_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_y, const char_T *c2_identifier, int32_T
  c2_y_data[320], int32_T c2_y_sizes[2]);
static void c2_b_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId,
  int32_T c2_y_data[320], int32_T c2_y_sizes[2]);
static void c2_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, int32_T c2_outData_data[320],
  int32_T c2_outData_sizes[2]);
static const mxArray *c2_b_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData);
static real_T c2_c_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId);
static void c2_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData);
static const mxArray *c2_c_sf_marshallOut(void *chartInstanceVoid, real_T
  c2_inData_data[320], int32_T c2_inData_sizes[2]);
static void c2_d_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId,
  real_T c2_y_data[320], int32_T c2_y_sizes[2]);
static void c2_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, real_T c2_outData_data[320],
  int32_T c2_outData_sizes[2]);
static const mxArray *c2_d_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData);
static void c2_e_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId,
  real_T c2_y[2]);
static void c2_d_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData);
static void c2_repmat(SFc2_viptrafficof_winInstanceStruct *chartInstance, real_T
                      c2_m, real_T c2_b_data[320], int32_T c2_b_sizes[2]);
static void c2_eml_assert_valid_size_arg(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, real_T c2_varargin_1);
static void c2_eml_int_forloop_overflow_check
  (SFc2_viptrafficof_winInstanceStruct *chartInstance, int32_T c2_b);
static const mxArray *c2_e_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData);
static int32_T c2_f_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId);
static void c2_e_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData);
static uint8_T c2_g_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_b_is_active_c2_viptrafficof_win, const
  char_T *c2_identifier);
static uint8_T c2_h_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId);
static void c2_mul_wide_s32(SFc2_viptrafficof_winInstanceStruct *chartInstance,
  int32_T c2_in0, int32_T c2_in1, uint32_T *c2_ptrOutBitsHi, uint32_T
  *c2_ptrOutBitsLo);
static int32_T c2_mul_s32_s32_s32_sat(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, int32_T c2_a, int32_T c2_b);
static void init_dsm_address_info(SFc2_viptrafficof_winInstanceStruct
  *chartInstance);

/* Function Definitions */
static void initialize_c2_viptrafficof_win(SFc2_viptrafficof_winInstanceStruct
  *chartInstance)
{
  chartInstance->c2_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c2_is_active_c2_viptrafficof_win = 0U;
}

static void initialize_params_c2_viptrafficof_win
  (SFc2_viptrafficof_winInstanceStruct *chartInstance)
{
  real_T c2_d0;
  sf_set_error_prefix_string(
    "Error evaluating data 'line_row' in the parent workspace.\n");
  sf_mex_import_named("line_row", sf_mex_get_sfun_param(chartInstance->S, 0, 0),
                      &c2_d0, 0, 0, 0U, 0, 0U, 0);
  chartInstance->c2_line_row = c2_d0;
  sf_set_error_prefix_string("Stateflow Runtime Error (chart): ");
}

static void enable_c2_viptrafficof_win(SFc2_viptrafficof_winInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c2_viptrafficof_win(SFc2_viptrafficof_winInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c2_update_debugger_state_c2_viptrafficof_win
  (SFc2_viptrafficof_winInstanceStruct *chartInstance)
{
}

static const mxArray *get_sim_state_c2_viptrafficof_win
  (SFc2_viptrafficof_winInstanceStruct *chartInstance)
{
  const mxArray *c2_st;
  const mxArray *c2_y = NULL;
  int32_T c2_u_sizes[2];
  int32_T c2_u;
  int32_T c2_b_u;
  int32_T c2_loop_ub;
  int32_T c2_i0;
  int32_T c2_u_data[320];
  const mxArray *c2_b_y = NULL;
  uint8_T c2_hoistedGlobal;
  uint8_T c2_c_u;
  const mxArray *c2_c_y = NULL;
  int32_T (*c2_y_sizes)[2];
  int32_T (*c2_y_data)[320];
  c2_y_sizes = (int32_T (*)[2])ssGetCurrentOutputPortDimensions_wrapper
    (chartInstance->S, 1);
  c2_y_data = (int32_T (*)[320])ssGetOutputPortSignal(chartInstance->S, 1);
  c2_st = NULL;
  c2_st = NULL;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_createcellarray(2), FALSE);
  c2_u_sizes[0] = (*c2_y_sizes)[0];
  c2_u_sizes[1] = (*c2_y_sizes)[1];
  c2_u = c2_u_sizes[0];
  c2_b_u = c2_u_sizes[1];
  c2_loop_ub = (*c2_y_sizes)[0] * (*c2_y_sizes)[1] - 1;
  for (c2_i0 = 0; c2_i0 <= c2_loop_ub; c2_i0++) {
    c2_u_data[c2_i0] = (*c2_y_data)[c2_i0];
  }

  c2_b_y = NULL;
  sf_mex_assign(&c2_b_y, sf_mex_create("y", c2_u_data, 6, 0U, 1U, 0U, 2,
    c2_u_sizes[0], c2_u_sizes[1]), FALSE);
  sf_mex_setcell(c2_y, 0, c2_b_y);
  c2_hoistedGlobal = chartInstance->c2_is_active_c2_viptrafficof_win;
  c2_c_u = c2_hoistedGlobal;
  c2_c_y = NULL;
  sf_mex_assign(&c2_c_y, sf_mex_create("y", &c2_c_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c2_y, 1, c2_c_y);
  sf_mex_assign(&c2_st, c2_y, FALSE);
  return c2_st;
}

static void set_sim_state_c2_viptrafficof_win
  (SFc2_viptrafficof_winInstanceStruct *chartInstance, const mxArray *c2_st)
{
  const mxArray *c2_u;
  int32_T c2_tmp_sizes[2];
  int32_T c2_tmp_data[320];
  int32_T c2_i1;
  int32_T c2_i2;
  int32_T c2_loop_ub;
  int32_T c2_i3;
  int32_T (*c2_y_data)[320];
  int32_T (*c2_y_sizes)[2];
  c2_y_sizes = (int32_T (*)[2])ssGetCurrentOutputPortDimensions_wrapper
    (chartInstance->S, 1);
  c2_y_data = (int32_T (*)[320])ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c2_doneDoubleBufferReInit = TRUE;
  c2_u = sf_mex_dup(c2_st);
  c2_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c2_u, 0)), "y",
                      c2_tmp_data, c2_tmp_sizes);
  ssSetCurrentOutputPortDimensions(chartInstance->S, 1, 0, c2_tmp_sizes[0]);
  ssSetCurrentOutputPortDimensions(chartInstance->S, 1, 1, c2_tmp_sizes[1]);
  c2_i1 = (*c2_y_sizes)[0];
  c2_i2 = (*c2_y_sizes)[1];
  c2_loop_ub = c2_tmp_sizes[0] * c2_tmp_sizes[1] - 1;
  for (c2_i3 = 0; c2_i3 <= c2_loop_ub; c2_i3++) {
    (*c2_y_data)[c2_i3] = c2_tmp_data[c2_i3];
  }

  chartInstance->c2_is_active_c2_viptrafficof_win = c2_g_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c2_u, 1)),
     "is_active_c2_viptrafficof_win");
  sf_mex_destroy(&c2_u);
  c2_update_debugger_state_c2_viptrafficof_win(chartInstance);
  sf_mex_destroy(&c2_st);
}

static void finalize_c2_viptrafficof_win(SFc2_viptrafficof_winInstanceStruct
  *chartInstance)
{
}

static void sf_c2_viptrafficof_win(SFc2_viptrafficof_winInstanceStruct
  *chartInstance)
{
  int32_T c2_loop_ub;
  int32_T c2_i4;
  int32_T c2_b_loop_ub;
  int32_T c2_i5;
  int32_T c2_u_sizes[2];
  int32_T c2_u;
  int32_T c2_b_u;
  int32_T c2_c_loop_ub;
  int32_T c2_i6;
  int32_T c2_u_data[320];
  uint32_T c2_debug_family_var_map[7];
  real_T c2_dim[2];
  int32_T c2_repVector_sizes[2];
  real_T c2_repVector_data[320];
  real_T c2_c_line_row;
  real_T c2_nargin = 2.0;
  real_T c2_nargout = 1.0;
  int32_T c2_y_sizes[2];
  int32_T c2_y_data[320];
  int32_T c2_i7;
  int32_T c2_i8;
  real_T c2_dv0[2];
  int32_T c2_iv0[2];
  int32_T c2_iv1[2];
  int32_T c2_repVector;
  int32_T c2_b_repVector;
  int32_T c2_d_loop_ub;
  int32_T c2_i9;
  int32_T c2_tmp_sizes[2];
  real_T c2_tmp_data[320];
  int32_T c2_c_repVector;
  int32_T c2_d_repVector;
  int32_T c2_e_loop_ub;
  int32_T c2_i10;
  int32_T c2_b_repVector_sizes[2];
  int32_T c2_e_repVector;
  int32_T c2_f_repVector;
  int32_T c2_f_loop_ub;
  int32_T c2_i11;
  real_T c2_d1;
  int32_T c2_i12;
  int32_T c2_b_repVector_data[320];
  int32_T c2_i13;
  int32_T c2_c_u[2];
  int32_T c2_i14;
  int32_T c2_g_repVector[2];
  int32_T c2_y;
  int32_T c2_b_y;
  int32_T c2_g_loop_ub;
  int32_T c2_i15;
  int32_T c2_q0;
  real_T c2_d2;
  int32_T c2_i16;
  int32_T c2_q1;
  int32_T c2_qY;
  int32_T c2_i17;
  int32_T c2_i18;
  int32_T c2_h_loop_ub;
  int32_T c2_i19;
  int32_T (*c2_b_y_data)[320];
  int32_T (*c2_b_u_sizes)[2];
  int32_T (*c2_b_y_sizes)[2];
  int32_T (*c2_b_u_data)[320];
  c2_b_y_sizes = (int32_T (*)[2])ssGetCurrentOutputPortDimensions_wrapper
    (chartInstance->S, 1);
  c2_b_y_data = (int32_T (*)[320])ssGetOutputPortSignal(chartInstance->S, 1);
  c2_b_u_sizes = (int32_T (*)[2])ssGetCurrentInputPortDimensions_wrapper
    (chartInstance->S, 0);
  c2_b_u_data = (int32_T (*)[320])ssGetInputPortSignal(chartInstance->S, 0);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 1U, chartInstance->c2_sfEvent);
  c2_loop_ub = (*c2_b_u_sizes)[0] * (*c2_b_u_sizes)[1] - 1;
  for (c2_i4 = 0; c2_i4 <= c2_loop_ub; c2_i4++) {
    _SFD_DATA_RANGE_CHECK_MAX((real_T)(*c2_b_u_data)[c2_i4], 0U, 320.0);
  }

  c2_b_loop_ub = (*c2_b_y_sizes)[0] * (*c2_b_y_sizes)[1] - 1;
  for (c2_i5 = 0; c2_i5 <= c2_b_loop_ub; c2_i5++) {
    _SFD_DATA_RANGE_CHECK_MAX((real_T)(*c2_b_y_data)[c2_i5], 1U, 320.0);
  }

  _SFD_DATA_RANGE_CHECK(chartInstance->c2_line_row, 2U);
  chartInstance->c2_sfEvent = CALL_EVENT;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 1U, chartInstance->c2_sfEvent);
  c2_u_sizes[0] = (*c2_b_u_sizes)[0];
  c2_u_sizes[1] = (*c2_b_u_sizes)[1];
  c2_u = c2_u_sizes[0];
  c2_b_u = c2_u_sizes[1];
  c2_c_loop_ub = (*c2_b_u_sizes)[0] * (*c2_b_u_sizes)[1] - 1;
  for (c2_i6 = 0; c2_i6 <= c2_c_loop_ub; c2_i6++) {
    c2_u_data[c2_i6] = (*c2_b_u_data)[c2_i6];
  }

  sf_debug_symbol_scope_push_eml(0U, 7U, 7U, c2_debug_family_names,
    c2_debug_family_var_map);
  sf_debug_symbol_scope_add_eml_importable(c2_dim, 0U, c2_d_sf_marshallOut,
    c2_d_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_dyn_importable(c2_repVector_data, (const int32_T
    *)&c2_repVector_sizes, NULL, 0, 1, (void *)c2_c_sf_marshallOut, (void *)
    c2_c_sf_marshallIn);
  sf_debug_symbol_scope_add_eml(&c2_c_line_row, 2U, c2_b_sf_marshallOut);
  sf_debug_symbol_scope_add_eml_importable(&c2_nargin, 3U, c2_b_sf_marshallOut,
    c2_b_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c2_nargout, 4U, c2_b_sf_marshallOut,
    c2_b_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_dyn(c2_u_data, (const int32_T *)&c2_u_sizes,
    NULL, 1, 5, (void *)c2_sf_marshallOut);
  sf_debug_symbol_scope_add_eml_dyn_importable(c2_y_data, (const int32_T *)
    &c2_y_sizes, NULL, 0, 6, (void *)c2_sf_marshallOut, (void *)c2_sf_marshallIn);
  c2_c_line_row = 22.0;
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 3);
  for (c2_i7 = 0; c2_i7 < 2; c2_i7++) {
    c2_dim[c2_i7] = (real_T)c2_u_sizes[c2_i7];
  }

  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 4);
  for (c2_i8 = 0; c2_i8 < 2; c2_i8++) {
    c2_dv0[c2_i8] = c2_dim[c2_i8];
  }

  c2_iv0[0] = (int32_T)c2_dv0[0];
  c2_iv0[1] = (int32_T)c2_dv0[1];
  c2_repVector_sizes[0] = c2_iv0[0];
  c2_iv1[0] = (int32_T)c2_dv0[0];
  c2_iv1[1] = (int32_T)c2_dv0[1];
  c2_repVector_sizes[1] = c2_iv1[1];
  c2_repVector = c2_repVector_sizes[0];
  c2_b_repVector = c2_repVector_sizes[1];
  c2_d_loop_ub = (int32_T)c2_dv0[0] * (int32_T)c2_dv0[1] - 1;
  for (c2_i9 = 0; c2_i9 <= c2_d_loop_ub; c2_i9++) {
    c2_repVector_data[c2_i9] = 0.0;
  }

  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 5);
  c2_repmat(chartInstance, c2_dim[0], c2_tmp_data, c2_tmp_sizes);
  c2_repVector_sizes[0] = c2_tmp_sizes[0];
  c2_repVector_sizes[1] = 4;
  c2_c_repVector = c2_repVector_sizes[0];
  c2_d_repVector = c2_repVector_sizes[1];
  c2_e_loop_ub = c2_tmp_sizes[0] * c2_tmp_sizes[1] - 1;
  for (c2_i10 = 0; c2_i10 <= c2_e_loop_ub; c2_i10++) {
    c2_repVector_data[c2_i10] = c2_tmp_data[c2_i10];
  }

  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 7);
  c2_b_repVector_sizes[0] = c2_repVector_sizes[0];
  c2_b_repVector_sizes[1] = c2_repVector_sizes[1];
  c2_e_repVector = c2_b_repVector_sizes[0];
  c2_f_repVector = c2_b_repVector_sizes[1];
  c2_f_loop_ub = c2_repVector_sizes[0] * c2_repVector_sizes[1] - 1;
  for (c2_i11 = 0; c2_i11 <= c2_f_loop_ub; c2_i11++) {
    c2_d1 = muDoubleScalarRound(c2_repVector_data[c2_i11]);
    if (c2_d1 < 2.147483648E+9) {
      if (c2_d1 >= -2.147483648E+9) {
        c2_i12 = (int32_T)c2_d1;
      } else {
        c2_i12 = MIN_int32_T;
      }
    } else if (c2_d1 >= 2.147483648E+9) {
      c2_i12 = MAX_int32_T;
    } else {
      c2_i12 = 0;
    }

    c2_b_repVector_data[c2_i11] = c2_i12;
  }

  for (c2_i13 = 0; c2_i13 < 2; c2_i13++) {
    c2_c_u[c2_i13] = c2_u_sizes[c2_i13];
  }

  for (c2_i14 = 0; c2_i14 < 2; c2_i14++) {
    c2_g_repVector[c2_i14] = c2_b_repVector_sizes[c2_i14];
  }

  sf_debug_size_eq_check_nd(c2_c_u, c2_g_repVector, 2);
  sf_debug_dim_size_geq_check(80, c2_u_sizes[0], 1);
  sf_debug_dim_size_geq_check(4, c2_u_sizes[1], 2);
  c2_y_sizes[0] = c2_u_sizes[0];
  c2_y_sizes[1] = c2_u_sizes[1];
  c2_y = c2_y_sizes[0];
  c2_b_y = c2_y_sizes[1];
  c2_g_loop_ub = c2_u_sizes[0] * c2_u_sizes[1] - 1;
  for (c2_i15 = 0; c2_i15 <= c2_g_loop_ub; c2_i15++) {
    c2_q0 = c2_u_data[c2_i15];
    c2_d2 = muDoubleScalarRound(c2_repVector_data[c2_i15]);
    if (c2_d2 < 2.147483648E+9) {
      if (c2_d2 >= -2.147483648E+9) {
        c2_i16 = (int32_T)c2_d2;
      } else {
        c2_i16 = MIN_int32_T;
      }
    } else if (c2_d2 >= 2.147483648E+9) {
      c2_i16 = MAX_int32_T;
    } else {
      c2_i16 = 0;
    }

    c2_q1 = c2_i16;
    c2_qY = c2_q0 + c2_q1;
    if ((c2_q0 < 0) && ((c2_q1 < 0) && (c2_qY >= 0))) {
      c2_qY = MIN_int32_T;
    } else {
      if ((c2_q0 > 0) && ((c2_q1 > 0) && (c2_qY <= 0))) {
        c2_qY = MAX_int32_T;
      }
    }

    c2_y_data[c2_i15] = c2_qY;
  }

  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, -7);
  sf_debug_symbol_scope_pop();
  ssSetCurrentOutputPortDimensions(chartInstance->S, 1, 0, c2_y_sizes[0]);
  ssSetCurrentOutputPortDimensions(chartInstance->S, 1, 1, c2_y_sizes[1]);
  c2_i17 = (*c2_b_y_sizes)[0];
  c2_i18 = (*c2_b_y_sizes)[1];
  c2_h_loop_ub = c2_y_sizes[0] * c2_y_sizes[1] - 1;
  for (c2_i19 = 0; c2_i19 <= c2_h_loop_ub; c2_i19++) {
    (*c2_b_y_data)[c2_i19] = c2_y_data[c2_i19];
  }

  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 1U, chartInstance->c2_sfEvent);
  sf_debug_check_for_state_inconsistency(_viptrafficof_winMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc2_viptrafficof_win
  (SFc2_viptrafficof_winInstanceStruct *chartInstance)
{
}

static void init_script_number_translation(uint32_T c2_machineNumber, uint32_T
  c2_chartNumber)
{
}

static const mxArray *c2_sf_marshallOut(void *chartInstanceVoid, int32_T
  c2_inData_data[320], int32_T c2_inData_sizes[2])
{
  const mxArray *c2_mxArrayOutData = NULL;
  int32_T c2_b_inData_sizes[2];
  int32_T c2_loop_ub;
  int32_T c2_i20;
  int32_T c2_b_loop_ub;
  int32_T c2_i21;
  int32_T c2_b_inData_data[320];
  int32_T c2_u_sizes[2];
  int32_T c2_c_loop_ub;
  int32_T c2_i22;
  int32_T c2_d_loop_ub;
  int32_T c2_i23;
  int32_T c2_u_data[320];
  const mxArray *c2_y = NULL;
  SFc2_viptrafficof_winInstanceStruct *chartInstance;
  chartInstance = (SFc2_viptrafficof_winInstanceStruct *)chartInstanceVoid;
  c2_mxArrayOutData = NULL;
  c2_b_inData_sizes[0] = c2_inData_sizes[0];
  c2_b_inData_sizes[1] = c2_inData_sizes[1];
  c2_loop_ub = c2_inData_sizes[1] - 1;
  for (c2_i20 = 0; c2_i20 <= c2_loop_ub; c2_i20++) {
    c2_b_loop_ub = c2_inData_sizes[0] - 1;
    for (c2_i21 = 0; c2_i21 <= c2_b_loop_ub; c2_i21++) {
      c2_b_inData_data[c2_i21 + c2_b_inData_sizes[0] * c2_i20] =
        c2_inData_data[c2_i21 + c2_inData_sizes[0] * c2_i20];
    }
  }

  c2_u_sizes[0] = c2_b_inData_sizes[0];
  c2_u_sizes[1] = c2_b_inData_sizes[1];
  c2_c_loop_ub = c2_b_inData_sizes[1] - 1;
  for (c2_i22 = 0; c2_i22 <= c2_c_loop_ub; c2_i22++) {
    c2_d_loop_ub = c2_b_inData_sizes[0] - 1;
    for (c2_i23 = 0; c2_i23 <= c2_d_loop_ub; c2_i23++) {
      c2_u_data[c2_i23 + c2_u_sizes[0] * c2_i22] = c2_b_inData_data[c2_i23 +
        c2_b_inData_sizes[0] * c2_i22];
    }
  }

  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", c2_u_data, 6, 0U, 1U, 0U, 2,
    c2_u_sizes[0], c2_u_sizes[1]), FALSE);
  sf_mex_assign(&c2_mxArrayOutData, c2_y, FALSE);
  return c2_mxArrayOutData;
}

static void c2_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_y, const char_T *c2_identifier, int32_T
  c2_y_data[320], int32_T c2_y_sizes[2])
{
  emlrtMsgIdentifier c2_thisId;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_y), &c2_thisId, c2_y_data,
                        c2_y_sizes);
  sf_mex_destroy(&c2_y);
}

static void c2_b_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId,
  int32_T c2_y_data[320], int32_T c2_y_sizes[2])
{
  int32_T c2_i24;
  static uint32_T c2_uv0[2] = { 80U, 4U };

  uint32_T c2_uv1[2];
  int32_T c2_i25;
  boolean_T c2_bv0[2];
  int32_T c2_tmp_sizes[2];
  int32_T c2_tmp_data[320];
  int32_T c2_y;
  int32_T c2_b_y;
  int32_T c2_loop_ub;
  int32_T c2_i26;
  for (c2_i24 = 0; c2_i24 < 2; c2_i24++) {
    c2_uv1[c2_i24] = c2_uv0[c2_i24];
  }

  for (c2_i25 = 0; c2_i25 < 2; c2_i25++) {
    c2_bv0[c2_i25] = TRUE;
  }

  sf_mex_import_vs(c2_parentId, sf_mex_dup(c2_u), c2_tmp_data, 1, 6, 0U, 1, 0U,
                   2, c2_bv0, c2_uv1, c2_tmp_sizes);
  c2_y_sizes[0] = c2_tmp_sizes[0];
  c2_y_sizes[1] = c2_tmp_sizes[1];
  c2_y = c2_y_sizes[0];
  c2_b_y = c2_y_sizes[1];
  c2_loop_ub = c2_tmp_sizes[0] * c2_tmp_sizes[1] - 1;
  for (c2_i26 = 0; c2_i26 <= c2_loop_ub; c2_i26++) {
    c2_y_data[c2_i26] = c2_tmp_data[c2_i26];
  }

  sf_mex_destroy(&c2_u);
}

static void c2_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, int32_T c2_outData_data[320],
  int32_T c2_outData_sizes[2])
{
  const mxArray *c2_y;
  const char_T *c2_identifier;
  emlrtMsgIdentifier c2_thisId;
  int32_T c2_y_sizes[2];
  int32_T c2_y_data[320];
  int32_T c2_loop_ub;
  int32_T c2_i27;
  int32_T c2_b_loop_ub;
  int32_T c2_i28;
  SFc2_viptrafficof_winInstanceStruct *chartInstance;
  chartInstance = (SFc2_viptrafficof_winInstanceStruct *)chartInstanceVoid;
  c2_y = sf_mex_dup(c2_mxArrayInData);
  c2_identifier = c2_varName;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_y), &c2_thisId, c2_y_data,
                        c2_y_sizes);
  sf_mex_destroy(&c2_y);
  c2_outData_sizes[0] = c2_y_sizes[0];
  c2_outData_sizes[1] = c2_y_sizes[1];
  c2_loop_ub = c2_y_sizes[1] - 1;
  for (c2_i27 = 0; c2_i27 <= c2_loop_ub; c2_i27++) {
    c2_b_loop_ub = c2_y_sizes[0] - 1;
    for (c2_i28 = 0; c2_i28 <= c2_b_loop_ub; c2_i28++) {
      c2_outData_data[c2_i28 + c2_outData_sizes[0] * c2_i27] = c2_y_data[c2_i28
        + c2_y_sizes[0] * c2_i27];
    }
  }

  sf_mex_destroy(&c2_mxArrayInData);
}

static const mxArray *c2_b_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData)
{
  const mxArray *c2_mxArrayOutData = NULL;
  real_T c2_u;
  const mxArray *c2_y = NULL;
  SFc2_viptrafficof_winInstanceStruct *chartInstance;
  chartInstance = (SFc2_viptrafficof_winInstanceStruct *)chartInstanceVoid;
  c2_mxArrayOutData = NULL;
  c2_u = *(real_T *)c2_inData;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", &c2_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c2_mxArrayOutData, c2_y, FALSE);
  return c2_mxArrayOutData;
}

static real_T c2_c_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId)
{
  real_T c2_y;
  real_T c2_d3;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), &c2_d3, 1, 0, 0U, 0, 0U, 0);
  c2_y = c2_d3;
  sf_mex_destroy(&c2_u);
  return c2_y;
}

static void c2_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData)
{
  const mxArray *c2_nargout;
  const char_T *c2_identifier;
  emlrtMsgIdentifier c2_thisId;
  real_T c2_y;
  SFc2_viptrafficof_winInstanceStruct *chartInstance;
  chartInstance = (SFc2_viptrafficof_winInstanceStruct *)chartInstanceVoid;
  c2_nargout = sf_mex_dup(c2_mxArrayInData);
  c2_identifier = c2_varName;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_y = c2_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_nargout), &c2_thisId);
  sf_mex_destroy(&c2_nargout);
  *(real_T *)c2_outData = c2_y;
  sf_mex_destroy(&c2_mxArrayInData);
}

static const mxArray *c2_c_sf_marshallOut(void *chartInstanceVoid, real_T
  c2_inData_data[320], int32_T c2_inData_sizes[2])
{
  const mxArray *c2_mxArrayOutData = NULL;
  int32_T c2_b_inData_sizes[2];
  int32_T c2_loop_ub;
  int32_T c2_i29;
  int32_T c2_b_loop_ub;
  int32_T c2_i30;
  real_T c2_b_inData_data[320];
  int32_T c2_u_sizes[2];
  int32_T c2_c_loop_ub;
  int32_T c2_i31;
  int32_T c2_d_loop_ub;
  int32_T c2_i32;
  real_T c2_u_data[320];
  const mxArray *c2_y = NULL;
  SFc2_viptrafficof_winInstanceStruct *chartInstance;
  chartInstance = (SFc2_viptrafficof_winInstanceStruct *)chartInstanceVoid;
  c2_mxArrayOutData = NULL;
  c2_b_inData_sizes[0] = c2_inData_sizes[0];
  c2_b_inData_sizes[1] = c2_inData_sizes[1];
  c2_loop_ub = c2_inData_sizes[1] - 1;
  for (c2_i29 = 0; c2_i29 <= c2_loop_ub; c2_i29++) {
    c2_b_loop_ub = c2_inData_sizes[0] - 1;
    for (c2_i30 = 0; c2_i30 <= c2_b_loop_ub; c2_i30++) {
      c2_b_inData_data[c2_i30 + c2_b_inData_sizes[0] * c2_i29] =
        c2_inData_data[c2_i30 + c2_inData_sizes[0] * c2_i29];
    }
  }

  c2_u_sizes[0] = c2_b_inData_sizes[0];
  c2_u_sizes[1] = c2_b_inData_sizes[1];
  c2_c_loop_ub = c2_b_inData_sizes[1] - 1;
  for (c2_i31 = 0; c2_i31 <= c2_c_loop_ub; c2_i31++) {
    c2_d_loop_ub = c2_b_inData_sizes[0] - 1;
    for (c2_i32 = 0; c2_i32 <= c2_d_loop_ub; c2_i32++) {
      c2_u_data[c2_i32 + c2_u_sizes[0] * c2_i31] = c2_b_inData_data[c2_i32 +
        c2_b_inData_sizes[0] * c2_i31];
    }
  }

  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", c2_u_data, 0, 0U, 1U, 0U, 2,
    c2_u_sizes[0], c2_u_sizes[1]), FALSE);
  sf_mex_assign(&c2_mxArrayOutData, c2_y, FALSE);
  return c2_mxArrayOutData;
}

static void c2_d_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId,
  real_T c2_y_data[320], int32_T c2_y_sizes[2])
{
  int32_T c2_i33;
  static uint32_T c2_uv2[2] = { 80U, 4U };

  uint32_T c2_uv3[2];
  int32_T c2_i34;
  boolean_T c2_bv1[2];
  int32_T c2_tmp_sizes[2];
  real_T c2_tmp_data[320];
  int32_T c2_y;
  int32_T c2_b_y;
  int32_T c2_loop_ub;
  int32_T c2_i35;
  for (c2_i33 = 0; c2_i33 < 2; c2_i33++) {
    c2_uv3[c2_i33] = c2_uv2[c2_i33];
  }

  for (c2_i34 = 0; c2_i34 < 2; c2_i34++) {
    c2_bv1[c2_i34] = TRUE;
  }

  sf_mex_import_vs(c2_parentId, sf_mex_dup(c2_u), c2_tmp_data, 1, 0, 0U, 1, 0U,
                   2, c2_bv1, c2_uv3, c2_tmp_sizes);
  c2_y_sizes[0] = c2_tmp_sizes[0];
  c2_y_sizes[1] = c2_tmp_sizes[1];
  c2_y = c2_y_sizes[0];
  c2_b_y = c2_y_sizes[1];
  c2_loop_ub = c2_tmp_sizes[0] * c2_tmp_sizes[1] - 1;
  for (c2_i35 = 0; c2_i35 <= c2_loop_ub; c2_i35++) {
    c2_y_data[c2_i35] = c2_tmp_data[c2_i35];
  }

  sf_mex_destroy(&c2_u);
}

static void c2_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, real_T c2_outData_data[320],
  int32_T c2_outData_sizes[2])
{
  const mxArray *c2_repVector;
  const char_T *c2_identifier;
  emlrtMsgIdentifier c2_thisId;
  int32_T c2_y_sizes[2];
  real_T c2_y_data[320];
  int32_T c2_loop_ub;
  int32_T c2_i36;
  int32_T c2_b_loop_ub;
  int32_T c2_i37;
  SFc2_viptrafficof_winInstanceStruct *chartInstance;
  chartInstance = (SFc2_viptrafficof_winInstanceStruct *)chartInstanceVoid;
  c2_repVector = sf_mex_dup(c2_mxArrayInData);
  c2_identifier = c2_varName;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_d_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_repVector), &c2_thisId,
                        c2_y_data, c2_y_sizes);
  sf_mex_destroy(&c2_repVector);
  c2_outData_sizes[0] = c2_y_sizes[0];
  c2_outData_sizes[1] = c2_y_sizes[1];
  c2_loop_ub = c2_y_sizes[1] - 1;
  for (c2_i36 = 0; c2_i36 <= c2_loop_ub; c2_i36++) {
    c2_b_loop_ub = c2_y_sizes[0] - 1;
    for (c2_i37 = 0; c2_i37 <= c2_b_loop_ub; c2_i37++) {
      c2_outData_data[c2_i37 + c2_outData_sizes[0] * c2_i36] = c2_y_data[c2_i37
        + c2_y_sizes[0] * c2_i36];
    }
  }

  sf_mex_destroy(&c2_mxArrayInData);
}

static const mxArray *c2_d_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData)
{
  const mxArray *c2_mxArrayOutData = NULL;
  int32_T c2_i38;
  real_T c2_b_inData[2];
  int32_T c2_i39;
  real_T c2_u[2];
  const mxArray *c2_y = NULL;
  SFc2_viptrafficof_winInstanceStruct *chartInstance;
  chartInstance = (SFc2_viptrafficof_winInstanceStruct *)chartInstanceVoid;
  c2_mxArrayOutData = NULL;
  for (c2_i38 = 0; c2_i38 < 2; c2_i38++) {
    c2_b_inData[c2_i38] = (*(real_T (*)[2])c2_inData)[c2_i38];
  }

  for (c2_i39 = 0; c2_i39 < 2; c2_i39++) {
    c2_u[c2_i39] = c2_b_inData[c2_i39];
  }

  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", c2_u, 0, 0U, 1U, 0U, 2, 1, 2), FALSE);
  sf_mex_assign(&c2_mxArrayOutData, c2_y, FALSE);
  return c2_mxArrayOutData;
}

static void c2_e_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId,
  real_T c2_y[2])
{
  real_T c2_dv1[2];
  int32_T c2_i40;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), c2_dv1, 1, 0, 0U, 1, 0U, 2, 1, 2);
  for (c2_i40 = 0; c2_i40 < 2; c2_i40++) {
    c2_y[c2_i40] = c2_dv1[c2_i40];
  }

  sf_mex_destroy(&c2_u);
}

static void c2_d_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData)
{
  const mxArray *c2_dim;
  const char_T *c2_identifier;
  emlrtMsgIdentifier c2_thisId;
  real_T c2_y[2];
  int32_T c2_i41;
  SFc2_viptrafficof_winInstanceStruct *chartInstance;
  chartInstance = (SFc2_viptrafficof_winInstanceStruct *)chartInstanceVoid;
  c2_dim = sf_mex_dup(c2_mxArrayInData);
  c2_identifier = c2_varName;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_e_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_dim), &c2_thisId, c2_y);
  sf_mex_destroy(&c2_dim);
  for (c2_i41 = 0; c2_i41 < 2; c2_i41++) {
    (*(real_T (*)[2])c2_outData)[c2_i41] = c2_y[c2_i41];
  }

  sf_mex_destroy(&c2_mxArrayInData);
}

const mxArray *sf_c2_viptrafficof_win_get_eml_resolved_functions_info(void)
{
  const mxArray *c2_nameCaptureInfo = NULL;
  c2_nameCaptureInfo = NULL;
  sf_mex_assign(&c2_nameCaptureInfo, sf_mex_create("nameCaptureInfo", NULL, 0,
    0U, 1U, 0U, 2, 0, 1), FALSE);
  return c2_nameCaptureInfo;
}

static void c2_repmat(SFc2_viptrafficof_winInstanceStruct *chartInstance, real_T
                      c2_m, real_T c2_b_data[320], int32_T c2_b_sizes[2])
{
  real_T c2_d4;
  int32_T c2_i42;
  int32_T c2_mv[2];
  real_T c2_d5;
  int32_T c2_i43;
  int32_T c2_i44;
  int32_T c2_outsize[2];
  int32_T c2_b_outsize[2];
  int32_T c2_tmp_sizes[2];
  int32_T c2_i45;
  int32_T c2_i46;
  int32_T c2_loop_ub;
  int32_T c2_i47;
  real_T c2_tmp_data[320];
  int32_T c2_i48;
  boolean_T c2_b0;
  int32_T c2_ntilerows;
  int32_T c2_ia;
  int32_T c2_ib;
  int32_T c2_jtilecol;
  int32_T c2_iacol;
  int32_T c2_jcol;
  int32_T c2_itilerow;
  static real_T c2_dv2[4] = { 0.0, 22.0, 0.0, 0.0 };

  int32_T c2_a;
  int32_T c2_b_a;
  c2_eml_assert_valid_size_arg(chartInstance, c2_m);
  c2_eml_assert_valid_size_arg(chartInstance, 1.0);
  c2_d4 = muDoubleScalarRound(c2_m);
  if (c2_d4 < 2.147483648E+9) {
    if (c2_d4 >= -2.147483648E+9) {
      c2_i42 = (int32_T)c2_d4;
    } else {
      c2_i42 = MIN_int32_T;
    }
  } else if (c2_d4 >= 2.147483648E+9) {
    c2_i42 = MAX_int32_T;
  } else {
    c2_i42 = 0;
  }

  c2_mv[0] = c2_i42;
  c2_d5 = muDoubleScalarRound(1.0);
  if (c2_d5 < 2.147483648E+9) {
    if (c2_d5 >= -2.147483648E+9) {
      c2_i43 = (int32_T)c2_d5;
    } else {
      c2_i43 = MIN_int32_T;
    }
  } else if (c2_d5 >= 2.147483648E+9) {
    c2_i43 = MAX_int32_T;
  } else {
    c2_i43 = 0;
  }

  c2_mv[1] = c2_i43;
  for (c2_i44 = 0; c2_i44 < 2; c2_i44++) {
    c2_outsize[c2_i44] = c2_mul_s32_s32_s32_sat(chartInstance, 1 + 3 * c2_i44,
      c2_mv[c2_i44]);
  }

  c2_b_outsize[0] = c2_outsize[0];
  c2_b_outsize[1] = 4;
  c2_tmp_sizes[0] = c2_b_outsize[0];
  c2_tmp_sizes[1] = 4;
  c2_i45 = c2_tmp_sizes[0];
  c2_i46 = c2_tmp_sizes[1];
  c2_loop_ub = (c2_outsize[0] << 2) - 1;
  for (c2_i47 = 0; c2_i47 <= c2_loop_ub; c2_i47++) {
    c2_tmp_data[c2_i47] = 0.0;
  }

  for (c2_i48 = 0; c2_i48 < 2; c2_i48++) {
    c2_b_sizes[c2_i48] = c2_tmp_sizes[c2_i48];
  }

  c2_b0 = (c2_b_sizes[0] == 0);
  if (c2_b0) {
  } else {
    c2_ntilerows = c2_mv[0];
    c2_ia = 0;
    c2_ib = 1;
    c2_eml_int_forloop_overflow_check(chartInstance, 1);
    c2_jtilecol = 1;
    while (c2_jtilecol <= 1) {
      c2_iacol = 1;
      c2_eml_int_forloop_overflow_check(chartInstance, 4);
      for (c2_jcol = 1; c2_jcol < 5; c2_jcol++) {
        c2_eml_int_forloop_overflow_check(chartInstance, c2_ntilerows);
        for (c2_itilerow = 1; c2_itilerow <= c2_ntilerows; c2_itilerow++) {
          c2_ia = c2_iacol;
          c2_b_data[_SFD_EML_ARRAY_BOUNDS_CHECK("", c2_ib, 1, c2_b_sizes[0] << 2,
            1, 0) - 1] = c2_dv2[_SFD_EML_ARRAY_BOUNDS_CHECK("", c2_ia, 1, 4, 1,
            0) - 1];
          c2_a = c2_ia;
          c2_ia = c2_a;
          c2_b_a = c2_ib + 1;
          c2_ib = c2_b_a;
        }

        c2_iacol = c2_ia + 1;
      }

      c2_jtilecol = 2;
    }
  }
}

static void c2_eml_assert_valid_size_arg(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, real_T c2_varargin_1)
{
  real_T c2_arg;
  boolean_T c2_p;
  int32_T c2_i49;
  static char_T c2_cv0[28] = { 'C', 'o', 'd', 'e', 'r', ':', 'M', 'A', 'T', 'L',
    'A', 'B', ':', 'N', 'o', 'n', 'I', 'n', 't', 'e', 'g', 'e', 'r', 'I', 'n',
    'p', 'u', 't' };

  char_T c2_u[28];
  const mxArray *c2_y = NULL;
  c2_arg = c2_varargin_1;
  if (c2_arg != c2_arg) {
    c2_p = FALSE;
  } else {
    c2_p = TRUE;
  }

  if (c2_p) {
  } else {
    for (c2_i49 = 0; c2_i49 < 28; c2_i49++) {
      c2_u[c2_i49] = c2_cv0[c2_i49];
    }

    c2_y = NULL;
    sf_mex_assign(&c2_y, sf_mex_create("y", c2_u, 10, 0U, 1U, 0U, 2, 1, 28),
                  FALSE);
    sf_mex_call_debug("error", 0U, 1U, 14, sf_mex_call_debug("message", 1U, 1U,
      14, c2_y));
  }
}

static void c2_eml_int_forloop_overflow_check
  (SFc2_viptrafficof_winInstanceStruct *chartInstance, int32_T c2_b)
{
}

static const mxArray *c2_e_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData)
{
  const mxArray *c2_mxArrayOutData = NULL;
  int32_T c2_u;
  const mxArray *c2_y = NULL;
  SFc2_viptrafficof_winInstanceStruct *chartInstance;
  chartInstance = (SFc2_viptrafficof_winInstanceStruct *)chartInstanceVoid;
  c2_mxArrayOutData = NULL;
  c2_u = *(int32_T *)c2_inData;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", &c2_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c2_mxArrayOutData, c2_y, FALSE);
  return c2_mxArrayOutData;
}

static int32_T c2_f_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId)
{
  int32_T c2_y;
  int32_T c2_i50;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), &c2_i50, 1, 6, 0U, 0, 0U, 0);
  c2_y = c2_i50;
  sf_mex_destroy(&c2_u);
  return c2_y;
}

static void c2_e_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData)
{
  const mxArray *c2_b_sfEvent;
  const char_T *c2_identifier;
  emlrtMsgIdentifier c2_thisId;
  int32_T c2_y;
  SFc2_viptrafficof_winInstanceStruct *chartInstance;
  chartInstance = (SFc2_viptrafficof_winInstanceStruct *)chartInstanceVoid;
  c2_b_sfEvent = sf_mex_dup(c2_mxArrayInData);
  c2_identifier = c2_varName;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_y = c2_f_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_b_sfEvent),
    &c2_thisId);
  sf_mex_destroy(&c2_b_sfEvent);
  *(int32_T *)c2_outData = c2_y;
  sf_mex_destroy(&c2_mxArrayInData);
}

static uint8_T c2_g_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_b_is_active_c2_viptrafficof_win, const
  char_T *c2_identifier)
{
  uint8_T c2_y;
  emlrtMsgIdentifier c2_thisId;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_y = c2_h_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c2_b_is_active_c2_viptrafficof_win), &c2_thisId);
  sf_mex_destroy(&c2_b_is_active_c2_viptrafficof_win);
  return c2_y;
}

static uint8_T c2_h_emlrt_marshallIn(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId)
{
  uint8_T c2_y;
  uint8_T c2_u0;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), &c2_u0, 1, 3, 0U, 0, 0U, 0);
  c2_y = c2_u0;
  sf_mex_destroy(&c2_u);
  return c2_y;
}

static void c2_mul_wide_s32(SFc2_viptrafficof_winInstanceStruct *chartInstance,
  int32_T c2_in0, int32_T c2_in1, uint32_T *c2_ptrOutBitsHi, uint32_T
  *c2_ptrOutBitsLo)
{
  uint32_T c2_absIn0;
  uint32_T c2_absIn1;
  int32_T c2_negativeProduct;
  uint32_T c2_in0Hi;
  uint32_T c2_in0Lo;
  uint32_T c2_in1Hi;
  uint32_T c2_in1Lo;
  uint32_T c2_productHiHi;
  uint32_T c2_productHiLo;
  uint32_T c2_productLoHi;
  uint32_T c2_productLoLo;
  uint32_T c2_carry;
  uint32_T c2_outBitsLo;
  uint32_T c2_outBitsHi;
  c2_absIn0 = (uint32_T)(c2_in0 < 0 ? -c2_in0 : c2_in0);
  c2_absIn1 = (uint32_T)(c2_in1 < 0 ? -c2_in1 : c2_in1);
  c2_negativeProduct = !((c2_in0 == 0) || ((c2_in1 == 0) || (c2_in0 > 0 ==
    c2_in1 > 0)));
  c2_in0Hi = c2_absIn0 >> 16U;
  c2_in0Lo = c2_absIn0 & 65535U;
  c2_in1Hi = c2_absIn1 >> 16U;
  c2_in1Lo = c2_absIn1 & 65535U;
  c2_productHiHi = c2_in0Hi * c2_in1Hi;
  c2_productHiLo = c2_in0Hi * c2_in1Lo;
  c2_productLoHi = c2_in0Lo * c2_in1Hi;
  c2_productLoLo = c2_in0Lo * c2_in1Lo;
  c2_carry = 0U;
  c2_outBitsLo = c2_productLoLo + (c2_productLoHi << 16U);
  if (c2_outBitsLo < c2_productLoLo) {
    c2_carry++;
  }

  c2_productLoLo = c2_outBitsLo;
  c2_outBitsLo += c2_productHiLo << 16U;
  if (c2_outBitsLo < c2_productLoLo) {
    c2_carry++;
  }

  c2_outBitsHi = ((c2_carry + c2_productHiHi) + (c2_productLoHi >> 16U)) +
    (c2_productHiLo >> 16U);
  if (c2_negativeProduct) {
    c2_outBitsHi = ~c2_outBitsHi;
    c2_outBitsLo = ~c2_outBitsLo;
    c2_outBitsLo++;
    if (c2_outBitsLo == 0U) {
      c2_outBitsHi++;
    }
  }

  *c2_ptrOutBitsHi = c2_outBitsHi;
  *c2_ptrOutBitsLo = c2_outBitsLo;
}

static int32_T c2_mul_s32_s32_s32_sat(SFc2_viptrafficof_winInstanceStruct
  *chartInstance, int32_T c2_a, int32_T c2_b)
{
  int32_T c2_result;
  uint32_T c2_u32_clo;
  uint32_T c2_u32_chi;
  c2_mul_wide_s32(chartInstance, c2_a, c2_b, &c2_u32_chi, &c2_u32_clo);
  if (((int32_T)c2_u32_chi > 0) || ((c2_u32_chi == 0U) && (c2_u32_clo >=
        2147483648U))) {
    c2_result = MAX_int32_T;
  } else if (((int32_T)c2_u32_chi < -1) || (((int32_T)c2_u32_chi == -1) &&
              (c2_u32_clo < 2147483648U))) {
    c2_result = MIN_int32_T;
  } else {
    c2_result = (int32_T)c2_u32_clo;
  }

  return c2_result;
}

static void init_dsm_address_info(SFc2_viptrafficof_winInstanceStruct
  *chartInstance)
{
}

/* SFunction Glue Code */
void sf_c2_viptrafficof_win_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(2181624669U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(600279328U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(9926751U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1388600274U);
}

mxArray *sf_c2_viptrafficof_win_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("PkoBFPPd3RVysUE47UjU1D");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(80);
      pr[1] = (double)(4);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(8));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));
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
      pr[0] = (double)(80);
      pr[1] = (double)(4);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(8));
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

static const mxArray *sf_get_sim_state_info_c2_viptrafficof_win(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x2'type','srcId','name','auxInfo'{{M[1],M[5],T\"y\",},{M[8],M[0],T\"is_active_c2_viptrafficof_win\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 2, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c2_viptrafficof_win_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc2_viptrafficof_winInstanceStruct *chartInstance;
    chartInstance = (SFc2_viptrafficof_winInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (_viptrafficof_winMachineNumber_,
           2,
           1,
           1,
           3,
           0,
           0,
           0,
           0,
           0,
           &(chartInstance->chartNumber),
           &(chartInstance->instanceNumber),
           ssGetPath(S),
           (void *)S);
        if (chartAlreadyPresent==0) {
          /* this is the first instance */
          init_script_number_translation(_viptrafficof_winMachineNumber_,
            chartInstance->chartNumber);
          sf_debug_set_chart_disable_implicit_casting
            (_viptrafficof_winMachineNumber_,chartInstance->chartNumber,1);
          sf_debug_set_chart_event_thresholds(_viptrafficof_winMachineNumber_,
            chartInstance->chartNumber,
            0,
            0,
            0);
          _SFD_SET_DATA_PROPS(0,1,1,0,"u");
          _SFD_SET_DATA_PROPS(1,2,0,1,"y");
          _SFD_SET_DATA_PROPS(2,10,0,0,"line_row");
          _SFD_STATE_INFO(0,0,2);
          _SFD_CH_SUBSTATE_COUNT(0);
          _SFD_CH_SUBSTATE_DECOMP(0);
        }

        _SFD_CV_INIT_CHART(0,0,0,0);

        {
          _SFD_CV_INIT_STATE(0,0,0,0,0,0,NULL,NULL);
        }

        _SFD_CV_INIT_TRANS(0,0,NULL,NULL,0,NULL);

        /* Initialization of MATLAB Function Model Coverage */
        _SFD_CV_INIT_EML(0,1,1,0,0,0,0,0,0,0);
        _SFD_CV_INIT_EML_FCN(0,0,"eML_blk_kernel",0,-1,154);
        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        {
          unsigned int dimVector[2];
          dimVector[0]= 80;
          dimVector[1]= 4;
          _SFD_SET_DATA_COMPILED_PROPS(0,SF_INT32,2,&(dimVector[0]),0,0,0,0.0,
            1.0,0,0,(MexFcnForType)c2_sf_marshallOut,(MexInFcnForType)NULL);
        }

        {
          unsigned int dimVector[2];
          dimVector[0]= 80;
          dimVector[1]= 4;
          _SFD_SET_DATA_COMPILED_PROPS(1,SF_INT32,2,&(dimVector[0]),0,0,0,0.0,
            1.0,0,0,(MexFcnForType)c2_sf_marshallOut,(MexInFcnForType)
            c2_sf_marshallIn);
        }

        _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c2_b_sf_marshallOut,(MexInFcnForType)c2_b_sf_marshallIn);

        {
          int32_T (*c2_u_sizes)[2];
          int32_T (*c2_y_sizes)[2];
          int32_T (*c2_u_data)[320];
          int32_T (*c2_y_data)[320];
          c2_y_sizes = (int32_T (*)[2])ssGetCurrentOutputPortDimensions_wrapper
            (chartInstance->S, 1);
          c2_y_data = (int32_T (*)[320])ssGetOutputPortSignal(chartInstance->S,
            1);
          c2_u_sizes = (int32_T (*)[2])ssGetCurrentInputPortDimensions_wrapper
            (chartInstance->S, 0);
          c2_u_data = (int32_T (*)[320])ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR_VAR_DIM(0U, *c2_u_data, (void *)c2_u_sizes);
          _SFD_SET_DATA_VALUE_PTR_VAR_DIM(1U, *c2_y_data, (void *)c2_y_sizes);
          _SFD_SET_DATA_VALUE_PTR(2U, &chartInstance->c2_line_row);
        }
      }
    } else {
      sf_debug_reset_current_state_configuration(_viptrafficof_winMachineNumber_,
        chartInstance->chartNumber,chartInstance->instanceNumber);
    }
  }
}

static const char* sf_get_instance_specialization()
{
  return "waO4cP1UkGcL828l5c7YHB";
}

static void sf_opaque_initialize_c2_viptrafficof_win(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc2_viptrafficof_winInstanceStruct*)
    chartInstanceVar)->S,0);
  initialize_params_c2_viptrafficof_win((SFc2_viptrafficof_winInstanceStruct*)
    chartInstanceVar);
  initialize_c2_viptrafficof_win((SFc2_viptrafficof_winInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_enable_c2_viptrafficof_win(void *chartInstanceVar)
{
  enable_c2_viptrafficof_win((SFc2_viptrafficof_winInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_disable_c2_viptrafficof_win(void *chartInstanceVar)
{
  disable_c2_viptrafficof_win((SFc2_viptrafficof_winInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_gateway_c2_viptrafficof_win(void *chartInstanceVar)
{
  sf_c2_viptrafficof_win((SFc2_viptrafficof_winInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c2_viptrafficof_win(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c2_viptrafficof_win
    ((SFc2_viptrafficof_winInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c2_viptrafficof_win();/* state var info */
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

extern void sf_internal_set_sim_state_c2_viptrafficof_win(SimStruct* S, const
  mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c2_viptrafficof_win();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c2_viptrafficof_win((SFc2_viptrafficof_winInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c2_viptrafficof_win(SimStruct* S)
{
  return sf_internal_get_sim_state_c2_viptrafficof_win(S);
}

static void sf_opaque_set_sim_state_c2_viptrafficof_win(SimStruct* S, const
  mxArray *st)
{
  sf_internal_set_sim_state_c2_viptrafficof_win(S, st);
}

static void sf_opaque_terminate_c2_viptrafficof_win(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc2_viptrafficof_winInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
    }

    finalize_c2_viptrafficof_win((SFc2_viptrafficof_winInstanceStruct*)
      chartInstanceVar);
    free((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }

  unload_viptrafficof_win_optimization_info();
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc2_viptrafficof_win((SFc2_viptrafficof_winInstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c2_viptrafficof_win(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c2_viptrafficof_win((SFc2_viptrafficof_winInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c2_viptrafficof_win(SimStruct *S)
{
  /* Actual parameters from chart:
     line_row
   */
  const char_T *rtParamNames[] = { "p1" };

  ssSetNumRunTimeParams(S,ssGetSFcnParamsCount(S));

  /* registration for line_row*/
  ssRegDlgParamAsRunTimeParam(S, 0, 0, rtParamNames[0], SS_DOUBLE);
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_viptrafficof_win_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      2);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,2,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,2,
      "gatewayCannotBeInlinedMultipleTimes"));
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,2,1);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,2,1);
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,2);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(3331476317U));
  ssSetChecksum1(S,(3245163733U));
  ssSetChecksum2(S,(2976799212U));
  ssSetChecksum3(S,(1080403485U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
}

static void mdlRTW_c2_viptrafficof_win(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
  }
}

static void mdlStart_c2_viptrafficof_win(SimStruct *S)
{
  SFc2_viptrafficof_winInstanceStruct *chartInstance;
  chartInstance = (SFc2_viptrafficof_winInstanceStruct *)malloc(sizeof
    (SFc2_viptrafficof_winInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc2_viptrafficof_winInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 1;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway =
    sf_opaque_gateway_c2_viptrafficof_win;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c2_viptrafficof_win;
  chartInstance->chartInfo.terminateChart =
    sf_opaque_terminate_c2_viptrafficof_win;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c2_viptrafficof_win;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c2_viptrafficof_win;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c2_viptrafficof_win;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c2_viptrafficof_win;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c2_viptrafficof_win;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c2_viptrafficof_win;
  chartInstance->chartInfo.mdlStart = mdlStart_c2_viptrafficof_win;
  chartInstance->chartInfo.mdlSetWorkWidths =
    mdlSetWorkWidths_c2_viptrafficof_win;
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
  chart_debug_initialization(S,1);
}

void c2_viptrafficof_win_method_dispatcher(SimStruct *S, int_T method, void
  *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c2_viptrafficof_win(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c2_viptrafficof_win(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c2_viptrafficof_win(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c2_viptrafficof_win_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}

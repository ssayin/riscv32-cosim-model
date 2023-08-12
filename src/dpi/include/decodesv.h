// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

#ifndef EXPORTER_DECODESV_H
#define EXPORTER_DECODESV_H

#include <stdint.h>

#include "svdpi.h"

#define EXPORTER_VECVAL_SET(x, val)                                            \
  do {                                                                         \
    x.aval = val;                                                              \
    x.bval = 0;                                                                \
  } while (0)

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
  svLogicVecVal instr;
  svLogicVecVal pc_in;
} decoder_in_t;

typedef struct {
  svLogicVecVal imm;
  svLogicVecVal rs1_addr;
  svLogic rs1_en;
  svLogicVecVal rs2_addr;
  svLogic rs2_en;
  svLogicVecVal rd_addr;
  svLogic rd_en;
  svLogic alu;
  svLogic lsu;
  svLogic br;
  svLogic csr;
  svLogic lui;
  svLogic auipc;
  svLogic jal;
  svLogic fencei;
  svLogic fence;
  svLogic illegal;
  svLogic use_imm;
} decoder_out_t;

// Declare the DPI-imported and exported functions
void dpi_decoder_input(const decoder_in_t *in);
void dpi_decoder_output(decoder_out_t *out);
void dpi_decoder_process(const decoder_in_t *in, decoder_out_t *out);

#ifdef __cplusplus
}
#endif
#endif /* end of include guard: EXPORTER_DECODESV_H */

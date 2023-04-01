#ifndef EXPORTER_DECODESV_H
#define EXPORTER_DECODESV_H

#include <stdint.h>

#include "svdpi.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
  svLogic alu;
  svLogic mul;
  svLogic lsu;
  svLogic br;
  svLogic illegal;
} pt_t;

typedef struct {
  svLogicVecVal instr;
  svLogicVecVal pc_target;
  svLogicVecVal rs1_addr;
  svLogicVecVal rs2_addr;
  svLogicVecVal rd_addr;
  svLogicVecVal rd_data;
  svLogicVecVal imm;
  svLogicVecVal funct3;
  svLogicVecVal funct7;
  pt_t pt;
  svLogic clk;
  svLogic rst_n;
  svLogic is_compressed;
  svLogic rd_en;
  svLogic mem_rd_en;
  svLogic mem_wr_en;
  svLogic use_imm;
  svLogic load_upper;
} Decoder_IO;

// Declare the DPI-imported and exported functions
void dpi_decoder_input(const Decoder_IO *io);
void dpi_decoder_output(Decoder_IO *io);
void dpi_decoder_process(const Decoder_IO *in, Decoder_IO *out);

#ifdef __cplusplus
}
#endif
#endif /* end of include guard: EXPORTER_DECODESV_H */

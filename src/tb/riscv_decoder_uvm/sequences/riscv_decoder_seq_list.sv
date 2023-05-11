// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_DECODER_SEQ_LIST
`define RISCV_DECODER_SEQ_LIST

package riscv_decoder_seq_list;

  import uvm_pkg::*;

  `include "uvm_macros.svh"

  import riscv_decoder_pkg::*;
  import riscv_decoder_ref_model_pkg::*;
  import riscv_decoder_env_pkg::*;

  `include "riscv_decoder_basic_seq.sv"
  `include "riscv_decoder_instr_seq_from_file.sv"

endpackage : riscv_decoder_seq_list

`endif

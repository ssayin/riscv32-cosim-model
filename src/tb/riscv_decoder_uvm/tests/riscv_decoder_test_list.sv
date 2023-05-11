// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_DECODER_TEST_LIST
`define RISCV_DECODER_TEST_LIST

package riscv_decoder_test_list;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import riscv_decoder_env_pkg::*;
  import riscv_decoder_seq_list::*;

  `include "riscv_decoder_basic_test.sv"
  `include "riscv_decoder_from_file_test.sv"

endpackage : riscv_decoder_test_list

`endif




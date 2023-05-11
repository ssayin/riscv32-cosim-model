// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_DECODER_REF_MODEL_PKG
`define RISCV_DECODER_REF_MODEL_PKG

package riscv_decoder_ref_model_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"

  import riscv_decoder_pkg::*;

  `include "riscv_decoder_ref_model.sv"

endpackage : riscv_decoder_ref_model_pkg

`endif

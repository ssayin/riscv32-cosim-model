// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_CORE_REF_MODEL_PKG
`define RISCV_CORE_REF_MODEL_PKG

package riscv_core_ref_model_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"

  import riscv_core_pkg::*;

  `include "riscv_core_ref_model.sv"

endpackage : riscv_core_ref_model_pkg

`endif

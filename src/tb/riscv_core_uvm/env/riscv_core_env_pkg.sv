// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_CORE_ENV_PKG
`define RISCV_CORE_ENV_PKG

package riscv_core_env_pkg;
  import uvm_pkg::*;

  `include "uvm_macros.svh"
  `include "riscv_core_scoreboard.sv"
  `include "riscv_core_coverage.sv"
  `include "riscv_core_env.sv"

endpackage : riscv_core_env_pkg

`endif



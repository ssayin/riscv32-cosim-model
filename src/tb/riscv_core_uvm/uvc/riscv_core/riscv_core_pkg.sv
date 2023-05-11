// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_CORE_AGENT_PKG
`define RISCV_CORE_AGENT_PKG

package riscv_core_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"

  `include "riscv_core_transaction.sv"
  `include "riscv_core_sequencer.sv"
  `include "riscv_core_driver.sv"
  `include "riscv_core_monitor.sv"
  `include "riscv_core_agent.sv"

endpackage : riscv_core_pkg

`endif

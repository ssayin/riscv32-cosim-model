// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_DECODER_AGENT_PKG
`define RISCV_DECODER_AGENT_PKG

package riscv_decoder_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"

  `include "riscv_decoder_transaction.sv"
  `include "riscv_decoder_sequencer.sv"
  `include "riscv_decoder_driver.sv"
  `include "riscv_decoder_monitor.sv"
  `include "riscv_decoder_agent.sv"

endpackage : riscv_decoder_pkg

`endif

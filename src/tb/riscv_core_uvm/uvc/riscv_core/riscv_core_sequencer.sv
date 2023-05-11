// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_CORE_SEQUENCER
`define RISCV_CORE_SEQUENCER

class riscv_core_sequencer extends uvm_sequencer #(riscv_core_transaction);
  `uvm_component_utils(riscv_core_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

`endif

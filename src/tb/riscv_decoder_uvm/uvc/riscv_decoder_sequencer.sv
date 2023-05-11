// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_DECODER_SEQUENCER
`define RISCV_DECODER_SEQUENCER

class riscv_decoder_sequencer extends uvm_sequencer #(riscv_decoder_transaction);
  `uvm_component_utils(riscv_decoder_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

`endif

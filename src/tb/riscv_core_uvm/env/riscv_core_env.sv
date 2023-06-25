// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_CORE_ENV
`define RISCV_CORE_ENV

class riscv_core_env extends uvm_env;
  `uvm_component_utils(riscv_core_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
  endfunction : connect_phase

endclass : riscv_core_env

`endif





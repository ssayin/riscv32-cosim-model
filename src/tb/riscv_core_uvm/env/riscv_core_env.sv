// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_CORE_ENV
`define RISCV_CORE_ENV

class riscv_env extends uvm_env;
  `uvm_component_utils(riscv_env)

  if_stage_agent  if_stage;
  id_stage_agent  id_stage;
  ex_stage_agent  ex_stage;
  mem_stage_agent mem_stage;
  wb_stage_agent  wb_stage;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if_stage  = if_stage_agent::type_id::create("if_stage", this);
    id_stage  = id_stage_agent::type_id::create("id_stage", this);
    ex_stage  = ex_stage_agent::type_id::create("ex_stage", this);
    mem_stage = mem_stage_agent::type_id::create("mem_stage", this);
    wb_stage  = wb_stage_agent::type_id::create("wb_stage", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // connect

  endfunction : connect_phase

  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  endfunction : start_of_simulation_phase

  virtual function void run_phase(uvm_phase phase);
    super.run_phase(phase);
  endfunction : run_phase

  virtual function void end_of_simulation_phase(uvm_phase phase);
    super.end_of_simulation_phase(phase);
  endfunction : end_of_simulation_phase

endclass : riscv_env

`endif





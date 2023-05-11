// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

class mem_stage_agent extends uvm_agent;
`uvm_component_utils(mem_stage_agent)

  mem_stage_monitor mem_mon;
  mem_stage_driver  mem_drv;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mem_mon = mem_stage_monitor::type_id::create("mem_mon", this);
    mem_drv = mem_stage_driver::type_id::create("mem_drv", this);
  endfunction : build_phase
endclass : mem_stage_agent


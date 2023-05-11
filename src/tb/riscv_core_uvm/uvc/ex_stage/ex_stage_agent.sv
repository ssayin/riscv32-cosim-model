// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

class ex_stage_agent extends uvm_agent;
  `uvm_component_utils(ex_stage_agent)

  ex_stage_monitor ex_mon;
  ex_stage_driver  ex_drv;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ex_mon = ex_stage_monitor::type_id::create("ex_mon", this);
    ex_drv = ex_stage_driver::type_id::create("ex_drv", this);
  endfunction : build_phase
endclass : ex_stage_agent

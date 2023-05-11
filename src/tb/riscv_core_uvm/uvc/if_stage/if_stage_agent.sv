// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

class if_stage_agent extends uvm_agent;
  `uvm_component_utils(if_stage_agent)

  if_stage_monitor if_mon;
  if_stage_driver  if_drv;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if_mon = if_stage_monitor::type_id::create("if_mon", this);
    if_drv = if_stage_driver::type_id::create("if_drv", this);
  endfunction : build_phase
endclass : if_stage_agent



// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

class wb_stage_agent extends uvm_agent;
  `uvm_component_utils(wb_stage_agent)

  wb_stage_monitor wb_mon;
  wb_stage_driver  wb_drv;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wb_mon = wb_stage_monitor::type_id::create("wb_mon", this);
    wb_drv = wb_stage_driver::type_id::create("wb_drv", this);
  endfunction : build_phase
endclass : wb_stage_agent


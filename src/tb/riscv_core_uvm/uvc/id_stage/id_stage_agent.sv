// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

class id_stage_agent extends uvm_agent;
  `uvm_component_utils(id_stage_agent)

  id_stage_monitor id_mon;
  id_stage_driver  id_drv;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    id_mon = id_stage_monitor::type_id::create("id_mon", this);
    id_drv = id_stage_driver::type_id::create("id_drv", this);
  endfunction : build_phase
endclass : id_stage_agent


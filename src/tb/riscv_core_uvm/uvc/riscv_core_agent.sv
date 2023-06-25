// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_CORE_AGENT
`define RISCV_CORE_AGENT

class riscv_core_agent extends uvm_agent;

  riscv_core_driver    driver;
  riscv_core_sequencer sequencer;
  riscv_core_monitor   monitor;

  `uvm_component_utils(riscv_core_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = riscv_core_driver::type_id::create("driver", this);
    sequencer = riscv_core_sequencer::type_id::create("sequencer", this);
    monitor = riscv_core_monitor::type_id::create("monitor", this);
  endfunction : build_phase


  function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction : connect_phase

endclass : riscv_core_agent

`endif

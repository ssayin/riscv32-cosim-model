`ifndef RISCV_DECODER_AGENT
`define RISCV_DECODER_AGENT

class riscv_decoder_agent extends uvm_agent;

  riscv_decoder_driver    driver;
  riscv_decoder_sequencer sequencer;
  riscv_decoder_monitor   monitor;

  `uvm_component_utils(riscv_decoder_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = riscv_decoder_driver::type_id::create("driver", this);
    sequencer = riscv_decoder_sequencer::type_id::create("sequencer", this);
    monitor = riscv_decoder_monitor::type_id::create("monitor", this);
  endfunction : build_phase


  function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction : connect_phase

endclass : riscv_decoder_agent

`endif

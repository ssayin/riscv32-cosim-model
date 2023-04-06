`ifndef DEC_DECODE_AGENT
`define DEC_DECODE_AGENT

class dec_decode_agent extends uvm_agent;

  dec_decode_driver    driver;
  dec_decode_sequencer sequencer;
  dec_decode_monitor   monitor;

  `uvm_component_utils(dec_decode_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = dec_decode_driver::type_id::create("driver", this);
    sequencer = dec_decode_sequencer::type_id::create("sequencer", this);
    monitor = dec_decode_monitor::type_id::create("monitor", this);
  endfunction : build_phase


  function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction : connect_phase

endclass : dec_decode_agent

`endif

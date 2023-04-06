`ifndef DEC_DECODE_ENV
`define DEC_DECODE_ENV

class dec_decode_env extends uvm_env;
  dec_decode_agent dec_decode_ag;
  dec_decode_ref_model ref_model;

  dec_decode_coverage #(dec_decode_transaction) coverage;

  dec_decode_scoreboard sb;

  `uvm_component_utils(dec_decode_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    dec_decode_ag = dec_decode_agent::type_id::create("dec_decode_ag", this);
    ref_model = dec_decode_ref_model::type_id::create("ref_model", this);
    coverage = dec_decode_coverage#(dec_decode_transaction)::type_id::create("coverage", this);
    sb = dec_decode_scoreboard::type_id::create("sb", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    dec_decode_ag.driver.drv2rm_port.connect(ref_model.rm_export);
    dec_decode_ag.monitor.mon2sb_port.connect(sb.mon2sb_export);
    ref_model.rm2sb_port.connect(coverage.analysis_export);
    ref_model.rm2sb_port.connect(sb.rm2sb_export);
  endfunction : connect_phase

endclass : dec_decode_env

`endif





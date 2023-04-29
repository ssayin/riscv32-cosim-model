`ifndef RISCV_DECODER_ENV
`define RISCV_DECODER_ENV

class riscv_decoder_env extends uvm_env;
  riscv_decoder_agent                                 riscv_decoder_ag;
  riscv_decoder_ref_model                             ref_model;

  riscv_decoder_coverage #(riscv_decoder_transaction) coverage;

  riscv_decoder_scoreboard                            sb;

  `uvm_component_utils(riscv_decoder_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    riscv_decoder_ag = riscv_decoder_agent::type_id::create("riscv_decoder_ag", this);
    ref_model = riscv_decoder_ref_model::type_id::create("ref_model", this);
    coverage =
        riscv_decoder_coverage#(riscv_decoder_transaction)::type_id::create("coverage", this);
    sb = riscv_decoder_scoreboard::type_id::create("sb", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    riscv_decoder_ag.driver.drv2rm_port.connect(ref_model.rm_export);
    riscv_decoder_ag.monitor.mon2sb_port.connect(sb.mon2sb_export);
    ref_model.rm2sb_port.connect(coverage.analysis_export);
    ref_model.rm2sb_port.connect(sb.rm2sb_export);
  endfunction : connect_phase

endclass : riscv_decoder_env

`endif





`ifndef RISCV_CORE_ENV
`define RISCV_CORE_ENV

class riscv_core_env extends uvm_env;
  riscv_core_agent                                 riscv_core_ag;
  riscv_core_ref_model                             ref_model;

  riscv_core_coverage #(riscv_core_transaction) coverage;

  riscv_core_scoreboard                            sb;

  `uvm_component_utils(riscv_core_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    riscv_core_ag = riscv_core_agent::type_id::create("riscv_core_ag", this);
    ref_model = riscv_core_ref_model::type_id::create("ref_model", this);
    coverage =
        riscv_core_coverage#(riscv_core_transaction)::type_id::create("coverage", this);
    sb = riscv_core_scoreboard::type_id::create("sb", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    riscv_core_ag.driver.drv2rm_port.connect(ref_model.rm_export);
    riscv_core_ag.monitor.mon2sb_port.connect(sb.mon2sb_export);
    ref_model.rm2sb_port.connect(coverage.analysis_export);
    ref_model.rm2sb_port.connect(sb.rm2sb_export);
  endfunction : connect_phase

endclass : riscv_core_env

`endif





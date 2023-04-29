`ifndef RISCV_DECODER_FROM_FILE_TEST
`define RISCV_DECODER_FROM_FILE_TEST

class riscv_decoder_from_file_test extends uvm_test;

  `uvm_component_utils(riscv_decoder_from_file_test)

  riscv_decoder_env env;
  riscv_decoder_instr_seq_from_file seq;

  function new(string name = "riscv_decoder_from_file_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    env = riscv_decoder_env::type_id::create("env", this);
    seq = riscv_decoder_instr_seq_from_file::type_id::create("seq");

  endfunction : build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.riscv_decoder_ag.sequencer);
    phase.drop_objection(this);
  endtask : run_phase

endclass : riscv_decoder_from_file_test

`endif

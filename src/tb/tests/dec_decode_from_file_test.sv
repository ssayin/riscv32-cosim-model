`ifndef DEC_DECODE_FROM_FILE_TEST
`define DEC_DECODE_FROM_FILE_TEST

class dec_decode_from_file_test extends uvm_test;

  `uvm_component_utils(dec_decode_from_file_test)

  dec_decode_env env;
  dec_decode_instr_seq_from_file seq;

  function new(string name = "dec_decode_from_file_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    env = dec_decode_env::type_id::create("env", this);
    seq = dec_decode_instr_seq_from_file::type_id::create("seq");

  endfunction : build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.dec_decode_ag.sequencer);
    phase.drop_objection(this);
  endtask : run_phase

endclass : dec_decode_from_file_test

`endif

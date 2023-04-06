`ifndef DEC_DECODE_COVERAGE
`define DEC_DECODE_COVERAGE

class dec_decode_coverage #(
    type T = dec_decode_transaction
) extends uvm_subscriber #(T);

  dec_decode_transaction cov_trans;
  `uvm_component_utils(dec_decode_coverage);

  covergroup dec_decode_cg;

    option.per_instance = 1;
    option.goal = 100;

    dec_decode_instr: coverpoint cov_trans.dec_in.instr {bins instr_values[] = {[0 : $]};}

    // dec_decode_alu: coverpoint cov_trans.dec_out.alu {bins low = {0}; bins high = {1};}

    dec_decode_illegal: coverpoint cov_trans.dec_out.illegal {
      bins low = {0}; bins high = {1};
    }

  endgroup : dec_decode_cg


  function new(string name = "dec_decode_ref_model", uvm_component parent);
    super.new(name, parent);
    dec_decode_cg = new();
    cov_trans = new();
  endfunction : new


  function void write(T t);
    this.cov_trans = t;
    dec_decode_cg.sample();
  endfunction : write

endclass : dec_decode_coverage

`endif

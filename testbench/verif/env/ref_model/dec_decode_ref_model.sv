`ifndef DEC_DECODE_REF_MODEL
`define DEC_DECODE_REF_MODEL

`include "dec_decode_def.sv"

import "DPI-C" function void init();
import "DPI-C" function void dpi_decoder_input(decoder_in_t io);
import "DPI-C" function void dpi_decoder_output(decoder_out_t io);

import "DPI-C" function void dpi_decoder_process(
  input  decoder_in_t  in,
  output decoder_out_t out
);


class dec_decode_ref_model extends uvm_component;
  `uvm_component_utils(dec_decode_ref_model)

  uvm_analysis_export #(dec_decode_transaction) rm_export;
  uvm_analysis_port #(dec_decode_transaction) rm2sb_port;
  dec_decode_transaction exp_trans, rm_trans;
  uvm_tlm_analysis_fifo #(dec_decode_transaction) rm_exp_fifo;

  function new(string name = "dec_decode_ref_model", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rm_export   = new("rm_export", this);
    rm2sb_port  = new("rm2sb_port", this);
    rm_exp_fifo = new("rm_exp_fifo", this);
  endfunction : build_phase


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rm_export.connect(rm_exp_fifo.analysis_export);
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    forever begin
      rm_exp_fifo.get(rm_trans);
      get_expected_transaction(rm_trans);
    end
  endtask : run_phase

  task get_expected_transaction(dec_decode_transaction rm_trans);
    this.exp_trans = rm_trans;

    // Get decoded instruction
    // from the riscv32-decoder
    dpi_decoder_process(exp_trans.dec_in, exp_trans.dec_out);

    `uvm_info(get_full_name(), $sformatf("EXPECTED TRANSACTION FROM REF MODEL"), UVM_LOW);

    // exp_trans.print();

    rm2sb_port.write(exp_trans);

  endtask : get_expected_transaction


endclass : dec_decode_ref_model

`endif

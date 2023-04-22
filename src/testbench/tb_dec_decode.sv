`ifndef TB_DEC_DECODE
`define TB_DEC_DECODE

module tb_dec_decode
  import uvm_pkg::*;
  import dec_decode_test_list::*;
  import svdpi_pkg::decoder_in_t;
  import svdpi_pkg::decoder_out_t;
#(
  `include "uvm_macros.svh"
  `include "dec_decode_if.sv"
);


  bit clk;
  bit reset;

  initial begin
    clk = 0;
    forever #(50) clk = ~clk;
  end

  initial begin
    reset = 1;
    #(60) reset = 0;
  end

  dec_decode_if dec_decode_intf (
    .clk  (clk),
    .reset(reset)
  );

  dec_decode decoder_inst (
    .i_clk      (clk),
    .i_rst_n    (reset),
    .i_instr    (dec_decode_intf.dec_in.instr),
    .i_pc       (dec_decode_intf.dec_in.pc_in),
    .o_rs1_addr (dec_decode_intf.dec_out.rs1_addr),
    .o_rs2_addr (dec_decode_intf.dec_out.rs2_addr),
    .o_rd_addr  (dec_decode_intf.dec_out.rd_addr),
    .o_imm      (dec_decode_intf.dec_out.imm),
    .o_rd_en    (dec_decode_intf.dec_out.rd_en),
    .o_mem_rd_en(),
    .o_mem_wr_en(),
    .o_use_imm  (dec_decode_intf.dec_out.use_imm),
    .o_alu      (dec_decode_intf.dec_out.alu),
    .o_lsu      (dec_decode_intf.dec_out.lsu),
    .o_br       (dec_decode_intf.dec_out.br),
    .o_alu_op   (),
    .o_lsu_op   (),
    .o_illegal  (dec_decode_intf.dec_out.illegal),
    .o_exp_code ()
  );

  initial begin
    run_test();
  end

  initial begin
    uvm_config_db#(virtual dec_decode_if)::set(uvm_root::get(), "*", "intf", dec_decode_intf);
  end

endmodule : tb_dec_decode


`endif

`ifndef TB_RISCV_DECODER
`define TB_RISCV_DECODER

module tb_riscv_decoder
  import uvm_pkg::*;
  import riscv_decoder_test_list::*;
  import svdpi_pkg::decoder_in_t;
  import svdpi_pkg::decoder_out_t;
#(
  `include "uvm_macros.svh"
  `include "riscv_decoder_if.sv"
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

  riscv_decoder_if riscv_decoder_intf (
    .clk  (clk),
    .reset(reset)
  );

  riscv_decoder decoder_inst (
    .clk       (clk),
    .rst_n     (reset),
    .i_instr   (riscv_decoder_intf.dec_in.instr),
    .i_pc      (riscv_decoder_intf.dec_in.pc_in),
    .o_rs1_addr(riscv_decoder_intf.dec_out.rs1_addr),
    .o_rs2_addr(riscv_decoder_intf.dec_out.rs2_addr),
    .o_rd_addr (riscv_decoder_intf.dec_out.rd_addr),
    .o_imm     (riscv_decoder_intf.dec_out.imm),
    .o_rd_en   (riscv_decoder_intf.dec_out.rd_en),
    .o_use_imm (riscv_decoder_intf.dec_out.use_imm),
    .o_alu     (riscv_decoder_intf.dec_out.alu),
    .o_lsu     (riscv_decoder_intf.dec_out.lsu),
    .o_br      (riscv_decoder_intf.dec_out.br),
    .o_csr     (riscv_decoder_intf.dec_out.csr),
    .o_alu_op  (),
    .o_lsu_op  (),
    .o_lui     (riscv_decoder_intf.dec_out.lui),
    .o_auipc   (riscv_decoder_intf.dec_out.auipc),
    .o_illegal (riscv_decoder_intf.dec_out.illegal),
    .o_exp_code()
  );

  initial begin
    run_test();
  end

  initial begin
    uvm_config_db#(virtual riscv_decoder_if)::set(uvm_root::get(), "*", "intf", riscv_decoder_intf);
  end

endmodule : tb_riscv_decoder


`endif

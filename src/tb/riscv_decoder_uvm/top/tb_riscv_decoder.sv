// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef TB_RISCV_DECODER
`define TB_RISCV_DECODER

module tb_riscv_decoder
  import uvm_pkg::*;
  import riscv_decoder_test_list::*;
  import svdpi_pkg::decoder_in_t;
  import svdpi_pkg::decoder_out_t;
  import instr_defs::*;
#(
  `include "uvm_macros.svh"
  `include "riscv_decoder_if.sv"
);
  bit       clk;
  bit       rst_n;

  ctl_pkt_t ctl;

  initial begin
    clk = 0;
    forever #(50) clk = ~clk;
  end

  initial begin
    rst_n = 1;
    #(60) rst_n = 0;
  end

  riscv_decoder_if riscv_decoder_intf (
    .clk  (clk),
    .rst_n(rst_n)
  );

  riscv_decoder decoder_inst (
    .clk     (clk),
    .rst_n   (rst_n),
    .instr   (riscv_decoder_intf.dec_in.instr),
    .pc      (riscv_decoder_intf.dec_in.pc_in),
    .rs1_addr(riscv_decoder_intf.dec_out.rs1_addr),
    .rs2_addr(riscv_decoder_intf.dec_out.rs2_addr),
    .rd_addr (riscv_decoder_intf.dec_out.rd_addr),
    .imm     (riscv_decoder_intf.dec_out.imm),
    .rd_en   (riscv_decoder_intf.dec_out.rd_en),
    .use_imm (riscv_decoder_intf.dec_out.use_imm),
    .ctl     (ctl),
    .alu_op  (),
    .lsu_op  ()
  );

  assign riscv_decoder_intf.dec_out.alu     = ctl.alu;
  assign riscv_decoder_intf.dec_out.lsu     = ctl.lsu;
  assign riscv_decoder_intf.dec_out.br      = ctl.br;
  assign riscv_decoder_intf.dec_out.csr     = ctl.csr;
  assign riscv_decoder_intf.dec_out.lui     = ctl.lui;
  assign riscv_decoder_intf.dec_out.auipc   = ctl.auipc;
  assign riscv_decoder_intf.dec_out.illegal = ctl.illegal;
  assign riscv_decoder_intf.dec_out.jal     = ctl.jal;
  assign riscv_decoder_intf.dec_out.fence   = ctl.fence;
  assign riscv_decoder_intf.dec_out.fencei  = ctl.fencei;

  initial begin
    run_test();
  end

  initial begin
    uvm_config_db#(virtual riscv_decoder_if)::set(uvm_root::get(), "*", "intf", riscv_decoder_intf);
  end

endmodule : tb_riscv_decoder


`endif

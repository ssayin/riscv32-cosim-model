// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import param_defs::*;
import instr_defs::*;

module riscv_core (
  input logic clk,
  input logic rst_n,

  // WA Channel
  output logic        axi_awid_f,
  output logic [31:0] axi_awaddr_f,
  output logic [ 7:0] axi_awlen_f,
  output logic [ 2:0] axi_awsize_f,
  output logic [ 1:0] axi_awburst_f,
  output logic        axi_awlock_f,
  output logic [ 3:0] axi_awcache_f,
  output logic [ 2:0] axi_awprot_f,
  output logic        axi_awvalid_f,
  output logic [ 3:0] axi_awregion_f,
  output logic [ 3:0] axi_awqos_f,
  input  logic        axi_awready_f,

  // WD Channel
  output logic [63:0] axi_wdata_f,
  output logic [ 7:0] axi_wstrb_f,
  output logic        axi_wlast_f,
  output logic        axi_wvalid_f,
  input  logic        axi_wready_f,

  // Write Response Channel
  input  logic       axi_bid_f,
  input  logic [1:0] axi_bresp_f,
  input  logic       axi_bvalid_f,
  output logic       axi_bready_f,

  // RA Channel
  output logic        axi_arid_f,
  output logic [31:0] axi_araddr_f,
  output logic [ 7:0] axi_arlen_f,
  output logic [ 2:0] axi_arsize_f,
  output logic [ 1:0] axi_arburst_f,
  output logic        axi_arlock_f,
  output logic [ 3:0] axi_arcache_f,
  output logic [ 2:0] axi_arprot_f,
  output logic        axi_arvalid_f,
  output logic [ 3:0] axi_arqos_f,
  output logic [ 3:0] axi_arregion_f,
  input  logic        axi_arready_f,

  // RD Channel
  input  logic        axi_rid_f,
  input  logic [63:0] axi_rdata_f,
  input  logic [ 1:0] axi_rresp_f,
  input  logic        axi_rlast_f,
  input  logic        axi_rvalid_f,
  output logic        axi_rready_f,


  // WA Channel
  output logic        axi_awid_m,
  output logic [31:0] axi_awaddr_m,
  output logic [ 7:0] axi_awlen_m,
  output logic [ 2:0] axi_awsize_m,
  output logic [ 1:0] axi_awburst_m,
  output logic        axi_awlock_m,
  output logic [ 3:0] axi_awcache_m,
  output logic [ 2:0] axi_awprot_m,
  output logic        axi_awvalid_m,
  output logic [ 3:0] axi_awregion_m,
  output logic [ 3:0] axi_awqos_m,
  input  logic        axi_awready_m,

  // WD Channel
  output logic [63:0] axi_wdata_m,
  output logic [ 7:0] axi_wstrb_m,
  output logic        axi_wlast_m,
  output logic        axi_wvalid_m,
  input  logic        axi_wready_m,

  // Write Response Channel
  input  logic       axi_bid_m,
  input  logic [1:0] axi_bresp_m,
  input  logic       axi_bvalid_m,
  output logic       axi_bready_m,

  // RA Channel
  output logic        axi_arid_m,
  output logic [31:0] axi_araddr_m,
  output logic [ 7:0] axi_arlen_m,
  output logic [ 2:0] axi_arsize_m,
  output logic [ 1:0] axi_arburst_m,
  output logic        axi_arlock_m,
  output logic [ 3:0] axi_arcache_m,
  output logic [ 2:0] axi_arprot_m,
  output logic        axi_arvalid_m,
  output logic [ 3:0] axi_arqos_m,
  output logic [ 3:0] axi_arregion_m,
  input  logic        axi_arready_m,

  // RD Channel
  input  logic        axi_rid_m,
  input  logic [63:0] axi_rdata_m,
  input  logic [ 1:0] axi_rresp_m,
  input  logic        axi_rlast_m,
  input  logic        axi_rvalid_m,
  output logic        axi_rready_m
);

  logic                          flush;

  logic                          flush_d0;
  logic                          flush_d1;

  logic      [             31:0] instr_d0;
  logic      [             31:1] pc_d0;
  logic                          compressed_d0;
  logic                          br_d0;
  logic                          br_taken_d0;
  logic                          illegal_d0;

  logic      [             31:0] instr_d1;
  logic      [             31:1] pc_d1;
  logic                          compressed_d1;
  logic                          br_d1;
  logic                          br_taken_d1;
  reg_addr_t                     rd_addr_d1;
  logic                          illegal_d1;

  logic      [             31:1] pc_e;
  logic                          compressed_e;
  logic                          br_e;
  logic                          br_taken_e;
  logic                          use_imm_e;
  logic                          use_pc_e;
  reg_data_t                     imm_e;
  logic                          illegal_e;
  logic                          alu_e;
  logic      [   AluOpWidth-1:0] alu_op_e;
  reg_addr_t                     rd_addr_e;
  logic                          lsu_e;
  logic      [   LsuOpWidth-1:0] lsu_op_e;
  logic      [BranchOpWidth-1:0] br_op_e;
  logic                          rd_en_e;

  logic                          compressed_m;
  logic                          rd_en_m;
  reg_data_t                     alu_res_m;
  reg_data_t                     store_data_m;
  logic                          lsu_m;
  logic      [   LsuOpWidth-1:0] lsu_op_m;
  logic                          br_taken_m;
  logic                          br_m;
  reg_addr_t                     rd_addr_m;

  logic                          rd_en_wb;
  reg_addr_t                     rd_addr_wb;
  reg_data_t                     rd_data_wb;

  ctl_pkt_t                      ctl;

  reg_addr_t                     rd_addr;
  reg_addr_t                     rs1_addr_r;
  reg_addr_t                     rs2_addr_r;

  logic      [             31:1] pc_in;
  logic      [             31:1] pc_out;
  logic                          pc_update;

  reg_data_t                     rs1_data_e;
  reg_data_t                     rs2_data_e;

  logic                          should_br;
  logic                          br_mispredictd;

  logic                          stall;
  logic                          stall_f;

  assign flush_d0 = 0;
  assign flush_d1 = 0;

  ifu ifu_0 (
    .clk          (clk),
    .rst_n        (rst_n),
    .flush_f      (flush),
    .pc_in        (alu_res_m[31:1]),
    .pc_update    (pc_update),
    .pc_out       (pc_out),
    .instr_d0     (instr_d0),
    .pc_d0        (pc_d0),
    .compressed_d0(compressed_d0),
    .br_d0        (br_d0),
    .br_taken_d0  (br_taken_d0),
    .*
  );

  reg_file #(
      .DATA_WIDTH(DataWidth)
  ) register_file_inst (
    .clk     (clk & stall_f),
    .rst_n   (rst_n),
    .rd_addr (rd_addr_wb),
    .rs1_addr(rs1_addr_r),
    .rs2_addr(rs2_addr_r),
    .rd_data (rd_data_wb),
    .wr_en   (rd_en_wb),
    .rs1_data(rs1_data_e),
    .rs2_data(rs2_data_e)
  );

  exu exu_0 (
    .clk(clk & stall_f),
    .*
  );

  id0 id0_0 (
    .clk(clk & stall_f),
    .*
  );

  id1 id1_0 (
    .clk(clk & stall_f),
    .*
  );

  mem mem_0 (
    .clk(clk & stall_f),
    .*
  );


  assign stall               = 'b0;
  assign pc_update           = should_br || br_mispredictd;
  assign flush               = br_mispredictd;

  assign axi_awid_f          = 0;
  assign axi_awaddr_f[31:0]  = 0;
  assign axi_awlen_f[7:0]    = 0;
  assign axi_awsize_f[2:0]   = 0;
  assign axi_awburst_f[1:0]  = 2'b01;
  assign axi_awlock_f        = 0;
  assign axi_awcache_f[3:0]  = 0;
  assign axi_awprot_f[2:0]   = 0;
  assign axi_awvalid_f       = 0;
  assign axi_awregion_f[3:0] = 0;
  assign axi_awqos_f[3:0]    = 0;

  assign axi_wdata_f[63:0]   = 0;
  assign axi_wstrb_f[7:0]    = 0;

  assign axi_wlast_f         = 0;
  assign axi_wvalid_f        = 0;

  assign axi_bready_f        = 0;

  initial begin
    $dumpfile("top.vcd");
    $dumpvars(0, riscv_core);
  end

endmodule : riscv_core

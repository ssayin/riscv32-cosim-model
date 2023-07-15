// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import param_defs::*;
import instr_defs::*;


module lsu (
  input logic clk,
  input logic rst_n
);

endmodule

module riscv_core (
  input  logic                   clk,
  input  logic                   rst_n,
  input  logic [MemBusWidth-1:0] mem_data_in [2],
  input  logic                   mem_ready,        // Stall pipeline on I$ misses
  input  logic                   irq_external,     // unused
  input  logic                   irq_timer,        // unused
  input  logic                   irq_software,     // unused
  output logic [MemBusWidth-1:0] mem_data_out[2],  // Driven by D$ controller
  //output logic [            3:0] mem_wr_en,     // TODO: Alter after cache impl
  output logic                   mem_wr_en   [2],
  output logic                   mem_rd_en   [2],  // The access is for instruction fetch
  //output logic                   mem_valid[2],
  output logic                   mem_clk_en,
  output logic [           31:0] mem_addr    [2]   // Memory offset
);

  logic      [             31:0] mem_rd;
  logic                          flush;

  logic                          flush_d0;
  logic                          flush_d1;

  logic      [             31:0] instr_d0;
  logic      [             31:1] pc_d0;
  logic                          compressed_d0;
  logic                          br_d0;
  logic                          br_taken_d0;

  logic      [             31:0] instr_d1;
  logic      [             31:1] pc_d1;
  logic                          compressed_d1;
  logic                          br_d1;
  logic                          br_taken_d1;
  reg_addr_t                     rd_addr_d1;

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

  logic      [    DataWidth-1:0] pc_in;
  logic      [    DataWidth-1:0] pc_out;
  logic                          pc_update;

  reg_data_t                     rs1_data_e;
  reg_data_t                     rs2_data_e;

  logic                          should_br;
  logic                          br_mispredictd;

  logic                          if_stage_clk_en;
  logic                          id_stage_0_clk_en;
  logic                          id_stage_1_clk_en;
  logic                          ex_stage_clk_en;
  logic                          mem_stage_clk_en;
  logic                          wb_stage_clk_en;
  logic                          reg_file_clk_en;

  logic                          stall;


  if_stage if_stage_0 (
    .clk          (clk & if_stage_clk_en),
    .rst_n        (rst_n),
    .mem_rd       (mem_data_in[0]),
    .flush_f      (flush),
    .pc_in        (alu_res_m),
    .pc_update    (pc_update),
    .pc_out       (pc_out),
    .instr_d0     (instr_d0),
    .pc_d0        (pc_d0),
    .compressed_d0(compressed_d0),
    .br_d0        (br_d0),
    .br_taken_d0  (br_taken_d0)
  );

  reg_file #(
    .DATA_WIDTH(DataWidth)
  ) register_file_inst (
    .clk     (clk & reg_file_clk_en),
    .rst_n   (rst_n),
    .rd_addr (rd_addr_wb),
    .rs1_addr(rs1_addr_r),
    .rs2_addr(rs2_addr_r),
    .rd_data (rd_data_wb),
    .wr_en   (rd_en_wb),
    .rs1_data(rs1_data_e),
    .rs2_data(rs2_data_e)
  );

  ex_stage ex_stage_0 (.*);

  id_stage_0 _id_stage_0 (.*);

  id_stage_1 _id_stage_1 (.*);

  mem_stage mem_stage_0 (
    .clk   (clk & mem_stage_clk_en),
    .rst_n (rst_n),
    .mem_in(mem_data_in[1]),
    .*
  );

  assign mem_wr_en[1]      = lsu_op_m[3] & lsu_m;  // Store
  assign mem_rd_en[1]      = ~lsu_op_m[3] & lsu_m;  // Load
  assign mem_data_out[1]   = store_data_m;  // loaded from reg_file in stage ID1
  assign mem_addr[1]       = alu_res_m;  // load store

  assign stall             = 'b0;

  assign if_stage_clk_en   = !stall;
  assign id_stage_0_clk_en = !stall;
  assign id_stage_1_clk_en = !stall;
  assign mem_stage_clk_en  = !stall;
  assign wb_stage_clk_en   = !stall;
  assign reg_file_clk_en   = !stall;

  assign mem_rd_en[0]      = 'b1;  // always fetch
  assign mem_addr[0]       = pc_out;  //  mem offset for fetch

  assign pc_update         = should_br || br_mispredictd;

  assign flush             = br_mispredictd;

endmodule : riscv_core

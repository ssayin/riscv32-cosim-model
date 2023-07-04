// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import param_defs::*;
import instr_defs::*;

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

  logic      [DataWidth-1:0] write_data;
  logic                      write_en;
  logic      [         31:0] mem_rd;

  logic                      flush;

  p_if_id_t                  p_if_id_0;
  p_if_id_t                  p_id_0_id_1;
  p_id_ex_t                  p_id_ex;
  p_ex_mem_t                 p_ex_mem;
  p_mem_wb_t                 p_mem_wb;
  ctl_pkt_t                  ctl;

  reg_addr_t                 rd_addr;
  reg_addr_t                 rs1_addr;
  reg_addr_t                 rs2_addr;

  logic      [DataWidth-1:0] pc_in;
  logic      [DataWidth-1:0] pc_out;
  logic                      pc_update;

  reg_data_t                 rs1_data;
  reg_data_t                 rs2_data;

  logic                      should_br;
  logic                      br_mispredictd;

  assign mem_rd_en[0] = 'b1;
  assign mem_addr[0]  = pc_out;

  assign pc_update    = should_br || br_mispredictd;

  assign flush        = br_mispredictd;

  if_stage if_stage_0 (
    .clk      (clk),
    .rst_n    (rst_n),
    .mem_rd   (mem_data_in[0]),
    .flush    (flush),
    .pc_in    (p_ex_mem.alu_res),
    .pc_update(pc_update),
    .pc_out   (pc_out),
    .p_if_id  (p_if_id_0)
  );

  reg_file #(
    .DATA_WIDTH(DataWidth)
  ) register_file_inst (
    .clk     (clk),
    .rst_n   (rst_n),
    .rd_addr (p_mem_wb.rd_addr),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_data (p_mem_wb.rd_data),
    .wr_en   (p_mem_wb.rd_en),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
  );

  ex_stage ex_stage_0 (
    .clk           (clk),
    .rst_n         (rst_n),
    .rs1_data      (rs1_data),
    .rs2_data      (rs2_data),
    .p_id_ex       (p_id_ex),
    .p_ex_mem      (p_ex_mem),
    .should_br     (should_br),
    .br_mispredictd(br_mispredictd)
  );

  id_stage_0 _id_stage_0 (
    .clk        (clk),
    .rst_n      (rst_n),
    .flush      (flush),
    .p_if_id_0  (p_if_id_0),
    .p_id_0_id_1(p_id_0_id_1),
    .rd_addr    (rd_addr),
    .rs1_addr   (rs1_addr),
    .rs2_addr   (rs2_addr)
  );

  id_stage_1 _id_stage_1 (
    .clk    (clk),
    .rst_n  (rst_n),
    .flush  (flush),
    .rd_addr(rd_addr),
    .p_if_id(p_id_0_id_1),
    .p_id_ex(p_id_ex)
  );

  assign mem_data_out[1] = p_ex_mem.alu_res;
  assign write_data[0]   = mem_data_in[1];

  assign mem_wr_en[1]    = p_ex_mem.lsu_op[3];
  assign mem_rd_en[1]    = ~p_ex_mem.lsu_op[3];

  assign write_en        = ~p_ex_mem.lsu_op[3];

endmodule : riscv_core

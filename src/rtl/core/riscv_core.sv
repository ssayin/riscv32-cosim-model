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

  logic                        p_id_ex_rd_en;
  logic                        p_ex_mem_rd_en;
  logic                        p_mem_wb_rd_en;

  logic     [   DataWidth-1:0] write_data;
  logic                        write_en;
  logic     [            31:0] mem_rd;
  // Wires
  logic     [RegAddrWidth-1:0] p_id_rd_addr;
  logic     [RegAddrWidth-1:0] p_id_rs1_addr;
  logic     [RegAddrWidth-1:0] p_id_rs2_addr;
  // IF -> ID
  logic     [   DataWidth-1:0] p_if_id_instr;
  logic     [            31:0] p_if_id_pc;
  logic                        p_if_id_br;
  logic                        p_if_id_br_taken;
  // ID -> EX
  logic     [   DataWidth-1:0] p_id_ex_rs1_data;
  logic     [   DataWidth-1:0] p_id_ex_rs2_data;
  logic                        p_id_ex_use_imm;
  logic     [   DataWidth-1:0] p_id_ex_imm;
  logic                        p_id_ex_illegal;
  logic                        p_id_ex_alu;
  logic     [  AluOpWidth-1:0] p_id_ex_alu_op;
  logic     [RegAddrWidth-1:0] p_id_ex_rd_addr;
  // Skips EX stage
  logic                        p_id_ex_lsu;
  logic     [  LsuOpWidth-1:0] p_id_ex_lsu_op;
  logic                        p_id_ex_br;
  ctl_pkt_t                    ctl;
  // EX -> MEM
  logic     [   DataWidth-1:0] p_ex_mem_alu_res;
  logic                        p_ex_mem_lsu;
  logic     [  LsuOpWidth-1:0] p_ex_mem_lsu_op;
  logic                        p_ex_mem_br;
  logic     [RegAddrWidth-1:0] p_ex_mem_rd_addr;
  logic     [RegAddrWidth-1:0] p_mem_wb_rd_addr;

  // TODO: change these later
  assign mem_rd_en[0]    = 'b1;
  assign mem_addr[0]     = p_if_id_pc;
  assign p_id_ex_alu     = ctl.alu;
  assign p_id_ex_lsu     = ctl.lsu;
  assign p_id_ex_br      = ctl.br;
  assign p_id_ex_illegal = ctl.illegal;

  if_stage if_stage_0 (
      .clk     (clk),
      .rst_n   (rst_n),
      .mem_rd  (mem_data_in[0]),
      .instr   (p_if_id_instr),
      .pc      (p_if_id_pc),
      .br      (p_if_id_br),
      .br_taken(p_if_id_br_taken)
  );

  id_stage id_stage_0 (
      .clk     (clk),
      .rst_n   (rst_n),
      .instr   (p_if_id_instr),
      .pc      (p_if_id_pc),
      .imm     (p_id_ex_imm),
      .rd_addr (p_id_ex_rd_addr),
      .rs1_addr(p_id_rs1_addr),
      .rs2_addr(p_id_rs2_addr),
      .rd_en   (p_id_ex_rd_en),
      .ctl     (ctl),
      .use_imm (p_id_ex_use_imm),
      .alu_op  (p_id_ex_alu_op),
      .lsu_op  (p_id_ex_lsu_op)
  );

  reg_file #(
      .DATA_WIDTH(DataWidth)
  ) register_file_inst (
      .clk     (clk),
      .rst_n   (rst_n),
      .rd_addr (p_id_rd_addr),
      .rs1_addr(p_id_rs1_addr),
      .rs2_addr(p_id_rs2_addr),
      .rd_data (write_data),
      .wr_en   (p_mem_wb_rd_en),
      .rs1_data(p_id_ex_rs1_data),
      .rs2_data(p_id_ex_rs2_data)
  );

  ex_stage ex_stage_0 (
      .clk     (clk),
      .rst_n   (rst_n),
      .alu_op  (p_id_ex_alu_op),
      .rs1_data(p_id_ex_rs1_data),
      .rs2_data(p_id_ex_rs2_data),
      .imm     (p_id_ex_imm),
      .use_imm (p_id_ex_use_imm),
      .res     (p_ex_mem_alu_res)
  );

  assign mem_data_out[1] = p_ex_mem_alu_res;
  assign write_data[0] = mem_data_in[1];

  assign mem_wr_en[1] = p_ex_mem_lsu_op[3];
  assign mem_rd_en[1] = ~p_ex_mem_lsu_op[3];

  assign write_en = ~p_ex_mem_lsu_op[3];


  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
    end else begin
      p_ex_mem_lsu     <= p_id_ex_lsu;
		
      p_ex_mem_lsu_op  <= p_id_ex_lsu_op;
		
      p_ex_mem_br      <= p_id_ex_br;
		
      p_ex_mem_rd_addr <= p_id_ex_rd_addr;
      p_mem_wb_rd_addr <= p_ex_mem_rd_addr;
		
      p_ex_mem_rd_en   <= p_id_ex_rd_en;
      p_mem_wb_rd_en   <= p_ex_mem_rd_en;
    end
  end
endmodule : riscv_core

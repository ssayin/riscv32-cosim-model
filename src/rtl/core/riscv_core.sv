// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module riscv_core
(
  input  logic                   clk,
  input  logic                   rst_n,
  output logic [           31:0] o_mem_addr,      // Memory offset
  input  logic [MemBusWidth-1:0] i_mem_data,      // Cache fill port
  output logic [MemBusWidth-1:0] o_mem_data,      // Driven by D$ controller
  output logic [            3:0] o_mem_wr_en,     // TODO: Alter after cache impl
  output logic                   o_mem_rd_en,     // The access is for instruction fetch
  output logic                   o_mem_valid,
  input  logic                   i_mem_ready,     // Stall pipeline on I$ misses
  input  logic                   i_irq_external,  // unused
  input  logic                   i_irq_timer,     // unused
  input  logic                   i_irq_software   // unused
);

  import param_defs::*;
  import instr_defs::*;

  logic [             2:0] pc_incr;  // Assigned 'b011 for now

  logic [RegAddrWidth-1:0] rd_addr [1];
  logic [   DataWidth-1:0] rd_data;

  logic [   DataWidth-1:0] exp_code;

  logic [   DataWidth-1:0] write_data                         [1];
  logic                    write_en                           [1];
  // IF -> ID
  logic [   DataWidth-1:0] p_if_id_instr;
  logic [            31:0] p_if_id_pc;

  // TODO: change these later
  assign o_mem_rd_en = 'b1;
  assign o_mem_addr  = p_if_id_pc;

  _0_if_stage if_stage_0 (
    .clk    (clk),
    .rst_n  (rst_n),
    .i_pc_incr(pc_incr),
    .i_mem_rd (i_mem_data),
    .o_instr  (p_if_id_instr),
    .o_pc     (p_if_id_pc)
  );

  // Wires
  logic [RegAddrWidth-1:0] p_id_rs_addr[2];

  // ID -> EX
  logic [   DataWidth-1:0] p_id_ex_rs_data [2];
  logic                    p_id_ex_use_imm;
  logic [   DataWidth-1:0] p_id_ex_imm;
  logic                    p_id_ex_illegal;
  logic                    p_id_ex_alu;
  logic [  AluOpWidth-1:0] p_id_ex_alu_op;


  logic [RegAddrWidth-1:0] p_id_ex_rd_addr;

  // Wires RS1/RS2 reg_file to pipeline registers
  // p_id_ex_rs_data [2]
  logic [   DataWidth-1:0] rs_data         [2];

  // Skips EX stage
  logic                    p_id_ex_lsu;
  logic [  LsuOpWidth-1:0] p_id_ex_lsu_op;

  logic                    p_id_ex_br;

  _1_id_stage id_stage_0 (
    .clk     (clk),
    .rst_n   (rst_n),
    .i_instr   (p_if_id_instr),
    .i_pc      (p_if_id_pc),
    .o_imm     (p_id_ex_imm),
    .o_rd_addr (p_id_ex_rd_addr),
    .o_rs1_addr(p_id_rs1_addr),
    .o_rs2_addr(p_id_rs2_addr),
    .o_rd_en   (rd_en),
    .o_use_imm (use_imm),
    .o_alu     (p_id_ex_alu),
    .o_lsu     (p_id_ex_lsu),
    .o_br      (p_id_ex_br),
    .o_alu_op  (p_id_ex_alu_op),
    .o_lsu_op  (p_id_ex_lsu_op),
    .o_illegal (p_id_ex_illegal),
    .o_exp_code(exp_code)
  );

  reg_file #(
    .DATA_WIDTH        (DataWidth),
    .NUM_READ_PORTS    (2),
    .NUM_WRITE_PORTS   (1),
    .ENABLE_BYTE_WRITES(0),
    .ENABLE_HALF_WRITES(0),
    .ENABLE_REG_LOCK   (0)
  ) register_file_inst (
    .clk    (clk),
    .rst_n  (rst_n),
    .i_rd_addr(rd_addr),
    .i_rs_addr(p_id_rs_addr),
    .i_rd_data(write_data),
    .i_wr_en  (write_en),
    .o_rs_data(rs_data)
  );


  // EX -> MEM
  logic [ DataWidth-1:0] p_ex_mem_alu_res;

  logic                  p_ex_mem_lsu;
  logic [LsuOpWidth-1:0] p_ex_mem_lsu_op;

  logic                  p_ex_mem_br;

  _2_ex_stage ex_stage_0 (
    .clk     (clk),
    .rst_n   (rst_n),
    .i_alu_op  (p_id_ex_alu_op),
    .i_rs1_data(p_id_ex_rs_data[0]),
    .i_rs2_data(p_id_ex_rs_data[1]),
    .i_imm     (p_id_ex_imm),
    .i_use_imm (p_id_ex_use_imm),
    .o_res     (p_ex_mem_alu_res)
  );

  _3_mem_stage mem_stage_0 (
    .clk           (clk),
    .rst_n         (rst_n),
    .i_ex_mem_alu_res(p_ex_mem_alu_res),
    .i_ex_mem_rd     (),
    .i_lsu_op        (p_ex_mem_lsu_op),
    .o_mem_wb_data   (),
    .o_mem_wb_alu_res(),
    .o_mem_wb_rd     ()
  );

  _4_wb_stage wb_stage_0 (
    .clk           (clk),
    .rst_n         (rst_n),
    .i_mem_wb_data   (3),
    .i_mem_wb_alu_res(12),
    .i_mem_wb_rd     (2),
    .o_wb_data       ()
  );


  initial begin
    pc_incr = 3'b100;
  end

  always_ff @(posedge clk or negedge rst_n) begin

    $display("pc: %d mem_rd_data: %h instr: %h illegal: %d alu_op: %d res: %d, rs_data %d %d",
             p_if_id_pc, i_mem_data, p_if_id_instr, p_id_ex_illegal, p_id_ex_alu_op,
             p_ex_mem_alu_res, p_id_ex_rs_data[0], p_id_ex_rs_data[1]);


    if (!rst_n) begin
      p_id_ex_rs_data[0] <= 5'bXXXXX;
      p_id_ex_rs_data[1] <= 5'bXXXXX;
      p_ex_mem_lsu       <= 1'b0;
      p_ex_mem_lsu_op    <= 5'bXXXXX;
      p_ex_mem_br        <= 1'b0;

    end else begin
      p_id_ex_rs_data[0] <= rs_data[0];  // Pipe combinatorial from reg_file to pipeline register
      p_id_ex_rs_data[1] <= rs_data[1];  // Pipe combinatorial from reg_file to pipeline register
      p_ex_mem_lsu       <= p_id_ex_lsu;
      p_ex_mem_lsu_op    <= p_id_ex_lsu_op;
      p_ex_mem_br        <= p_id_ex_br;
    end
  end

endmodule : riscv_core

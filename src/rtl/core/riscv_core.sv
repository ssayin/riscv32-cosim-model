// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module riscv_core
  import param_defs::*;
  import instr_defs::*;
(
  input  logic                   clk,
  input  logic                   rst_n,
  output logic [           31:0] mem_addr,      // Memory offset
  input  logic [MemBusWidth-1:0] mem_data_in,   // Cache fill port
  output logic [MemBusWidth-1:0] mem_data_out,  // Driven by D$ controller
  output logic [            3:0] mem_wr_en,     // TODO: Alter after cache impl
  output logic                   mem_rd_en,     // The access is for instruction fetch
  output logic                   mem_valid,
  input  logic                   mem_ready,     // Stall pipeline on I$ misses
  input  logic                   irq_external,  // unused
  input  logic                   irq_timer,     // unused
  input  logic                   irq_software   // unused
);

  logic [             2:0] pc_incr;

  logic [RegAddrWidth-1:0] rd_addr       [1];
  logic [   DataWidth-1:0] rd_data;

  logic [   DataWidth-1:0] exp_code;

  logic [   DataWidth-1:0] write_data    [1];
  logic                    write_en      [1];
  // IF -> ID
  logic [   DataWidth-1:0] p_if_id_instr;
  logic [            31:0] p_if_id_pc;

  // TODO: change these later
  assign mem_rd_en = 'b1;
  assign mem_addr  = p_if_id_pc;

  if_stage if_stage_0 (
    .clk    (clk),
    .rst_n  (rst_n),
    .pc_incr(pc_incr),
    .mem_rd (mem_data_in),
    .instr  (p_if_id_instr),
    .pc     (p_if_id_pc)
  );

  // Wires
  logic     [RegAddrWidth-1:0] p_id_rs1_addr;
  logic     [RegAddrWidth-1:0] p_id_rs2_addr;

  // ID -> EX
  logic     [   DataWidth-1:0] p_id_ex_rs_data [2];
  logic                        p_id_ex_use_imm;
  logic     [   DataWidth-1:0] p_id_ex_imm;
  logic                        p_id_ex_illegal;
  logic                        p_id_ex_alu;
  logic     [  AluOpWidth-1:0] p_id_ex_alu_op;


  logic     [RegAddrWidth-1:0] p_id_ex_rd_addr;

  // Wires RS1/RS2 reg_file to pipeline registers
  // p_id_ex_rs_data [2]
  logic     [   DataWidth-1:0] rs_data         [2];

  // Skips EX stage
  logic                        p_id_ex_lsu;
  logic     [  LsuOpWidth-1:0] p_id_ex_lsu_op;

  logic                        p_id_ex_br;

  ctl_pkt_t                    ctl;

  assign p_id_ex_alu     = ctl.alu;
  assign p_id_ex_lsu     = ctl.lsu;
  assign p_id_ex_br      = ctl.br;
  assign p_id_ex_illegal = ctl.illegal;

  id_stage id_stage_0 (
    .clk     (clk),
    .rst_n   (rst_n),
    .instr   (p_if_id_instr),
    .pc      (p_if_id_pc),
    .imm     (p_id_ex_imm),
    .rd_addr (p_id_ex_rd_addr),
    .rs1_addr(p_id_rs1_addr),
    .rs2_addr(p_id_rs2_addr),
    .rd_en   (write_en[0]),
    .ctl     (ctl),
    .use_imm (p_id_ex_use_imm),
    .alu_op  (p_id_ex_alu_op),
    .lsu_op  (p_id_ex_lsu_op),
    .exp_code(exp_code)
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
    .rd_addr(rd_addr),
    .rs_addr({p_id_rs1_addr, p_id_rs2_addr}),
    .rd_data(write_data),
    .wr_en  (write_en),
    .rs_data(rs_data)
  );


  // EX -> MEM
  logic [ DataWidth-1:0] p_ex_mem_alu_res;

  logic                  p_ex_mem_lsu;
  logic [LsuOpWidth-1:0] p_ex_mem_lsu_op;

  logic                  p_ex_mem_br;

  ex_stage ex_stage_0 (
    .clk     (clk),
    .rst_n   (rst_n),
    .alu_op  (p_id_ex_alu_op),
    .rs1_data(rs_data[0]),
    .rs2_data(rs_data[1]),
    .imm     (p_id_ex_imm),
    .use_imm (p_id_ex_use_imm),
    .res     (p_ex_mem_alu_res)
  );

  mem_stage mem_stage_0 (
    .clk           (clk),
    .rst_n         (rst_n),
    .ex_mem_alu_res(p_ex_mem_alu_res),
    .ex_mem_rd     (p_id_ex_rd_addr),
    .lsu_op        (p_ex_mem_lsu_op),
    .mem_wb_data   (),
    .mem_wb_alu_res(mem_data_out),
    .mem_wb_rd     ()
  );

  wb_stage wb_stage_0 (
    .clk           (clk),
    .rst_n         (rst_n),
    .mem_wb_data   (),
    .mem_wb_alu_res(),
    .mem_wb_rd     (),
    .wb_data       ()
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      p_id_ex_rs_data[0] <= 'b0;
      p_id_ex_rs_data[1] <= 'b0;
      p_ex_mem_lsu       <= 'b0;
      p_ex_mem_lsu_op    <= 'b0;
      p_ex_mem_br        <= 'b0;
      pc_incr            <= 'b0;
    end else begin
      p_id_ex_rs_data[0] <= rs_data[0];
      p_id_ex_rs_data[1] <= rs_data[1];
      p_ex_mem_lsu       <= p_id_ex_lsu;
      p_ex_mem_lsu_op    <= p_id_ex_lsu_op;
      p_ex_mem_br        <= p_id_ex_br;
      pc_incr            <= 3'b100;
    end
  end

endmodule : riscv_core

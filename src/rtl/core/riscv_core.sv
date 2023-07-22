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
  input logic clk,
  input logic rst_n,

  // WA Channel
  output logic        axi_awid,
  output logic [31:0] axi_awaddr,
  output logic [ 7:0] axi_awlen,
  output logic [ 2:0] axi_awsize,
  output logic [ 1:0] axi_awburst,
  output logic        axi_awlock,
  output logic [ 3:0] axi_awcache,
  output logic [ 2:0] axi_awprot,
  output logic        axi_awvalid,
  output logic [ 3:0] axi_awregion,
  output logic [ 3:0] axi_awqos,
  input  logic        axi_awready,

  // WD Channel
  output logic [63:0] axi_wdata,
  output logic [ 7:0] axi_wstrb,
  output logic        axi_wlast,
  output logic        axi_wvalid,
  input  logic        axi_wready,

  // Write Response Channel
  input  logic       axi_bid,
  input  logic [1:0] axi_bresp,
  input  logic       axi_bvalid,
  output logic       axi_bready,

  // RA Channel
  output logic        axi_arid,
  output logic [31:0] axi_araddr,
  output logic [ 7:0] axi_arlen,
  output logic [ 2:0] axi_arsize,
  output logic [ 1:0] axi_arburst,
  output logic        axi_arlock,
  output logic [ 3:0] axi_arcache,
  output logic [ 2:0] axi_arprot,
  output logic        axi_arvalid,
  output logic [ 3:0] axi_arqos,
  output logic [ 3:0] axi_arregion,
  input  logic        axi_arready,

  // RD Channel
  input  logic        axi_rid,
  input  logic [63:0] axi_rdata,
  input  logic [ 1:0] axi_rresp,
  input  logic        axi_rlast,
  input  logic        axi_rvalid,
  output logic        axi_rready,

  output logic [31:1] pc_out_trace
);

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

  logic      [             31:1] pc_in;
  logic      [             31:1] pc_out;
  logic                          pc_update;

  reg_data_t                     rs1_data_e;
  reg_data_t                     rs2_data_e;

  logic                          should_br;
  logic                          br_mispredictd;

  logic                          stall;

  logic      [             31:0] fetch_addr;
  logic      [             63:0] fetch_data;
  logic      [             31:0] load_addr;
  logic      [             63:0] load_data;


  assign data_in  = 0;
  assign flush_d0 = 0;
  assign flush_d1 = 0;


  typedef enum logic [1:0] {
    IDLE    = 2'b00,
    ADDRESS = 2'b01,
    DATA    = 2'b10
  } axi_state_t;

  axi_state_t axi_read_state;
  axi_state_t axi_read_state_next;

  // TODO: move FSM logic somewhere else
  // impl. separate master axi4 interface for LSU to avoid port contention and stalling
  always_comb begin
    axi_read_state_next = IDLE;
    axi_arvalid         = 0;
    axi_araddr[31:0]    = 0;
    axi_arlen[7:0]      = 0;
    axi_arburst[1:0]    = 0;
    axi_rready          = 0;

    case (axi_read_state)
      IDLE: begin
        axi_arvalid         = 1'b1;
        axi_araddr[31:0]    = fetch_addr;
        axi_arlen[7:0]      = 'b1;  // TODO: probably not gonan impl icc/dcc very soon
        axi_arburst[1:0]    = 'b01;  // AVN supports INCR only
        axi_read_state_next = ADDRESS;
      end
      ADDRESS: begin
        if (axi_arready) axi_read_state_next = DATA;
      end
      DATA: begin
        axi_rready = 1'b1;
        if (axi_rvalid) begin
          fetch_data          = axi_rdata;
          axi_read_state_next = IDLE;
        end
      end
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      axi_read_state <= IDLE;
    end else begin
      axi_read_state <= axi_read_state_next;
    end
  end

  assign fetch_addr = {pc_d0, 1'b0};



  if_stage if_stage_0 (
    .clk          (clk),
    .rst_n        (rst_n),
    .mem_rd       (fetch_addr),
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
    .clk     (clk),
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
    .clk   (clk),
    .rst_n (rst_n),
    .mem_in(data_in),
    .*
  );

  assign pc_out_trace      = pc_out;

  // TODO: Impl LSU and change wr_en signals
  // assign mem_wr_en[1][0]   = lsu_op_m[3] & lsu_m;  // Store
  // assign mem_rd_en[1]      = ~lsu_op_m[3] & lsu_m;  // Load
  // assign mem_data_out[1]   = store_data_m;  // loaded from reg_file in stage ID1
  // assign mem_addr[1]       = alu_res_m;  // load store

  assign stall             = 'b0;
  assign pc_update         = should_br || br_mispredictd;
  assign flush             = br_mispredictd;


  assign axi_awid          = 0;
  assign axi_awaddr[31:0]  = 0;
  assign axi_awlen[7:0]    = 0;
  assign axi_awsize[2:0]   = 0;
  assign axi_awburst[1:0]  = 2'b01;
  assign axi_awlock        = 0;
  assign axi_awcache[3:0]  = 0;
  assign axi_awprot[2:0]   = 0;
  assign axi_awvalid       = 0;
  assign axi_awregion[3:0] = 0;
  assign axi_awqos[3:0]    = 0;

  assign axi_wdata[63:0]   = 0;
  assign axi_wstrb[7:0]    = 0;
  assign axi_arsize[2:0]   = 0;
  assign axi_arcache[3:0]  = 0;
  assign axi_arprot[2:0]   = 0;
  assign axi_arqos[3:0]    = 0;
  assign axi_arregion[3:0] = 0;
  assign axi_wlast         = 0;
  assign axi_wvalid        = 0;

  assign axi_bready        = 0;
  assign axi_arid          = 0;
  assign axi_arlock        = 0;
endmodule : riscv_core

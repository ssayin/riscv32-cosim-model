// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import instr_defs::*;

module ifu (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        flush_f,         // TODO: decide if this is really needed
  output logic        stall_f,
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

  input  logic [31:1] pc_in,
  input  logic        pc_update,
  output logic [31:1] pc_out,
  output logic [31:0] instr_d0,
  output logic [31:1] pc_d0,
  output logic        compressed_d0,
  output logic        br_d0,
  output logic        br_taken_d0
);

  logic [31:1] pc;
  logic        compressed;
  logic        j;
  logic [31:0] jimm;
  logic        br;
  logic        br_taken;
  logic        take_jump;

  logic [63:0] instr;

  logic        stall_f_next;

  typedef enum logic [1:0] {
    IDLE    = 2'b00,
    ADDRESS = 2'b01,
    DATA    = 2'b10
  } axi_state_t;

  axi_state_t axi_read_state;
  axi_state_t axi_read_state_next;

  always_comb begin
    axi_read_state_next = IDLE;
    axi_arvalid_f       = 0;
    axi_araddr_f[31:0]  = 0;
    axi_arlen_f[7:0]    = 0;
    axi_arburst_f[1:0]  = 0;
    axi_rready_f        = 0;
    stall_f_next        = 0;
    instr[63:0]         = 0;

    case (axi_read_state)
      IDLE: begin
        axi_arvalid_f       = 1'b1;
        axi_araddr_f[31:0]  = {pc, 1'b0};
        axi_arlen_f[7:0]    = 'b1;  // TODO: probably not gonan impl icc/dcc very soon
        axi_arburst_f[1:0]  = 'b01;  // AVN supports INCR only
        axi_read_state_next = ADDRESS;
        stall_f_next        = 0;
      end
      ADDRESS: begin
        stall_f_next = 0;
        if (axi_arready_f) axi_read_state_next = DATA;
      end
      DATA: begin
        axi_rready_f = 1'b1;
        if (axi_rvalid_f) begin
          instr               = axi_rdata_f;
          axi_read_state_next = IDLE;
          stall_f_next        = 1;
        end
      end
      default: begin
      end
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      axi_read_state <= IDLE;
      stall_f        <= 0;
    end else begin
      axi_read_state <= axi_read_state_next;
      stall_f        <= stall_f_next;
    end
  end


  localparam logic [31:0] Nop = 'h13;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pc            <= 'h0;  // boot sector
      pc_d0         <= 'h0;
      compressed_d0 <= 'b0;
      instr_d0      <= 'h0;  // maybe nop?
      br_taken_d0   <= 'b0;
    end else begin
      if (pc_update) begin
        $display("pc_update = 1");
        pc_d0         <= pc;
        compressed_d0 <= 'b0;
        pc            <= pc_in;
        instr_d0      <= Nop;
      end else if (take_jump) begin
        $display("take_jump = 1");
        pc_d0         <= pc;
        compressed_d0 <= compressed;
        pc[31:1]      <= jimm[31:1];
        instr_d0      <= Nop;
      end else begin
        pc_d0 <= pc;
        $display("pc = %d", pc);
        compressed_d0 <= compressed;
        pc[31:1]      <= pc[31:1] + (compressed ? 31'h1 : 31'h2);
        instr_d0      <= {{instr[31:24], instr[23:16], instr[15:8], instr[7:0]}};
        br_taken_d0   <= br_taken;
      end
    end
  end

  assign take_jump = j && !pc_update;  // always prioritize mispredicted branches and exceptions

  riscv_decoder_br dec_br (
    .instr(instr[15:0]),
    .br   (br)
  );

  riscv_decoder_j_no_rr dec_j_no_rr (
    .instr(instr[15:0]),
    .j    (j)
  );

  riscv_decoder_j_no_rr_imm dec_j_no_rr_imm (
    .instr(instr),
    .imm  (jimm)
  );

  assign br_taken            = 'b0;
  assign pc_out              = pc;
  assign compressed          = ~(instr[0] & instr[1]);
  assign br_d0               = br;

  assign axi_arid_f          = 0;
  assign axi_arlock_f        = 0;
  assign axi_arsize_f[2:0]   = 0;
  assign axi_arcache_f[3:0]  = 0;
  assign axi_arprot_f[2:0]   = 0;
  assign axi_arqos_f[3:0]    = 0;
  assign axi_arregion_f[3:0] = 0;

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

endmodule : ifu

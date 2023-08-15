// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module ifu #(
    parameter integer IFU_MRF_DEPTH   = 16,
    parameter integer IFU_FTF_DEPTH   = 8,
    parameter integer FETCH_BUF_DEPTH = 4
) (
  input  logic              clk,
  input  logic              rst_n,
  input  logic              exu_pc_redir_en,
  input  logic              exu_pc_redir_en_d,
  //
  // LSU
  //
  input  logic [      31:1] pc_m,
  input  logic              comp_m,
  input  logic              br_misp_m,
  input  logic              br_ataken_m,
  input  logic [      31:0] alu_res_m,
  input  logic              valid_m,
  input  logic              jalr_m,
  input  logic              reset_sync,
  //
  // ID and EX
  //
  output logic              valid_d,
  output logic [      31:0] instr_d,
  output logic [      31:1] pc_d,
  output logic              comp_d,
  output logic              br_d,
  output logic              jal_d,
  output logic              jalr_d,
  output logic              br_ataken_d,
  output logic              illegal_d,
  output logic [       4:0] rd_addr_d,
  output logic [       4:0] rs1_addr_r,
  output logic [       4:0] rs2_addr_r,
  input  logic [       4:0] rd_addr_e,
  input  logic              valid_e,
  //
  // AR Channel
  //
  output logic [AxiIdW-1:0] axi_arid_f,
  output logic [      31:0] axi_araddr_f,
  output logic [       7:0] axi_arlen_f,
  output logic [       2:0] axi_arsize_f,
  output logic [       1:0] axi_arburst_f,
  output logic              axi_arlock_f,
  output logic [       3:0] axi_arcache_f,
  output logic [       2:0] axi_arprot_f,
  output logic              axi_arvalid_f,
  output logic [       3:0] axi_arqos_f,
  output logic [       3:0] axi_arregion_f,
  input  logic              axi_arready_f,
  //
  // R Channel
  //
  input  logic [AxiIdW-1:0] axi_rid_f,
  input  logic [      63:0] axi_rdata_f,
  input  logic [       1:0] axi_rresp_f,
  input  logic              axi_rlast_f,
  input  logic              axi_rvalid_f,
  output logic              axi_rready_f
);


  logic        illegal;
  logic [63:0] ic_rd;
  logic        ic_clear;
  logic        ic_ready;
  logic        ic_valid;
  logic [63:0] qw;
  logic        qwvalid;

  logic        ifu_mrf_full;
  logic        ifu_mrf_empty;
  logic [95:0] ifu_mrf_pkt;

  ////////////////////////////////////////////////////////
  //
  //                    PCs / Ctrl
  //
  ////////////////////////////////////////////////////////
  logic [31:1] ifu_fetch_pc_d, ifu_last_pc, ifu_fetch_pc, ifu_fetch_pc_q0;

  logic [31:1] jal_target;

  logic jal_en, jal_en_q0;
  logic ifu_npc_en;

  logic pipe_haz;
  // verilog_format: off
  mydff #(.W(31), .L(1)) fetch_pc_ff (.*, .din(ifu_fetch_pc),        .dout(ifu_fetch_pc_q0));

  mydffsclr    phz0_ff   (.*, .din(pipe_haz),    .dout(pipe_haz_q0));
  mydffsclr    phz1_ff   (.*, .din(pipe_haz_q0), .dout(pipe_haz_q1));
  // verilog_format: on




  syncfifo #(
      .WIDTH(95),
      .DEPTH(IFU_MRF_DEPTH)
  ) ifu_mrf (
    .*,
    .clr  (ifu_mrf_clr),
    .wren (ic_valid && ic_ready),
    .rden (qwvalid),
    .wr   ({ic_rd[63:0], ifu_fetch_pc[31:1]}),
    .rd   (ifu_mrf_pkt),
    .empty(ifu_mrf_empty),
    .full (ifu_mrf_full)
  );

  syncfifo #(
      .WIDTH(32),
      .DEPTH(IFU_FTF_DEPTH)
  ) ifu_ftf (
    .*,
    .clr  (ifu_ftf_clr),
    .wren (ifu_ftf_wren),
    .rden (ifu_ftf_rden),
    .wr   (ifu_ftf_enq),
    .rd   (ifu_ftf_deq),
    .empty(ifu_ftf_empty),
    .full (ifu_ftf_full)
  );

  assign ifu_ftf_rden = 1;


  ////////////////////////////////////////////////////////
  //
  //                     PREDECODE
  //
  ////////////////////////////////////////////////////////
  logic [31:0] jimm;
  logic        br;
  logic        jal;
  logic        jalr;
  logic        comp;
  logic [ 4:0] rs1_addr;
  logic [ 4:0] rs2_addr;
  logic [ 4:0] rd_addr;
  logic        br_ataken;
  logic [31:1] pc;

  logic [52:0] op_in, op_out;
  logic [ 31:0] instr;

  ///////////////////////////////////////////////////////
  //
  //                     FETCHBUF
  //
  ///////////////////////////////////////////////////////
  logic [255:0] ifu_fetch_buf_pkt;
  logic [  3:0] wren;
  logic         empty;
  logic         full;
  logic         clr;



  ////////////////////////////////////////////////////////
  //
  //                      IMEM
  //
  ////////////////////////////////////////////////////////

  ifu_mem_ctrl ifu_mem_ctrl_0 (.*);


  ////////////////////////////////////////////////////////
  //
  //                      ALIGNER
  //
  ////////////////////////////////////////////////////////
  logic [127:0] ifu_algn_pkt;
  logic [127:0] ifu_algn_pc_pkt;
  logic [  3:0] ifu_algn_valid;


  logic [15:0] ifu_algn_part_in, ifu_algn_part_out;
  logic ifu_algn_part_valid_in, ifu_algn_part_valid_out;

  // verilog_format: off
  mydff         icr_ff       (.*, .din(~ifu_mrf_full && ic_valid),    .dout(ic_ready));
  mydff         qwr_rff      (.*, .din(~ifu_mrf_empty && qwvalid),    .dout(qwready));
  // verilog_format: on



  // verilog_format: off
  mydff #(.W(31), .L(1)) pc_d_ff     (.*, .din(pc),                  .dout(pc_d));

  mydff #(.RSTVAL(1'b1)) empty_ff    (.*, .din(empty),               .dout(empty_q0));

  mydffsclr #(.W(256))   f0_q0_ff (.*, .din({ifu_algn_pkt, ifu_algn_pc_pkt}), .dout(ifu_fetch_buf_pkt));


  mydff  ifu_npc_en_q0_ff (.*, .din(ifu_npc_en), .dout(ifu_npc_en_q0));
  mydff  exu_pc_redir_en_ff (.*, .din(exu_pc_redir_en), .dout(exu_pc_redir_en_q0));

  ifu_bpu ifu_bpu_0 (.*);
  ifu_algn ifu_algn_0 (.qw(ifu_mrf_pkt[94:31]), .ifu_fetch_pc(ifu_mrf_pkt[30:0]), .*);


  ifu_fetch_buf #(.DEPTH(FETCH_BUF_DEPTH)) fetch_buf (.*);
  // verilog_format: on

  assign ifu_algn_part_in       = ifu_algn_part_out;

  assign ifu_algn_part_valid_in = ifu_algn_part_valid_out & ~ifu_npc_en;

  // always_comb ifu_npc_en = reset_sync || jal_en || exu_pc_redir_en_d;

  always_comb ifu_npc_en = ~ifu_ftf_empty;

  assign qwvalid = ~ifu_mrf_empty;

  // always_ff @(posedge clk) ifu_npc_en <= reset_sync || jal_en || exu_pc_redir_en;

  always_comb clr = reset_sync || exu_pc_redir_en_d;

  assign ic_clear = reset_sync;




  logic bubble;
  always_comb bubble = pipe_haz || pipe_haz_q0 || pipe_haz_q1 || exu_pc_redir_en || empty;

  logic rden;
  assign rden = ~bubble;

  logic ins_nop;
  assign ins_nop = bubble || empty || empty_q0;

  assign op_in = ins_nop ? {Nop, 21'h1} : {instr, comp, br, rd_addr, rs1_addr, rs2_addr,
                                           jalr, jal, br_ataken, 1'b1};
  //
  // assign op_in = {
  //   instr_d,
  //   comp_d,
  //   br_d,
  //  rd_addr_d,
  //  rs1_addr_r,
  //  rs2_addr_r,
  //  jalr_d,
  //  jal_d,
  //  br_ataken_d,
  //  valid_d
  //};

  mydff #(
      .W     (53),
      .RSTVAL({Nop, 21'h1})
  ) opff (
    .*,
    .din (op_in),
    .dout(op_out)
  );

  // verilog_format: off
  ifu_dec ifu_dec_0 (.i32(instr), .*);
  pipe_haz_ctrl haz (.*);
  // verilog_format: on

  always_ff @(posedge clk)
    if (ifu_npc_en || (ic_valid && ic_ready && !illegal))
      ifu_last_pc <= ifu_fetch_pc_d;

  always_ff @(posedge clk) begin
    if (valid_m && br_misp_m && ~br_ataken_m) ifu_fetch_pc[31:1] <= alu_res_m[31:1];
    else if (valid_m && br_misp_m && br_ataken_m)
      ifu_fetch_pc[31:1] <= pc_m[31:1] + {~comp_m, comp_m, 1'b0};
    else if (valid_m && jalr_m) ifu_fetch_pc[31:1] <= alu_res_m[31:1];
    else if (ifu_npc_en) ifu_fetch_pc[31:1] <= ifu_fetch_pc_d[31:1];
    else if (ic_valid && ic_ready)
      ifu_fetch_pc[31:1] <= {ifu_fetch_pc[31:3] + 29'h1, 2'b00};
  end

  logic redir_fast;
  assign redir_fast   = valid_m && br_misp_m;

  assign ifu_ftf_enq  = jal_target[31:1];
  assign ifu_ftf_wren = jal_en;
  // assign ifu_fetch_pc_d[31:1]   = ifu_ftf_deq[31:1];

  always_comb begin
    if (reset_sync) ifu_fetch_pc_d[31:1] = 31'h0;
    else if (jal_en) ifu_fetch_pc_d[31:1] = jal_target[31:1];
    else if (!ifu_algn_valid) ifu_fetch_pc_d[31:1] = ifu_fetch_pc[31:1];
    else if (ic_valid) ifu_fetch_pc_d[31:1] = ifu_fetch_pc[31:1] + 31'h4;
    else ifu_fetch_pc_d[31:1] = ifu_fetch_pc[31:1];
  end

  logic [31:1] redir_fast_target;

  always_comb begin
    redir_fast_target[31:1] = alu_res_m[31:1];
    if (br_ataken && ~jalr_m)
      redir_fast_target[31:1] = pc_m[31:1] + {~comp_m, comp_m, 1'b0};
  end


`ifdef DEBUG
  always_comb
    if (valid_m && br_misp_m && ~br_ataken_m)
      $display("PC_M: %x, BR MISPREDICT %x", {pc_m[31:1], 1'b0}, {alu_res_m[31:1], 1'b0});

  always_comb
    if (valid_m && jalr_m)
      $display("PC_M: %x, JALR %x", {pc_m[31:1], 1'b0}, {alu_res_m[31:1], 1'b0});

  always_comb if (empty) $display("EMPTY");

  always_ff @(posedge clk)
    if (instr_d[31:0] == 32'h13) $display("BUBBLE");
    else
      $display(
          "PC %x  PC_D %x  INSTR %x INSTR_D %x",
          {
            pc[31:1], 1'b0
          },
          {
            pc_d[31:1], 1'b0
          },
          instr[31:0],
          instr_d[31:0]
      );
`endif

`ifdef DEBUG_FULL
  always_ff @(posedge clk) begin
    $display("------------------------------------------------------");
    $display("PC_D           %x", {ifu_fetch_pc_d, 1'b0});
    $display("PC             %x", {ifu_fetch_pc, 1'b0});
    $display("PC_Q0          %x", {ifu_fetch_pc_q0, 1'b0});
    $display("PC_LAST        %x", {ifu_last_pc, 1'b0});
    $display("QW             %x", qw);
    $display("IFU_I32        %x %x %x %x", ifu_algn_pkt[127:96], ifu_algn_pkt[95:64],
             ifu_algn_pkt[63:32], ifu_algn_pkt[31:0]);
    $display("IFU_ALGN_VALID %b", ifu_algn_valid);
    $display("QPC            %x %x %x %x", ifu_algn_pc_pkt[127:96],
             ifu_algn_pc_pkt[95:64], ifu_algn_pc_pkt[63:32], ifu_algn_pc_pkt[31:0]);
    $display("WREN           %b", wren);
    $display("INSTR_D        %x", instr_d[31:0]);
    $display("------------------------------------------------------");
    if (ifu_npc_en)
      $display(
          "JUMP TO %x, JAL %d, REDIRECT %d",
          {
            ifu_fetch_pc_d[31:1], 1'b0
          },
          jal_en,
          exu_pc_redir_en
      );
  end
`endif

endmodule : ifu

// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module riscv_core (
  input  logic              clk,
  input  logic              rst_n,
  // RA Channel
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
  // RD Channel
  input  logic [AxiIdW-1:0] axi_rid_f,
  input  logic [      63:0] axi_rdata_f,
  input  logic [       1:0] axi_rresp_f,
  input  logic              axi_rlast_f,
  input  logic              axi_rvalid_f,
  output logic              axi_rready_f,
  // WA Channel
  output logic [AxiIdW-1:0] axi_awid_m,
  output logic [      31:0] axi_awaddr_m,
  output logic [       7:0] axi_awlen_m,
  output logic [       2:0] axi_awsize_m,
  output logic [       1:0] axi_awburst_m,
  output logic              axi_awlock_m,
  output logic [       3:0] axi_awcache_m,
  output logic [       2:0] axi_awprot_m,
  output logic              axi_awvalid_m,
  output logic [       3:0] axi_awregion_m,
  output logic [       3:0] axi_awqos_m,
  input  logic              axi_awready_m,
  // WD Channel
  output logic [      63:0] axi_wdata_m,
  output logic [       7:0] axi_wstrb_m,
  output logic              axi_wlast_m,
  output logic              axi_wvalid_m,
  input  logic              axi_wready_m,
  // Write Response Channel
  input  logic [AxiIdW-1:0] axi_bid_m,
  input  logic [       1:0] axi_bresp_m,
  input  logic              axi_bvalid_m,
  output logic              axi_bready_m,
  // RA Channel
  output logic [AxiIdW-1:0] axi_arid_m,
  output logic [      31:0] axi_araddr_m,
  output logic [       7:0] axi_arlen_m,
  output logic [       2:0] axi_arsize_m,
  output logic [       1:0] axi_arburst_m,
  output logic              axi_arlock_m,
  output logic [       3:0] axi_arcache_m,
  output logic [       2:0] axi_arprot_m,
  output logic              axi_arvalid_m,
  output logic [       3:0] axi_arqos_m,
  output logic [       3:0] axi_arregion_m,
  input  logic              axi_arready_m,
  // RD Channel
  input  logic [AxiIdW-1:0] axi_rid_m,
  input  logic [      63:0] axi_rdata_m,
  input  logic [       1:0] axi_rresp_m,
  input  logic              axi_rlast_m,
  input  logic              axi_rvalid_m,
  output logic              axi_rready_m
);

  logic                 br_misp_m;
  logic [          4:0] rs1_addr_r;
  logic [          4:0] rs2_addr_r;

  logic                 exu_pc_redir_en;
  ////////////////////////////////////////
  //                                    //
  //                DEC                 //
  //                                    //
  ////////////////////////////////////////
  logic [         31:0] instr_d;
  logic [         31:1] pc_d;
  logic                 comp_d;
  logic                 br_d;
  logic                 br_ataken_d;
  logic                 illegal_d;
  logic [          4:0] rd_addr_d;
  logic                 valid_d;
  logic                 jalr_d;
  logic                 jal_d;
  ////////////////////////////////////////
  //                                    //
  //                EXU                 //
  //                                    //
  ////////////////////////////////////////
  logic [         31:1] pc_e;
  logic                 comp_e;
  logic                 br_e;
  logic                 br_ataken_e;
  logic                 use_imm_e;
  logic                 use_pc_e;
  logic [         31:0] imm_e;
  logic                 illegal_e;
  logic                 alu_e;
  logic [   AluOpW-1:0] alu_op_e;
  logic [          4:0] rd_addr_e;
  logic                 lsu_e;
  logic [   LsuOpW-1:0] lsu_op_e;
  logic [BranchOpW-1:0] br_op_e;
  logic                 rd_en_e;
  logic [         31:0] rs1_data_e;
  logic [         31:0] rs2_data_e;
  logic                 jalr_e;
  logic                 jal_e;
  logic                 valid_e;
  ////////////////////////////////////////
  //                                    //
  //                MEM                 //
  //                                    //
  ////////////////////////////////////////
  logic                 comp_m;
  logic                 rd_en_m;
  logic [         31:0] alu_res_m;
  logic [         31:0] store_data_m;
  logic                 lsu_m;
  logic                 jal_m;
  logic [   LsuOpW-1:0] lsu_op_m;
  logic                 br_ataken_m;
  logic                 br_m;
  logic [          4:0] rd_addr_m;
  logic [         31:1] pc_m;
  logic                 jalr_m;
  logic                 valid_m;
  ////////////////////////////////////////
  //                                    //
  //                 WB                 //
  //                                    //
  ////////////////////////////////////////
  logic                 rd_en_wb;
  logic [          4:0] rd_addr_wb;
  logic [         31:0] rd_data_wb;

  logic                 flush;

  logic                 reset_sync;


  logic                 exu_pc_redir_en_d;

  // Synchronize reset for pipeline registers
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) reset_sync <= 1;
    else reset_sync <= 0;
  end

  reg_file #(.DW(DataW)) reg_file_0 (.*);
  ifu ifu_0 (.*);
  exu exu_0 (.*);
  dec dec_0 (.*);
  lsu lsu_0 (.*);

`ifdef DUMPVCD
  initial begin
    $dumpfile("riscv_core.vcd");
    $dumpvars(0, riscv_core);
  end
`endif

`ifdef DEBUG_FULL
  int cycle = 0;
  always_ff @(posedge clk) begin
    $write("%c[1;34m", 27);
    $display("[%-0d]", cycle);
    $write("%c[0m", 27);
    $display("[CORE]    pc_d    0x%X ", pc_d);
    $display("[CORE]    instr_d 0x%X #%2d", instr_d, (1 << (5 - comp_d)));
    $monitor("[CORE]    br_ataken_d %d", br_ataken_d);
    $monitor("[CORE]    br_misp_m   %d", br_misp_m);
    cycle++;
  end
`endif

endmodule : riscv_core

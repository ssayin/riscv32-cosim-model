// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0
import defs_pkg::*;
module riscv_core (
  input  logic                  clk,
  input  logic                  rst_n,
  // WA Channel
  output logic [AxiIdWidth-1:0] axi_awid_f,
  output logic [          31:0] axi_awaddr_f,
  output logic [           7:0] axi_awlen_f,
  output logic [           2:0] axi_awsize_f,
  output logic [           1:0] axi_awburst_f,
  output logic                  axi_awlock_f,
  output logic [           3:0] axi_awcache_f,
  output logic [           2:0] axi_awprot_f,
  output logic                  axi_awvalid_f,
  output logic [           3:0] axi_awregion_f,
  output logic [           3:0] axi_awqos_f,
  input  logic                  axi_awready_f,
  // WD Channel
  output logic [          63:0] axi_wdata_f,
  output logic [           7:0] axi_wstrb_f,
  output logic                  axi_wlast_f,
  output logic                  axi_wvalid_f,
  input  logic                  axi_wready_f,
  // Write Response Channel
  input  logic [AxiIdWidth-1:0] axi_bid_f,
  input  logic [           1:0] axi_bresp_f,
  input  logic                  axi_bvalid_f,
  output logic                  axi_bready_f,
  // RA Channel
  output logic [AxiIdWidth-1:0] axi_arid_f,
  output logic [          31:0] axi_araddr_f,
  output logic [           7:0] axi_arlen_f,
  output logic [           2:0] axi_arsize_f,
  output logic [           1:0] axi_arburst_f,
  output logic                  axi_arlock_f,
  output logic [           3:0] axi_arcache_f,
  output logic [           2:0] axi_arprot_f,
  output logic                  axi_arvalid_f,
  output logic [           3:0] axi_arqos_f,
  output logic [           3:0] axi_arregion_f,
  input  logic                  axi_arready_f,
  // RD Channel
  input  logic [AxiIdWidth-1:0] axi_rid_f,
  input  logic [          63:0] axi_rdata_f,
  input  logic [           1:0] axi_rresp_f,
  input  logic                  axi_rlast_f,
  input  logic                  axi_rvalid_f,
  output logic                  axi_rready_f,
  // WA Channel
  output logic [AxiIdWidth-1:0] axi_awid_m,
  output logic [          31:0] axi_awaddr_m,
  output logic [           7:0] axi_awlen_m,
  output logic [           2:0] axi_awsize_m,
  output logic [           1:0] axi_awburst_m,
  output logic                  axi_awlock_m,
  output logic [           3:0] axi_awcache_m,
  output logic [           2:0] axi_awprot_m,
  output logic                  axi_awvalid_m,
  output logic [           3:0] axi_awregion_m,
  output logic [           3:0] axi_awqos_m,
  input  logic                  axi_awready_m,
  // WD Channel
  output logic [          63:0] axi_wdata_m,
  output logic [           7:0] axi_wstrb_m,
  output logic                  axi_wlast_m,
  output logic                  axi_wvalid_m,
  input  logic                  axi_wready_m,
  // Write Response Channel
  input  logic [AxiIdWidth-1:0] axi_bid_m,
  input  logic [           1:0] axi_bresp_m,
  input  logic                  axi_bvalid_m,
  output logic                  axi_bready_m,
  // RA Channel
  output logic [AxiIdWidth-1:0] axi_arid_m,
  output logic [          31:0] axi_araddr_m,
  output logic [           7:0] axi_arlen_m,
  output logic [           2:0] axi_arsize_m,
  output logic [           1:0] axi_arburst_m,
  output logic                  axi_arlock_m,
  output logic [           3:0] axi_arcache_m,
  output logic [           2:0] axi_arprot_m,
  output logic                  axi_arvalid_m,
  output logic [           3:0] axi_arqos_m,
  output logic [           3:0] axi_arregion_m,
  input  logic                  axi_arready_m,
  // RD Channel
  input  logic [AxiIdWidth-1:0] axi_rid_m,
  input  logic [          63:0] axi_rdata_m,
  input  logic [           1:0] axi_rresp_m,
  input  logic                  axi_rlast_m,
  input  logic                  axi_rvalid_m,
  output logic                  axi_rready_m
);
  logic                     flush_f;
  logic                     flush_d0;
  logic                     flush_d1;
  // ID0
  // ID0
  // ID0
  logic [             31:0] instr_d0;
  logic [             31:1] pc_d0;
  logic                     comp_d0;
  logic                     br_d0;
  logic                     br_ataken_d0;
  logic                     illegal_d0;
  // ID1
  // ID1
  // ID1
  logic [             31:0] instr_d1;
  logic [             31:1] pc_d1;
  logic                     comp_d1;
  logic                     br_d1;
  logic                     br_ataken_d1;
  logic [              4:0] rd_addr_d1;
  logic                     illegal_d1;
  // EX
  // EX
  // EX
  logic [             31:1] pc_e;
  logic                     comp_e;
  logic                     br_e;
  logic                     br_ataken_e;
  logic                     use_imm_e;
  logic                     use_pc_e;
  logic [             31:0] imm_e;
  logic                     illegal_e;
  logic                     alu_e;
  logic [   AluOpWidth-1:0] alu_op_e;
  logic [              4:0] rd_addr_e;
  logic                     lsu_e;
  logic [   LsuOpWidth-1:0] lsu_op_e;
  logic [BranchOpWidth-1:0] br_op_e;
  logic                     rd_en_e;
  logic [             31:0] rs1_data_e;
  logic [             31:0] rs2_data_e;
  // MEM
  // MEM
  // MEM
  logic                     comp_m;
  logic                     rd_en_m;
  logic [             31:0] alu_res_m;
  logic [             31:0] store_data_m;
  logic                     lsu_m;
  logic [   LsuOpWidth-1:0] lsu_op_m;
  logic                     br_ataken_m;
  logic                     br_m;
  logic [              4:0] rd_addr_m;
  // WB
  // WB
  // WB
  logic                     rd_en_wb;
  logic [              4:0] rd_addr_wb;
  logic [             31:0] rd_data_wb;
  // REG FILE
  // REG FILE
  // REG FILE
  logic [              4:0] rd_addr;
  logic [              4:0] rs1_addr_r;
  logic [              4:0] rs2_addr_r;
  // IF/EX/MEM stuff
  logic [             31:1] pc_in;
  logic                     pc_update;
  logic                     br_misp_m;
  logic                     stall;
  logic                     stall_f;
  assign flush_d0 = 0;
  assign flush_d1 = 0;
  assign pc_in    = alu_res_m[31:1];
  // TODO: Need a skid buffer here
  // ID0 -> ID1 -> EX
  // ADDR -> WAIT -> DATA
  reg_file #(.DATA_WIDTH(DataWidth)) register_file_inst (.*);
  ifu ifu_0 (.*);
  exu exu_0 (.*);
  id0 id0_0 (.*);
  id1 id1_0 (.*);
  mem mem_0 (.*);
  assign stall                      = 'b0;
  assign pc_update                  = br_misp_m;
  assign flush                      = br_misp_m;
  // Unused signals
  assign axi_awid_f[AxiIdWidth-1:0] = 0;
  assign axi_awaddr_f[31:0]         = 0;
  assign axi_awlen_f[7:0]           = 0;
  assign axi_awsize_f[2:0]          = 0;
  assign axi_awburst_f[1:0]         = 0;
  assign axi_awlock_f               = 0;
  assign axi_awcache_f[3:0]         = 0;
  assign axi_awprot_f[2:0]          = 0;
  assign axi_awvalid_f              = 0;
  assign axi_awregion_f[3:0]        = 0;
  assign axi_awqos_f[3:0]           = 0;
  assign axi_wdata_f[63:0]          = 0;
  assign axi_wstrb_f[7:0]           = 0;
  assign axi_wlast_f                = 0;
  assign axi_wvalid_f               = 0;
  assign axi_bready_f               = 0;
  initial begin
    $dumpfile("top.vcd");
    $dumpvars(0, riscv_core);
  end
endmodule : riscv_core

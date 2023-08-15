// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module lsu (
  input  logic              clk,
  input  logic              rst_n,
  input  logic              rd_en_m,
  input  logic [      31:1] pc_m,
  input  logic [      31:0] alu_res_m,
  input  logic [      31:0] store_data_m,
  input  logic              lsu_m,
  input  logic [LsuOpW-1:0] lsu_op_m,
  input  logic [       4:0] rd_addr_m,
  input  logic              valid_m,
  input  logic              br_misp_m,
  input  logic              jal_m,
  input  logic              jalr_m,
  input  logic              comp_m,
  output logic              rd_en_wb,
  output logic [       4:0] rd_addr_wb,
  output logic [      31:0] rd_data_wb,
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

  logic        rden;
  logic        wren;

  logic [31:0] load_data_m;
  logic [31:0] pipe_store_data;

  logic [ 2:0] i_op;

  assign i_op[2:0] = {1'b0, rden, wren};

  // verilog_format: off
  mydff #(.W(5))  rd_addrff    (.*, .din(rd_addr_m),              .dout(rd_addr_wb));
  mydff           rd_enff      (.*, .din(rd_en_m & valid_m),                .dout(rd_en_wb));
  mydff #(.W(32)) rd_data_wbff (.*, .din(pipe_store_data),        .dout(rd_data_wb));
  // verilog_format: on

  lsu_mem_ctrl lsu_mem_ctrl_0 (.*);

  // This wire will send 'load_data_m' for load instructions and 'alu_res_m,'
  // denoting the calculated result from the execution unit, contingent upon
  // the specific micro-operations in progress.

  always_comb begin
    pipe_store_data[31:0] = 0;
    if (valid_m && lsu_m && wren) pipe_store_data[31:0] = load_data_m[31:0];
    else if ((jal_m || jalr_m) && valid_m)
      pipe_store_data[31:0] = {pc_m[31:1], 1'b0} + {~comp_m, comp_m, 1'b0};
    else pipe_store_data[31:0] = alu_res_m[31:0];
  end

  assign wren = lsu_op_m[3] & lsu_m;  // Store
  assign rden = ~lsu_op_m[3] & lsu_m;  // Load

endmodule : lsu

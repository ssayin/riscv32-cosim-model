// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module lsu_mem_ctrl (
  input  logic              clk,
  input  logic              rst_n,
  input  logic              rden,
  input  logic              wren,
  input  logic [      31:0] alu_res_m,
  input  logic [      31:0] store_data_m,
  input  logic [       4:0] rd_addr_m,
  input  logic              br_misp_m,
  input  logic              valid_m,
  output logic [      31:0] load_data_m,
  input  logic [       2:0] i_op,
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
  logic [4:0] o_wreg;

  logic       o_rdbusy;
  logic       o_err;
  logic       o_pipe_stalled;
  logic       o_busy;
  logic       o_valid;


`ifdef DEBUG
  always_comb if (valid_m && ~br_misp_m && (alu_res_m == 32'h68) && (i_op == 3'b001)) $finish;
`endif


  axidcache dcache (
    .clk           (clk),
    .rst_n         (rst_n),
    .i_cpu_reset   (1'b0),
    .i_clear       (1'b0),
    .i_pipe_stb    (1'b0),
    .i_lock        (1'b0),
    .i_op          (i_op),            // 3 bits
    .i_addr        (alu_res_m),
    .i_restart_pc  (1'b0),
    .i_data        (store_data_m),
    .i_oreg        (rd_addr_m),
    .o_busy        (o_busy),
    .o_rdbusy      (o_rdbusy),
    .o_pipe_stalled(o_pipe_stalled),
    .o_valid       (o_valid),
    .o_err         (o_err),
    .o_wreg        (o_wreg),
    .o_data        (load_data_m),
    .*
  );

endmodule

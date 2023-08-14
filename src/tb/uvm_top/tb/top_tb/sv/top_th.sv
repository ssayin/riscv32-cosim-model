// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: top_th.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 03:07:16 2023
//=============================================================================
// Description: Test Harness
//=============================================================================

module top_th;

  timeunit      1ns;
  timeprecision 1ps;


  // Example clock and reset declarations
  logic clock = 0;
  logic reset;

  // Example clock generator process
  always #10 clock = ~clock;

  // Example reset generator process
  initial
  begin
    reset = 0;         // Active low reset in this example
    #75 reset = 1;
  end

  assign riscv_core_if_0.rst_n = reset;

  assign riscv_core_if_0.clk   = clock;

  // Pin-level interfaces connected to DUT
  riscv_core_if  riscv_core_if_0 ();

  riscv_core uut (
    .clk           (riscv_core_if_0.clk),
    .rst_n         (riscv_core_if_0.rst_n),
    .axi_awid_f    (riscv_core_if_0.awid),
    .axi_awaddr_f  (riscv_core_if_0.awaddr),
    .axi_awlen_f   (riscv_core_if_0.awlen),
    .axi_awsize_f  (riscv_core_if_0.awsize),
    .axi_awburst_f (riscv_core_if_0.awburst),
    .axi_awlock_f  (riscv_core_if_0.awlock),
    .axi_awcache_f (riscv_core_if_0.awcache),
    .axi_awprot_f  (riscv_core_if_0.awprot),
    .axi_awvalid_f (riscv_core_if_0.awvalid),
    .axi_awregion_f(riscv_core_if_0.awregion),
    .axi_awqos_f   (riscv_core_if_0.awqos),
    .axi_awready_f (riscv_core_if_0.awready),
    .axi_wdata_f   (riscv_core_if_0.wdata),
    .axi_wstrb_f   (riscv_core_if_0.wstrb),
    .axi_wlast_f   (riscv_core_if_0.wlast),
    .axi_wvalid_f  (riscv_core_if_0.wvalid),
    .axi_wready_f  (riscv_core_if_0.wready),
    .axi_bid_f     (riscv_core_if_0.bid),
    .axi_bresp_f   (riscv_core_if_0.bresp),
    .axi_bvalid_f  (riscv_core_if_0.bvalid),
    .axi_bready_f  (riscv_core_if_0.bready),
    .axi_arid_f    (riscv_core_if_0.arid),
    .axi_araddr_f  (riscv_core_if_0.araddr),
    .axi_arlen_f   (riscv_core_if_0.arlen),
    .axi_arsize_f  (riscv_core_if_0.arsize),
    .axi_arburst_f (riscv_core_if_0.arburst),
    .axi_arlock_f  (riscv_core_if_0.arlock),
    .axi_arcache_f (riscv_core_if_0.arcache),
    .axi_arprot_f  (riscv_core_if_0.arprot),
    .axi_arvalid_f (riscv_core_if_0.arvalid),
    .axi_arqos_f   (riscv_core_if_0.arqos),
    .axi_arregion_f(riscv_core_if_0.arregion),
    .axi_arready_f (riscv_core_if_0.arready),
    .axi_rid_f     (riscv_core_if_0.rid),
    .axi_rdata_f   (riscv_core_if_0.rdata),
    .axi_rresp_f   (riscv_core_if_0.rresp),
    .axi_rlast_f   (riscv_core_if_0.rlast),
    .axi_rvalid_f  (riscv_core_if_0.rvalid),
    .axi_rready_f  (riscv_core_if_0.rready)
  );

endmodule


// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: top_th.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Wed Jul 26 23:05:54 2023
//=============================================================================
// Description: Test Harness
//=============================================================================

module top_hdl_th;

  timeunit      1ns;
  timeprecision 1ps;


  // You can remove clock and reset below by setting th_generate_clock_and_reset = no in file common.tpl

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

  assign busf_if_0.rst_n = reset;
  assign busm_if_0.rst_n = reset;

  assign busf_if_0.clk   = clock;
  assign busm_if_0.clk   = clock;

  // You can insert code here by setting th_inc_inside_module in file common.tpl

  // Pin-level interfaces connected to DUT
  // You can remove interface instances by setting generate_interface_instance = no in the interface template file

  busf_if   busf_if_0 ();          
  busm_if   busm_if_0 ();          

  // BFM interfaces that communicate with proxy transactors in UVM environment
  busf_bfm  busf_bfm_0 (busf_if_0);
  busm_bfm  busm_bfm_0 (busm_if_0);

  riscv_core uut (
    .clk           (busf_if_0.clk),
    .rst_n         (busf_if_0.rst_n),
    .axi_awid_f    (busf_if_0.awid),
    .axi_awaddr_f  (busf_if_0.awaddr),
    .axi_awlen_f   (busf_if_0.awlen),
    .axi_awsize_f  (busf_if_0.awsize),
    .axi_awburst_f (busf_if_0.awburst),
    .axi_awlock_f  (busf_if_0.awlock),
    .axi_awcache_f (busf_if_0.awcache),
    .axi_awprot_f  (busf_if_0.awprot),
    .axi_awvalid_f (busf_if_0.awvalid),
    .axi_awregion_f(busf_if_0.awregion),
    .axi_awqos_f   (busf_if_0.awqos),
    .axi_awready_f (busf_if_0.awready),
    .axi_wdata_f   (busf_if_0.wdata),
    .axi_wstrb_f   (busf_if_0.wstrb),
    .axi_wlast_f   (busf_if_0.wlast),
    .axi_wvalid_f  (busf_if_0.wvalid),
    .axi_wready_f  (busf_if_0.wready),
    .axi_bid_f     (busf_if_0.bid),
    .axi_bresp_f   (busf_if_0.bresp),
    .axi_bvalid_f  (busf_if_0.bvalid),
    .axi_bready_f  (busf_if_0.bready),
    .axi_arid_f    (busf_if_0.arid),
    .axi_araddr_f  (busf_if_0.araddr),
    .axi_arlen_f   (busf_if_0.arlen),
    .axi_arsize_f  (busf_if_0.arsize),
    .axi_arburst_f (busf_if_0.arburst),
    .axi_arlock_f  (busf_if_0.arlock),
    .axi_arcache_f (busf_if_0.arcache),
    .axi_arprot_f  (busf_if_0.arprot),
    .axi_arvalid_f (busf_if_0.arvalid),
    .axi_arqos_f   (busf_if_0.arqos),
    .axi_arregion_f(busf_if_0.arregion),
    .axi_arready_f (busf_if_0.arready),
    .axi_rid_f     (busf_if_0.rid),
    .axi_rdata_f   (busf_if_0.rdata),
    .axi_rresp_f   (busf_if_0.rresp),
    .axi_rlast_f   (busf_if_0.rlast),
    .axi_rvalid_f  (busf_if_0.rvalid),
    .axi_rready_f  (busf_if_0.rready),
    .axi_awid_m    (busm_if_0.awid),
    .axi_awaddr_m  (busm_if_0.awaddr),
    .axi_awlen_m   (busm_if_0.awlen),
    .axi_awsize_m  (busm_if_0.awsize),
    .axi_awburst_m (busm_if_0.awburst),
    .axi_awlock_m  (busm_if_0.awlock),
    .axi_awcache_m (busm_if_0.awcache),
    .axi_awprot_m  (busm_if_0.awprot),
    .axi_awvalid_m (busm_if_0.awvalid),
    .axi_awregion_m(busm_if_0.awregion),
    .axi_awqos_m   (busm_if_0.awqos),
    .axi_awready_m (busm_if_0.awready),
    .axi_wdata_m   (busm_if_0.wdata),
    .axi_wstrb_m   (busm_if_0.wstrb),
    .axi_wlast_m   (busm_if_0.wlast),
    .axi_wvalid_m  (busm_if_0.wvalid),
    .axi_wready_m  (busm_if_0.wready),
    .axi_bid_m     (busm_if_0.bid),
    .axi_bresp_m   (busm_if_0.bresp),
    .axi_bvalid_m  (busm_if_0.bvalid),
    .axi_bready_m  (busm_if_0.bready),
    .axi_arid_m    (busm_if_0.arid),
    .axi_araddr_m  (busm_if_0.araddr),
    .axi_arlen_m   (busm_if_0.arlen),
    .axi_arsize_m  (busm_if_0.arsize),
    .axi_arburst_m (busm_if_0.arburst),
    .axi_arlock_m  (busm_if_0.arlock),
    .axi_arcache_m (busm_if_0.arcache),
    .axi_arprot_m  (busm_if_0.arprot),
    .axi_arvalid_m (busm_if_0.arvalid),
    .axi_arqos_m   (busm_if_0.arqos),
    .axi_arregion_m(busm_if_0.arregion),
    .axi_arready_m (busm_if_0.arready),
    .axi_rdata_m   (busm_if_0.rdata),
    .axi_rresp_m   (busm_if_0.rresp),
    .axi_rlast_m   (busm_if_0.rlast),
    .axi_rvalid_m  (busm_if_0.rvalid),
    .axi_rready_m  (busm_if_0.rready)
  );

endmodule


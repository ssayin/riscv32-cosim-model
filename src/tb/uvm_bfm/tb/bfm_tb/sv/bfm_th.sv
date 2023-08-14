// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: bfm_th.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 07:56:24 2023
//=============================================================================
// Description: Test Harness
//=============================================================================

module bfm_hdl_th;

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

  assign axi4ar_if_0.rst_n = reset;
  assign axi4aw_if_0.rst_n = reset;
  assign axi4b_if_0.rst_n  = reset;
  assign axi4r_if_0.rst_n  = reset;
  assign axi4w_if_0.rst_n  = reset;

  assign axi4ar_if_0.clk   = clock;
  assign axi4aw_if_0.clk   = clock;
  assign axi4b_if_0.clk    = clock;
  assign axi4r_if_0.clk    = clock;
  assign axi4w_if_0.clk    = clock;

  // Pin-level interfaces connected to DUT
  axi4ar_if   axi4ar_if_0 ();            
  axi4aw_if   axi4aw_if_0 ();            
  axi4b_if    axi4b_if_0 ();             
  axi4r_if    axi4r_if_0 ();             
  axi4w_if    axi4w_if_0 ();             

  // BFM interfaces that communicate with proxy transactors in UVM environment
  axi4ar_bfm  axi4ar_bfm_0 (axi4ar_if_0);
  axi4aw_bfm  axi4aw_bfm_0 (axi4aw_if_0);
  axi4b_bfm   axi4b_bfm_0 (axi4b_if_0);  
  axi4r_bfm   axi4r_bfm_0 (axi4r_if_0);  
  axi4w_bfm   axi4w_bfm_0 (axi4w_if_0);  

  riscv_core uut (
    .axi_awid_f    (axi4aw_if_0.awid),
    .axi_awaddr_f  (axi4aw_if_0.awaddr),
    .axi_awlen_f   (axi4aw_if_0.awlen),
    .axi_awsize_f  (axi4aw_if_0.awsize),
    .axi_awburst_f (axi4aw_if_0.awburst),
    .axi_awlock_f  (axi4aw_if_0.awlock),
    .axi_awcache_f (axi4aw_if_0.awcache),
    .axi_awprot_f  (axi4aw_if_0.awprot),
    .axi_awvalid_f (axi4aw_if_0.awvalid),
    .axi_awregion_f(axi4aw_if_0.awregion),
    .axi_awqos_f   (axi4aw_if_0.awqos),
    .axi_awready_f (axi4aw_if_0.awready),
    .axi_wdata_f   (axi4w_if_0.wdata),
    .axi_wstrb_f   (axi4w_if_0.wstrb),
    .axi_wlast_f   (axi4w_if_0.wlast),
    .axi_wvalid_f  (axi4w_if_0.wvalid),
    .axi_wready_f  (axi4w_if_0.wready),
    .axi_bid_f     (axi4b_if_0.bid),
    .axi_bresp_f   (axi4b_if_0.bresp),
    .axi_bvalid_f  (axi4b_if_0.bvalid),
    .axi_bready_f  (axi4b_if_0.bready),
    .axi_arid_f    (axi4ar_if_0.arid),
    .axi_araddr_f  (axi4ar_if_0.araddr),
    .axi_arlen_f   (axi4ar_if_0.arlen),
    .axi_arsize_f  (axi4ar_if_0.arsize),
    .axi_arburst_f (axi4ar_if_0.arburst),
    .axi_arlock_f  (axi4ar_if_0.arlock),
    .axi_arcache_f (axi4ar_if_0.arcache),
    .axi_arprot_f  (axi4ar_if_0.arprot),
    .axi_arvalid_f (axi4ar_if_0.arvalid),
    .axi_arqos_f   (axi4ar_if_0.arqos),
    .axi_arregion_f(axi4ar_if_0.arregion),
    .axi_arready_f (axi4ar_if_0.arready),
    .axi_rid_f     (axi4r_if_0.rid),
    .axi_rdata_f   (axi4r_if_0.rdata),
    .axi_rresp_f   (axi4r_if_0.rresp),
    .axi_rlast_f   (axi4r_if_0.rlast),
    .axi_rvalid_f  (axi4r_if_0.rvalid),
    .axi_rready_f  (axi4r_if_0.rready)
  );

endmodule


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
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Aug  5 17:35:11 2023
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

  assign axi4master_if_0.rst_n = reset;
  assign axi4master_if_1.rst_n = reset;

  assign axi4master_if_0.clk   = clock;
  assign axi4master_if_1.clk   = clock;

  // You can insert code here by setting th_inc_inside_module in file common.tpl

  // Pin-level interfaces connected to DUT
  // You can remove interface instances by setting generate_interface_instance = no in the interface template file

  axi4master_if   axi4master_if_0 ();                
  axi4master_if   axi4master_if_1 ();                

  // BFM interfaces that communicate with proxy transactors in UVM environment
  axi4master_bfm  axi4master_bfm_0 (axi4master_if_0);
  axi4master_bfm  axi4master_bfm_1 (axi4master_if_1);

  riscv_core uut (
    .clk           (axi4master_if_0.clk),
    .rst_n         (axi4master_if_0.rst_n),
    .axi_awid_f    (axi4master_if_0.awid),
    .axi_awaddr_f  (axi4master_if_0.awaddr),
    .axi_awlen_f   (axi4master_if_0.awlen),
    .axi_awsize_f  (axi4master_if_0.awsize),
    .axi_awburst_f (axi4master_if_0.awburst),
    .axi_awlock_f  (axi4master_if_0.awlock),
    .axi_awcache_f (axi4master_if_0.awcache),
    .axi_awprot_f  (axi4master_if_0.awprot),
    .axi_awvalid_f (axi4master_if_0.awvalid),
    .axi_awregion_f(axi4master_if_0.awregion),
    .axi_awqos_f   (axi4master_if_0.awqos),
    .axi_awready_f (axi4master_if_0.awready),
    .axi_wdata_f   (axi4master_if_0.wdata),
    .axi_wstrb_f   (axi4master_if_0.wstrb),
    .axi_wlast_f   (axi4master_if_0.wlast),
    .axi_wvalid_f  (axi4master_if_0.wvalid),
    .axi_wready_f  (axi4master_if_0.wready),
    .axi_bid_f     (axi4master_if_0.bid),
    .axi_bresp_f   (axi4master_if_0.bresp),
    .axi_bvalid_f  (axi4master_if_0.bvalid),
    .axi_bready_f  (axi4master_if_0.bready),
    .axi_arid_f    (axi4master_if_0.arid),
    .axi_araddr_f  (axi4master_if_0.araddr),
    .axi_arlen_f   (axi4master_if_0.arlen),
    .axi_arsize_f  (axi4master_if_0.arsize),
    .axi_arburst_f (axi4master_if_0.arburst),
    .axi_arlock_f  (axi4master_if_0.arlock),
    .axi_arcache_f (axi4master_if_0.arcache),
    .axi_arprot_f  (axi4master_if_0.arprot),
    .axi_arvalid_f (axi4master_if_0.arvalid),
    .axi_arqos_f   (axi4master_if_0.arqos),
    .axi_arregion_f(axi4master_if_0.arregion),
    .axi_arready_f (axi4master_if_0.arready),
    .axi_rid_f     (axi4master_if_0.rid),
    .axi_rdata_f   (axi4master_if_0.rdata),
    .axi_rresp_f   (axi4master_if_0.rresp),
    .axi_rlast_f   (axi4master_if_0.rlast),
    .axi_rvalid_f  (axi4master_if_0.rvalid),
    .axi_rready_f  (axi4master_if_0.rready),
    .axi_awid_m    (axi4master_if_1.awid),
    .axi_awaddr_m  (axi4master_if_1.awaddr),
    .axi_awlen_m   (axi4master_if_1.awlen),
    .axi_awsize_m  (axi4master_if_1.awsize),
    .axi_awburst_m (axi4master_if_1.awburst),
    .axi_awlock_m  (axi4master_if_1.awlock),
    .axi_awcache_m (axi4master_if_1.awcache),
    .axi_awprot_m  (axi4master_if_1.awprot),
    .axi_awvalid_m (axi4master_if_1.awvalid),
    .axi_awregion_m(axi4master_if_1.awregion),
    .axi_awqos_m   (axi4master_if_1.awqos),
    .axi_awready_m (axi4master_if_1.awready),
    .axi_wdata_m   (axi4master_if_1.wdata),
    .axi_wstrb_m   (axi4master_if_1.wstrb),
    .axi_wlast_m   (axi4master_if_1.wlast),
    .axi_wvalid_m  (axi4master_if_1.wvalid),
    .axi_wready_m  (axi4master_if_1.wready),
    .axi_bid_m     (axi4master_if_1.bid),
    .axi_bresp_m   (axi4master_if_1.bresp),
    .axi_bvalid_m  (axi4master_if_1.bvalid),
    .axi_bready_m  (axi4master_if_1.bready),
    .axi_arid_m    (axi4master_if_1.arid),
    .axi_araddr_m  (axi4master_if_1.araddr),
    .axi_arlen_m   (axi4master_if_1.arlen),
    .axi_arsize_m  (axi4master_if_1.arsize),
    .axi_arburst_m (axi4master_if_1.arburst),
    .axi_arlock_m  (axi4master_if_1.arlock),
    .axi_arcache_m (axi4master_if_1.arcache),
    .axi_arprot_m  (axi4master_if_1.arprot),
    .axi_arvalid_m (axi4master_if_1.arvalid),
    .axi_arqos_m   (axi4master_if_1.arqos),
    .axi_arregion_m(axi4master_if_1.arregion),
    .axi_arready_m (axi4master_if_1.arready),
    .axi_rdata_m   (axi4master_if_1.rdata),
    .axi_rresp_m   (axi4master_if_1.rresp),
    .axi_rlast_m   (axi4master_if_1.rlast),
    .axi_rvalid_m  (axi4master_if_1.rvalid),
    .axi_rready_m  (axi4master_if_1.rready)
  );

endmodule


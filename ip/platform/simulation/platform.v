// platform.v

// Generated using ACDS version 22.1 917

`timescale 1 ps / 1 ps
module platform (
		input  wire  clk_clk,       //   clk.clk
		input  wire  rst_n_reset_n  // rst_n.reset_n
	);

	wire   [1:0] riscv_core_0_altera_axi4_master_1_awburst;        // riscv_core_0:axi_awburst_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_awburst
	wire   [3:0] riscv_core_0_altera_axi4_master_1_arregion;       // riscv_core_0:axi_arregion_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_arregion
	wire   [7:0] riscv_core_0_altera_axi4_master_1_arlen;          // riscv_core_0:axi_arlen_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_arlen
	wire   [3:0] riscv_core_0_altera_axi4_master_1_arqos;          // riscv_core_0:axi_arqos_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_arqos
	wire   [7:0] riscv_core_0_altera_axi4_master_1_wstrb;          // riscv_core_0:axi_wstrb_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_wstrb
	wire         riscv_core_0_altera_axi4_master_1_wready;         // mm_interconnect_0:riscv_core_0_altera_axi4_master_1_wready -> riscv_core_0:axi_wready_f
	wire         riscv_core_0_altera_axi4_master_1_rid;            // mm_interconnect_0:riscv_core_0_altera_axi4_master_1_rid -> riscv_core_0:axi_rid_f
	wire         riscv_core_0_altera_axi4_master_1_rready;         // riscv_core_0:axi_rready_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_rready
	wire   [7:0] riscv_core_0_altera_axi4_master_1_awlen;          // riscv_core_0:axi_awlen_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_awlen
	wire   [3:0] riscv_core_0_altera_axi4_master_1_awqos;          // riscv_core_0:axi_awqos_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_awqos
	wire   [3:0] riscv_core_0_altera_axi4_master_1_arcache;        // riscv_core_0:axi_arcache_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_arcache
	wire         riscv_core_0_altera_axi4_master_1_wvalid;         // riscv_core_0:axi_wvalid_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_wvalid
	wire  [31:0] riscv_core_0_altera_axi4_master_1_araddr;         // riscv_core_0:axi_araddr_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_araddr
	wire   [2:0] riscv_core_0_altera_axi4_master_1_arprot;         // riscv_core_0:axi_arprot_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_arprot
	wire   [2:0] riscv_core_0_altera_axi4_master_1_awprot;         // riscv_core_0:axi_awprot_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_awprot
	wire  [63:0] riscv_core_0_altera_axi4_master_1_wdata;          // riscv_core_0:axi_wdata_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_wdata
	wire         riscv_core_0_altera_axi4_master_1_arvalid;        // riscv_core_0:axi_arvalid_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_arvalid
	wire   [3:0] riscv_core_0_altera_axi4_master_1_awcache;        // riscv_core_0:axi_awcache_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_awcache
	wire         riscv_core_0_altera_axi4_master_1_arid;           // riscv_core_0:axi_arid_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_arid
	wire         riscv_core_0_altera_axi4_master_1_arlock;         // riscv_core_0:axi_arlock_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_arlock
	wire         riscv_core_0_altera_axi4_master_1_awlock;         // riscv_core_0:axi_awlock_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_awlock
	wire  [31:0] riscv_core_0_altera_axi4_master_1_awaddr;         // riscv_core_0:axi_awaddr_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_awaddr
	wire   [1:0] riscv_core_0_altera_axi4_master_1_bresp;          // mm_interconnect_0:riscv_core_0_altera_axi4_master_1_bresp -> riscv_core_0:axi_bresp_f
	wire         riscv_core_0_altera_axi4_master_1_arready;        // mm_interconnect_0:riscv_core_0_altera_axi4_master_1_arready -> riscv_core_0:axi_arready_f
	wire  [63:0] riscv_core_0_altera_axi4_master_1_rdata;          // mm_interconnect_0:riscv_core_0_altera_axi4_master_1_rdata -> riscv_core_0:axi_rdata_f
	wire         riscv_core_0_altera_axi4_master_1_awready;        // mm_interconnect_0:riscv_core_0_altera_axi4_master_1_awready -> riscv_core_0:axi_awready_f
	wire   [1:0] riscv_core_0_altera_axi4_master_1_arburst;        // riscv_core_0:axi_arburst_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_arburst
	wire   [2:0] riscv_core_0_altera_axi4_master_1_arsize;         // riscv_core_0:axi_arsize_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_arsize
	wire         riscv_core_0_altera_axi4_master_1_bready;         // riscv_core_0:axi_bready_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_bready
	wire         riscv_core_0_altera_axi4_master_1_rlast;          // mm_interconnect_0:riscv_core_0_altera_axi4_master_1_rlast -> riscv_core_0:axi_rlast_f
	wire         riscv_core_0_altera_axi4_master_1_wlast;          // riscv_core_0:axi_wlast_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_wlast
	wire   [3:0] riscv_core_0_altera_axi4_master_1_awregion;       // riscv_core_0:axi_awregion_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_awregion
	wire   [1:0] riscv_core_0_altera_axi4_master_1_rresp;          // mm_interconnect_0:riscv_core_0_altera_axi4_master_1_rresp -> riscv_core_0:axi_rresp_f
	wire         riscv_core_0_altera_axi4_master_1_awid;           // riscv_core_0:axi_awid_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_awid
	wire         riscv_core_0_altera_axi4_master_1_bid;            // mm_interconnect_0:riscv_core_0_altera_axi4_master_1_bid -> riscv_core_0:axi_bid_f
	wire         riscv_core_0_altera_axi4_master_1_bvalid;         // mm_interconnect_0:riscv_core_0_altera_axi4_master_1_bvalid -> riscv_core_0:axi_bvalid_f
	wire   [2:0] riscv_core_0_altera_axi4_master_1_awsize;         // riscv_core_0:axi_awsize_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_awsize
	wire         riscv_core_0_altera_axi4_master_1_awvalid;        // riscv_core_0:axi_awvalid_f -> mm_interconnect_0:riscv_core_0_altera_axi4_master_1_awvalid
	wire         riscv_core_0_altera_axi4_master_1_rvalid;         // mm_interconnect_0:riscv_core_0_altera_axi4_master_1_rvalid -> riscv_core_0:axi_rvalid_f
	wire         mm_interconnect_0_onchip_memory2_0_s1_chipselect; // mm_interconnect_0:onchip_memory2_0_s1_chipselect -> onchip_memory2_0:chipselect
	wire  [63:0] mm_interconnect_0_onchip_memory2_0_s1_readdata;   // onchip_memory2_0:readdata -> mm_interconnect_0:onchip_memory2_0_s1_readdata
	wire   [8:0] mm_interconnect_0_onchip_memory2_0_s1_address;    // mm_interconnect_0:onchip_memory2_0_s1_address -> onchip_memory2_0:address
	wire   [7:0] mm_interconnect_0_onchip_memory2_0_s1_byteenable; // mm_interconnect_0:onchip_memory2_0_s1_byteenable -> onchip_memory2_0:byteenable
	wire         mm_interconnect_0_onchip_memory2_0_s1_write;      // mm_interconnect_0:onchip_memory2_0_s1_write -> onchip_memory2_0:write
	wire  [63:0] mm_interconnect_0_onchip_memory2_0_s1_writedata;  // mm_interconnect_0:onchip_memory2_0_s1_writedata -> onchip_memory2_0:writedata
	wire         mm_interconnect_0_onchip_memory2_0_s1_clken;      // mm_interconnect_0:onchip_memory2_0_s1_clken -> onchip_memory2_0:clken
	wire   [1:0] riscv_core_0_altera_axi4_master_2_awburst;        // riscv_core_0:axi_awburst_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_awburst
	wire   [3:0] riscv_core_0_altera_axi4_master_2_arregion;       // riscv_core_0:axi_arregion_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_arregion
	wire   [7:0] riscv_core_0_altera_axi4_master_2_arlen;          // riscv_core_0:axi_arlen_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_arlen
	wire   [3:0] riscv_core_0_altera_axi4_master_2_arqos;          // riscv_core_0:axi_arqos_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_arqos
	wire   [7:0] riscv_core_0_altera_axi4_master_2_wstrb;          // riscv_core_0:axi_wstrb_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_wstrb
	wire         riscv_core_0_altera_axi4_master_2_wready;         // mm_interconnect_1:riscv_core_0_altera_axi4_master_2_wready -> riscv_core_0:axi_wready_m
	wire         riscv_core_0_altera_axi4_master_2_rid;            // mm_interconnect_1:riscv_core_0_altera_axi4_master_2_rid -> riscv_core_0:axi_rid_m
	wire         riscv_core_0_altera_axi4_master_2_rready;         // riscv_core_0:axi_rready_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_rready
	wire   [7:0] riscv_core_0_altera_axi4_master_2_awlen;          // riscv_core_0:axi_awlen_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_awlen
	wire   [3:0] riscv_core_0_altera_axi4_master_2_awqos;          // riscv_core_0:axi_awqos_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_awqos
	wire   [3:0] riscv_core_0_altera_axi4_master_2_arcache;        // riscv_core_0:axi_arcache_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_arcache
	wire         riscv_core_0_altera_axi4_master_2_wvalid;         // riscv_core_0:axi_wvalid_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_wvalid
	wire  [31:0] riscv_core_0_altera_axi4_master_2_araddr;         // riscv_core_0:axi_araddr_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_araddr
	wire   [2:0] riscv_core_0_altera_axi4_master_2_arprot;         // riscv_core_0:axi_arprot_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_arprot
	wire   [2:0] riscv_core_0_altera_axi4_master_2_awprot;         // riscv_core_0:axi_awprot_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_awprot
	wire  [63:0] riscv_core_0_altera_axi4_master_2_wdata;          // riscv_core_0:axi_wdata_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_wdata
	wire         riscv_core_0_altera_axi4_master_2_arvalid;        // riscv_core_0:axi_arvalid_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_arvalid
	wire   [3:0] riscv_core_0_altera_axi4_master_2_awcache;        // riscv_core_0:axi_awcache_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_awcache
	wire         riscv_core_0_altera_axi4_master_2_arid;           // riscv_core_0:axi_arid_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_arid
	wire         riscv_core_0_altera_axi4_master_2_arlock;         // riscv_core_0:axi_arlock_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_arlock
	wire         riscv_core_0_altera_axi4_master_2_awlock;         // riscv_core_0:axi_awlock_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_awlock
	wire  [31:0] riscv_core_0_altera_axi4_master_2_awaddr;         // riscv_core_0:axi_awaddr_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_awaddr
	wire   [1:0] riscv_core_0_altera_axi4_master_2_bresp;          // mm_interconnect_1:riscv_core_0_altera_axi4_master_2_bresp -> riscv_core_0:axi_bresp_m
	wire         riscv_core_0_altera_axi4_master_2_arready;        // mm_interconnect_1:riscv_core_0_altera_axi4_master_2_arready -> riscv_core_0:axi_arready_m
	wire  [63:0] riscv_core_0_altera_axi4_master_2_rdata;          // mm_interconnect_1:riscv_core_0_altera_axi4_master_2_rdata -> riscv_core_0:axi_rdata_m
	wire         riscv_core_0_altera_axi4_master_2_awready;        // mm_interconnect_1:riscv_core_0_altera_axi4_master_2_awready -> riscv_core_0:axi_awready_m
	wire   [1:0] riscv_core_0_altera_axi4_master_2_arburst;        // riscv_core_0:axi_arburst_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_arburst
	wire   [2:0] riscv_core_0_altera_axi4_master_2_arsize;         // riscv_core_0:axi_arsize_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_arsize
	wire         riscv_core_0_altera_axi4_master_2_bready;         // riscv_core_0:axi_bready_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_bready
	wire         riscv_core_0_altera_axi4_master_2_rlast;          // mm_interconnect_1:riscv_core_0_altera_axi4_master_2_rlast -> riscv_core_0:axi_rlast_m
	wire         riscv_core_0_altera_axi4_master_2_wlast;          // riscv_core_0:axi_wlast_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_wlast
	wire   [3:0] riscv_core_0_altera_axi4_master_2_awregion;       // riscv_core_0:axi_awregion_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_awregion
	wire   [1:0] riscv_core_0_altera_axi4_master_2_rresp;          // mm_interconnect_1:riscv_core_0_altera_axi4_master_2_rresp -> riscv_core_0:axi_rresp_m
	wire         riscv_core_0_altera_axi4_master_2_awid;           // riscv_core_0:axi_awid_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_awid
	wire         riscv_core_0_altera_axi4_master_2_bid;            // mm_interconnect_1:riscv_core_0_altera_axi4_master_2_bid -> riscv_core_0:axi_bid_m
	wire         riscv_core_0_altera_axi4_master_2_bvalid;         // mm_interconnect_1:riscv_core_0_altera_axi4_master_2_bvalid -> riscv_core_0:axi_bvalid_m
	wire   [2:0] riscv_core_0_altera_axi4_master_2_awsize;         // riscv_core_0:axi_awsize_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_awsize
	wire         riscv_core_0_altera_axi4_master_2_awvalid;        // riscv_core_0:axi_awvalid_m -> mm_interconnect_1:riscv_core_0_altera_axi4_master_2_awvalid
	wire         riscv_core_0_altera_axi4_master_2_rvalid;         // mm_interconnect_1:riscv_core_0_altera_axi4_master_2_rvalid -> riscv_core_0:axi_rvalid_m
	wire         mm_interconnect_1_onchip_memory2_0_s2_chipselect; // mm_interconnect_1:onchip_memory2_0_s2_chipselect -> onchip_memory2_0:chipselect2
	wire  [63:0] mm_interconnect_1_onchip_memory2_0_s2_readdata;   // onchip_memory2_0:readdata2 -> mm_interconnect_1:onchip_memory2_0_s2_readdata
	wire   [8:0] mm_interconnect_1_onchip_memory2_0_s2_address;    // mm_interconnect_1:onchip_memory2_0_s2_address -> onchip_memory2_0:address2
	wire   [7:0] mm_interconnect_1_onchip_memory2_0_s2_byteenable; // mm_interconnect_1:onchip_memory2_0_s2_byteenable -> onchip_memory2_0:byteenable2
	wire         mm_interconnect_1_onchip_memory2_0_s2_write;      // mm_interconnect_1:onchip_memory2_0_s2_write -> onchip_memory2_0:write2
	wire  [63:0] mm_interconnect_1_onchip_memory2_0_s2_writedata;  // mm_interconnect_1:onchip_memory2_0_s2_writedata -> onchip_memory2_0:writedata2
	wire         mm_interconnect_1_onchip_memory2_0_s2_clken;      // mm_interconnect_1:onchip_memory2_0_s2_clken -> onchip_memory2_0:clken2

	platform_onchip_memory2_0 onchip_memory2_0 (
		.address     (mm_interconnect_0_onchip_memory2_0_s1_address),    //     s1.address
		.clken       (mm_interconnect_0_onchip_memory2_0_s1_clken),      //       .clken
		.chipselect  (mm_interconnect_0_onchip_memory2_0_s1_chipselect), //       .chipselect
		.write       (mm_interconnect_0_onchip_memory2_0_s1_write),      //       .write
		.readdata    (mm_interconnect_0_onchip_memory2_0_s1_readdata),   //       .readdata
		.writedata   (mm_interconnect_0_onchip_memory2_0_s1_writedata),  //       .writedata
		.byteenable  (mm_interconnect_0_onchip_memory2_0_s1_byteenable), //       .byteenable
		.address2    (mm_interconnect_1_onchip_memory2_0_s2_address),    //     s2.address
		.chipselect2 (mm_interconnect_1_onchip_memory2_0_s2_chipselect), //       .chipselect
		.clken2      (mm_interconnect_1_onchip_memory2_0_s2_clken),      //       .clken
		.write2      (mm_interconnect_1_onchip_memory2_0_s2_write),      //       .write
		.readdata2   (mm_interconnect_1_onchip_memory2_0_s2_readdata),   //       .readdata
		.writedata2  (mm_interconnect_1_onchip_memory2_0_s2_writedata),  //       .writedata
		.byteenable2 (mm_interconnect_1_onchip_memory2_0_s2_byteenable), //       .byteenable
		.clk         (clk_clk),                                          //   clk1.clk
		.reset       (~rst_n_reset_n),                                   // reset1.reset
		.freeze      (1'b0),                                             // (terminated)
		.reset_req   (1'b0)                                              // (terminated)
	);

	platform_riscv_core_0 riscv_core_0 (
		.axi_awid_f     (riscv_core_0_altera_axi4_master_1_awid),     // altera_axi4_master_1.awid
		.axi_awaddr_f   (riscv_core_0_altera_axi4_master_1_awaddr),   //                     .awaddr
		.axi_awlen_f    (riscv_core_0_altera_axi4_master_1_awlen),    //                     .awlen
		.axi_awsize_f   (riscv_core_0_altera_axi4_master_1_awsize),   //                     .awsize
		.axi_awburst_f  (riscv_core_0_altera_axi4_master_1_awburst),  //                     .awburst
		.axi_awlock_f   (riscv_core_0_altera_axi4_master_1_awlock),   //                     .awlock
		.axi_awcache_f  (riscv_core_0_altera_axi4_master_1_awcache),  //                     .awcache
		.axi_awprot_f   (riscv_core_0_altera_axi4_master_1_awprot),   //                     .awprot
		.axi_awvalid_f  (riscv_core_0_altera_axi4_master_1_awvalid),  //                     .awvalid
		.axi_awregion_f (riscv_core_0_altera_axi4_master_1_awregion), //                     .awregion
		.axi_awqos_f    (riscv_core_0_altera_axi4_master_1_awqos),    //                     .awqos
		.axi_awready_f  (riscv_core_0_altera_axi4_master_1_awready),  //                     .awready
		.axi_wdata_f    (riscv_core_0_altera_axi4_master_1_wdata),    //                     .wdata
		.axi_wstrb_f    (riscv_core_0_altera_axi4_master_1_wstrb),    //                     .wstrb
		.axi_wlast_f    (riscv_core_0_altera_axi4_master_1_wlast),    //                     .wlast
		.axi_wvalid_f   (riscv_core_0_altera_axi4_master_1_wvalid),   //                     .wvalid
		.axi_wready_f   (riscv_core_0_altera_axi4_master_1_wready),   //                     .wready
		.axi_bid_f      (riscv_core_0_altera_axi4_master_1_bid),      //                     .bid
		.axi_bresp_f    (riscv_core_0_altera_axi4_master_1_bresp),    //                     .bresp
		.axi_bvalid_f   (riscv_core_0_altera_axi4_master_1_bvalid),   //                     .bvalid
		.axi_bready_f   (riscv_core_0_altera_axi4_master_1_bready),   //                     .bready
		.axi_arid_f     (riscv_core_0_altera_axi4_master_1_arid),     //                     .arid
		.axi_araddr_f   (riscv_core_0_altera_axi4_master_1_araddr),   //                     .araddr
		.axi_arlen_f    (riscv_core_0_altera_axi4_master_1_arlen),    //                     .arlen
		.axi_arsize_f   (riscv_core_0_altera_axi4_master_1_arsize),   //                     .arsize
		.axi_arburst_f  (riscv_core_0_altera_axi4_master_1_arburst),  //                     .arburst
		.axi_arlock_f   (riscv_core_0_altera_axi4_master_1_arlock),   //                     .arlock
		.axi_arcache_f  (riscv_core_0_altera_axi4_master_1_arcache),  //                     .arcache
		.axi_arprot_f   (riscv_core_0_altera_axi4_master_1_arprot),   //                     .arprot
		.axi_arvalid_f  (riscv_core_0_altera_axi4_master_1_arvalid),  //                     .arvalid
		.axi_arqos_f    (riscv_core_0_altera_axi4_master_1_arqos),    //                     .arqos
		.axi_arregion_f (riscv_core_0_altera_axi4_master_1_arregion), //                     .arregion
		.axi_arready_f  (riscv_core_0_altera_axi4_master_1_arready),  //                     .arready
		.axi_rid_f      (riscv_core_0_altera_axi4_master_1_rid),      //                     .rid
		.axi_rdata_f    (riscv_core_0_altera_axi4_master_1_rdata),    //                     .rdata
		.axi_rresp_f    (riscv_core_0_altera_axi4_master_1_rresp),    //                     .rresp
		.axi_rlast_f    (riscv_core_0_altera_axi4_master_1_rlast),    //                     .rlast
		.axi_rvalid_f   (riscv_core_0_altera_axi4_master_1_rvalid),   //                     .rvalid
		.axi_rready_f   (riscv_core_0_altera_axi4_master_1_rready),   //                     .rready
		.axi_awid_m     (riscv_core_0_altera_axi4_master_2_awid),     // altera_axi4_master_2.awid
		.axi_awaddr_m   (riscv_core_0_altera_axi4_master_2_awaddr),   //                     .awaddr
		.axi_awlen_m    (riscv_core_0_altera_axi4_master_2_awlen),    //                     .awlen
		.axi_awsize_m   (riscv_core_0_altera_axi4_master_2_awsize),   //                     .awsize
		.axi_awburst_m  (riscv_core_0_altera_axi4_master_2_awburst),  //                     .awburst
		.axi_awlock_m   (riscv_core_0_altera_axi4_master_2_awlock),   //                     .awlock
		.axi_awcache_m  (riscv_core_0_altera_axi4_master_2_awcache),  //                     .awcache
		.axi_awprot_m   (riscv_core_0_altera_axi4_master_2_awprot),   //                     .awprot
		.axi_awvalid_m  (riscv_core_0_altera_axi4_master_2_awvalid),  //                     .awvalid
		.axi_awregion_m (riscv_core_0_altera_axi4_master_2_awregion), //                     .awregion
		.axi_awqos_m    (riscv_core_0_altera_axi4_master_2_awqos),    //                     .awqos
		.axi_awready_m  (riscv_core_0_altera_axi4_master_2_awready),  //                     .awready
		.axi_wdata_m    (riscv_core_0_altera_axi4_master_2_wdata),    //                     .wdata
		.axi_wstrb_m    (riscv_core_0_altera_axi4_master_2_wstrb),    //                     .wstrb
		.axi_wlast_m    (riscv_core_0_altera_axi4_master_2_wlast),    //                     .wlast
		.axi_wvalid_m   (riscv_core_0_altera_axi4_master_2_wvalid),   //                     .wvalid
		.axi_wready_m   (riscv_core_0_altera_axi4_master_2_wready),   //                     .wready
		.axi_bid_m      (riscv_core_0_altera_axi4_master_2_bid),      //                     .bid
		.axi_bresp_m    (riscv_core_0_altera_axi4_master_2_bresp),    //                     .bresp
		.axi_bvalid_m   (riscv_core_0_altera_axi4_master_2_bvalid),   //                     .bvalid
		.axi_bready_m   (riscv_core_0_altera_axi4_master_2_bready),   //                     .bready
		.axi_arid_m     (riscv_core_0_altera_axi4_master_2_arid),     //                     .arid
		.axi_araddr_m   (riscv_core_0_altera_axi4_master_2_araddr),   //                     .araddr
		.axi_arlen_m    (riscv_core_0_altera_axi4_master_2_arlen),    //                     .arlen
		.axi_arsize_m   (riscv_core_0_altera_axi4_master_2_arsize),   //                     .arsize
		.axi_arburst_m  (riscv_core_0_altera_axi4_master_2_arburst),  //                     .arburst
		.axi_arlock_m   (riscv_core_0_altera_axi4_master_2_arlock),   //                     .arlock
		.axi_arcache_m  (riscv_core_0_altera_axi4_master_2_arcache),  //                     .arcache
		.axi_arprot_m   (riscv_core_0_altera_axi4_master_2_arprot),   //                     .arprot
		.axi_arvalid_m  (riscv_core_0_altera_axi4_master_2_arvalid),  //                     .arvalid
		.axi_arqos_m    (riscv_core_0_altera_axi4_master_2_arqos),    //                     .arqos
		.axi_arregion_m (riscv_core_0_altera_axi4_master_2_arregion), //                     .arregion
		.axi_arready_m  (riscv_core_0_altera_axi4_master_2_arready),  //                     .arready
		.axi_rid_m      (riscv_core_0_altera_axi4_master_2_rid),      //                     .rid
		.axi_rdata_m    (riscv_core_0_altera_axi4_master_2_rdata),    //                     .rdata
		.axi_rresp_m    (riscv_core_0_altera_axi4_master_2_rresp),    //                     .rresp
		.axi_rlast_m    (riscv_core_0_altera_axi4_master_2_rlast),    //                     .rlast
		.axi_rvalid_m   (riscv_core_0_altera_axi4_master_2_rvalid),   //                     .rvalid
		.axi_rready_m   (riscv_core_0_altera_axi4_master_2_rready),   //                     .rready
		.clk            (clk_clk),                                    //                  clk.clk
		.rst_n          (rst_n_reset_n)                               //                  rst.reset_n
	);

	platform_mm_interconnect_0 mm_interconnect_0 (
		.riscv_core_0_altera_axi4_master_1_awid       (riscv_core_0_altera_axi4_master_1_awid),           //      riscv_core_0_altera_axi4_master_1.awid
		.riscv_core_0_altera_axi4_master_1_awaddr     (riscv_core_0_altera_axi4_master_1_awaddr),         //                                       .awaddr
		.riscv_core_0_altera_axi4_master_1_awlen      (riscv_core_0_altera_axi4_master_1_awlen),          //                                       .awlen
		.riscv_core_0_altera_axi4_master_1_awsize     (riscv_core_0_altera_axi4_master_1_awsize),         //                                       .awsize
		.riscv_core_0_altera_axi4_master_1_awburst    (riscv_core_0_altera_axi4_master_1_awburst),        //                                       .awburst
		.riscv_core_0_altera_axi4_master_1_awlock     (riscv_core_0_altera_axi4_master_1_awlock),         //                                       .awlock
		.riscv_core_0_altera_axi4_master_1_awcache    (riscv_core_0_altera_axi4_master_1_awcache),        //                                       .awcache
		.riscv_core_0_altera_axi4_master_1_awprot     (riscv_core_0_altera_axi4_master_1_awprot),         //                                       .awprot
		.riscv_core_0_altera_axi4_master_1_awqos      (riscv_core_0_altera_axi4_master_1_awqos),          //                                       .awqos
		.riscv_core_0_altera_axi4_master_1_awregion   (riscv_core_0_altera_axi4_master_1_awregion),       //                                       .awregion
		.riscv_core_0_altera_axi4_master_1_awvalid    (riscv_core_0_altera_axi4_master_1_awvalid),        //                                       .awvalid
		.riscv_core_0_altera_axi4_master_1_awready    (riscv_core_0_altera_axi4_master_1_awready),        //                                       .awready
		.riscv_core_0_altera_axi4_master_1_wdata      (riscv_core_0_altera_axi4_master_1_wdata),          //                                       .wdata
		.riscv_core_0_altera_axi4_master_1_wstrb      (riscv_core_0_altera_axi4_master_1_wstrb),          //                                       .wstrb
		.riscv_core_0_altera_axi4_master_1_wlast      (riscv_core_0_altera_axi4_master_1_wlast),          //                                       .wlast
		.riscv_core_0_altera_axi4_master_1_wvalid     (riscv_core_0_altera_axi4_master_1_wvalid),         //                                       .wvalid
		.riscv_core_0_altera_axi4_master_1_wready     (riscv_core_0_altera_axi4_master_1_wready),         //                                       .wready
		.riscv_core_0_altera_axi4_master_1_bid        (riscv_core_0_altera_axi4_master_1_bid),            //                                       .bid
		.riscv_core_0_altera_axi4_master_1_bresp      (riscv_core_0_altera_axi4_master_1_bresp),          //                                       .bresp
		.riscv_core_0_altera_axi4_master_1_bvalid     (riscv_core_0_altera_axi4_master_1_bvalid),         //                                       .bvalid
		.riscv_core_0_altera_axi4_master_1_bready     (riscv_core_0_altera_axi4_master_1_bready),         //                                       .bready
		.riscv_core_0_altera_axi4_master_1_arid       (riscv_core_0_altera_axi4_master_1_arid),           //                                       .arid
		.riscv_core_0_altera_axi4_master_1_araddr     (riscv_core_0_altera_axi4_master_1_araddr),         //                                       .araddr
		.riscv_core_0_altera_axi4_master_1_arlen      (riscv_core_0_altera_axi4_master_1_arlen),          //                                       .arlen
		.riscv_core_0_altera_axi4_master_1_arsize     (riscv_core_0_altera_axi4_master_1_arsize),         //                                       .arsize
		.riscv_core_0_altera_axi4_master_1_arburst    (riscv_core_0_altera_axi4_master_1_arburst),        //                                       .arburst
		.riscv_core_0_altera_axi4_master_1_arlock     (riscv_core_0_altera_axi4_master_1_arlock),         //                                       .arlock
		.riscv_core_0_altera_axi4_master_1_arcache    (riscv_core_0_altera_axi4_master_1_arcache),        //                                       .arcache
		.riscv_core_0_altera_axi4_master_1_arprot     (riscv_core_0_altera_axi4_master_1_arprot),         //                                       .arprot
		.riscv_core_0_altera_axi4_master_1_arqos      (riscv_core_0_altera_axi4_master_1_arqos),          //                                       .arqos
		.riscv_core_0_altera_axi4_master_1_arregion   (riscv_core_0_altera_axi4_master_1_arregion),       //                                       .arregion
		.riscv_core_0_altera_axi4_master_1_arvalid    (riscv_core_0_altera_axi4_master_1_arvalid),        //                                       .arvalid
		.riscv_core_0_altera_axi4_master_1_arready    (riscv_core_0_altera_axi4_master_1_arready),        //                                       .arready
		.riscv_core_0_altera_axi4_master_1_rid        (riscv_core_0_altera_axi4_master_1_rid),            //                                       .rid
		.riscv_core_0_altera_axi4_master_1_rdata      (riscv_core_0_altera_axi4_master_1_rdata),          //                                       .rdata
		.riscv_core_0_altera_axi4_master_1_rresp      (riscv_core_0_altera_axi4_master_1_rresp),          //                                       .rresp
		.riscv_core_0_altera_axi4_master_1_rlast      (riscv_core_0_altera_axi4_master_1_rlast),          //                                       .rlast
		.riscv_core_0_altera_axi4_master_1_rvalid     (riscv_core_0_altera_axi4_master_1_rvalid),         //                                       .rvalid
		.riscv_core_0_altera_axi4_master_1_rready     (riscv_core_0_altera_axi4_master_1_rready),         //                                       .rready
		.clk_0_clk_clk                                (clk_clk),                                          //                              clk_0_clk.clk
		.riscv_core_0_rst_reset_bridge_in_reset_reset (~rst_n_reset_n),                                   // riscv_core_0_rst_reset_bridge_in_reset.reset
		.onchip_memory2_0_s1_address                  (mm_interconnect_0_onchip_memory2_0_s1_address),    //                    onchip_memory2_0_s1.address
		.onchip_memory2_0_s1_write                    (mm_interconnect_0_onchip_memory2_0_s1_write),      //                                       .write
		.onchip_memory2_0_s1_readdata                 (mm_interconnect_0_onchip_memory2_0_s1_readdata),   //                                       .readdata
		.onchip_memory2_0_s1_writedata                (mm_interconnect_0_onchip_memory2_0_s1_writedata),  //                                       .writedata
		.onchip_memory2_0_s1_byteenable               (mm_interconnect_0_onchip_memory2_0_s1_byteenable), //                                       .byteenable
		.onchip_memory2_0_s1_chipselect               (mm_interconnect_0_onchip_memory2_0_s1_chipselect), //                                       .chipselect
		.onchip_memory2_0_s1_clken                    (mm_interconnect_0_onchip_memory2_0_s1_clken)       //                                       .clken
	);

	platform_mm_interconnect_1 mm_interconnect_1 (
		.riscv_core_0_altera_axi4_master_2_awid       (riscv_core_0_altera_axi4_master_2_awid),           //      riscv_core_0_altera_axi4_master_2.awid
		.riscv_core_0_altera_axi4_master_2_awaddr     (riscv_core_0_altera_axi4_master_2_awaddr),         //                                       .awaddr
		.riscv_core_0_altera_axi4_master_2_awlen      (riscv_core_0_altera_axi4_master_2_awlen),          //                                       .awlen
		.riscv_core_0_altera_axi4_master_2_awsize     (riscv_core_0_altera_axi4_master_2_awsize),         //                                       .awsize
		.riscv_core_0_altera_axi4_master_2_awburst    (riscv_core_0_altera_axi4_master_2_awburst),        //                                       .awburst
		.riscv_core_0_altera_axi4_master_2_awlock     (riscv_core_0_altera_axi4_master_2_awlock),         //                                       .awlock
		.riscv_core_0_altera_axi4_master_2_awcache    (riscv_core_0_altera_axi4_master_2_awcache),        //                                       .awcache
		.riscv_core_0_altera_axi4_master_2_awprot     (riscv_core_0_altera_axi4_master_2_awprot),         //                                       .awprot
		.riscv_core_0_altera_axi4_master_2_awqos      (riscv_core_0_altera_axi4_master_2_awqos),          //                                       .awqos
		.riscv_core_0_altera_axi4_master_2_awregion   (riscv_core_0_altera_axi4_master_2_awregion),       //                                       .awregion
		.riscv_core_0_altera_axi4_master_2_awvalid    (riscv_core_0_altera_axi4_master_2_awvalid),        //                                       .awvalid
		.riscv_core_0_altera_axi4_master_2_awready    (riscv_core_0_altera_axi4_master_2_awready),        //                                       .awready
		.riscv_core_0_altera_axi4_master_2_wdata      (riscv_core_0_altera_axi4_master_2_wdata),          //                                       .wdata
		.riscv_core_0_altera_axi4_master_2_wstrb      (riscv_core_0_altera_axi4_master_2_wstrb),          //                                       .wstrb
		.riscv_core_0_altera_axi4_master_2_wlast      (riscv_core_0_altera_axi4_master_2_wlast),          //                                       .wlast
		.riscv_core_0_altera_axi4_master_2_wvalid     (riscv_core_0_altera_axi4_master_2_wvalid),         //                                       .wvalid
		.riscv_core_0_altera_axi4_master_2_wready     (riscv_core_0_altera_axi4_master_2_wready),         //                                       .wready
		.riscv_core_0_altera_axi4_master_2_bid        (riscv_core_0_altera_axi4_master_2_bid),            //                                       .bid
		.riscv_core_0_altera_axi4_master_2_bresp      (riscv_core_0_altera_axi4_master_2_bresp),          //                                       .bresp
		.riscv_core_0_altera_axi4_master_2_bvalid     (riscv_core_0_altera_axi4_master_2_bvalid),         //                                       .bvalid
		.riscv_core_0_altera_axi4_master_2_bready     (riscv_core_0_altera_axi4_master_2_bready),         //                                       .bready
		.riscv_core_0_altera_axi4_master_2_arid       (riscv_core_0_altera_axi4_master_2_arid),           //                                       .arid
		.riscv_core_0_altera_axi4_master_2_araddr     (riscv_core_0_altera_axi4_master_2_araddr),         //                                       .araddr
		.riscv_core_0_altera_axi4_master_2_arlen      (riscv_core_0_altera_axi4_master_2_arlen),          //                                       .arlen
		.riscv_core_0_altera_axi4_master_2_arsize     (riscv_core_0_altera_axi4_master_2_arsize),         //                                       .arsize
		.riscv_core_0_altera_axi4_master_2_arburst    (riscv_core_0_altera_axi4_master_2_arburst),        //                                       .arburst
		.riscv_core_0_altera_axi4_master_2_arlock     (riscv_core_0_altera_axi4_master_2_arlock),         //                                       .arlock
		.riscv_core_0_altera_axi4_master_2_arcache    (riscv_core_0_altera_axi4_master_2_arcache),        //                                       .arcache
		.riscv_core_0_altera_axi4_master_2_arprot     (riscv_core_0_altera_axi4_master_2_arprot),         //                                       .arprot
		.riscv_core_0_altera_axi4_master_2_arqos      (riscv_core_0_altera_axi4_master_2_arqos),          //                                       .arqos
		.riscv_core_0_altera_axi4_master_2_arregion   (riscv_core_0_altera_axi4_master_2_arregion),       //                                       .arregion
		.riscv_core_0_altera_axi4_master_2_arvalid    (riscv_core_0_altera_axi4_master_2_arvalid),        //                                       .arvalid
		.riscv_core_0_altera_axi4_master_2_arready    (riscv_core_0_altera_axi4_master_2_arready),        //                                       .arready
		.riscv_core_0_altera_axi4_master_2_rid        (riscv_core_0_altera_axi4_master_2_rid),            //                                       .rid
		.riscv_core_0_altera_axi4_master_2_rdata      (riscv_core_0_altera_axi4_master_2_rdata),          //                                       .rdata
		.riscv_core_0_altera_axi4_master_2_rresp      (riscv_core_0_altera_axi4_master_2_rresp),          //                                       .rresp
		.riscv_core_0_altera_axi4_master_2_rlast      (riscv_core_0_altera_axi4_master_2_rlast),          //                                       .rlast
		.riscv_core_0_altera_axi4_master_2_rvalid     (riscv_core_0_altera_axi4_master_2_rvalid),         //                                       .rvalid
		.riscv_core_0_altera_axi4_master_2_rready     (riscv_core_0_altera_axi4_master_2_rready),         //                                       .rready
		.clk_0_clk_clk                                (clk_clk),                                          //                              clk_0_clk.clk
		.riscv_core_0_rst_reset_bridge_in_reset_reset (~rst_n_reset_n),                                   // riscv_core_0_rst_reset_bridge_in_reset.reset
		.onchip_memory2_0_s2_address                  (mm_interconnect_1_onchip_memory2_0_s2_address),    //                    onchip_memory2_0_s2.address
		.onchip_memory2_0_s2_write                    (mm_interconnect_1_onchip_memory2_0_s2_write),      //                                       .write
		.onchip_memory2_0_s2_readdata                 (mm_interconnect_1_onchip_memory2_0_s2_readdata),   //                                       .readdata
		.onchip_memory2_0_s2_writedata                (mm_interconnect_1_onchip_memory2_0_s2_writedata),  //                                       .writedata
		.onchip_memory2_0_s2_byteenable               (mm_interconnect_1_onchip_memory2_0_s2_byteenable), //                                       .byteenable
		.onchip_memory2_0_s2_chipselect               (mm_interconnect_1_onchip_memory2_0_s2_chipselect), //                                       .chipselect
		.onchip_memory2_0_s2_clken                    (mm_interconnect_1_onchip_memory2_0_s2_clken)       //                                       .clken
	);

endmodule

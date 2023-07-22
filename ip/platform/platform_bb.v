
module platform (
	clk_clk,
	rst_n_reset_n,
	ssram_0_external_interface_ssram_be_n,
	ssram_0_external_interface_ssram_we_n,
	ssram_0_external_interface_fs_dq,
	ssram_0_external_interface_ssram_adsc_n,
	ssram_0_external_interface_ssram_oe_n,
	ssram_0_external_interface_fs_addr,
	ssram_0_external_interface_ssram_cs_n);	

	input		clk_clk;
	input		rst_n_reset_n;
	output	[3:0]	ssram_0_external_interface_ssram_be_n;
	output	[0:0]	ssram_0_external_interface_ssram_we_n;
	inout	[31:0]	ssram_0_external_interface_fs_dq;
	output	[0:0]	ssram_0_external_interface_ssram_adsc_n;
	output	[0:0]	ssram_0_external_interface_ssram_oe_n;
	output	[19:0]	ssram_0_external_interface_fs_addr;
	output	[0:0]	ssram_0_external_interface_ssram_cs_n;
endmodule

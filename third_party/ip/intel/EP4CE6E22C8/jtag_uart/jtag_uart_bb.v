
module jtag_uart (
	clk_clk,
	rst_n_reset_n,
	avn_slave_chipselect,
	avn_slave_address,
	avn_slave_read_n,
	avn_slave_readdata,
	avn_slave_write_n,
	avn_slave_writedata,
	avn_slave_waitrequest,
	jtag_uart_irq_irq);	

	input		clk_clk;
	input		rst_n_reset_n;
	input		avn_slave_chipselect;
	input		avn_slave_address;
	input		avn_slave_read_n;
	output	[31:0]	avn_slave_readdata;
	input		avn_slave_write_n;
	input	[31:0]	avn_slave_writedata;
	output		avn_slave_waitrequest;
	output		jtag_uart_irq_irq;
endmodule

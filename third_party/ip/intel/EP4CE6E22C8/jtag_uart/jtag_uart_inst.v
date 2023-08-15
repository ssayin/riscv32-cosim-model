	jtag_uart u0 (
		.clk_clk               (<connected-to-clk_clk>),               //           clk.clk
		.rst_n_reset_n         (<connected-to-rst_n_reset_n>),         //         rst_n.reset_n
		.avn_slave_chipselect  (<connected-to-avn_slave_chipselect>),  //     avn_slave.chipselect
		.avn_slave_address     (<connected-to-avn_slave_address>),     //              .address
		.avn_slave_read_n      (<connected-to-avn_slave_read_n>),      //              .read_n
		.avn_slave_readdata    (<connected-to-avn_slave_readdata>),    //              .readdata
		.avn_slave_write_n     (<connected-to-avn_slave_write_n>),     //              .write_n
		.avn_slave_writedata   (<connected-to-avn_slave_writedata>),   //              .writedata
		.avn_slave_waitrequest (<connected-to-avn_slave_waitrequest>), //              .waitrequest
		.jtag_uart_irq_irq     (<connected-to-jtag_uart_irq_irq>)      // jtag_uart_irq.irq
	);


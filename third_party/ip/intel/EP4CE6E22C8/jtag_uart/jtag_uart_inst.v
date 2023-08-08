	jtag_uart u0 (
		.jtag_uart_clk_clk                       (<connected-to-jtag_uart_clk_clk>),                       //               jtag_uart_clk.clk
		.jtag_uart_reset_reset_n                 (<connected-to-jtag_uart_reset_reset_n>),                 //             jtag_uart_reset.reset_n
		.jtag_uart_avalon_jtag_slave_chipselect  (<connected-to-jtag_uart_avalon_jtag_slave_chipselect>),  // jtag_uart_avalon_jtag_slave.chipselect
		.jtag_uart_avalon_jtag_slave_address     (<connected-to-jtag_uart_avalon_jtag_slave_address>),     //                            .address
		.jtag_uart_avalon_jtag_slave_read_n      (<connected-to-jtag_uart_avalon_jtag_slave_read_n>),      //                            .read_n
		.jtag_uart_avalon_jtag_slave_readdata    (<connected-to-jtag_uart_avalon_jtag_slave_readdata>),    //                            .readdata
		.jtag_uart_avalon_jtag_slave_write_n     (<connected-to-jtag_uart_avalon_jtag_slave_write_n>),     //                            .write_n
		.jtag_uart_avalon_jtag_slave_writedata   (<connected-to-jtag_uart_avalon_jtag_slave_writedata>),   //                            .writedata
		.jtag_uart_avalon_jtag_slave_waitrequest (<connected-to-jtag_uart_avalon_jtag_slave_waitrequest>), //                            .waitrequest
		.jtag_uart_irq_irq                       (<connected-to-jtag_uart_irq_irq>)                        //               jtag_uart_irq.irq
	);


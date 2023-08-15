	component jtag_uart is
		port (
			clk_clk               : in  std_logic                     := 'X';             -- clk
			rst_n_reset_n         : in  std_logic                     := 'X';             -- reset_n
			avn_slave_chipselect  : in  std_logic                     := 'X';             -- chipselect
			avn_slave_address     : in  std_logic                     := 'X';             -- address
			avn_slave_read_n      : in  std_logic                     := 'X';             -- read_n
			avn_slave_readdata    : out std_logic_vector(31 downto 0);                    -- readdata
			avn_slave_write_n     : in  std_logic                     := 'X';             -- write_n
			avn_slave_writedata   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			avn_slave_waitrequest : out std_logic;                                        -- waitrequest
			jtag_uart_irq_irq     : out std_logic                                         -- irq
		);
	end component jtag_uart;

	u0 : component jtag_uart
		port map (
			clk_clk               => CONNECTED_TO_clk_clk,               --           clk.clk
			rst_n_reset_n         => CONNECTED_TO_rst_n_reset_n,         --         rst_n.reset_n
			avn_slave_chipselect  => CONNECTED_TO_avn_slave_chipselect,  --     avn_slave.chipselect
			avn_slave_address     => CONNECTED_TO_avn_slave_address,     --              .address
			avn_slave_read_n      => CONNECTED_TO_avn_slave_read_n,      --              .read_n
			avn_slave_readdata    => CONNECTED_TO_avn_slave_readdata,    --              .readdata
			avn_slave_write_n     => CONNECTED_TO_avn_slave_write_n,     --              .write_n
			avn_slave_writedata   => CONNECTED_TO_avn_slave_writedata,   --              .writedata
			avn_slave_waitrequest => CONNECTED_TO_avn_slave_waitrequest, --              .waitrequest
			jtag_uart_irq_irq     => CONNECTED_TO_jtag_uart_irq_irq      -- jtag_uart_irq.irq
		);


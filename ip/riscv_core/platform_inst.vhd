	component platform is
		port (
			clk_clk       : in std_logic := 'X'; -- clk
			rst_n_reset_n : in std_logic := 'X'  -- reset_n
		);
	end component platform;

	u0 : component platform
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			rst_n_reset_n => CONNECTED_TO_rst_n_reset_n  -- rst_n.reset_n
		);


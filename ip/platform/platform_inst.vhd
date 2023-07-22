	component platform is
		port (
			clk_clk                                 : in    std_logic                     := 'X';             -- clk
			rst_n_reset_n                           : in    std_logic                     := 'X';             -- reset_n
			ssram_0_external_interface_ssram_be_n   : out   std_logic_vector(3 downto 0);                     -- ssram_be_n
			ssram_0_external_interface_ssram_we_n   : out   std_logic_vector(0 downto 0);                     -- ssram_we_n
			ssram_0_external_interface_fs_dq        : inout std_logic_vector(31 downto 0) := (others => 'X'); -- fs_dq
			ssram_0_external_interface_ssram_adsc_n : out   std_logic_vector(0 downto 0);                     -- ssram_adsc_n
			ssram_0_external_interface_ssram_oe_n   : out   std_logic_vector(0 downto 0);                     -- ssram_oe_n
			ssram_0_external_interface_fs_addr      : out   std_logic_vector(19 downto 0);                    -- fs_addr
			ssram_0_external_interface_ssram_cs_n   : out   std_logic_vector(0 downto 0)                      -- ssram_cs_n
		);
	end component platform;

	u0 : component platform
		port map (
			clk_clk                                 => CONNECTED_TO_clk_clk,                                 --                        clk.clk
			rst_n_reset_n                           => CONNECTED_TO_rst_n_reset_n,                           --                      rst_n.reset_n
			ssram_0_external_interface_ssram_be_n   => CONNECTED_TO_ssram_0_external_interface_ssram_be_n,   -- ssram_0_external_interface.ssram_be_n
			ssram_0_external_interface_ssram_we_n   => CONNECTED_TO_ssram_0_external_interface_ssram_we_n,   --                           .ssram_we_n
			ssram_0_external_interface_fs_dq        => CONNECTED_TO_ssram_0_external_interface_fs_dq,        --                           .fs_dq
			ssram_0_external_interface_ssram_adsc_n => CONNECTED_TO_ssram_0_external_interface_ssram_adsc_n, --                           .ssram_adsc_n
			ssram_0_external_interface_ssram_oe_n   => CONNECTED_TO_ssram_0_external_interface_ssram_oe_n,   --                           .ssram_oe_n
			ssram_0_external_interface_fs_addr      => CONNECTED_TO_ssram_0_external_interface_fs_addr,      --                           .fs_addr
			ssram_0_external_interface_ssram_cs_n   => CONNECTED_TO_ssram_0_external_interface_ssram_cs_n    --                           .ssram_cs_n
		);


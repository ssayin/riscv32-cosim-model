agent_name = axi4aw

number_of_instances = 1

trans_item = axi4aw_tx

trans_var = rand logic [ 1:0] awid;
trans_var = rand logic [31:0] awaddr;
trans_var = rand logic [ 7:0] awlen;
trans_var = rand logic [ 2:0] awsize;
trans_var = rand logic [ 1:0] awburst;
trans_var = rand logic        awlock;
trans_var = rand logic [ 3:0] awcache;
trans_var = rand logic [ 2:0] awprot;
trans_var = rand logic        awvalid;
trans_var = rand logic [ 3:0] awregion;
trans_var = rand logic [ 3:0] awqos;
trans_var = rand logic        awready;

trans_inc_before_class       = axi4/aw/axi4aw_trans_inc_before_class.sv    inline
driver_inc_inside_class      = axi4/aw/axi4aw_driver_inc_inside_class.sv   inline
monitor_inc_inside_class     = axi4/aw/axi4aw_monitor_inc_inside_class.sv  inline
agent_inc_inside_bfm         = axi4/aw/axi4aw_inc_inside_bfm.sv            inline
#agent_seq_inc                = axi4/aw/my_axi4aw_seq.sv                    inline

if_port = logic        clk;
if_port = logic        rst_n;
if_port = logic  [1:0] awid;
if_port = logic [31:0] awaddr;
if_port = logic [ 7:0] awlen;
if_port = logic [ 2:0] awsize;
if_port = logic [ 1:0] awburst;
if_port = logic        awlock;
if_port = logic [ 3:0] awcache;
if_port = logic [ 2:0] awprot;
if_port = logic        awvalid;
if_port = logic [ 3:0] awregion;
if_port = logic [ 3:0] awqos;
if_port = logic        awready;

if_clock = clk
if_reset = rst_n

#uvm_reg_kind = arid
#uvm_reg_addr = araddr
#uvm_reg_data = rdata

#reg_access_mode = WR
#reg_access_block_type = axi4aw_reg_block

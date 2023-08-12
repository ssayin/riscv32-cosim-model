agent_name = axi4w

number_of_instances = 1

trans_item = axi4w_tx

trans_var = rand logic [63:0] wdata;
trans_var = rand logic [ 7:0] wstrb;
trans_var = rand logic        wlast;
trans_var = rand logic        wvalid;
trans_var = rand logic        wready;

trans_inc_before_class       = axi4/w/axi4w_trans_inc_before_class.sv    inline
driver_inc_inside_class      = axi4/w/axi4w_driver_inc_inside_class.sv   inline
monitor_inc_inside_class     = axi4/w/axi4w_monitor_inc_inside_class.sv  inline
agent_inc_inside_bfm         = axi4/w/axi4w_inc_inside_bfm.sv            inline
#agent_seq_inc                = axi4/w/my_axi4w_seq.sv                    inline

if_port = logic        clk;
if_port = logic        rst_n;
if_port = logic [63:0] wdata;
if_port = logic [ 7:0] wstrb;
if_port = logic        wlast;
if_port = logic        wvalid;
if_port = logic        wready;

if_clock = clk
if_reset = rst_n

#uvm_reg_kind = arid
#uvm_reg_addr = araddr
#uvm_reg_data = rdata

#reg_access_mode = WR
#reg_access_block_type = axi4w_reg_block

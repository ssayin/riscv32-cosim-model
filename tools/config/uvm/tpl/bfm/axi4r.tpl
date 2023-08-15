agent_name = axi4r

number_of_instances = 1

trans_item = axi4r_tx

trans_var = rand logic [ 1:0] rid;
trans_var = rand logic [63:0] rdata;
trans_var = rand logic [ 1:0] rresp;
trans_var = rand logic        rlast;
trans_var = rand logic        rvalid;
trans_var = rand logic        rready;

trans_inc_before_class       = axi4/r/axi4r_trans_inc_before_class.sv    inline
driver_inc_inside_class      = axi4/r/axi4r_driver_inc_inside_class.sv   inline
monitor_inc_inside_class     = axi4/r/axi4r_monitor_inc_inside_class.sv  inline
agent_inc_inside_bfm         = axi4/r/axi4r_inc_inside_bfm.sv            inline
#agent_seq_inc                = axi4/r/my_axi4r_seq.sv                    inline

if_port = logic        clk;
if_port = logic        rst_n;
if_port = logic [ 1:0] rid;
if_port = logic [63:0] rdata;
if_port = logic [ 1:0] rresp;
if_port = logic        rlast;
if_port = logic        rvalid;
if_port = logic        rready;

if_clock = clk
if_reset = rst_n

#uvm_reg_kind = arid
#uvm_reg_addr = araddr
#uvm_reg_data = rdata

#reg_access_mode = WR
#reg_access_block_type = axi4r_reg_block

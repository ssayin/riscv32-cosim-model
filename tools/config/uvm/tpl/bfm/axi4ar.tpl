agent_name = axi4ar

number_of_instances = 1

trans_item = axi4ar_tx

trans_var = rand logic [ 1:0] arid;
trans_var = rand logic [31:0] araddr;
trans_var = rand logic [ 7:0] arlen;
trans_var = rand logic [ 2:0] arsize;
trans_var = rand logic [ 1:0] arburst;
trans_var = rand logic        arlock;
trans_var = rand logic [ 3:0] arcache;
trans_var = rand logic [ 2:0] arprot;
trans_var = rand logic        arvalid;
trans_var = rand logic [ 3:0] arqos;
trans_var = rand logic [ 3:0] arregion;
trans_var = rand logic        arready;

trans_inc_before_class       = axi4/ar/axi4ar_trans_inc_before_class.sv    inline
driver_inc_inside_class      = axi4/ar/axi4ar_driver_inc_inside_class.sv   inline
monitor_inc_inside_class     = axi4/ar/axi4ar_monitor_inc_inside_class.sv  inline
agent_inc_inside_bfm         = axi4/ar/axi4ar_inc_inside_bfm.sv            inline
#agent_seq_inc                = axi4/ar/my_axi4ar_seq.sv                    inline

if_port  = logic        clk;
if_port  = logic        rst_n;
if_port  = logic        arid;
if_port  = logic [31:0] araddr;
if_port  = logic [ 7:0] arlen;
if_port  = logic [ 2:0] arsize;
if_port  = logic [ 1:0] arburst;
if_port  = logic        arlock;
if_port  = logic [ 3:0] arcache;
if_port  = logic [ 2:0] arprot;
if_port  = logic        arvalid;
if_port  = logic [ 3:0] arqos;
if_port  = logic [ 3:0] arregion;
if_port  = logic        arready;

if_clock = clk
if_reset = rst_n

#uvm_reg_kind = arid
#uvm_reg_addr = araddr
#uvm_reg_data = rdata

#reg_access_mode = WR
#reg_access_block_type = axi4ar_reg_block

agent_name = axi4b

number_of_instances = 1

trans_item = axi4b_tx

trans_var = rand logic [1:0] bid;
trans_var = rand logic [1:0] bresp;
trans_var = rand logic       bvalid;
trans_var = rand logic       bready;

trans_inc_before_class       = axi4/b/axi4b_trans_inc_before_class.sv    inline
driver_inc_inside_class      = axi4/b/axi4b_driver_inc_inside_class.sv   inline
monitor_inc_inside_class     = axi4/b/axi4b_monitor_inc_inside_class.sv  inline
agent_inc_inside_bfm         = axi4/b/axi4b_inc_inside_bfm.sv            inline
#agent_seq_inc                = axi4/b/my_axi4b_seq.sv                    inline

if_port  = logic       clk;
if_port  = logic       rst_n;
if_port  = logic       bid;
if_port  = logic [1:0] bresp;
if_port  = logic       bvalid;
if_port  = logic       bready;

if_clock = clk
if_reset = rst_n

#uvm_reg_kind = arid
#uvm_reg_addr = araddr
#uvm_reg_data = rdata

#reg_access_mode = WR
#reg_access_block_type = axi4b_reg_block

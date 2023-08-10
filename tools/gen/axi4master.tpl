agent_name = axi4master 

number_of_instances = 1

trans_item = axi4_tx

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

trans_var = rand logic [63:0] wdata;
trans_var = rand logic [ 7:0] wstrb;
trans_var = rand logic        wlast;
trans_var = rand logic        wvalid;
trans_var = rand logic        wready;

trans_var = rand logic [1:0] bid;
trans_var = rand logic [1:0] bresp;
trans_var = rand logic       bvalid;
trans_var = rand logic       bready;

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

trans_var = rand logic [ 1:0] rid;
trans_var = rand logic [63:0] rdata;
trans_var = rand logic [ 1:0] rresp;
trans_var = rand logic        rlast;
trans_var = rand logic        rvalid;
trans_var = rand logic        rready;

trans_inc_before_class       = axi4master_trans_inc_before_class.sv    inline
driver_inc_inside_class      = axi4master_driver_inc_inside_class.sv   inline
monitor_inc_inside_class     = axi4master_monitor_inc_inside_class.sv  inline
agent_inc_inside_bfm         = axi4master_inc_inside_bfm.sv            inline

agent_seq_inc                = my_axi4master_seq.sv  inline

if_port = logic clk;
if_port = logic rst_n;

if_port = logic awid;
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

if_port = logic [63:0] wdata;
if_port = logic [ 7:0] wstrb;
if_port = logic        wlast;
if_port = logic        wvalid;
if_port = logic        wready;

if_port = logic       bid;
if_port = logic [1:0] bresp;
if_port = logic       bvalid;
if_port = logic       bready;

if_port = logic        arid;
if_port = logic [31:0] araddr;
if_port = logic [ 7:0] arlen;
if_port = logic [ 2:0] arsize;
if_port = logic [ 1:0] arburst;
if_port = logic        arlock;
if_port = logic [ 3:0] arcache;
if_port = logic [ 2:0] arprot;
if_port = logic        arvalid;
if_port = logic [ 3:0] arqos;
if_port = logic [ 3:0] arregion;
if_port = logic        arready;

if_port = logic        rid;
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
#reg_access_block_type = axi4master_reg_block

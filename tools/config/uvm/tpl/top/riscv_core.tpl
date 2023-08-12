agent_name = riscv_core 

number_of_instances = 1

trans_item = riscv_core_tx

trans_var = rand logic [63:0] rdata;

agent_inc_after_class     = riscv_core/riscv_core_inc_after_class.sv           inline

driver_inc_before_class   = riscv_core/riscv_core_driver_inc_before_class.sv   inline
driver_inc_inside_class   = riscv_core/riscv_core_driver_inc_inside_class.sv   inline
driver_inc                = riscv_core/riscv_core_do_drive.sv                  inline
monitor_inc               = riscv_core/riscv_core_do_mon.sv                    inline

agent_seq_inc             = riscv_core/my_riscv_core_seq.sv                    inline

agent_factory_set         = riscv_core_instr_feed_seq riscv_core_default_seq

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
#reg_access_block_type = riscv_core_reg_block

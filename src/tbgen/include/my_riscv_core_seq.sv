`ifndef MY_RISCV_CORE_SEQ_SV
`define MY_RISCV_CORE_SEQ_SV

class my_riscv_core_seq extends riscv_core_default_seq;

  `uvm_object_utils(my_riscv_core_seq)

  logic [31:0] mem_data_in  [2];
  logic        mem_ready;
  logic        irq_external;
  logic        irq_timer;
  logic        irq_software;
  logic [31:0] mem_data_out [2];
  logic        mem_wr_en    [2];
  logic        mem_rd_en    [2];
  logic        mem_clk_en;
  logic [31:0] mem_addr     [2];

  function new(string name = "");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "my_riscv_core_seq seq starting", UVM_HIGH)
    req = riscv_core_tx::type_id::create("req");
    start_item(req);
    if (!req.randomize()) `uvm_error(get_type_name(), "randomization failed")
    finish_item(req);
    `uvm_info(get_type_name(), "my_riscv_core_seq seq completed", UVM_HIGH)
  endtask : body

endclass : my_riscv_core_seq


`endif




`ifndef MY_RISCV_CORE_SEQ_SV
`define MY_RISCV_CORE_SEQ_SV

class my_riscv_core_seq extends riscv_core_default_seq;

  `uvm_object_utils(my_riscv_core_seq)

  function new(string name = "");
    super.new(name);
  endfunction : new

  task body();
    //`uvm_info(get_type_name(), "my_riscv_core_seq seq starting", UVM_HIGH)
    //req = riscv_core_tx::type_id::create("req");
    //start_item(req);
    //req.mem_data_in[0][31:0]  = 32'h13;
    //req.mem_data_in[1][31:0]  = 32'h0;
    //req.mem_ready             = 1;
    //req.irq_timer             = 0;
    //req.irq_external          = 0;
    //req.irq_software          = 0;
    // outputs
    //req.mem_data_out[0][31:0] = 0;
    //req.mem_data_out[1][31:0] = 0;
    //req.mem_wr_en[0]          = 0;
    //req.mem_wr_en[1]          = 0;
    //req.mem_rd_en[0]          = 1;
    //req.mem_rd_en[1]          = 0;
    //req.mem_clk_en            = 1;
    //req.mem_addr[0][31:0]     = 0;
    //req.mem_addr[1][31:0]     = 0;

    //finish_item(req);
    //`uvm_info(get_type_name(), "my_riscv_core_seq seq completed", UVM_HIGH)
  endtask : body

endclass : my_riscv_core_seq


`endif




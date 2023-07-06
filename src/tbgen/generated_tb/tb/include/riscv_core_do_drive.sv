task riscv_core_driver::do_drive();
  vif.mem_data_in[0]  = req.mem_data_in[0];
  vif.mem_ready       = req.mem_ready;
  vif.irq_external    = req.irq_external;
  vif.irq_timer       = req.irq_timer;
  vif.irq_software    = req.irq_software;
  // vif.mem_data_out[1] = req.mem_data_out[1];
  // vif.mem_wr_en[1]    = req.mem_wr_en[1];
  // vif.mem_rd_en[0]    = req.mem_rd_en[0];
  // vif.mem_rd_en[1]    = req.mem_rd_en[1];
  // vif.mem_clk_en      = req.mem_clk_en;
  // vif.mem_addr[0]     = req.mem_addr[0];
  // vif.mem_addr[1]     = req.mem_addr[1];
  @(posedge vif.clk);
endtask

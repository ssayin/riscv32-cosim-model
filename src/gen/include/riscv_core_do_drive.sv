task riscv_core_driver::do_drive();
  vif.mem_data_in[0] = req.mem_data_in[0];
  vif.mem_data_in[1] = req.mem_data_in[1];
  vif.mem_ready      = req.mem_ready;
  vif.irq_external   = req.irq_external;
  vif.irq_timer      = req.irq_timer;
  vif.irq_software   = req.irq_software;
  @(posedge vif.clk);
endtask

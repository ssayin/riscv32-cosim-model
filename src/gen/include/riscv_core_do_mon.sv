task riscv_core_monitor::do_mon;
  @(posedge vif.clk);
  m_trans.mem_data_out[1] = vif.mem_data_out[1];
  m_trans.mem_wr_en[1]    = vif.mem_wr_en[1];
  m_trans.mem_rd_en[0]    = vif.mem_rd_en[0];
  m_trans.mem_rd_en[1]    = vif.mem_rd_en[1];
  m_trans.mem_clk_en      = vif.mem_clk_en;
  m_trans.mem_addr[0]     = vif.mem_addr[0];
  m_trans.mem_addr[1]     = vif.mem_addr[1];
endtask

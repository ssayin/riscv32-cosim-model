task riscv_core_monitor::do_mon;
  forever
    @(posedge vif.clk) begin
      m_trans                 = riscv_core_tx::type_id::create("m_trans");
      m_trans.mem_data_out[1] = vif.mem_data_out[1];
      m_trans.mem_wr_en[1]    = vif.mem_wr_en[1];
      m_trans.mem_rd_en[0]    = vif.mem_rd_en[0];
      m_trans.mem_rd_en[1]    = vif.mem_rd_en[1];
      m_trans.mem_clk_en      = vif.mem_clk_en;
      m_trans.mem_addr[0]     = vif.mem_addr[0];
      m_trans.mem_addr[1]     = vif.mem_addr[1];
      analysis_port.write(m_trans);
    end
endtask

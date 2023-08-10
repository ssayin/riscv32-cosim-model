task riscv_core_monitor::do_mon;
  forever @(posedge vif.clk)
  begin
    m_trans = riscv_core_tx::type_id::create("m_trans");
    m_trans.rdata = vif.rdata;
    analysis_port.write(m_trans);
  end
endtask

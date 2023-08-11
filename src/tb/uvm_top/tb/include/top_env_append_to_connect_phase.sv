m_riscv_core_agent.m_driver.analysis_port.connect(m_ref_model.rm_export);
m_riscv_core_agent.m_monitor.analysis_port.connect(m_scoreboard.mon2sb_export);
//m_ref_model.rm2sb_port.connect(coverage.analysis_export);
m_ref_model.rm2sb_port.connect(m_scoreboard.rm2sb_export);

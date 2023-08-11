function void reference::write_reference_0(riscv_core_tx t);
  send(t);
endfunction

function void reference::send(riscv_core_tx core_tx);
  riscv_core_tx m_tx;
  m_tx = riscv_core_tx::type_id::create("m_tx");
  analysis_export_0.write(m_tx);
endfunction

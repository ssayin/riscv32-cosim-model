task run_phase(uvm_phase phase);
  vif.proxy_back_ptr = this;
  vif.run();
endtask

function void write(axi4ar_tx_s req_s);
  axi4ar_tx tx;
  tx          = axi4ar_tx::type_id::create("tx");

  tx.arid     = req_s.arid;
  tx.araddr   = req_s.araddr;
  tx.arlen    = req_s.arlen;
  tx.arsize   = req_s.arsize;
  tx.arburst  = req_s.arburst;
  tx.arlock   = req_s.arlock;
  tx.arcache  = req_s.arcache;
  tx.arprot   = req_s.arprot;
  tx.arvalid  = req_s.arvalid;
  tx.arqos    = req_s.arqos;
  tx.arregion = req_s.arregion;
  tx.arready  = req_s.arready;

   analysis_port.write(tx);
endfunction

task run_phase(uvm_phase phase);
  vif.proxy_back_ptr = this;
  vif.run();
endtask

function void write(axi4aw_tx_s req_s);
  axi4aw_tx tx;

  tx          = axi4aw_tx::type_id::create("tx");
  tx.awid     = req_s.awid;
  tx.awaddr   = req_s.awaddr;
  tx.awlen    = req_s.awlen;
  tx.awsize   = req_s.awsize;
  tx.awburst  = req_s.awburst;
  tx.awlock   = req_s.awlock;
  tx.awcache  = req_s.awcache;
  tx.awprot   = req_s.awprot;
  tx.awvalid  = req_s.awvalid;
  tx.awregion = req_s.awregion;
  tx.awqos    = req_s.awqos;
  tx.awready  = req_s.awready;

  analysis_port.write(tx);
endfunction

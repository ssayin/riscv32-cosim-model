task run_phase(uvm_phase phase);
  vif.proxy_back_ptr = this;
  vif.run();
endtask

function void write(axi4r_tx_s req_s);
  axi4r_tx tx;
  tx          = axi4r_tx::type_id::create("tx");
  tx.rid      = req_s.rid;
  tx.rdata    = req_s.rdata;
  tx.rresp    = req_s.rresp;
  tx.rlast    = req_s.rlast;
  tx.rvalid   = req_s.rvalid;
  tx.rready   = req_s.rready;
  analysis_port.write(tx);
endfunction

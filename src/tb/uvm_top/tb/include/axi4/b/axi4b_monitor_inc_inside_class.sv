task run_phase(uvm_phase phase);
  vif.proxy_back_ptr = this;
  vif.run();
endtask

function void write(axi4b_tx_s req_s);
  axi4b_tx tx;
  tx          = axi4b_tx::type_id::create("tx");

  tx.bid      = req_s.bid;
  tx.bresp    = req_s.bresp;
  tx.bvalid   = req_s.bvalid;
  tx.bready   = req_s.bready;

   analysis_port.write(tx);
endfunction

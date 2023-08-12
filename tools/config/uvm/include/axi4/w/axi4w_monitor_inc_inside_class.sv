task run_phase(uvm_phase phase);
  vif.proxy_back_ptr = this;
  vif.run();
endtask

function void write(axi4w_tx_s req_s);
  axi4w_tx tx;
  tx          = axi4w_tx::type_id::create("tx");

  tx.wdata    = req_s.wdata;
  tx.wstrb    = req_s.wstrb;
  tx.wlast    = req_s.wlast;
  tx.wvalid   = req_s.wvalid;
  tx.wready   = req_s.wready;

  analysis_port.write(tx);
endfunction

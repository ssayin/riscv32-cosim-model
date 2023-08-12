task run_phase(uvm_phase phase);
  forever begin
    axi4b_tx_s req_s;
    seq_item_port.get_next_item(req);

    req_s.bid      = req.bid;
    req_s.bresp    = req.bresp;
    req_s.bvalid   = req.bvalid;
    req_s.bready   = req.bready;

    vif.drive(req_s);

    seq_item_port.item_done();
  end
endtask : run_phase

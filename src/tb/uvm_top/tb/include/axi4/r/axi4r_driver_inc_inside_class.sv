task run_phase(uvm_phase phase);
  forever begin
    axi4r_tx_s req_s;
    seq_item_port.get_next_item(req);

    req_s.rid      = req.rid;
    req_s.rdata    = req.rdata;
    req_s.rresp    = req.rresp;
    req_s.rlast    = req.rlast;
    req_s.rvalid   = req.rvalid;
    req_s.rready   = req.rready;

    vif.drive(req_s);

    seq_item_port.item_done();
  end
endtask : run_phase

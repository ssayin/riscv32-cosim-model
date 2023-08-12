task run_phase(uvm_phase phase);
  forever begin
    axi4w_tx_s req_s;
    seq_item_port.get_next_item(req);

    req_s.wdata    = req.wdata;
    req_s.wstrb    = req.wstrb;
    req_s.wlast    = req.wlast;
    req_s.wvalid   = req.wvalid;
    req_s.wready   = req.wready;

    vif.drive(req_s);

    seq_item_port.item_done();
  end
endtask : run_phase

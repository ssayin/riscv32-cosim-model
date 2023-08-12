task run_phase(uvm_phase phase);
  forever begin
    axi4ar_tx_s req_s;
    seq_item_port.get_next_item(req);

    req_s.arid     = req.arid;
    req_s.araddr   = req.araddr;
    req_s.arlen    = req.arlen;
    req_s.arsize   = req.arsize;
    req_s.arburst  = req.arburst;
    req_s.arlock   = req.arlock;
    req_s.arcache  = req.arcache;
    req_s.arprot   = req.arprot;
    req_s.arvalid  = req.arvalid;
    req_s.arqos    = req.arqos;
    req_s.arregion = req.arregion;
    req_s.arready  = req.arready;

    vif.drive(req_s);

    seq_item_port.item_done();
  end
endtask : run_phase

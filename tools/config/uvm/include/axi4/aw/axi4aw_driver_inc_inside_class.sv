task run_phase(uvm_phase phase);
  forever begin
    axi4aw_tx_s req_s;
    seq_item_port.get_next_item(req);

    req_s.awid     = req.awid;
    req_s.awaddr   = req.awaddr;
    req_s.awlen    = req.awlen;
    req_s.awsize   = req.awsize;
    req_s.awburst  = req.awburst;
    req_s.awlock   = req.awlock;
    req_s.awcache  = req.awcache;
    req_s.awprot   = req.awprot;
    req_s.awvalid  = req.awvalid;
    req_s.awregion = req.awregion;
    req_s.awqos    = req.awqos;
    req_s.awready  = req.awready;

    vif.drive(req_s);

    seq_item_port.item_done();
  end
endtask : run_phase

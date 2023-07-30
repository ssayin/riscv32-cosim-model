`ifndef MY_BUSF_SEQ_SV
`define MY_BUSF_SEQ_SV

class my_busf_seq extends busf_default_seq;

  `uvm_object_utils(my_busf_seq)

  function new(string name = "");
    super.new(name);
  endfunction : new

  axi4_tx req;

  task body();
    req = axi4_tx::type_id::create("req");
    start_item(req);
    req.awid     = 0;
    req.awaddr   = 0;
    req.awlen    = 0;
    req.awsize   = 0;
    req.awburst  = 0;
    req.awlock   = 0;
    req.awcache  = 0;
    req.awprot   = 0;
    req.awvalid  = 0;
    req.awregion = 0;
    req.awqos    = 0;
    req.awready  = 0;

    req.wdata    = 0;
    req.wstrb    = 0;
    req.wlast    = 0;
    req.wvalid   = 0;
    req.wready   = 0;

    req.bid      = 0;
    req.bresp    = 0;
    req.bvalid   = 0;
    req.bready   = 0;

    req.arid     = 0;
    req.araddr   = 0;
    req.arlen    = 0;
    req.arsize   = 0;
    req.arburst  = 0;
    req.arlock   = 0;
    req.arcache  = 0;
    req.arprot   = 0;
    req.arvalid  = 0;
    req.arqos    = 0;
    req.arregion = 0;
    req.arready  = 1;

    req.rid      = 0;
    req.rdata    = 64'h32;
    req.rresp    = 0;
    req.rlast    = 0;
    req.rvalid   = 1;
    req.rready   = 0;
    finish_item(req);
  endtask : body

endclass


`endif




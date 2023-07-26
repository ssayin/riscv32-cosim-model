task drive(axi4_tx_s req_s);
  if_port.awid     <= req_s.awid;
  if_port.awaddr   <= req_s.awaddr;
  if_port.awlen    <= req_s.awlen;
  if_port.awsize   <= req_s.awsize;
  if_port.awburst  <= req_s.awburst;
  if_port.awlock   <= req_s.awlock;
  if_port.awcache  <= req_s.awcache;
  if_port.awprot   <= req_s.awprot;
  if_port.awvalid  <= req_s.awvalid;
  if_port.awregion <= req_s.awregion;
  if_port.awqos    <= req_s.awqos;
  if_port.awready  <= req_s.awready;

  if_port.wdata    <= req_s.wdata;
  if_port.wstrb    <= req_s.wstrb;
  if_port.wlast    <= req_s.wlast;
  if_port.wvalid   <= req_s.wvalid;
  if_port.wready   <= req_s.wready;

  if_port.bid      <= req_s.bid;
  if_port.bresp    <= req_s.bresp;
  if_port.bvalid   <= req_s.bvalid;
  if_port.bready   <= req_s.bready;

  if_port.arid     <= req_s.arid;
  if_port.araddr   <= req_s.araddr;
  if_port.arlen    <= req_s.arlen;
  if_port.arsize   <= req_s.arsize;
  if_port.arburst  <= req_s.arburst;
  if_port.arlock   <= req_s.arlock;
  if_port.arcache  <= req_s.arcache;
  if_port.arprot   <= req_s.arprot;
  if_port.arvalid  <= req_s.arvalid;
  if_port.arqos    <= req_s.arqos;
  if_port.arregion <= req_s.arregion;
  if_port.arready  <= req_s.arready;

  if_port.rid      <= req_s.rid;
  if_port.rdata    <= req_s.rdata;
  if_port.rresp    <= req_s.rresp;
  if_port.rlast    <= req_s.rlast;
  if_port.rvalid   <= req_s.rvalid;
  if_port.rready   <= req_s.rready;
  @(posedge if_port.clk);
endtask

import busm_pkg::busm_monitor;
busm_monitor proxy_back_ptr;

task run;
  forever begin
    axi4_tx_s req_s;
    @(posedge if_port.clk);
    req_s.awid     = if_port.awid;
    req_s.awaddr   = if_port.awaddr;
    req_s.awlen    = if_port.awlen;
    req_s.awsize   = if_port.awsize;
    req_s.awburst  = if_port.awburst;
    req_s.awlock   = if_port.awlock;
    req_s.awcache  = if_port.awcache;
    req_s.awprot   = if_port.awprot;
    req_s.awvalid  = if_port.awvalid;
    req_s.awregion = if_port.awregion;
    req_s.awqos    = if_port.awqos;
    req_s.awready  = if_port.awready;

    req_s.wdata    = if_port.wdata;
    req_s.wstrb    = if_port.wstrb;
    req_s.wlast    = if_port.wlast;
    req_s.wvalid   = if_port.wvalid;
    req_s.wready   = if_port.wready;

    req_s.bid      = if_port.bid;
    req_s.bresp    = if_port.bresp;
    req_s.bvalid   = if_port.bvalid;
    req_s.bready   = if_port.bready;

    req_s.arid     = if_port.arid;
    req_s.araddr   = if_port.araddr;
    req_s.arlen    = if_port.arlen;
    req_s.arsize   = if_port.arsize;
    req_s.arburst  = if_port.arburst;
    req_s.arlock   = if_port.arlock;
    req_s.arcache  = if_port.arcache;
    req_s.arprot   = if_port.arprot;
    req_s.arvalid  = if_port.arvalid;
    req_s.arqos    = if_port.arqos;
    req_s.arregion = if_port.arregion;
    req_s.arready  = if_port.arready;

    req_s.rid      = if_port.rid;
    req_s.rdata    = if_port.rdata;
    req_s.rresp    = if_port.rresp;
    req_s.rlast    = if_port.rlast;
    req_s.rvalid   = if_port.rvalid;
    req_s.rready   = if_port.rready;

    proxy_back_ptr.write(req_s);
  end
endtask

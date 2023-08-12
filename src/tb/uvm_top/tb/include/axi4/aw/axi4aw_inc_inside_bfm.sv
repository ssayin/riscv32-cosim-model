task drive(axi4aw_tx_s req_s);
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

   @(posedge if_port.clk);
endtask

import axi4aw_pkg::axi4aw_monitor;
axi4aw_monitor proxy_back_ptr;

task run;
  forever begin
    axi4aw_tx_s req_s;
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

    proxy_back_ptr.write(req_s);
  end
endtask

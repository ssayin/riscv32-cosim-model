task drive(axi4r_tx_s req_s);
  if_port.rid      <= req_s.rid;
  if_port.rdata    <= req_s.rdata;
  if_port.rresp    <= req_s.rresp;
  if_port.rlast    <= req_s.rlast;
  if_port.rvalid   <= req_s.rvalid;
  if_port.rready   <= req_s.rready;
  @(posedge if_port.clk);
endtask

import axi4r_pkg::axi4r_monitor;
axi4r_monitor proxy_back_ptr;

task run;
  forever begin
    axi4r_tx_s req_s;
    @(posedge if_port.clk);
    req_s.rid      = if_port.rid;
    req_s.rdata    = if_port.rdata;
    req_s.rresp    = if_port.rresp;
    req_s.rlast    = if_port.rlast;
    req_s.rvalid   = if_port.rvalid;
    req_s.rready   = if_port.rready;
    proxy_back_ptr.write(req_s);
  end
endtask

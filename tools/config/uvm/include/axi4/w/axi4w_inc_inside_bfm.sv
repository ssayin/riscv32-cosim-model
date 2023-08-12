task drive(axi4w_tx_s req_s);

  if_port.wdata    <= req_s.wdata;
  if_port.wstrb    <= req_s.wstrb;
  if_port.wlast    <= req_s.wlast;
  if_port.wvalid   <= req_s.wvalid;
  if_port.wready   <= req_s.wready;

  @(posedge if_port.clk);
endtask

import axi4w_pkg::axi4w_monitor;
axi4w_monitor proxy_back_ptr;

task run;
  forever begin
    axi4w_tx_s req_s;
    @(posedge if_port.clk);
 
    req_s.wdata    = if_port.wdata;
    req_s.wstrb    = if_port.wstrb;
    req_s.wlast    = if_port.wlast;
    req_s.wvalid   = if_port.wvalid;
    req_s.wready   = if_port.wready;

    proxy_back_ptr.write(req_s);
  end
endtask

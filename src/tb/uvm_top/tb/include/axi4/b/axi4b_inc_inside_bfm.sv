task drive(axi4b_tx_s req_s);

  if_port.bid      <= req_s.bid;
  if_port.bresp    <= req_s.bresp;
  if_port.bvalid   <= req_s.bvalid;
  if_port.bready   <= req_s.bready;

  @(posedge if_port.clk);
endtask

import axi4b_pkg::axi4b_monitor;
axi4b_monitor proxy_back_ptr;

task run;
  forever begin
    axi4b_tx_s req_s;
    @(posedge if_port.clk);
  
    req_s.bid      = if_port.bid;
    req_s.bresp    = if_port.bresp;
    req_s.bvalid   = if_port.bvalid;
    req_s.bready   = if_port.bready;

    proxy_back_ptr.write(req_s);
  end
endtask

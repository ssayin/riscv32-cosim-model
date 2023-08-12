task drive(axi4ar_tx_s req_s);

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

  @(posedge if_port.clk);
endtask

import axi4ar_pkg::axi4ar_monitor;
axi4ar_monitor proxy_back_ptr;

task run;
  forever begin
    axi4ar_tx_s req_s;
    @(posedge if_port.clk);

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

    proxy_back_ptr.write(req_s);
  end
endtask

function uvm_sequence_item reg2axi4aw_adapter::reg2bus(const ref uvm_reg_bus_op rw);
  axi4aw_tx axi4 = axi4aw_tx::type_id::create("axi4");

  axi4.rid    = (rw.kind == UVM_READ) ? 0 : 1;
  axi4.araddr = rw.addr;
  axi4.rdata  = rw.data;
  assert (axi4.araddr == 0);
  `uvm_info(get_type_name(), $sformatf("reg2bus rw::kind: %s, addr: %d, data: %h, status: %s", rw.kind, rw.addr, rw.data, rw.status), UVM_HIGH)
  $finish;
  return axi4;
endfunction : reg2bus


function void reg2axi4aw_adapter::bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
  axi4aw_tx axi4;
  if (!$cast(axi4, bus_item)) `uvm_fatal(get_type_name(), "Provided bus_item is not of the correct type")
  rw.kind   = axi4.rid ? UVM_WRITE : UVM_READ;
  rw.addr   = axi4.araddr;
  rw.data   = axi4.rdata;
  rw.status = UVM_IS_OK;
  assert (axi4.araddr == 0);
  $finish;
  `uvm_info(get_type_name(), $sformatf("bus2reg rw::kind: %s, addr: %d, data: %h, status: %s", rw.kind, rw.addr, rw.data, rw.status), UVM_HIGH)
endfunction : bus2reg

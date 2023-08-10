function uvm_sequence_item reg2axi4master_adapter::reg2bus(const ref uvm_reg_bus_op rw);
  axi4_tx axi4master = axi4_tx::type_id::create("axi4master");

  axi4master.rid    = (rw.kind == UVM_READ) ? 0 : 1;
  axi4master.araddr = rw.addr;
  axi4master.rdata  = rw.data;
  assert (axi4master.araddr == 0);
  `uvm_info(get_type_name(), $sformatf("reg2bus rw::kind: %s, addr: %d, data: %h, status: %s", rw.kind, rw.addr, rw.data, rw.status), UVM_HIGH)
  $finish;
  return axi4master;
endfunction : reg2bus


function void reg2axi4master_adapter::bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
  axi4_tx axi4master;
  if (!$cast(axi4master, bus_item)) `uvm_fatal(get_type_name(), "Provided bus_item is not of the correct type")
  rw.kind   = axi4master.rid ? UVM_WRITE : UVM_READ;
  rw.addr   = axi4master.araddr;
  rw.data   = axi4master.rdata;
  rw.status = UVM_IS_OK;
  assert (axi4master.araddr == 0);
  $finish;
  `uvm_info(get_type_name(), $sformatf("bus2reg rw::kind: %s, addr: %d, data: %h, status: %s", rw.kind, rw.addr, rw.data, rw.status), UVM_HIGH)
endfunction : bus2reg

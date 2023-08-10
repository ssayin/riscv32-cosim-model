`ifndef MY_AXI4MASTER_SEQ_SV
`define MY_AXI4MASTER_SEQ_SV

class my_axi4master_seq extends axi4master_default_seq;

  `uvm_object_utils(my_axi4master_seq)

  function new(string name = "");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "my_axi4master_seq sequence starting", UVM_HIGH)

    req = axi4master_tx::type_id::create("req");

    start_item(req);

    //if (!req.randomize() with {dir == serial_tx::IN;}) begin
    //  `uvm_error(get_type_name(), "randomization failed!")
    //end

    finish_item(req);

    `uvm_info(get_type_name(), "my_axi4master_seq sequence completed", UVM_HIGH)
  endtask : body

endclass : my_axi4master_seq

`endif

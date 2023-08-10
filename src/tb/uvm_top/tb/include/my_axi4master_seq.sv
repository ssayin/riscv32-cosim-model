`ifndef MY_AXI4MASTER_SEQ_SV
`define MY_AXI4MASTER_SEQ_SV

class axi4master_hex_seq extends axi4master_default_seq;

  `uvm_object_utils(axi4master_hex_seq)

  function new(string name = "axi4master_hex_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "axi4master_hex_seq sequence starting", UVM_HIGH)

    req = axi4_tx::type_id::create("req");

    start_item(req);

    assert (req.randomize() with {rid == 2'b00;});

    finish_item(req);

    `uvm_info(get_type_name(), "axi4master_hex_seq sequence completed", UVM_HIGH)
  endtask : body
endclass : axi4master_hex_seq

class axi4master_instr_feed_seq extends axi4master_default_seq;

  `uvm_object_utils(axi4master_instr_feed_seq)

  int          fd;
  logic [31:0] data[2];

  function new(string name = "axi4master_instr_feed_seq");
    super.new(name);
    fd = $fopen(`INSTR_SEQ_FILENAME, "r");
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "axi4master_instr_feed_seq sequence starting", UVM_HIGH)


    for (int i = 0; i < `INSTR_SEQ_LINECOUNT / 2; ++i) begin
      req = axi4_tx::type_id::create("req");

      // TODO: fix endian
      for (int i = 0; i < 2; i++) begin
        $fscanf(fd, "%d", data[i]);
      end

      start_item(req);

      assert (req.randomize() with {rid == 2'b00;});
      for (int i = 0; i < 2; i++) begin
        // TODO: fix endian
        req.rdata[i] = data[i];
      end

      finish_item(req);
    end

    $fclose(fd);
    `uvm_info(get_type_name(), "axi4master_instr_feed_seq sequence completed", UVM_HIGH)
  endtask : body

endclass : axi4master_instr_feed_seq

`endif

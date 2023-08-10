`ifndef MY_AXI4MASTER_SEQ_SV
`define MY_AXI4MASTER_SEQ_SV

class axi4master_hex_seq extends axi4master_default_seq;

  `uvm_object_utils(axi4master_hex_seq)

  bit [7:0] data[1024];

  function new(string name = "axi4master_hex_seq");
    super.new(name);
    $readmemh(`HEX_FILENAME, data);
  endfunction : new

  task body();

    for (int i = 0; i < 1024; i = i + 8) begin
      req = axi4_tx::type_id::create("req");

      `uvm_info(get_type_name(), "axi4master_hex_seq sequence starting", UVM_HIGH)
      start_item(req);

      assert (req.randomize() with {rid == 2'b00;});

      req.rdata[63:0] = {{data[i][7:0], data[i+1][7:0], data[i+2][7:0], data[i+3][7:0], data[i+4][7:0], data[i+5][7:0], data[i+6][7:0], data[i+7][7:0]}};

      finish_item(req);
      `uvm_info(get_type_name(), "axi4master_hex_seq sequence completed", UVM_HIGH)
    end

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

    for (int i = 0; i < `INSTR_SEQ_LINECOUNT; i = i + 2) begin
      `uvm_info(get_type_name(), "axi4master_instr_feed_seq sequence starting", UVM_HIGH)
      req = axi4_tx::type_id::create("req");

      // TODO: fix endian
      for (int j = 0; j < 2; j++) begin
        $fscanf(fd, "%d", data[j]);
      end

      start_item(req);

      assert (req.randomize() with {rid == 2'b00;});
      for (int j = 0; j < 2; j++) begin
        // TODO: fix endian
        req.rdata[63:32] = data[j];
        req.rdata[31:0]  = data[j+1];
      end

      finish_item(req);
      `uvm_info(get_type_name(), "axi4master_instr_feed_seq sequence completed", UVM_HIGH)
    end

    $fclose(fd);
  endtask : body

endclass : axi4master_instr_feed_seq

`endif

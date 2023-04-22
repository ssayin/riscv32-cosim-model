`ifndef DEC_DECODE_INSTR_SEQ_FROM_FILE
`define DEC_DECODE_INSTR_SEQ_FROM_FILE

class dec_decode_instr_seq_from_file extends uvm_sequence #(dec_decode_transaction);

  `uvm_object_utils(dec_decode_instr_seq_from_file)

  int fd;

  function new(string name = "dec_decode_instr_seq_from_file");
    super.new(name);
    fd = $fopen(`INSTR_SEQ_FILENAME, "r");
  endfunction : new

  virtual task body();
    for (int i = 0; i < `INSTR_SEQ_LINECOUNT; ++i) begin
      logic [31:0] instr;
      $fscanf(fd, "%d", instr);
      req = dec_decode_transaction::type_id::create("req");
      start_item(req);
      req.dec_in.instr = instr;
      req.dec_in.pc_in = 0;  // set 0 for this seq
      finish_item(req);
      get_response(rsp);
    end
    $fclose(fd);
  endtask : body
endclass

`endif

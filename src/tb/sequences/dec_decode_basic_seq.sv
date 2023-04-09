`ifndef DEC_DECODE_BASIC_SEQ
`define DEC_DECODE_BASIC_SEQ

class dec_decode_basic_seq extends uvm_sequence #(dec_decode_transaction);

  `uvm_object_utils(dec_decode_basic_seq)

  function new(string name = "dec_decode_basic_seq");
    super.new(name);
  endfunction : new

  virtual task body();

    for (int i = 0; i < 1000; i++) begin

      req = dec_decode_transaction::type_id::create("req");

      start_item(req);

      assert (req.randomize());

      `uvm_info(get_full_name(), $sformatf("RANDOMIZED TRANSACTION FROM SEQUENCE"), UVM_LOW);

      // req.print();
      finish_item(req);
      get_response(rsp);
    end

  endtask : body

endclass : dec_decode_basic_seq


`endif

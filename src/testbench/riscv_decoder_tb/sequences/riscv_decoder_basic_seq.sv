`ifndef RISCV_DECODER_BASIC_SEQ
`define RISCV_DECODER_BASIC_SEQ

class riscv_decoder_basic_seq extends uvm_sequence #(riscv_decoder_transaction);

  `uvm_object_utils(riscv_decoder_basic_seq)

  function new(string name = "riscv_decoder_basic_seq");
    super.new(name);
  endfunction : new

  virtual task body();

    for (int i = 0; i < 100; i++) begin

      req = riscv_decoder_transaction::type_id::create("req");

      start_item(req);

      assert (req.randomize());

      `uvm_info(get_full_name(), $sformatf("RANDOMIZED TRANSACTION FROM SEQUENCE"), UVM_LOW);

      // req.print();
      finish_item(req);
      get_response(rsp);
    end

  endtask : body

endclass : riscv_decoder_basic_seq


`endif

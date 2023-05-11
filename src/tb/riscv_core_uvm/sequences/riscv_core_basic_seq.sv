// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_CORE_BASIC_SEQ
`define RISCV_CORE_BASIC_SEQ

class riscv_core_basic_seq extends uvm_sequence #(riscv_core_transaction);

  `uvm_object_utils(riscv_core_basic_seq)

  function new(string name = "riscv_core_basic_seq");
    super.new(name);
  endfunction : new

  virtual task body();

    for (int i = 0; i < 100; i++) begin

      req = riscv_core_transaction::type_id::create("req");

      start_item(req);

      assert (req.randomize());

      `uvm_info(get_full_name(), $sformatf("RANDOMIZED TRANSACTION FROM SEQUENCE"), UVM_LOW);

      // req.print();
      finish_item(req);
      get_response(rsp);
    end

  endtask : body

endclass : riscv_core_basic_seq


`endif

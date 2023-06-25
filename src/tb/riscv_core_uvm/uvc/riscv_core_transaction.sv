// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_CORE_TRANSACTION
`define RISCV_CORE_TRANSACTION

class riscv_core_transaction extends uvm_sequence_item;

  function new(string name = "riscv_core_transaction");
    super.new(name);
  endfunction : new

  function void post_randomize();
  endfunction : post_randomize


  function bit compare(uvm_object rhs);

    riscv_core_transaction rhs_trans;

    if (!$cast(rhs_trans, rhs)) begin
      `uvm_error(get_full_name(), "Failed to cast rhs to riscv_core_transaction");
      return 0;
    end
    return 1;

  endfunction : compare

endclass : riscv_core_transaction

`endif

// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_CORE_INSTR_SEQ_FROM_FILE
`define RISCV_CORE_INSTR_SEQ_FROM_FILE

class riscv_core_instr_seq_from_file extends uvm_sequence #(riscv_core_transaction);

  `uvm_object_utils(riscv_core_instr_seq_from_file)

  int fd;

  function new(string name = "riscv_core_instr_seq_from_file");
    super.new(name);
    fd = $fopen(`INSTR_SEQ_FILENAME, "r");
  endfunction : new

  virtual task body();
    for (int i = 0; i < `INSTR_SEQ_LINECOUNT; ++i) begin
      logic [31:0] instr;
      $fscanf(fd, "%d", instr);
      req = riscv_core_transaction::type_id::create("req");
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

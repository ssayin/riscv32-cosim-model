// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_DECODER_INSTR_SEQ_FROM_FILE
`define RISCV_DECODER_INSTR_SEQ_FROM_FILE

class riscv_decoder_instr_seq_from_file extends uvm_sequence #(riscv_decoder_transaction);

  `uvm_object_utils(riscv_decoder_instr_seq_from_file)

  int fd;
  string filename = "build/data/amalgamated.txt";

  function new(string name = "riscv_decoder_instr_seq_from_file");
    super.new(name);
    fd = $fopen(filename, "r");
  endfunction : new

  virtual task body();
    int i = 0;
    while (!$feof(
        fd
    )) begin
      logic [31:0] instr;
      $fscanf(fd, "%d", instr);
      req = riscv_decoder_transaction::type_id::create("req");
      start_item(req);
      req.dec_in.instr = instr;
      req.dec_in.pc_in = 0;  // set 0 for this seq
      finish_item(req);
      get_response(rsp);
      i = i + 1;
    end
    $fclose(fd);
  endtask : body
endclass

`endif

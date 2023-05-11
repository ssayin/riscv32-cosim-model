// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_DECODER_IF
`define RISCV_DECODER_IF

interface riscv_decoder_if
  import svdpi_pkg::decoder_in_t;
  import svdpi_pkg::decoder_out_t;
(
  input logic clk,
  input logic rst_n
);

  decoder_in_t  dec_in;
  decoder_out_t dec_out;

  clocking dr_cb @(posedge clk);
    output dec_in;
    input dec_out;
  endclocking : dr_cb


  modport DRV(clocking dr_cb, input clk, input rst_n);

  clocking rc_cb @(negedge clk);
    input dec_in;
    input dec_out;
  endclocking : rc_cb


  modport RCV(clocking rc_cb, input clk, input rst_n);

endinterface : riscv_decoder_if

`endif

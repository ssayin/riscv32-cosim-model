// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

interface if_stage_if (
  input logic clk
);
  logic [31:0] instr;
  logic [31:0] pc;

  clocking dr_cb @(posedge clk);
    output dec_in;
    input dec_out;
  endclocking : dr_cb


  modport DRV(clocking dr_cb, input clk, reset);

  clocking rc_cb @(negedge clk);
    input dec_in;
    input dec_out;
  endclocking : rc_cb


  modport RCV(clocking rc_cb, input clk, reset);
endinterface : if_stage_if


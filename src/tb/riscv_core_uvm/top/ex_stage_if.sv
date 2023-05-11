// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

interface ex_stage_if (
  input logic clk,
  input logic rst_n
);
  logic [31:0] rs1_data, rs2_data, imm;
  logic       use_imm;
  logic [2:0] alu_op;

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
endinterface : ex_stage_if


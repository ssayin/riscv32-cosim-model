// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns / 1ps

module tb_top_level;

  logic clk;
  logic rst_n;

  top_level top_level_0 (.*);

  initial clk = 0;
  initial rst_n = 0;

  integer i;

  initial begin
    #50 rst_n = 1;
    #50 rst_n = 0;
    #50 rst_n = 1;
  end

  initial begin
    for (i = 0; i < 100; i++) begin
      #10 clk = ~clk;
    end
    $finish;
  end

  initial begin
    $dumpfile("tb_top_level.vcd");
    $dumpvars(0, tb_top_level);
  end

endmodule

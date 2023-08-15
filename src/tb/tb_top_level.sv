// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns / 1ps

module tb_top_level;

  logic clk;
  logic clk0;
  logic clk1;
  logic rst_n;

  initial clk = 0;
  initial clk0 = 0;
  initial clk1 = 0;
  initial rst_n = 0;
  integer i;

  logic   PIN_133;
  logic   PIN_135;
  logic   PIN_136;
  logic   PIN_137;
  logic   PIN_128;
  logic   PIN_121;
  logic   PIN_125;
  logic   PIN_129;
  logic   PIN_132;
  logic   PIN_126;
  logic   PIN_124;
  logic   PIN_127;
  logic   PIN_114;
  logic   PIN_115;
  logic   PIN_87;
  logic   PIN_86;
  logic   PIN_85;
  logic   PIN_84;


  fpga_top top_level_0 (.*);

  initial begin
    #10 rst_n = 0;
    #70 rst_n = 1;
  end

`ifdef DUMPVCD
  initial $dumpvars(0, tb_top_level);
`endif

  initial begin
    for (i = 0; i < 400; i++) begin
      #30;
      clk  = ~clk;
      clk0 = ~clk0;
      clk1 = ~clk1;
    end
  end

endmodule

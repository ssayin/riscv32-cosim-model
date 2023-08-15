// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

// USE AT YOUR OWN RISK

module fpga_top (
`ifdef DEBUG
  clk0,
  clk1,
`endif
  clk,
  rst_n,
  /*  PIN_133,
  PIN_135,
  PIN_136,
  PIN_137,
  PIN_128,
  PIN_121,
  PIN_125,
  PIN_129,
  PIN_132,
  PIN_126,
  PIN_124,
  PIN_127,
  PIN_114,
  PIN_115,
  PIN_87,
  PIN_86,
  */
  PIN_85,
  PIN_84
);

  input logic clk;
  input logic rst_n;

`ifndef DEBUG
  logic clk0;
  logic clk1;
`else
  input logic clk0;
  input logic clk1;
`endif

  //  output logic PIN_133;
  //  output logic PIN_135;
  //  output logic PIN_136;
  //  output logic PIN_137;
  //  output logic PIN_128;
  //  output logic PIN_121;
  //  output logic PIN_125;
  //  output logic PIN_129;
  //  output logic PIN_132;
  //  output logic PIN_126;
  //  output logic PIN_124;
  //  output logic PIN_127;
  //  output logic PIN_114;
  //  output logic PIN_115;
  // output logic PIN_87;
  //  output logic PIN_86;
  output logic PIN_85;
  output logic PIN_84;

  // BRAM PORT A
  logic        clka;
  logic        rsta;
  logic        ena;
  logic        rdena;
  logic        wrena;
  logic [ 7:0] byteena;
  logic [ 9:0] addra;
  logic [63:0] dina;
  logic [63:0] douta;
  // BRAM PORT B
  logic        clkb;
  logic        rstb;
  logic        enb;
  logic        rdenb;
  logic        wrenb;
  logic [ 7:0] byteenb;
  logic [ 9:0] addrb;
  logic [63:0] dinb;
  logic [63:0] doutb;

  assign PIN_84 = doutb[6];
  assign PIN_85 = douta[8];

`ifndef DEBUG
  pll pll_0 (
    .inclk0(clk),
    .c0    (clk0),
    .c1    (clk1)
  );
`endif

  // ATTENTION
  // FOR THE TIME BEING
  // SLAVE CLOCKS MUST BE SYNCHRONIZED WITH THE MASTER
  ssram ssram_0 (
    .clka(clk0),
    .clkb(clk1),
    .rsta(~rst_n),
    .rstb(~rst_n),
    .*
  );

  top_level top_level_0 (.*);

endmodule

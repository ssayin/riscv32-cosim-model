// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module sled (
  output logic [7:0] seg,
  output logic [3:0] dig,
  input  logic       clk
);
  reg [ 3:0] disp_dat;
  reg [36:0] count;

  always @(posedge clk) begin
    count = count + 1'b1;
    dig   = 4'b0000;
  end

  always @(count[24]) begin
    disp_dat = {count[28:25]};
  end

  always @(disp_dat) begin
    case (disp_dat)
      4'h0:    seg = 8'hc0;
      4'h1:    seg = 8'hf9;
      4'h2:    seg = 8'ha4;
      4'h3:    seg = 8'hb0;
      4'h4:    seg = 8'h99;
      4'h5:    seg = 8'h92;
      4'h6:    seg = 8'h82;
      4'h7:    seg = 8'hf8;
      4'h8:    seg = 8'h80;
      4'h9:    seg = 8'h90;
      4'ha:    seg = 8'h88;
      4'hb:    seg = 8'h83;
      4'hc:    seg = 8'hc6;
      4'hd:    seg = 8'ha1;
      4'he:    seg = 8'h86;
      4'hf:    seg = 8'h8e;
      default: seg = 8'hc0;
    endcase
  end
endmodule

module uart_test (
  clk,
  rst_n,
  PIN_133,
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
  PIN_127
  //PIN_114,
  //PIN_115,
  //PIN_87,
  //PIN_86,
  //PIN_85,
  //PIN_84
);

  input logic clk;
  input logic rst_n;

  logic       clk0;
  logic       clk1;

  logic [7:0] seg;
  logic [3:0] dig;


  output logic PIN_133;
  output logic PIN_135;
  output logic PIN_136;
  output logic PIN_137;
  output logic PIN_128;
  output logic PIN_121;
  output logic PIN_125;
  output logic PIN_129;
  output logic PIN_132;
  output logic PIN_126;
  output logic PIN_124;
  output logic PIN_127;


  assign PIN_133 = dig[0];
  assign PIN_135 = dig[1];
  assign PIN_136 = dig[2];
  assign PIN_137 = dig[3];

  assign PIN_128 = seg[0];
  assign PIN_121 = seg[1];
  assign PIN_125 = seg[2];
  assign PIN_129 = seg[3];
  assign PIN_132 = seg[4];
  assign PIN_126 = seg[5];
  assign PIN_124 = seg[6];
  assign PIN_127 = seg[7];

  /* output logic PIN_114;
  output logic PIN_115;
  output logic PIN_87;
  output logic PIN_86;
  output logic PIN_85;
  output logic PIN_84;
  */


  logic        penable;
  logic        paddr;
  logic        pwrite;
  logic        psel;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic        pready;

  uart_apb uart_0 (.*);

  pll pll_0 (
    .inclk0(clk),
    .c0    (clk0),
    .c1    (clk1)
  );

  logic [31:0] counter;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      penable <= 0;
      psel    <= 0;
      paddr   <= 0;
      counter <= 0;
    end else begin
      penable <= 1;
      psel    <= 0;
      paddr   <= 0;
      counter <= counter + 1;
    end
  end

  sled s0 (
    .seg(seg),
    .dig(dig),
    .clk(clk)
  );

endmodule

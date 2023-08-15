// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module mydff #(
    parameter int         W      = 1,
    parameter int         L      = 0,
    parameter int         H      = W + L - 1,
    parameter logic [H:L] RSTVAL = 0
) (
  input  logic       clk,
  input  logic       rst_n,
  input  logic [H:L] din,
  output logic [H:L] dout
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) dout[H:L] <= RSTVAL;
    else dout[H:L] <= din[H:L];
  end

endmodule

module mydffs #(
    parameter int W = 1,
    parameter int L = 0,
    parameter int H = W + L - 1
) (
  input  logic       clk,
  input  logic [H:L] din,
  output logic [H:L] dout
);

  always_ff @(posedge clk) dout[H:L] <= din[H:L];

endmodule

module mydffena #(
    parameter int W = 1
) (
  input  logic         clk,
  input  logic         rst_n,
  input  logic         en,
  input  logic [W-1:0] din,
  output logic [W-1:0] dout
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) dout[W-1:0] <= 0;
    else if (en) dout[W-1:0] <= din[W-1:0];
    // else dout[W-1:0] <= 0;
  end

endmodule

module mydffsclr #(
    parameter int W = 1
) (
  input  logic         clk,
  input  logic         rst_n,
  input  logic         clr,
  input  logic [W-1:0] din,
  output logic [W-1:0] dout
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) dout[W-1:0] <= 0;
    else if (clr) dout[W-1:0] <= 0;
    else dout[W-1:0] <= din[W-1:0];
    // else dout[W-1:0] <= 0;
  end

endmodule

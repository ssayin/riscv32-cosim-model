// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module syncfifo #(
    parameter  int WIDTH = 1,
    parameter  int DEPTH = 16,
    localparam int PW    = $clog2(DEPTH)
) (
  input logic clk,
  input logic rst_n,

  input logic [WIDTH-1:0] wr_data,
  input logic             wr_valid,

  output logic [WIDTH-1:0] rd_data,
  output logic             rd_valid,
  output logic [   PW-1:0] rd_fullness
);

  logic [WIDTH-1:0] mem[DEPTH];

  logic             wr;
  logic             rd;

  always_comb wr = (wr_valid && !(&rd_fullness));
  always_comb rd = (rd_valid && |rd_fullness);

  logic [PW-1:0] wrptr;
  logic [PW-1:0] rdptr;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) rd_fullness <= 0;
    else
      case ({
        wr, rd
      })
        2'b01:   rd_fullness <= rd_fullness - 1;
        2'b10:   rd_fullness <= rd_fullness + 1;
        default: rd_fullness <= wrptr - rdptr;
      endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (rst_n) wrptr <= 0;
    else if (wr) wrptr <= wrptr + 1'b1;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (rst_n) rdptr <= 0;
    else if (rd) rdptr <= rdptr + 1'b1;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (wr) mem[wrptr] <= wr_data;
  end

  assign rd_data = mem[rdptr];




endmodule

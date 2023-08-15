// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module syncfifo #(
    parameter int WIDTH = 1,
    parameter int DEPTH = 16
) (
  input  logic             clk,
  input  logic             clr,
  input  logic             rst_n,
  input  logic             wren,
  input  logic             rden,
  input  logic [WIDTH-1:0] wr,
  output logic [WIDTH-1:0] rd,
  output logic             empty,
  output logic             full
);

  logic [WIDTH-1:0] mem[DEPTH];

  // Pointer Width
  localparam int PW = $clog2(DEPTH);

  // Registers
  logic [PW-1:0] wrptr;
  logic [PW-1:0] rdptr;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) wrptr <= 0;
    else if (clr) wrptr <= 0;
    else if (~full & wren) wrptr <= wrptr + 1;
  end

  always_ff @(posedge clk) if (~full & wren) mem[wrptr] <= wr;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) rdptr <= 0;
    else if (clr) rdptr <= 0;
    else if (!empty && rden) rdptr <= rdptr + 1;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) rd <= 0;
    else if (clr) rd <= 0;
    else if (!empty && rden) rd <= mem[rdptr];
  end

  assign full  = ((wrptr + 1) == rdptr);
  assign empty = (wrptr == rdptr);

endmodule

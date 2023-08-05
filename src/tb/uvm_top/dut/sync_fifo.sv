// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

// TODO: add multiple clock domains support
module sync_fifo #(
    parameter int RW    = 64,  // Row width
    parameter int DEPTH = 64   // Fifo Depth
) (
  input  logic          clk,
  input  logic          rst_n,
  input  logic          wren,
  input  logic          rden,
  input  logic [RW-1:0] din,
  output logic [RW-1:0] dout,
  input  logic          flush,
  output logic          empty,
  output logic          almost_empty,
  output logic          full
);

  logic [RW-1:0] mem_array[0:DEPTH-1];

  // Pointer Width
  parameter int PW = $clog2(DEPTH);

  // Registers
  logic [PW-1:0] wrptr;
  logic [PW-1:0] rdptr;
  logic [PW-1:0] cnt;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n || flush) begin
      // Do not fill with 0s, just reset ptrs and cnt
      wrptr <= 0;
      rdptr <= 0;
      cnt   <= 0;
    end else begin
      if (wren && !full) begin
        mem_array[wrptr] <= din;
        wrptr            <= wrptr + 1;
        cnt              <= cnt + 1;
      end
      if (rden && !empty) begin
        dout  <= mem_array[rdptr];
        rdptr <= rdptr + 1;
        cnt   <= cnt - 1;
      end
    end
  end

  assign full         = (cnt == (DEPTH - 1));
  assign empty        = (cnt == 0);
  assign almost_empty = (cnt == 1);

endmodule

// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module ifu_fetch_buf #(
    parameter int DEPTH = 16
) (
  input  logic         clk,
  input  logic         clr,
  input  logic         rst_n,
  input  logic [  3:0] wren,
  input  logic         rden,
  input  logic [255:0] ifu_fetch_buf_pkt,
  output logic [ 31:0] instr,
  output logic [ 31:1] pc,
  output logic         empty,
  output logic         full
);

  logic [63:1] arr[DEPTH];

  // Pointer Width
  localparam int PW = $clog2(DEPTH);

  // Registers
  logic [PW-1:0] wrptr;
  logic [PW-1:0] rdptr;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) wrptr <= 0;
    else if (clr) wrptr <= 0;
    else if (~full) wrptr <= wrptr + wren[0] + wren[1] + wren[2] + wren[3];
  end

  always_ff @(posedge clk)
    if (~full && ~clr)
      for (int i = 0; i < 4; i++) begin
        if (wren[i]) begin
          arr[wrptr+i] <= {
            ifu_fetch_buf_pkt[(i*32+128)+:32], ifu_fetch_buf_pkt[(i*32+1)+:31]
          };
        end
      end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) rdptr <= 0;
    else if (clr) rdptr <= 0;
    else if (!empty && rden) rdptr <= rdptr + 1;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) {instr[31:0], pc[31:1]} <= {32'h0, 31'h0};
    else if (clr) {instr[31:0], pc[31:1]} <= {32'h0, 31'h0};
    else if (!empty && rden)
      {instr[31:0], pc[31:1]} <= {arr[rdptr][63:32], arr[rdptr][31:1]};
  end

  assign full = ((wrptr + 1) == rdptr) || ((wrptr + 2) == rdptr) ||
      ((wrptr + 3) == rdptr) || ((wrptr + 4) == rdptr);
  assign empty = (wrptr == rdptr);

endmodule

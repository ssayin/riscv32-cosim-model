// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module uart (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        av_address,
  input  logic        av_read_n,
  input  logic        av_write_n,
  output logic        av_waitrequest,
  input  logic        av_chipselect,
  input  logic [31:0] av_writedata,
  output logic [31:0] av_readdata,
  output logic        av_irq
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      av_waitrequest <= 1'b0;
      av_readdata    <= 32'h0;
      av_irq         <= 1'b0;
    end else begin
      av_waitrequest <= 1'b1;
      av_irq         <= 1'b0;
    end
  end

`ifdef FORMAL
  always_ff @(posedge clk) begin
    begin
    end
  end
`endif

endmodule



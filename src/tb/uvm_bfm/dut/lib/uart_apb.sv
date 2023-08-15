// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

// Avalon Basic MM to APB
// Not fully tested

module uart_apb (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        penable,
  input  logic        paddr,
  input  logic        pwrite,
  input  logic        psel,
  input  logic [31:0] pwdata,
  output logic [31:0] prdata,
  output logic        pready
);

  localparam logic [1:0] Idle = 2'b00;
  localparam logic [1:0] Setup = 2'b01;
  localparam logic [1:0] Access = 2'b10;

  logic [1:0] state;

  logic       av_read_n;
  logic       av_write_n;
  logic       av_waitrequest;

  assign av_write_n = ~pwrite;
  assign av_read_n  = pwrite;

`ifndef FORMAL
  jtag_uart_jtag_uart jtag_uart_0 (
    .clk           (clk),
    .rst_n         (rst_n),
    .av_address    (paddr),
    .av_read_n     (av_read_n),
    .av_write_n    (av_write_n),
    .av_waitrequest(av_waitrequest),
    .av_chipselect (psel),
    .av_writedata  (pwdata),
    .av_readdata   (prdata),
    .av_irq        (),
  );
`else
  uart uart_0 (
    .clk           (clk),
    .rst_n         (rst_n),
    .av_address    (paddr),
    .av_read_n     (av_read_n),
    .av_write_n    (av_write_n),
    .av_waitrequest(av_waitrequest),
    .av_chipselect (psel),
    .av_writedata  (pwdata),
    .av_readdata   (prdata),
    .av_irq        (),
  );
`endif

  assign pready = !(av_waitrequest) && (state == Access);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= Idle;
    end else begin
      case (state)
        Idle:    if (psel) state <= Setup;
        Setup:   if (penable) state <= Access;
        Access: begin
          if (!av_waitrequest) begin
            if (psel) state <= Setup;
            else state <= Idle;
          end
        end
        default: state <= Idle;
      endcase
    end
  end

endmodule

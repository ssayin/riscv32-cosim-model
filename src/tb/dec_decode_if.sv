`ifndef DEC_DECODE_IF
`define DEC_DECODE_IF

interface dec_decode_if
  import svdpi_pkg::decoder_in_t;
  import svdpi_pkg::decoder_out_t;
(
    input logic clk,
    reset
);

  decoder_in_t  dec_in;
  decoder_out_t dec_out;

  clocking dr_cb @(posedge clk);
    output dec_in;
    input dec_out;
  endclocking : dr_cb


  modport DRV(clocking dr_cb, input clk, reset);

  clocking rc_cb @(negedge clk);
    input dec_in;
    input dec_out;
  endclocking : rc_cb


  modport RCV(clocking rc_cb, input clk, reset);

endinterface : dec_decode_if

`endif
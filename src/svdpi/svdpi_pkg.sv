`ifndef SVDPI_PKG
`define SVDPI_PKG

package svdpi_pkg;

typedef struct {
  rand logic [31:0] instr;
  rand logic [31:0] pc_in;
} decoder_in_t;

typedef struct {
  logic [31:0] imm;
  logic [4:0]  rs1_addr;
  logic [4:0]  rs2_addr;
  logic [4:0]  rd_addr;
  logic        alu;
  logic        lsu;
  logic        br;
  logic        illegal;
  logic        use_imm;
} decoder_out_t;

import "DPI-C" function void init();
import "DPI-C" function void dpi_decoder_input(decoder_in_t io);
import "DPI-C" function void dpi_decoder_output(decoder_out_t io);

import "DPI-C" function void dpi_decoder_process(
  input  decoder_in_t  in,
  output decoder_out_t out
);

import "DPI-C" function void disas(decoder_in_t dec_in);

`endif

endpackage

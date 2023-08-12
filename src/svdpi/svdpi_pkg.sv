// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

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
    logic        rs1_en;
    logic [4:0]  rs2_addr;
    logic        rs2_en;
    logic [4:0]  rd_addr;
    logic        rd_en;
    logic        alu;
    logic        lsu;
    logic        br;
    logic        csr;
    logic        lui;
    logic        auipc;
    logic        jal;
    logic        fence;
    logic        fencei;
    logic        illegal;
    logic        use_imm;
  } decoder_out_t;

  typedef struct {
    logic alu;
    logic lsu;
    logic lui;
    logic auipc;
    logic br;
    logic jal;
    logic csr;
    logic fencei;
    logic fence;
    logic illegal;
  } ctl_pkt_t;

  import "DPI-C" function void init();
  import "DPI-C" function void dpi_decoder_input(decoder_in_t io);
  import "DPI-C" function void dpi_decoder_output(decoder_out_t io);

  import "DPI-C" function void dpi_decoder_process(
    input  decoder_in_t  in,
    output decoder_out_t out
  );

  import "DPI-C" function void disas(decoder_in_t dec_in);

endpackage

`endif

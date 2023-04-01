#include "decodesv.h"
#include "decoder/decoder.hpp"
#include "svdpi.h"
#include <cstring>
#include <iostream>

/*
extern "C" void decodesv(const svLogicVecVal *word, svLogicVecVal *out) {
  op dec = decode(word->aval);
#ifdef P1800_2005_VECVAL
  out->a = word->a;
  out->b = 0;
#else
  out->aval = word->aval;
  out->bval = 0;
#endif
  std::cout << (dec.tgt == target::illegal ? "illegal\n" : "legal\n");
}
*/
void dpi_decoder_input(const Decoder_IO *io) {}

void dpi_decoder_output(Decoder_IO *io) {}

void dpi_decoder_process(const Decoder_IO *in, Decoder_IO *out) {
  // memcpy(out, in, sizeof(Decoder_IO));

  op dec = decode(in->instr.aval);

  out->is_compressed = dec.is_compressed;

  out->use_imm = dec.has_imm;

  out->imm.aval = dec.imm;
  out->imm.bval = 0;

  out->rd_addr.aval = dec.rd;
  out->rd_addr.bval = 0;

  out->rs1_addr.aval = dec.rs1;
  out->rs1_addr.bval = 0;

  out->rs2_addr.aval = dec.rs2;
  out->rs2_addr.bval = 0;

  switch (dec.tgt) {
  case target::load:
    out->pt.lsu = 1;
    break;
  case target::store:
    out->pt.lsu = 1;
    break;
  case target::alu:
    out->pt.alu = 1;
    break;
  case target::branch:
    out->pt.br = 1;
    break;
  case target::illegal:
    out->pt.illegal = 1;
    break;

  case target::csr:
  case target::mret:
  case target::ebreak:
  case target::ecall:
    break;
  }
}

extern "C" void init() {
  std::cout << "DPI_VERSION: " << svDpiVersion() << std::endl;
}

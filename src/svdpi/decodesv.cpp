#include "decodesv.h"
#include "decoder/decoder.hpp"
#include "decoder/rv32_isn.hpp"
#include "svdpi.h"
#include <bitset>
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
void dpi_decoder_input(const decoder_in_t *in) {}

void dpi_decoder_output(decoder_out_t *out) {}

void dpi_decoder_process(const decoder_in_t *in, decoder_out_t *out) {
  memset(out, 0, sizeof(decoder_out_t));

  uint32_t instr = in->instr.aval;
  bool is_compressed = (instr & 0x3) != 0x3;
  op dec;
  if (is_compressed) {
    dec = decode16(instr & 0x0000FFFF);
  } else {
    dec = decode(instr);
  }

  out->use_imm = dec.has_imm;

  EXPORTER_VECVAL_SET(out->imm, dec.imm);
  EXPORTER_VECVAL_SET(out->rd_addr, dec.rd);
  EXPORTER_VECVAL_SET(out->rs1_addr, dec.rs1);
  EXPORTER_VECVAL_SET(out->rs2_addr, dec.rs2);

  // memset(&out->pt, 0, sizeof(pt_t));
  out->lsu = 0;
  out->alu = 0;
  out->br = 0;
  out->illegal = 0;

  switch (dec.tgt) {
  case target::load:
    out->lsu = 1;
    break;
  case target::store:
    out->lsu = 1;
    break;
  case target::alu:
    /*switch (std::get<alu>(dec.opt)) {
    case alu::_sll:
    case alu::_srl:
    case alu::_sra:
      if (dec.has_imm && !dec.is_compressed) {
        out->imm.aval = 0;
        out->imm.bval = 0;
        out->rs2_addr.aval = dec.imm;
      }
      break;
    default:
      break;
    }*/
    out->alu = 1;
    break;
  case target::branch:
    out->br = 1;
    break;
  case target::illegal:
    out->illegal = 1;
    break;

  case target::csr:
  case target::mret:
  case target::ebreak:
  case target::ecall:
    break;
  }
}

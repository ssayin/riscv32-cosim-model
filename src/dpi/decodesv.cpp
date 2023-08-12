// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

#include "decodesv.h"
#include "decoder/decoder.hpp"

#include <bitset>
#include <cstring>
#include <iostream>

#include "rapidjson/document.h"

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
  printf("HI\n");

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

  if (dec.tgt == target::alu) {
    alu alu0 = std::get<alu>(dec.opt);
    if ((alu0 == alu::_jal) || (alu0 == alu::_jalr)) {
      out->jal = 1;
    }
    out->alu = 1;
    if ((!is_compressed) &&
        ((instr & static_cast<uint32_t>(masks::opcode::auipc)) ==
         static_cast<uint32_t>(masks::opcode::auipc))) {
      out->auipc = 1;
    }

    if ((instr & static_cast<uint32_t>(masks::opcode::lui)) ==
            static_cast<uint32_t>(masks::opcode::lui) ||
        (is_compressed && (instr & 0b0110000000000001) == 0b0110000000000001)) {
      out->lui = 1;
    }
    if ((instr & static_cast<uint32_t>(masks::opcode::jal)) ==
        static_cast<uint32_t>(masks::opcode::jal)) {
      out->jal = 1;
      // 32'b????????????????011???????????01
    }
  }

  switch (dec.tgt) {
  case target::load:
    out->lsu = 1;
    break;
  case target::store:
    out->lsu = 1;
    break;
  case target::branch:
    out->br = 1;
    break;
  case target::illegal:
    out->illegal = 1;
    break;
  case target::csr:
    out->csr = 1;
    break;
  case target::alu:
  case target::mret:
  case target::ebreak:
  case target::ecall:
    break;
  }
}

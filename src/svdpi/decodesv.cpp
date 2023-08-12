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

inline void init_output(decoder_out_t *out) {
  memset(out, 0, sizeof(decoder_out_t));
}

void set_imm_and_registers(const op &dec, decoder_out_t *out) {
  out->use_imm = dec.has_imm;
  EXPORTER_VECVAL_SET(out->imm, dec.imm);
  EXPORTER_VECVAL_SET(out->rd_addr, dec.rd);
  EXPORTER_VECVAL_SET(out->rs1_addr, dec.rs1);
  EXPORTER_VECVAL_SET(out->rs2_addr, dec.rs2);
}

void set_flags(const op &dec, bool is_compressed, decoder_out_t *out,
               uint32_t instr) {
  if (dec.tgt == target::alu) {
    if ((std::get<alu>(dec.opt) == alu::_jal) ||
        (std::get<alu>(dec.opt) == alu::_jalr)) {
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
    }
  }
}

void set_target_flags(const op &dec, decoder_out_t *out) {
  switch (dec.tgt) {
  case target::load:
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
  default:
    break;
  }
}

void dpi_decoder_process(const decoder_in_t *in, decoder_out_t *out) {
  init_output(out);

  uint32_t instr = in->instr.aval;
  bool is_compressed = (instr & 0x3) != 0x3;

  op dec = is_compressed ? decode16(instr & 0x0000FFFF) : decode(instr);

  set_imm_and_registers(dec, out);
  set_flags(dec, is_compressed, out, instr);
  set_target_flags(dec, out);
}

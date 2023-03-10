// SPDX-FileCopyrightText: 2022 - 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: MIT

#ifndef DECODER_RVC_ISN_HPP
#define DECODER_RVC_ISN_HPP

#include "common/offset.hpp"

#include <cassert>

struct rvc_lwsp /* CI */ {
  uint8_t rdrs1;
  uint8_t imm;
  void    unpack(uint16_t w) {
    rdrs1 = offset(w, 7U, 11U);
    assert(rdrs1 != 0);
    imm = (offset(w, 12U, 12U) << 5) | (offset(w, 2U, 3U) << 6) |
          (offset(w, 4U, 5U) << 2);
  }
  rvc_lwsp(uint16_t w) { unpack(w); }
};

struct rvc_li /* CI */ {
  uint32_t imm;
  uint8_t  rdrs1;
  void     unpack(uint16_t w) {
    rdrs1 = offset(w, 7U, 11U);
    assert(rdrs1 != 0);
    imm = offset(w, 2U, 6U) |
          static_cast<uint32_t>(
              static_cast<int32_t>(offset(w, 12U, 12U) << 31) >> 27);
  }
  rvc_li(uint16_t w) { unpack(w); }
};

struct rvc_lui /* CI */ {
  uint32_t imm;
  uint8_t  rdrs1;
  void     unpack(uint16_t w) {
    rdrs1 = offset(w, 7U, 11U);
    assert(rdrs1 != 0);
    assert(rdrs1 != 2);
    imm = (offset(w, 2U, 6U) << 12) |
          static_cast<uint32_t>(
              static_cast<int32_t>(offset(w, 12U, 12U) << 31) >> 14);
  }
  rvc_lui(uint16_t w) { unpack(w); }
};

struct rvc_addi /* CI */ {
  uint32_t imm;
  uint8_t  rdrs1;

  void unpack(uint16_t w) {
    rdrs1 = offset(w, 7U, 11U);
    assert(rdrs1 != 0);
    imm = offset(w, 2U, 6U) |
          static_cast<uint32_t>(
              static_cast<int32_t>(offset(w, 12U, 12U) << 31) >> 27);
  }
  rvc_addi(uint16_t w) { unpack(w); }
};

struct rvc_addi16sp /* CI */ {
  uint32_t imm;
  uint8_t  rdrs1;

  void unpack(uint16_t w) {
    rdrs1 = offset(w, 7U, 11U);
    assert(rdrs1 == 2);
    imm = (offset(w, 2U, 2U) << 5) | (offset(w, 3U, 4U) << 7) |
          (offset(w, 5U, 5U) << 6) | (offset(w, 6U, 6U) << 4) |
          static_cast<uint32_t>(
              static_cast<int32_t>((offset(w, 12U, 12U) << 31)) >> 22);
  }
  rvc_addi16sp(uint16_t w) { unpack(w); }
};

struct rvc_slli /* CI */ {
  uint8_t rdrs1;
  uint8_t imm;
  void    unpack(uint16_t w) {
    rdrs1 = offset(w, 7U, 11U);
    assert(rdrs1 != 0);
    imm = offset(w, 2U, 6U) | (offset(w, 12U, 12U) << 5);
  }
  rvc_slli(uint16_t w) { unpack(w); }
};

struct rvc_swsp /* CSS */ {
  uint8_t rs2;
  uint8_t imm;
  void    unpack(uint16_t w) {
    rs2 = offset(w, 2U, 6U);
    imm = (offset(w, 7U, 8U) << 6) | (offset(w, 9U, 12U) << 2);
  }
  rvc_swsp(uint16_t w) { unpack(w); }
};

struct rvc_addi4spn /* CIW */ {
  uint16_t imm;
  uint8_t  rd;
  void     unpack(uint16_t w) {
    rd  = offset(w, 2U, 4U) + 8;
    imm = (offset(w, 5U, 5U) << 3) | (offset(w, 6U, 6U) << 2) |
          (offset(w, 7U, 10U) << 6) | (offset(w, 11U, 12U) << 4);
  }
  rvc_addi4spn(uint16_t w) { unpack(w); }
};

struct rvc_lw /* CL */ {
  uint8_t imm;
  uint8_t rs1;
  uint8_t rd;
  void    unpack(uint16_t w) {
    rs1 = offset(w, 7U, 9U) + 8;
    rd  = offset(w, 2U, 4U) + 8;
    imm = (offset(w, 5U, 5U) << 6) | (offset(w, 6U, 6U) << 2) |
          (offset(w, 10U, 12U) << 3);
  }
  rvc_lw(uint16_t w) { unpack(w); }
};

struct rvc_sw /* CS */ {
  uint8_t imm;
  uint8_t rs1;
  uint8_t rs2;
  void    unpack(uint16_t w) {
    rs1 = offset(w, 7U, 9U) + 8;
    rs2 = offset(w, 2U, 4U) + 8;
    imm = (offset(w, 5U, 5U) << 6) | (offset(w, 6U, 6U) << 2) |
          (offset(w, 10U, 12U) << 3);
  }
  rvc_sw(uint16_t w) { unpack(w); }
};

struct rvc_beqz {
  uint32_t ofs;
  uint8_t  rs1;

  void unpack(uint16_t w) {
    rs1 = offset(w, 7U, 9U) + 8;
    ofs = (offset(w, 2U, 2U) << 5) | (offset(w, 3U, 4U) << 1) |
          (offset(w, 5U, 6U) << 6) | (offset(w, 10U, 11U) << 3) |
          static_cast<uint32_t>(
              static_cast<int32_t>((offset(w, 12U, 12U) << 31)) >> 23);
  }
  rvc_beqz(uint16_t w) { unpack(w); }
};

struct rvc_bnez {
  uint32_t ofs;
  uint8_t  rs1;

  void unpack(uint16_t w) {
    rs1 = offset(w, 7U, 9U) + 8;
    ofs = (offset(w, 2U, 2U) << 5) | (offset(w, 3U, 4U) << 1) |
          (offset(w, 5U, 6U) << 6) | (offset(w, 10U, 11U) << 3) |
          static_cast<uint32_t>(
              static_cast<int32_t>((offset(w, 12U, 12U) << 31)) >> 23);
  }
  rvc_bnez(uint16_t w) { unpack(w); }
};

struct rvc_srli {
  uint8_t rs1;
  uint8_t ofs;
  void    unpack(uint16_t w) {
    rs1 = offset(w, 7U, 9U) + 8;
    ofs = offset(w, 2U, 6U) | offset(w, 12U, 12U) << 5;
  }
  rvc_srli(uint16_t w) { unpack(w); }
};

struct rvc_srai {
  uint8_t rs1;
  uint8_t ofs;
  void    unpack(uint16_t w) {
    rs1 = offset(w, 7U, 9U) + 8;
    ofs = offset(w, 2U, 6U) | offset(w, 12U, 12U) << 5;
  }
  rvc_srai(uint16_t w) { unpack(w); }
};

struct rvc_andi {
  uint32_t ofs;
  uint8_t  rs1;
  void     unpack(uint16_t w) {
    rs1 = offset(w, 7U, 9U) + 8;
    ofs = offset(w, 2U, 6U) |
          static_cast<uint32_t>(
              (static_cast<int32_t>(offset(w, 12U, 12U) << 31) >> 26));
  }
  rvc_andi(uint16_t w) { unpack(w); }
};

struct rvc_j /* CJ */ {
  uint32_t tgt;
  void     unpack(uint16_t w) {
    tgt = (offset(w, 2U, 2U) << 5) | (offset(w, 3U, 5U) << 1) |
          (offset(w, 6U, 6U) << 7) | (offset(w, 7U, 7U) << 6) |
          (offset(w, 8U, 8U) << 10) | (offset(w, 9U, 10U) << 8) |
          (offset(w, 11U, 11U) << 4) |
          static_cast<uint32_t>(
              static_cast<int32_t>((offset(w, 12U, 12U) << 31)) >> 20);
  }
  rvc_j(uint16_t w) { unpack(w); }
};

struct rvc_jal {
  uint32_t tgt;
  void     unpack(uint16_t w) {
    tgt = (offset(w, 2U, 2U) << 5) | (offset(w, 3U, 5U) << 1) |
          (offset(w, 6U, 6U) << 7) | (offset(w, 7U, 7U) << 6) |
          (offset(w, 8U, 8U) << 10) | (offset(w, 9U, 10U) << 8) |
          (offset(w, 11U, 11U) << 4) |
          static_cast<uint32_t>(
              static_cast<int32_t>((offset(w, 12U, 12U) << 31)) >> 20);
  }
  rvc_jal(uint16_t w) { unpack(w); }
};

#endif /* end of include guard: DECODER_RVC_ISN_HPP */

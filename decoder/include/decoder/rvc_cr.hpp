// SPDX-FileCopyrightText: 2022 - 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: MIT

#ifndef DECODER_RVC_CR_HPP
#define DECODER_RVC_CR_HPP

#include "common/offset.hpp"

struct rvc_cr /* CR */ {
  uint8_t rdrs1;
  uint8_t rs2;
  void    unpack(uint16_t w) {
    rdrs1 = offset(w, 7U, 11U);
    rs2   = offset(w, 2U, 6U);
  }
  rvc_cr(uint16_t w) { unpack(w); }
};

using rvc_jr   = rvc_cr;
using rvc_jalr = rvc_cr;
using rvc_mv   = rvc_cr;
using rvc_add  = rvc_cr;

#endif /* end of include guard: DECODER_RVC_CR_HPP */

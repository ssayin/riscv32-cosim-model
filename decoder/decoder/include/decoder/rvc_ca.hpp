// SPDX-FileCopyrightText: 2022 - 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: MIT

#ifndef DECODER_RVC_CA_HPP
#define DECODER_RVC_CA_HPP

#include "common/offset.hpp"

struct rvc_ca {
  uint8_t rdrs1;
  uint8_t rs2;
  void    unpack(uint16_t w) {
    rdrs1 = offset(w, 7U, 9U) + 8;
    rs2   = offset(w, 2U, 4U) + 8;
  }
  rvc_ca(uint16_t w) { unpack(w); }
};

using rvc_and  = rvc_ca;
using rvc_or   = rvc_ca;
using rvc_xor  = rvc_ca;
using rvc_sub  = rvc_ca;
using rvc_addw = rvc_ca;
using rvc_subw = rvc_ca;

#endif /* end of include guard: DECODER_RVC_CA_HPP */

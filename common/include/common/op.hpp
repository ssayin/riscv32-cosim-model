// SPDX-FileCopyrightText: 2022 - 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: MIT

#ifndef OP_HPP
#define OP_HPP

#include "op_type.hpp"

struct op {
  uint32_t imm;
  op_type opt; // 2 bytes
  target tgt;
  uint8_t rd;
  uint8_t rs1;
  uint8_t rs2;
  bool has_imm;
  bool use_pc = false;
  bool is_compressed = false;
};

struct hart_state {
  op dec;
  uint32_t instr;
};

#endif

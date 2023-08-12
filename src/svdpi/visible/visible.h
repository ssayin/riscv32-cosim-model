// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

#ifndef INCLUDE_VISIBLE_H
#define INCLUDE_VISIBLE_H

#include <cstdint>
#include <ostream>
#include <vector>

struct CsrStaged;
struct GprStaged;
struct DecodedInstr;
struct PC;
struct VisibleState;

std::ostream &operator<<(std::ostream &os, const PC &item);
std::ostream &operator<<(std::ostream &os, const DecodedInstr &item);
std::ostream &operator<<(std::ostream &os, const CsrStaged &item);
std::ostream &operator<<(std::ostream &os, const GprStaged &item);
std::ostream &operator<<(std::ostream &os, const VisibleState &item);

struct CsrStaged {
  uint32_t next;
  uint32_t prev;
  uint16_t index;
};

struct GprStaged {
  uint32_t next;
  uint32_t prev;
  uint16_t index;
};

struct DecodedInstr {
  uint32_t imm;
  uint16_t opt;
  uint16_t rd;
  uint16_t rs1;
  uint16_t rs2;
  uint16_t tgt;
  bool has_imm;
  bool is_compressed;
  bool use_pc;
};

struct PC {
  uint32_t pc;
  uint32_t pc_next;
};

struct VisibleState {
  std::vector<CsrStaged> csr_staged;
  std::vector<GprStaged> gpr_staged;
  DecodedInstr dec;
  uint32_t instr;
  PC pc;
};

#endif /* end of include guard: INCLUDE_VISIBLE_H */

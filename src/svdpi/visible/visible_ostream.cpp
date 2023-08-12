// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

#include "visible.h"
#include "rapidjson/document.h"

#include <fstream>
#include <iostream>
#include <vector>

using namespace rapidjson;

std::ostream &operator<<(std::ostream &os, const PC &item) {

  os << "PC:\n"
     << "  PC: " << item.pc << ", PC Next: " << item.pc_next;

  return os;
}

std::ostream &operator<<(std::ostream &os, const DecodedInstr &item) {
  os << "Decoded Instruction:\n"
     << "  Has Immediate: " << item.has_imm << "\n"
     << "  Immediate: " << item.imm << "\n"
     << "  Compressed: " << item.is_compressed << "\n"
     << "  Opt: " << item.opt << "\n"
     << "  Rd Addr: " << item.rd << "\n"
     << "  Rs1 Addr: " << item.rs1 << "\n"
     << "  Rs2 Addr: " << item.rs2 << "\n"
     << "  Target: " << item.tgt << "\n"
     << "  Use PC: " << item.use_pc;

  return os;
}

std::ostream &operator<<(std::ostream &os, const CsrStaged &item) {
  os << "  Index: " << item.index << ", New: " << item.next
     << ", Old: " << item.prev;

  return os;
}

std::ostream &operator<<(std::ostream &os, const GprStaged &item) {
  os << "  Index: " << item.index << ", New: " << item.next
     << ", Old: " << item.prev;
  return os;
}

std::ostream &operator<<(std::ostream &os, const VisibleState &item) {

  os << item.pc << "\n";

  os << "Instruction: " << item.instr << "\n";

  os << item.dec << "\n";

  os << "Changed CSRs:\n";
  for (const auto &csr : item.csr_staged) {
    os << csr << "\n";
  }

  os << "Changed GPRs:\n";
  for (const auto &gpr : item.gpr_staged) {
    os << gpr << "\n";
  }

  return os;
}

// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

#include "include/visible.h"
#include "rapidjson/document.h"
#include "visible.h"
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

void get_next_reentrant(int i, rapidjson::Document &doc) {
  const Value &item = doc[i];
  VisibleState parsedItem;
  if (item.IsObject()) {
    const Value &csrStagedArray = item["csr_staged"];
    if (csrStagedArray.IsArray()) {
      for (SizeType j = 0; j < csrStagedArray.Size(); ++j) {
        const Value &csrItem = csrStagedArray[j];
        if (csrItem.IsObject()) {
          CsrStaged staged;
          staged.index = csrItem["index"].GetUint();
          staged.next = csrItem["next"].GetUint();
          staged.prev = csrItem["prev"].GetUint();
          parsedItem.csr_staged.push_back(staged);
        }
      }
    }

    const Value &gprStagedArray = item["gpr_staged"];
    if (gprStagedArray.IsArray()) {
      for (SizeType j = 0; j < gprStagedArray.Size(); ++j) {
        const Value &gprItem = gprStagedArray[j];
        if (gprItem.IsObject()) {
          GprStaged staged;
          staged.index = gprItem["index"].GetUint();
          staged.next = gprItem["next"].GetUint();
          staged.prev = gprItem["prev"].GetUint();
          parsedItem.gpr_staged.push_back(staged);
        }
      }
    }

    const Value &dec = item["dec"];
    if (dec.IsObject()) {
      parsedItem.dec.has_imm = dec["has_imm"].GetBool();
      parsedItem.dec.imm = dec["imm"].GetUint();
      parsedItem.dec.is_compressed = dec["is_compressed"].GetBool();
      parsedItem.dec.opt = dec["opt"].GetUint();
      parsedItem.dec.rd = dec["rd"].GetUint();
      parsedItem.dec.rs1 = dec["rs1"].GetUint();
      parsedItem.dec.rs2 = dec["rs2"].GetUint();
      parsedItem.dec.tgt = dec["tgt"].GetUint();
      parsedItem.dec.use_pc = dec["use_pc"].GetBool();
    }

    const Value &pc = item["pc"];
    if (pc.IsObject()) {
      parsedItem.pc.pc = pc["pc"].GetUint();
      parsedItem.pc.pc_next = pc["pc_next"].GetUint();
    }

    const Value &instr = item["instr"];
    if (instr.IsObject()) {
      parsedItem.instr = instr.GetUint();
    }

    std::cout << parsedItem << "\n";
  }
}

int main(int argc, char *argv[]) {
  std::ifstream inputFile(argv[1]);
  std::string json((std::istreambuf_iterator<char>(inputFile)),
                   std::istreambuf_iterator<char>());

  Document doc;
  doc.Parse(json.c_str());

  if (!doc.HasParseError() && doc.IsArray()) {
    std::vector<VisibleState> items;

    for (SizeType i = 0; i < doc.Size(); ++i) {
      get_next_reentrant(i, doc);
    }
  }
  return 0;
}

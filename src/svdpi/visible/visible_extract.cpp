// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

#include "visible_extract.h"
#include "visible.h"

void get_dec(DecodedInstr &decoded, const rapidjson::Value &dec) {
  if (dec.IsObject()) {
    decoded.has_imm = dec["has_imm"].GetBool();
    decoded.imm = dec["imm"].GetUint();
    decoded.is_compressed = dec["is_compressed"].GetBool();
    decoded.opt = dec["opt"].GetUint();
    decoded.rd = dec["rd"].GetUint();
    decoded.rs1 = dec["rs1"].GetUint();
    decoded.rs2 = dec["rs2"].GetUint();
    decoded.tgt = dec["tgt"].GetUint();
    decoded.use_pc = dec["use_pc"].GetBool();
  }
}

void get_pc(PC &retpc, const rapidjson::Value &pc) {
  if (pc.IsObject()) {
    retpc.pc = pc["pc"].GetUint();
    retpc.pc_next = pc["pc_next"].GetUint();
  }
}

void get_visible(VisibleState &parsedItem, const rapidjson::Value &item) {
  if (item.IsObject()) {
    get_staged(parsedItem.csr_staged, item["csr_staged"]);
    get_staged(parsedItem.gpr_staged, item["gpr_staged"]);
    get_dec(parsedItem.dec, item["dec"]);
    get_pc(parsedItem.pc, item["pc"]);
    parsedItem.instr = item["instr"].GetUint();
  }
}

void get_next_reentrant(int i, VisibleState &parsedItem,
                        rapidjson::Document &doc) {
  get_visible(parsedItem, doc[i]);
}

void parse_visible(rapidjson::Document &doc, std::vector<VisibleState> &items,
                   const std::string &json) {

  if (!doc.HasParseError() && doc.IsArray()) {
    VisibleState state;

    for (rapidjson::SizeType i = 0; i < doc.Size(); ++i) {
      get_next_reentrant(i, state, doc);
      items.emplace_back(state);
    }
  }
}

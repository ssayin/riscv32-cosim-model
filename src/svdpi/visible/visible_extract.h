// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

#ifndef INCLUDE_VISIBLE_EXTRACT_H
#define INCLUDE_VISIBLE_EXTRACT_H

#include <vector>

#include "rapidjson/document.h"
#include "visible.h"

template <typename T>
void get_staged(std::vector<T> &vstaged, const rapidjson::Value &stagedArray) {
  if (stagedArray.IsArray()) {
    for (rapidjson::SizeType j = 0; j < stagedArray.Size(); ++j) {
      const rapidjson::Value &stagedItem = stagedArray[j];
      if (stagedItem.IsObject()) {
        T staged;
        staged.index = stagedItem["index"].GetUint();
        staged.next = stagedItem["next"].GetUint();
        staged.prev = stagedItem["prev"].GetUint();
        vstaged.push_back(staged);
      }
    }
  }
}

void get_dec(DecodedInstr &decoded, const rapidjson::Value &dec);

void get_pc(PC &retpc, const rapidjson::Value &pc);

void get_next_reentrant(int i, rapidjson::Document &doc);

void parse_visible(rapidjson::Document &doc, std::vector<VisibleState> &items,
                   const std::string &json);

void get_visible(VisibleState &parsedItem, const rapidjson::Value &item);

void get_next_reentrant(int i, VisibleState &parsedItem,
                        rapidjson::Document &doc);

#endif /* end of include guard: INCLUDE_VISIBLE_EXTRACT_H */

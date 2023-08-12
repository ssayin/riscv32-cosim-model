// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

#include "rapidjson/document.h"
#include "visible/visible.h"
#include "visible/visible_extract.h"
#include <fstream>
#include <iostream>
#include <vector>

using namespace rapidjson;

int main(int argc, char *argv[]) {
  std::ifstream inputFile(argv[1]);

  std::string json((std::istreambuf_iterator<char>(inputFile)),
                   std::istreambuf_iterator<char>());

  Document doc;
  doc.Parse(json.c_str());

  std::vector<VisibleState> state;

  parse_visible(doc, state, json);

  for (const auto &x : state) {
    std::cout << x << "\n";
  }

  return 0;
}

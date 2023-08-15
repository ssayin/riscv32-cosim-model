// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

#include <algorithm>
#include <iostream>
#include <numeric>
#include <sstream>
#include <string>
#include <vector>

const std::string blank = " ";

struct instr_type {
  enum placement_rule { ANY, HI, LO };
  std::string instr;
  int span;
  placement_rule rule;

  bool operator<(const instr_type &other);
};

void generate_permutations(std::vector<std::string> &places,
                           std::vector<std::string> &lines, int index);

bool instr_type::operator<(const instr_type &other) {
  if (this->instr != other.instr)
    return this->instr < other.instr;
  return this->span < other.span;
}

// An I32 instruction can be divided in half when the alignment is 2 bytes. This
// may not be significant as long as the instruction pointer correctly
// points to the intended instruction during branches and jumps. One potential
// concern is that our instructions could be divided across cache lines.
// However, since they are consecutive, we can possibly store them in a FIFO and
// retrieve them in the IF stage, handling predecode in a separate cycle.

std::vector<instr_type> instr = {
    {"I", 2, instr_type::ANY},   {"C", 1, instr_type::ANY},
    {"H", 1, instr_type::HI}, // I32[31:16]
    {"L", 1, instr_type::LO}, // I32[15:0]
    {blank, 1, instr_type::ANY},
};

void generate_permutations(std::vector<std::string> &places,
                           std::vector<std::string> &lines, int index) {
  if (index >= places.size()) {
    lines.push_back(
        std::accumulate(places.begin(), places.end(), std::string()));
  }

  for (const auto &pkt : instr) {
    if ((pkt.rule == instr_type::LO) && index != 0)
      continue;
    if ((pkt.rule == instr_type::HI) && index != 3)
      continue;
    if ((pkt.span + index) <= places.size()) {
      places[index++] = pkt.instr;
      for (int j = 1; j < pkt.span; ++j) {
        places[index++] = "";
      }
      generate_permutations(places, lines, index);
    }
  }
}

std::string as_capture(std::string::const_iterator begin,
                       std::string::const_iterator end) {
  std::string ret;
  while (begin != end) {
    switch (*begin) {
    case 'H':
      ret += "????????????????";
      break;
    case 'L':
      ret += "??????????????11";
      break;
    case 'C':
      ret += "????????????????";
      break;
    case 'I':
      ret += "??????????????????????????????11";
      break;
    case ' ':
      ret += "????????????????";
      break;
    }
    begin++;
  }
  return ret;
}

std::string as_comp(std::string::const_reverse_iterator begin,
                    std::string::const_reverse_iterator end) {
  std::string ret;
  while (begin != end) {
    switch (*begin) {
    case 'H':
      ret += "1?";
      break;
    case 'L':
      ret += "?";
      break;
    case 'C':
      ret += "1";
      break;
    case 'I':
      ret += "0?";
      break;
    case ' ':
      ret += "?";
      break;
    }
    begin++;
  }
  return ret;
}

void make_full(std::stringstream &ss, int ofs) {
  ss << "(&w[";
  ss << (ofs + 1) << ":" << ofs;
  ss << "])";
}

std::string as_equation(int chunk_size, int alignment,
                        std::string::const_iterator begin,
                        std::string::const_iterator end) {

  int ofs = chunk_size - alignment;
  std::stringstream ss;
  while (begin != end) {
    switch (*begin) {
    case 'H':
      ss << "i32l_valid && ";
      // ofs -= alignment;
      break;
    case 'L': // has to be 0 for partial, H will follow
      make_full(ss, ofs);
      if (begin != std::prev(end))
        ss << " && ";
      ofs -= alignment;
      break;
    case 'C':
      ss << "!";
      make_full(ss, ofs);
      if (begin != std::prev(end))
        ss << " && ";
      ofs -= alignment;
      break;
    case 'I':
      make_full(ss, ofs);
      if (begin != std::prev(end))
        ss << " && ";
      ofs -= (alignment * 2);
      break;
    case ' ':
      // ss << "";
      ofs -= alignment;
      break;
    }
    begin++;
  }
  return ss.str();
}

int main(int argc, char *argv[]) {
  if (argc != 3) {
    std::cout << "Usage: ./pinst <chunk_size> <alignment>\n";
    return 1;
  }

  int alignment = atoi(argv[2]);
  int chunk_size = atoi(argv[1]);
  int last = chunk_size / alignment;

  std::vector<std::string> lines;

  while (std::prev_permutation(instr.begin(), instr.end())) {
    std::vector<std::string> places;

    for (int i = 0; i < last; ++i)
      places.emplace_back(blank);

    generate_permutations(places, lines, 0);
  }

  std::sort(lines.begin(), lines.end());

  lines.erase(std::unique(lines.begin(), lines.end()), lines.end());

  std::cout << "LSB is the rightmost character for big-endian" << std::endl;

  for (const auto &str : lines) {
    std::cout << str << "\t" << as_capture(str.begin(), str.end()) << "\t"
              << as_equation(chunk_size, alignment, str.begin(), str.end())
              << std::endl;
  }
  return 0;
}

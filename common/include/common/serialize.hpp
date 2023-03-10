// SPDX-FileCopyrightText: 2022 - 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: MIT

#ifndef RISCV32_SIM_SERIALIZE_HPP
#define RISCV32_SIM_SERIALIZE_HPP

#include "op.hpp"

#include <nlohmann/json.hpp>

template<typename... Ts> struct overload : Ts ... {
  using Ts::operator()...;
};

template<class... Ts> overload(Ts...) -> overload<Ts...>;

namespace nlohmann {
template<> struct adl_serializer<op_type> {
  static void from_json(const json &j, op_type &type) {
    auto x = j.get<uint8_t>();
    if (x == 0)
      type = std::monostate{};
    if (x >= 1 && x <= 19) {
      type = masks::sys{--x};
    }
    if (x >= 20 && x <= 29)
      type = masks::branch{x -= 20};
    if (x >= 30 && x <= 39)
      type = masks::store{x -= 30};
    if (x >= 40 && x <= 49)
      type = masks::load{x -= 40};
    if (x >= 50 && x <= 100)
      type = alu{x -= 50};
    throw std::runtime_error("cannot parse");
  }

  static void to_json(json &j, const op_type &opt) {
    j = std::visit(
        overload{
            [](const alu &a) { return 50 + static_cast<uint8_t>(a); },
            [](const masks::load &l) { return 40 + static_cast<uint8_t>(l); },
            [](const masks::store &s) { return 30 + static_cast<uint8_t>(s); },
            [](const masks::branch &b) { return 20 + static_cast<uint8_t>(b); },
            [](const masks::sys &s) { return 1 + static_cast<uint8_t>(s); },
            [](const std::monostate &) { return 0; }},
        opt);
  }
};
} // namespace nlohmann

NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE(op, imm, opt, tgt, rd, rs1, rs2, has_imm,
                                   use_pc, is_compressed)

NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE(hart_state, instr, dec)

#endif // RISCV32_SIM_SERIALIZE_HPP

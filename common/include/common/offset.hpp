// SPDX-FileCopyrightText: 2022 - 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: MIT

#ifndef COMMON_OFFSET_HPP
#define COMMON_OFFSET_HPP

#include "masks.hpp"
#include "types.hpp"

constexpr auto fillbits(UnsignedIntegral auto bitcount) {
  return (1U << bitcount) - 1U;
}

constexpr auto offset(UnsignedIntegral auto inst, UnsignedIntegral auto low,
                      UnsignedIntegral auto high) {
  return (inst >> low) & fillbits(high - low + 1U);
}

namespace off {
constexpr uint8_t funct7(uint32_t w) {
  return static_cast<uint8_t>(offset(w, 25U, 31U));
}
constexpr uint8_t funct3(uint32_t w) {
  return static_cast<uint8_t>(offset(w, 12U, 14U));
}
constexpr uint8_t rs2(uint32_t w) {
  return static_cast<uint8_t>(offset(w, 20U, 24U));
}
constexpr uint8_t rs1(uint32_t w) {
  return static_cast<uint8_t>(offset(w, 15U, 19U));
}
constexpr uint8_t opc(uint32_t w) {
  return static_cast<uint8_t>(offset(w, 0U, 6U));
}
constexpr uint8_t rd(uint32_t w) {
  return static_cast<uint8_t>(offset(w, 7U, 11U));
}

} // namespace off

inline uint32_t rv32_imm_i(uint32_t x) {
  return static_cast<uint32_t>(static_cast<int32_t>(x) >> 20);
}

inline uint32_t rv32_imm_s(uint32_t x) {
  return (offset(x, 7U, 11U) |
          static_cast<uint32_t>(static_cast<int32_t>(x & 0xFE000000) >> 20));
}

inline uint32_t rv32_imm_b(uint32_t x) {
  return ((offset(x, 8U, 11U) << 1) | (offset(x, 25U, 30U) << 5) |
          (offset(x, 7U, 7U) << 11) |
          static_cast<uint32_t>(static_cast<int32_t>(x & masks::sign_bit) >>
                                19)) &
         0xFFFFFFFE;
}

inline uint32_t rv32_imm_u(uint32_t x) { return x & masks::type_u_imm; }

inline uint32_t rv32_imm_j(uint32_t x) {
  return (rv32_imm_i(x) & 0xFFF007FE) | (offset(x, 12U, 19U) << 12) |
         (offset(x, 20U, 20U) << 11);
}

#endif // COMMON_OFFSET_HPP

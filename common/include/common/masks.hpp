// SPDX-FileCopyrightText: 2022 - 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: MIT

#ifndef COMMON_CONSTS_HPP
#define COMMON_CONSTS_HPP

#include <cstdint>

namespace masks {
static constexpr uint32_t sign_bit = 0x80000000U;
static constexpr uint32_t lsb_zero = 0xFFFFFFFEU;
static constexpr uint32_t msb_zero = 0x7FFFFFFFU;
static constexpr uint32_t type_u_imm = 0xFFFFF000U;

namespace tvec {
static constexpr uint32_t type = 0x00000002U;
static constexpr uint32_t base_addr = 0xFFFFFFFCU;
} // namespace tvec

static constexpr uint32_t ecall = 0x73U;
static constexpr uint32_t ebreak = 0x9002U;
static constexpr uint32_t mret = 0x30200073U;
static constexpr uint32_t sret = 0x10200073U;
static constexpr uint32_t wfi = 0x10500073U;

} // namespace masks

#endif // COMMON_CONSTS_HPP

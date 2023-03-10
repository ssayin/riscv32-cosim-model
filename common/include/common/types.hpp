// SPDX-FileCopyrightText: 2022 - 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: MIT

#ifndef COMMON_TYPES_HPP
#define COMMON_TYPES_HPP

#include "masks.hpp"
#include "program_counter.hpp"

#include <string>
#include <type_traits>
#include <variant>

template <class T>
concept UnsignedIntegral =
    std::is_unsigned<T>::value && std::is_integral<T>::value;

template <typename T>
concept Enum = std::is_enum<T>::value;

template <typename T>
concept MemoryModel = requires(T mem, uint32_t addr, void *ptr, int64_t size) {
                        mem.write(addr, ptr, size);
                      };

constexpr auto to_int(Enum auto val) {
  return static_cast<std::underlying_type_t<decltype(val)>>(val);
}

#endif // COMMON_TYPES_HPP

# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: MIT

add_library(
  riscv32-decoder OBJECT
  src/decoder/decoder.cpp
  include/decoder/decoder.hpp
  include/decoder/rvc_isn.hpp
  include/decoder/rvc_ca.hpp
  include/decoder/rvc_cr.hpp
  include/decoder/rv32_isn.hpp
  src/decoder/decoder16.cpp)

target_include_directories(riscv32-decoder PUBLIC include)
target_link_libraries(riscv32-decoder PUBLIC riscv32-sim-common)

// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

#include "riscv-disas.h"
#include "decodesv.h"

#include <iostream>

extern "C" void disas(decoder_in_t *in) {
  char buf[128];
  bool is_compressed = (in->instr.aval & 0x3) != 0x3;
  disasm_inst(buf, 127, rv32, in->pc_in.aval, (rv_inst)in->instr.aval);
  std::cout << (is_compressed ? "[compressed] " : "") << buf << std::endl;
}

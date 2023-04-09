#include "svdpi.h"

#include "riscv-disas.h"

#include "decodesv.h"

#include <iostream>

extern "C" void disas(decoder_in_t *in) {
  char buf[128];
  disasm_inst(buf, 127, rv32, in->pc_in.aval, (rv_inst)in->instr.aval);
  std::cout << buf << std::endl;
}

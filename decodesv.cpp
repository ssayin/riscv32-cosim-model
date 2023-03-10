#include "decoder/decoder.hpp"
#include "svdpi.h"
#include <iostream>

extern "C" void decodesv(const svLogicVecVal *word, svLogicVecVal *out) {
  op dec = decode(word->aval);
#ifdef P1800_2005_VECVAL
  out->a = word->a;
  out->b = 0;
#else
  out->aval = word->aval;
  out->bval = 0;
#endif
  std::cout << (dec.tgt == target::illegal ? "illegal\n" : "legal\n");
}

extern "C" void init() {
  std::cout << "DPI_VERSION: " << svDpiVersion() << std::endl;
}

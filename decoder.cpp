
#include "svdpi.h"
#include <iostream>

extern "C" void decode(const svLogicVecVal *word, svLogicVecVal *out) {
  out->aval = word->aval;
  out->bval = 0;
}
extern "C" void init() {
  std::cout << "DPI_VERSION: " << svDpiVersion() << std::endl;
}

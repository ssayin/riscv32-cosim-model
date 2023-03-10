// SPDX-FileCopyrightText: 2022 - 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: MIT

#include "decoder/decoder.hpp"
#include "decoder/rv32_isn.hpp"
#include "decoder/rvc_ca.hpp"
#include "decoder/rvc_cr.hpp"
#include "decoder/rvc_isn.hpp"

namespace {
op decode16_quad0(uint16_t word);
op decode16_quad1(uint16_t word);
op decode16_quad2(uint16_t word);
} // namespace

op decode16(uint16_t word) {
  switch (word & 0b11) {
  case 0b00:
    return decode16_quad0(word);
  case 0b01:
    return decode16_quad1(word);
  case 0b10:
    return decode16_quad2(word);
  default:
    return make_illegal(true);
  }
}

namespace {
op decode16_quad0(uint16_t word) {
  switch (offset(word, 13U, 15U)) {
  case 0b000:
    if (word == 0U) return make_illegal(true);
    {
      rvc_addi4spn isn{word};
      return op{isn.imm, alu::_add, target::alu, isn.rd, 2,
                0,       true,      false,       true};
    }
  case 0b010: {
    rvc_lw isn{word};
    return op{isn.imm, masks::load::lw, target::load, isn.rd, isn.rs1, 0,
              true,    false,           true};
  }
  case 0b110: {
    rvc_sw isn{word};
    return op{isn.imm, masks::store::sw, target::store, 0,
              isn.rs1, isn.rs2,          true,          false,
              true};
  }
  default:
    return make_illegal(true);
  }
}

op decode16_quad1(uint16_t word) {
  switch (offset(word, 13U, 15U)) {
  case 0b000: {
    if (offset(word, 7U, 11U) == 0U) {
      return make_nop(true);
    } else {
      rvc_addi isn{word};
      return op{isn.imm, alu::_add, target::alu, isn.rdrs1, isn.rdrs1,
                0,       true,      false,       true};
    }
  }
  case 0b001: {
    rvc_jal isn{word};
    return op{isn.tgt, alu::_jal, target::alu, 1, 0, 0, true, true, true};
  }
  case 0b010: {
    rvc_li isn{word};
    return op{isn.imm, alu::_add, target::alu, isn.rdrs1, 0,
              0,       true,      false,       true};
  }

  case 0b011: {
    if (offset(word, 7U, 11U) == 2) {
      rvc_addi16sp isn{word};
      return op{isn.imm, alu::_add, target::alu, isn.rdrs1, 2,
                2,       true,      false,       true};
    } else {
      rvc_lui isn{word};
      return op{isn.imm, alu::_add, target::alu, isn.rdrs1, 0,
                0,       true,      false,       true};
    }
  }
  case 0b100: {
    switch (offset(word, 10U, 11U)) {
    case 0b00: {
      rvc_srli isn{word};
      return op{isn.ofs, alu::_srl, target::alu, isn.rs1, isn.rs1,
                0,       true,      false,       true};
    }
    case 0b01: {
      rvc_srai isn{word};
      return op{isn.ofs, alu::_sra, target::alu, isn.rs1, isn.rs1,
                0,       true,      false,       true};
    }
    case 0b10: {
      rvc_andi isn{word};
      return op{isn.ofs, alu::_and, target::alu, isn.rs1, isn.rs1,
                0,       true,      false,       true};
    }
    case 0b11: {
      switch ((offset(word, 12U, 12U) << 2) | offset(word, 5U, 6U)) {
      case 0b000: /*sub*/ {
        rvc_sub isn{word};
        return op{0,       alu::_sub, target::alu, isn.rdrs1, isn.rdrs1,
                  isn.rs2, false,     false,       true};
      }
      case 0b001: /*xor*/ {
        rvc_xor isn{word};
        return op{0,       alu::_xor, target::alu, isn.rdrs1, isn.rdrs1,
                  isn.rs2, false,     false,       true};
      }
      case 0b010: /*or*/ {
        rvc_or isn{word};
        return op{0,       alu::_or, target::alu, isn.rdrs1, isn.rdrs1,
                  isn.rs2, false,    false,       true};
      }
      case 0b011: /*and*/ {
        rvc_and isn{word};
        return op{0,       alu::_and, target::alu, isn.rdrs1, isn.rdrs1,
                  isn.rs2, false,     false,       true};
      }
      case 0b100:
      case 0b101:
      case 0b110:
      case 0b111:
        return make_illegal(true);
      }
    }
    default:
      return make_illegal(true);
    }
  }
  case 0b101: /*j*/ {
    rvc_j isn{word};
    return op{isn.tgt, alu::_jal, target::alu, 0, 0, true, true, true};
  }
  case 0b110: /*beqz*/ {
    rvc_beqz isn{word};
    return op{
        isn.ofs, masks::branch::beq, target::branch, 0, isn.rs1, 0, true, false,
        true};
  }
  case 0b111: /*bnez*/ {
    rvc_bnez isn{word};
    return op{
        isn.ofs, masks::branch::bne, target::branch, 0, isn.rs1, 0, true, false,
        true};
  }
  default:
    return make_illegal(true);
  }
}

op decode16_quad2(uint16_t word) {
  switch (offset(word, 13U, 15U)) {
  case 0b000: /*slli*/
  {
    rvc_slli isn{word};
    return op{isn.imm,   alu::_sll, target::alu, isn.rdrs1, isn.rdrs1,
              isn.rdrs1, true,      false,       true};
  }
  case 0b001:
    return make_illegal(true);
  case 0b010: /*lwsp*/ {
    rvc_lwsp isn{word};
    return op{isn.imm, masks::load::lw, target::load, isn.rdrs1, 2, 0,
              true,    false,           true};
  }
  case 0b011:
    return make_illegal(true);
  case 0b100: {
    auto _26  = offset(word, 2U, 6U);
    auto _711 = offset(word, 7U, 11U);
    switch (offset(word, 12U, 12U)) {
    case 0b0: {
      if (_26 == 0U && _711 != 0U) /*jr*/ {
        rvc_jr isn{word};
        return op{0,       alu::_jalr, target::alu, 0,   isn.rdrs1,
                  isn.rs2, false,      false,       true};
      }
      if (_26 != 0U && _711 != 0U) /*mv*/ {
        rvc_mv isn{word};
        return op{0,       alu::_add, target::alu, isn.rdrs1, 0,
                  isn.rs2, false,     false,       true};
      }
    }
    case 0b1: {
      if (_26 == 0 && _711 == 0) /* ebreak*/ {
        return op{0, {}, target::ebreak, 0, 0, 0, false, false, true};
      }
      if (_26 == 0 && _711 != 0) /*jalr*/ {
        rvc_jalr isn{word};
        return op{0,       alu::_jalr, target::alu, 1,   isn.rdrs1,
                  isn.rs2, false,      false,       true};
      }

      if (_26 != 0 && _711 != 0) /*add*/ {
        rvc_add isn{word};
        return op{0,       alu::_add, target::alu, isn.rdrs1, isn.rdrs1,
                  isn.rs2, false,     false,       true};
      }
      return make_illegal(true);
    }
    default:
      return make_illegal(true);
    }
  }

  case 0b110: /*swsp*/ {
    rvc_swsp isn{word};
    return op{isn.imm, masks::store::sw, target::store, 0,
              2,       isn.rs2,          true,          false,
              true};
  }
  case 0b101:
  case 0b111:
  default:
    return make_illegal(true);
  }
}
} // namespace

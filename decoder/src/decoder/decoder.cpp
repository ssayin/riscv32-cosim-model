// SPDX-FileCopyrightText: 2022 - 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: MIT

#include "decoder/decoder.hpp"
#include "decoder/rv32_isn.hpp"

#define RV32_LOAD(name)                                                        \
  case masks::load::name:                                                      \
    return make_load<rv32_##name>(word, masks::load::name);

#define RV32_STORE(name)                                                       \
  case masks::store::name:                                                     \
    return make_store<rv32_##name>(word, masks::store::name);

#define RV32_CSR(name)                                                         \
  case masks::sys::name:                                                       \
    return make_csr<rv32_##name>(word, masks::sys::name);

#define RV32_REG_IMM(name)                                                     \
  case name##i:                                                                \
    return make_reg_imm<rv32_##name##i>(word, alu::_##name);

#define RV32_BRANCH(name)                                                      \
  case masks::branch::name:                                                    \
    return make_branch<rv32_##name>(word, masks::branch::name);

#define RV32_REG_REG(name, funct7)                                             \
  case funct7: {                                                               \
    rv32_##name isn{word};                                                     \
    return op{0, alu::_##name, target::alu, isn.rd, isn.rs1, isn.rs2, false};  \
  }

namespace {
template <typename T> inline op make_store(uint32_t word, masks::store type) {
  T isn{word};
  return op{isn.imm, type, target::store, 0, isn.rs1, isn.rs2, true};
}

template <typename T> inline op make_load(uint32_t word, masks::load type) {
  T isn{word};
  return op{isn.imm, type, target::load, isn.rd, isn.rs, 0, true};
}

template <typename T> inline op make_csr(uint32_t word, masks::sys type) {
  T isn{word};
  return op{isn.csr, type, target::csr, isn.rd, isn.rs, 0, true};
}

template <typename T> inline op make_branch(uint32_t word, masks::branch type) {
  T isn{word};
  return op{isn.imm, type, target::branch, 0, isn.rs1, isn.rs2, true};
}

template <typename T> inline op make_reg_imm(uint32_t word, alu type) {
  T isn{word};
  return op{isn.imm, type, target::alu, isn.rd, isn.rs, 0, true};
}

op decode_load(uint32_t word);
op decode_store(uint32_t word);
op decode_branch(uint32_t word);
op decode_reg_imm(uint32_t word);
op decode_alu(uint32_t word);
op decode_sys(uint32_t word);
op decode_fence(uint32_t word);

} // namespace

op decode(uint32_t word) {
  switch (word) {
  case masks::ecall:
    return op{0, {}, target::ecall, 0, 0, 0, false};
  case masks::ebreak:
    return op{0, {}, target::ebreak, 0, 0, 0, false};
  case masks::mret:
    return op{0, {}, target::mret, 0, 0, 0, false};
  case masks::sret:
  case masks::wfi:
    return make_nop();
  default:
    break;
  }

  switch (masks::opcode{off::opc(word)}) {
    using enum masks::opcode;
  case auipc: {
    rv32_auipc isn{word};
    return op{isn.imm, alu::_auipc, target::alu, isn.rd, 0, 0, true, true};
  }
  case lui: {
    rv32_lui isn{word};
    return op{isn.imm, alu::_add, target::alu, isn.rd, 0, 0, true};
  }
  case jal: {
    rv32_jal isn{word};
    return op{isn.imm, alu::_jal, target::alu, isn.rd, 0, 0, true, true};
  }
  case jalr: {
    rv32_jalr isn{word};
    return op{isn.imm, alu::_jalr, target::alu, isn.rd, isn.rs, 0, true};
  }
  case load:
    return decode_load(word);
  case store:
    return decode_store(word);
  case branch:
    return decode_branch(word);
  case reg_imm:
    return decode_reg_imm(word);
  case reg_reg:
    return decode_alu(word);
  case sys:
    return decode_sys(word);
  case misc_mem:
    return decode_fence(word);
  default:
    return make_illegal();
  }
}

namespace {

op decode_load(uint32_t word) {
  switch (masks::load{off::funct3(word)}) {
    RV32_LOAD(lb)
    RV32_LOAD(lh)
    RV32_LOAD(lw)
    RV32_LOAD(lbu)
    RV32_LOAD(lhu)
  default:
    return make_illegal();
  }
}

op decode_store(uint32_t word) {
  switch (masks::store{off::funct3(word)}) {
    RV32_STORE(sb)
    RV32_STORE(sh)
    RV32_STORE(sw)
  default:
    return make_illegal();
  }
}

op decode_alu_and_remu(uint32_t word) {
  switch (off::funct7(word)) {
    RV32_REG_REG(and, 0x0)
    RV32_REG_REG(remu, 0x1)
  default:
    return make_illegal();
  }
}

op decode_alu_or_rem(uint32_t word) {
  switch (off::funct7(word)) {
    RV32_REG_REG(or, 0x0)
    RV32_REG_REG(rem, 0x1)
  default:
    return make_illegal();
  }
}

op decode_alu_xor_div(uint32_t word) {
  switch (off::funct7(word)) {
    RV32_REG_REG(xor, 0x0)
    RV32_REG_REG(div, 0x1)
  default:
    return make_illegal();
  }
}

op decode_alu_add_sub_mul(uint32_t word) {
  switch (off::funct7(word)) {
    RV32_REG_REG(add, 0x0)
    RV32_REG_REG(mul, 0x1)
    RV32_REG_REG(sub, 0x20)
  default:
    return make_illegal();
  }
}

op decode_alu_sll_mulh(uint32_t word) {
  switch (off::funct7(word)) {
    RV32_REG_REG(sll, 0x0)
    RV32_REG_REG(mulh, 0x1)
  default:
    return make_illegal();
  }
}

op decode_alu_srl_sra_divu(uint32_t word) {
  switch (off::funct7(word)) {
    RV32_REG_REG(srl, 0x0)
    RV32_REG_REG(divu, 0x1)
    RV32_REG_REG(sra, 0x20)
  default:
    return make_illegal();
  }
}

op decode_alu_slt_mulhsu(uint32_t word) {
  switch (off::funct7(word)) {
    RV32_REG_REG(slt, 0x0)
    RV32_REG_REG(mulhsu, 0x1)
  default:
    return make_illegal();
  }
}

op decode_alu_sltu_mulhu(uint32_t word) {
  switch (off::funct7(word)) {
    RV32_REG_REG(sltu, 0x0)
    RV32_REG_REG(mulhu, 0x1)
  default:
    return make_illegal();
  }
}

op decode_alu(uint32_t word) {
  switch (masks::reg_reg{off::funct3(word)}) {
    using enum masks::reg_reg;
  case and_remu:
    return decode_alu_and_remu(word);
  case or_rem:
    return decode_alu_or_rem(word);
  case xor_div:
    return decode_alu_xor_div(word);
  case add_sub_mul:
    return decode_alu_add_sub_mul(word);
  case sll_mulh:
    return decode_alu_sll_mulh(word);
  case srl_sra_divu:
    return decode_alu_srl_sra_divu(word);
  case slt_mulhsu:
    return decode_alu_slt_mulhsu(word);
  case sltu_mulhu:
    return decode_alu_sltu_mulhu(word);
  default:
    return make_illegal();
  }
}

op decode_reg_imm(uint32_t word) {
  switch (masks::reg_imm{off::funct3(word)}) {
    using enum masks::reg_imm;
    RV32_REG_IMM(add)
    RV32_REG_IMM(slt)
    RV32_REG_IMM(xor)
    RV32_REG_IMM(or)
    RV32_REG_IMM(and)
    RV32_REG_IMM(sll)

  case srli_srai: {
    constexpr int srli = 0x0;
    constexpr int srai = 0x20;
    switch (off::funct7(word)) {
      RV32_REG_IMM(srl)
      RV32_REG_IMM(sra)
    default:
      return make_illegal();
    }
  }

  case sltiu: {
    rv32_sltiu isn{word};
    return op{isn.imm, alu::_sltu, target::alu, isn.rd, isn.rs, 0, true};
  }
  default:
    return make_illegal();
  }
}

op decode_branch(uint32_t word) {
  switch (masks::branch{off::funct3(word)}) {
    RV32_BRANCH(beq)
    RV32_BRANCH(bne)
    RV32_BRANCH(blt)
    RV32_BRANCH(bltu)
    RV32_BRANCH(bge)
    RV32_BRANCH(bgeu)
  default:
    return make_illegal();
  }
}

op decode_fence(uint32_t word) { return make_nop(); }

op decode_sys(uint32_t word) {
  switch (masks::sys{off::funct3(word)}) {
    RV32_CSR(csrrw)
    RV32_CSR(csrrs)
    RV32_CSR(csrrc)
    RV32_CSR(csrrwi)
    RV32_CSR(csrrsi)
    RV32_CSR(csrrci)
  default:
    return make_illegal();
  }
}
} // namespace

#undef RV32_REG_REG
#undef RV32_LOAD
#undef RV32_STORE
#undef RV32_REG_IMM
#undef RV32_BRANCH
#undef RV32_CSR

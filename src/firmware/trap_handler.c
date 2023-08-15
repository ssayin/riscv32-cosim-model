// SPDX-FileCopyrightText: 2022 - 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

extern void _start_trap_handler() __attribute__((naked, noreturn));
extern void handle_ebreak() __attribute__((naked, noreturn));
extern void illegal_trap_handler() __attribute__((naked, noreturn));
extern void breakpoint_handler() __attribute__((naked, noreturn));
extern void exit_trap_handler() __attribute__((naked, noreturn));

void _start_trap_handler() {
  asm("csrr a0, mcause; li t0, 2; bne a0, t0, %[ebreak]; jal %[illegal];" ::
          [ebreak] "r"(handle_ebreak),
      [illegal] "r"(illegal_trap_handler));
}

void handle_ebreak() {
  asm("csrr    a0, mcause; li t0, 3; bne     a0, t0, %[exit]; jal %[illegal]" ::
          [exit] "r"(exit_trap_handler),
      [illegal] "r"(illegal_trap_handler));
}

void illegal_trap_handler() { asm("li a0, 1; li a7, 93; ecall"); }

void breakpoint_handler() { asm("mret"); }

void exit_trap_handler() { asm("mret"); }

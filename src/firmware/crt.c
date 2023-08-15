// SPDX-FileCopyrightText: 2022 - 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

#include <stdint.h>

extern void _entry() __attribute__((naked, section(".text.init")));
extern void _start() __attribute__((noreturn));
extern void _exit(int) __attribute__((noreturn, noinline));

void _entry() {
  __asm__ volatile("li x1, 0;"
                   "li x4, 0;"
                   "li x5, 0;"
                   "li x6, 0;"
                   "li x7, 0;"
                   "li x8, 0;"
                   "li x9, 0;"
                   "li x10, 0;"
                   "li x11, 0;"
                   "li x12, 0;"
                   "li x13, 0;"
                   "li x14, 0;"
                   "li x15, 0;"
                   "li x16, 0;"
                   "li x17, 0;"
                   "li x18, 0;"
                   "li x19, 0;"
                   "li x20, 0;"
                   "li x21, 0;"
                   "li x22, 0;"
                   "li x23, 0;"
                   "li x24, 0;"
                   "li x25, 0;"
                   "li x26, 0;"
                   "li x27, 0;"
                   "li x28, 0;"
                   "li x29, 0;"
                   "li x30, 0;"
                   "li x31, 0;"
                   ".option push;"
                   ".option norelax;"
                   "la gp, __global_pointer$;"
                   ".option pop;"
                   "la sp, _sp;"
                   "jal zero, _start;");
}

extern int main();

volatile uint32_t tohost;

void _exit(int ret) { tohost = ret; }

void _start() {
  int ret = main();
  _exit(ret);
}

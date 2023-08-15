// SPDX-FileCopyrightText: 2022 - 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

.option arch, +zicsr
.section .text

.globl _start_trap_handler
_start_trap_handler:
    # check the cause of the exception
    csrr    a0, mcause
    li      t0, 2
    bne     a0, t0, handle_ebreak     # if it's not an illegal instruction, it might be an ebreak
    jal     illegal_trap_handler      # otherwise, jump to our illegal instruction handler

.globl handle_ebreak
handle_ebreak:
    csrr    a0, mcause
    li      t0, 3
    bne     a0, t0, exit_trap_handler # if it's not an ebreak, we don't know how to handle it
    jal     illegal_trap_handler       # otherwise, jump to our breakpoint handler

.globl illegal_trap_handler 
illegal_trap_handler:
    li      a0, 1                     # illegal instruction cause is 1
    li      a7, 93                    # __NR_exit is 93
    ecall                             # exit the program

.globl breakpoint_handler
breakpoint_handler:
    mret                              # return from the exception

.globl exit_trap_handler
exit_trap_handler:
    mret                              # return from the exception

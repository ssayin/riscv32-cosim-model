/* SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com> */
/* SPDX-License-Identifier: Apache-2.0 */

OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv",
	      "elf32-littleriscv")
OUTPUT_ARCH(riscv)
ENTRY(_entry)
SECTIONS
{
PROVIDE(_stack_size = 0x200);
. = 0x0;
.text.init : { *(.text.init) }
.tohost : { *(.tohost) }
.text : { *(.text) }
.data : { 
  *(.data);
  PROVIDE( __global_pointer$ = . + 0x200 );
}
.bss : { *(.bss) }
.stack (NOLOAD) : ALIGN(16) { 
  PROVIDE(stack_begin = . );
  . += _stack_size;
  PROVIDE(_sp = . ); 
  PROVIDE(stack_end = . );
}
_end = .;
}

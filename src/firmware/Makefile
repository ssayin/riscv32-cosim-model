# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

ARCH          = rv32imc
ABI           = ilp32

RISCV         ?= /usr
RV32          = $(RISCV)/bin/riscv32-unknown-elf-

CROSSCC       = $(RV32)gcc
CROSSCFLAGS   = -Og -g -Wall -march=$(ARCH) -mabi=$(ABI) -ffunction-sections 
CROSSAR       = $(RV32)ar
CROSSAS       = $(RV32)as
CROSSOBJDUMP  = $(RV32)objdump
CROSSOBJCOPY  = $(RV32)objcopy

DW            = 1 # In bytes

CROSSLDSCRIPT = $(FIRMWARE_DIR)serdar.lds
CROSSLDFLAGS  = -nostartfiles -fno-exceptions -T ${CROSSLDSCRIPT}

firmware: $(FIRMWARE_DIR)boot.hex

$(FIRMWARE_DIR)%.hex: $(FIRMWARE_DIR)%.elf
	$(CROSSOBJCOPY) -O verilog --verilog-data-width=$(DW) $^ $@

$(FIRMWARE_DIR)boot.elf: $(FIRMWARE_DIR)boot.o $(FIRMWARE_DIR)crt.o
	$(CROSSCC) $(CROSSCFLAGS) $^ -o $@ $(CROSSLDFLAGS) -Wl,-Map=$(basename $@).map

$(FIRMWARE_DIR)%.o: $(FIRMWARE_DIR)%.c
	$(CROSSCC) $(CROSSCFLAGS) -c $^ -o $@

#!/bin/sh

# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

set -e

make clean

make firmware

echo "00 00" >> ./src/firmware/boot.hex

make SIM=verilator

./obj_dir/Vfpga_top 5

riscv32-unknown-elf-objdump -M numeric -d --visualize-jumps=extended-color ./src/firmware/boot.elf

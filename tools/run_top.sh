#!/bin/sh

# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

set -e

make cleaner
make firmware
make DUMPVCD=1
echo "00 00" >> ./src/firmware/boot.hex
./scripts/top | tee top.log
riscv32-unknown-elf-objdump -M numeric -d --visualize-jumps=extended-color src/firmware/boot.elf

# gtkwave riscv_core.gtkw & disown

flag=0

# Strip date from the log
# if diff <(head -n -1 ./ref/top.log) <(head -n -1 top.log);
# then
#   echo -e "\e[32mLOG OK\e[0m"
# else
#   echo -e "\e[31mLOG ERROR\e[0m"
#   flag=1
# fi

# Strip date from the dump
#if diff <(tail -n +4 ./ref/riscv_core.vcd) <(tail -n +4 riscv_core.vcd) >/dev/null;
#then
#  echo -e "\e[32mVCD OK\e[0m"
#else
#  echo -e "\e[31mVCD ERROR\e[0m"
#  flag=1
#fi

exit "$flag"

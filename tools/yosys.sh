#!/bin/sh

# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

yosys -s src/rtl/riscv_core.ys | tee yosys.log

netlistsvg schematic.json -o schematic.svg

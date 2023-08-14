#!/bin/sh

# SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
#
# SPDX-License-Identifier: Apache-2.0

# Vivado FPGA flow

TCL_VIVADO=tools/vivado.tcl

if test "${TCL_VIVADO}"; then
  vivado -mode batch -source tools/vivado.tcl
else
  echo "$0: ${TCL_VIVADO} does not exist."
fi

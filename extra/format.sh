#!/bin/sh

find src/rtl/core -type f -name "*.sv" -exec verible-verilog-format --flagfile $HOME/.config/.verilog_format --inplace "{}" \;
find src/rtl/core -maxdepth 1 -type f -name "*.sv" -exec verible-verilog-format --flagfile $HOME/.config/.verilog_format --inplace "{}" \;
find src/rtl/lib -type f -name "*.sv" -exec verible-verilog-format --flagfile $HOME/.config/.verilog_format --inplace "{}" \;

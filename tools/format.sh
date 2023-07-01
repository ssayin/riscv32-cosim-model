#!/bin/sh

find src/ -type f -name "*.sv" -exec verible-verilog-format --inplace "{}" \;

// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

#include <iostream>
#include <memory>
#include <string>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <verilated_vpi.h>

#include "Vfpga_top.h"

double sc_time_stamp() { return 0; }

int main(int argc, char **argv, char **env) {

  if (argc < 2) {
    return 1;
  }

  const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};

  contextp->debug(0);

  contextp->traceEverOn(true);

  contextp->commandArgs(argc, argv);

  const std::unique_ptr<Vfpga_top> cont{new Vfpga_top{contextp.get(), "top"}};

  VerilatedVcdC *m_trace = new VerilatedVcdC;
  cont->trace(m_trace, 50000);
  m_trace->open("top_level_verilator.vcd");

  contextp->internalsDump();

  cont->clk = 0;
  cont->clk0 = 0;
  cont->clk1 = 0;
  cont->rst_n = 0;
  cont->eval();

  int imax = argc == 1 ? 300 : atoi(argv[1]);

  for (std::size_t i = 0; i < imax; i++) {
    contextp->timeInc(1);
    cont->eval();
    // printf("%s [%zu]\n", (i % 2) ? "-" : "+", i / 2);
    if (i == 5)
      cont->rst_n = 1;
    VerilatedVpi::callValueCbs();
    m_trace->dump(i);
    cont->clk = !cont->clk;
    cont->clk0 = !cont->clk0;
    cont->clk1 = !cont->clk1;
  }
  cont->final();

  delete m_trace;
  m_trace = 0;

  return 0;
}

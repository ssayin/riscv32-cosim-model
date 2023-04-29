`ifndef RISCV_CORE_ENV_PKG
`define RISCV_CORE_ENV_PKG

package riscv_core_env_pkg;
  import uvm_pkg::*;

  `include "uvm_macros.svh"

  import riscv_core_agent_pkg::*;
  import riscv_core_ref_model_pkg::*;

  `include "riscv_core_scoreboard.sv"
  `include "riscv_core_coverage.sv"
  `include "riscv_core_env.sv"

endpackage : riscv_core_env_pkg

`endif



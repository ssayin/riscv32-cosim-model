`ifndef RISCV_DECODER_ENV_PKG
`define RISCV_DECODER_ENV_PKG

package riscv_decoder_env_pkg;
  import uvm_pkg::*;

  `include "uvm_macros.svh"

  import riscv_decoder_agent_pkg::*;
  import riscv_decoder_ref_model_pkg::*;

  `include "riscv_decoder_scoreboard.sv"
  `include "riscv_decoder_coverage.sv"
  `include "riscv_decoder_env.sv"

endpackage : riscv_decoder_env_pkg

`endif



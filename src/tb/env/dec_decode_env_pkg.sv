`ifndef DEC_DECODE_ENV_PKG
`define DEC_DECODE_ENV_PKG

package dec_decode_env_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import dec_decode_agent_pkg::*;
  import dec_decode_ref_model_pkg::*;

  `include "dec_decode_scoreboard.sv"
  `include "dec_decode_coverage.sv"
  `include "dec_decode_env.sv"

endpackage : dec_decode_env_pkg

`endif



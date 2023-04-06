`ifndef DEC_DECODE_AGENT_PKG
`define DEC_DECODE_AGENT_PKG

package dec_decode_agent_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"

  `include "dec_decode_def.sv"
  `include "dec_decode_transaction.sv"
  `include "dec_decode_sequencer.sv"
  `include "dec_decode_driver.sv"
  `include "dec_decode_monitor.sv"
  `include "dec_decode_agent.sv"

endpackage : dec_decode_agent_pkg

`endif

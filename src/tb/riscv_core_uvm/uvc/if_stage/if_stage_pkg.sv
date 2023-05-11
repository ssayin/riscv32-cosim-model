// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

package if_stage_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"

  `include "if_stage_agent.sv"
  `include "if_stage_monitor.sv"
  `include "if_stage_driver.sv"
  `include "if_stage_sequencer.sv"
  `include "if_stage_sequence.sv"

endpackage : if_stage_pkg

// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

package id_stage_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"

  `include "id_stage_agent.sv"
  `include "id_stage_monitor.sv"
  `include "id_stage_driver.sv"
  `include "id_stage_sequencer.sv"
  `include "id_stage_sequence.sv"

endpackage : id_stage_pkg

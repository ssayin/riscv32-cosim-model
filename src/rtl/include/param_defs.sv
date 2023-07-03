// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

package param_defs;

  // Do not change these values.
  localparam int AddrWidth = 32;
  localparam int DataWidth = 32;
  localparam int RegCount = 32;
  localparam int RegAddrWidth = (RegCount > 1) ? $clog2(RegCount) : 0;
  localparam int AluOpWidth = 5;
  localparam int LsuOpWidth = 4;
  localparam int BranchOpWidth = 3;

  localparam int MemBusWidth = 32;

endpackage

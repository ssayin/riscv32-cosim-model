// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module reg_file #(
    parameter int DW = 32
) (
  input  logic          clk,
  input  logic [   4:0] rd_addr_wb,
  input  logic [   4:0] rs1_addr_r,
  input  logic [   4:0] rs2_addr_r,
  input  logic [DW-1:0] rd_data_wb,
  input  logic          rd_en_wb,
  output logic [DW-1:0] rs1_data_e,
  output logic [DW-1:0] rs2_data_e
);
  // Register File
  reg [DW-1:0] reg_file[1:31];

  // Write ports
  always_ff @(posedge clk) begin
    if ((rd_addr_wb != 5'h0) && rd_en_wb) begin
      reg_file[rd_addr_wb] <= rd_data_wb;
`ifdef DEBUG
      $display("[REGFILE] writing 0x%X x%-0d", rd_data_wb, rd_addr_wb);
`endif
    end
  end
  // Read ports
  always_ff @(posedge clk) rs1_data_e <= (rs1_addr_r != 0) ? reg_file[rs1_addr_r] : 0;
  always_ff @(posedge clk) rs2_data_e <= (rs2_addr_r != 0) ? reg_file[rs2_addr_r] : 0;

endmodule

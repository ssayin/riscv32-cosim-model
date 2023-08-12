// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0
module reg_file #(
    parameter int DATA_WIDTH = 32
) (
  input  logic                  clk,
  input  logic                  rst_n,
  input  logic [           4:0] rd_addr_wb,
  input  logic [           4:0] rs1_addr_r,
  input  logic [           4:0] rs2_addr_r,
  input  logic [DATA_WIDTH-1:0] rd_data_wb,
  input  logic                  rd_en_wb,
  output logic [DATA_WIDTH-1:0] rs1_data_e,
  output logic [DATA_WIDTH-1:0] rs2_data_e
);
  // Register File
  reg [DATA_WIDTH-1:0] reg_file[1:31];

  // Write ports
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int j = 1; j < 32; j++) begin
        reg_file[j] <= {DATA_WIDTH{1'b0}};
      end
    end else if ((rd_addr_wb != 5'h0) && rd_en_wb) begin
      reg_file[rd_addr_wb] <= rd_data_wb;
    end
  end
  // Read ports
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rs1_data_e <= 0;
      rs2_data_e <= 0;
    end else begin
      rs1_data_e <= (rs1_addr_r != 0) ? reg_file[rs1_addr_r] : 0;
      rs2_data_e <= (rs2_addr_r != 0) ? reg_file[rs2_addr_r] : 0;
    end
  end
endmodule

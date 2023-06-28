// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module reg_file #(
    parameter int DATA_WIDTH = 32
) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic [           4:0] rd_addr,
    input  logic [           4:0] rs1_addr,
    input  logic [           4:0] rs2_addr,
    input  logic [DATA_WIDTH-1:0] rd_data,
    input  logic                  wr_en,
    input  logic                  byte_wr_en,
    input  logic                  half_wr_en,
    output logic [DATA_WIDTH-1:0] rs1_data,
    output logic [DATA_WIDTH-1:0] rs2_data
);

  // Register File
  reg [DATA_WIDTH-1:0] reg_file[32];

  // Write ports
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int j = 0; j < 32; j++) begin
        reg_file[j] <= {DATA_WIDTH{1'b0}};
      end
    end else begin
      if (rd_addr != 5'h0) begin
        reg_file[rd_addr] <= rd_data;
      end
      rs1_data <= reg_file[rs1_addr];
      rs2_data <= reg_file[rs2_addr];
    end
  end
endmodule

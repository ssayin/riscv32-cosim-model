// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module _4_wb_stage (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [31:0] i_mem_wb_data,
  input  logic [31:0] i_mem_wb_alu_res,
  input  logic [31:0] i_mem_wb_rd,
  output logic [31:0] o_wb_data
);
  logic reg_write;
  logic mem_read;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      o_wb_data <= 32'b0;
    end else begin
      if (reg_write) begin
        // Write data back to the register file
        if (mem_read) begin
          o_wb_data <= i_mem_wb_data;
        end else begin
          o_wb_data <= i_mem_wb_alu_res;
        end
      end
    end
  end

endmodule : _4_wb_stage

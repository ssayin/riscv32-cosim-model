// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module wb_stage
  import param_defs::*;
  import instr_defs::*;
(
  input  logic                    clk,
  input  logic                    rst_n,
  input  logic [   DataWidth-1:0] mem_wb_data,
  input  logic [   DataWidth-1:0] mem_wb_alu_res,
  input  logic [RegAddrWidth-1:0] mem_wb_rd,
  output logic [   DataWidth-1:0] wb_data
);
  logic reg_write;
  logic mem_read;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wb_data <= 'b0;
    end else begin
      if (reg_write) begin
        // Write data back to the register file
        if (mem_read) begin
          wb_data <= mem_wb_data;
        end else begin
          wb_data <= mem_wb_alu_res;
        end
      end else begin
        wb_data <= 'b0;  // No write-back
      end
    end
  end

endmodule : wb_stage

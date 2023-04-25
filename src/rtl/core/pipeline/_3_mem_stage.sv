// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module _3_mem_stage
(
  input  logic                    clk,
  input  logic                    rst_n,
  input  logic [   DataWidth-1:0] i_ex_mem_alu_res,  // Result from the previous stage
  input  logic [RegAddrWidth-1:0] i_ex_mem_rd,       // Destination register address (RD)
  input  logic [  LsuOpWidth-1:0] i_lsu_op,          // Memory access operation
  output logic [   DataWidth-1:0] o_mem_wb_data,     // Data read from mem or the imm i.e. AUIPC
  output logic [   DataWidth-1:0] o_mem_wb_alu_res,  // Carried from the EX-stage
  output logic [RegAddrWidth-1:0] o_mem_wb_rd        // Carried from the EX-stage
);

  import param_defs::*;
  import instr_defs::*;

  // Memory interface signals
  logic [ DataWidth-1:0] mem_data;
  logic [ DataWidth-1:0] mem_addr;
  logic                  mem_wr_en;
  logic [LsuOpWidth-1:0] lsu_op;

  /*
   * Logic[3]: 0 -> Load, 1 -> Store
   * Logic[2]: 0 -> Signed, 1 -> Unsigned (LBU and LHU only)
   * Logic[1-0]: 00 -> Byte,  ?1 -> Half, 10 -> Word
   */
  always_comb begin
    casez (i_lsu_op)
      LSU_LB: begin
      end
      LSU_LH: begin
      end
      LSU_LW: begin
      end
      LSU_LBU: begin
      end
      LSU_LHU: begin
      end
      LSU_SB: begin
      end
      LSU_SH: begin
      end
      LSU_SW: begin
      end
      default: begin
      end
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      o_mem_wb_data    <= 'b0;
      o_mem_wb_alu_res <= 'b0;
      o_mem_wb_rd      <= 'b0;
    end else begin
	   o_mem_wb_data    <= 'b0; // TODO: impl mem read
      o_mem_wb_alu_res <= i_ex_mem_alu_res;
      o_mem_wb_rd      <= i_ex_mem_rd;
    end
  end

endmodule : _3_mem_stage
// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module mem_stage
  import param_defs::*;
  import instr_defs::*;
(
  input  logic                    clk,
  input  logic                    rst_n,
  input  logic [   DataWidth-1:0] ex_mem_alu_res,  // Result from the previous stage
  input  logic [RegAddrWidth-1:0] ex_mem_rd,       // Destination register address (RD)
  input  logic [  LsuOpWidth-1:0] lsu_op,          // Memory access operation
  output logic [   DataWidth-1:0] mem_wb_data,     // Data read from mem or the imm i.e. AUIPC
  output logic [   DataWidth-1:0] mem_wb_alu_res,  // Carried from the EX-stage
  output logic [RegAddrWidth-1:0] mem_wb_rd        // Carried from the EX-stage
);


  // Memory interface signals
  logic [ DataWidth-1:0] mem_data;
  logic [ DataWidth-1:0] mem_addr;
  logic                  mem_wr_en;
  logic [LsuOpWidth-1:0] lsu_op_next;

  /*
   * Logic[3]: 0 -> Load, 1 -> Store
   * Logic[2]: 0 -> Signed, 1 -> Unsigned (LBU and LHU only)
   * Logic[1-0]: 00 -> Byte,  ?1 -> Half, 10 -> Word
   */
  always_comb begin
    casez (lsu_op)
      LSU_LB: begin
        mem_addr    = ex_mem_alu_res;  // Use ALU result as memory address
        lsu_op_next = lsu_op;
        mem_wr_en   = 0;
      end
      LSU_LH: begin
        mem_addr    = ex_mem_alu_res;  // Use ALU result as memory address
        lsu_op_next = lsu_op;
        mem_wr_en   = 0;
      end
      LSU_LW: begin
        mem_addr    = ex_mem_alu_res;  // Use ALU result as memory address
        lsu_op_next = lsu_op;
        mem_wr_en   = 0;
      end
      LSU_LBU: begin
        mem_addr    = ex_mem_alu_res;  // Use ALU result as memory address
        lsu_op_next = lsu_op;
        mem_wr_en   = 0;
      end
      LSU_LHU: begin
        mem_addr    = ex_mem_alu_res;  // Use ALU result as memory address
        lsu_op_next = lsu_op;
        mem_wr_en   = 0;
      end
      LSU_SB: begin
        mem_addr    = ex_mem_alu_res;  // Use ALU result as memory address
        mem_data    = ex_mem_rd;  // Use RD as data to store
        lsu_op_next = lsu_op;
        mem_wr_en   = 1;
      end
      LSU_SH: begin
        mem_addr    = ex_mem_alu_res;  // Use ALU result as memory address
        mem_data    = ex_mem_rd;  // Use RD as data to store
        lsu_op_next = lsu_op;
        mem_wr_en   = 1;
      end
      LSU_SW: begin
        mem_addr    = ex_mem_alu_res;  // Use ALU result as memory address
        mem_data    = ex_mem_rd;  // Use RD as data to store
        lsu_op_next = lsu_op;
        mem_wr_en   = 1;
      end
      default: begin
        mem_addr    = 'b0;  // Invalid memory address for unsupported operations
        mem_data    = 'b0;  // Invalid data for unsupported operations
        lsu_op_next = 'b0;  // Invalid LSU operation
        mem_wr_en   = 0;  // Disable memory write for unsupported operations
      end
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mem_wb_data    <= 'b0;
      mem_wb_alu_res <= 'b0;
      mem_wb_rd      <= 'b0;
    end else begin
      if (mem_wr_en) begin
        mem_data <= ex_mem_rd;
      end
      if (lsu_op[0]) begin  // Store operation
        mem_wb_data <= 'b0;
      end else begin  // Load operation
        mem_wb_data <= mem_data;
      end

      mem_wb_alu_res <= ex_mem_alu_res;
      mem_wb_rd      <= ex_mem_rd;
    end
  end

endmodule : mem_stage


// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module ex_stage
  import param_defs::*;
(
  input  logic                      clk,
  input  logic                      rst_n,
  input  logic                      rs1_data,
  input  logic                      rs2_data,
  input  p_id_ex_t                  p_id_ex,
  output p_ex_mem_t                 p_ex_mem,
  output logic                      should_br,
  output logic                      br_mispredictd,
  output logic      [DataWidth-1:0] br_target
);
  logic [DataWidth-1:0] res_next;
  logic                 should_br_next;

  always_comb begin
    if (p_id_ex.br) begin
      case (p_id_ex.br_op)
        BR_BEQ:  should_br_next = (rs1_data == rs2_data);
        BR_BGE:  should_br_next = ($signed(rs1_data) >= $signed(rs2_data));
        BR_BGEU: should_br_next = (rs1_data >= rs2_data);
        BR_BNEZ: should_br_next = (rs1_data != 0);
        BR_BLTU: should_br_next = (rs1_data < rs2_data);
        BR_BEQZ: should_br_next = (rs1_data == 0);
        BR_BLT:  should_br_next = ($signed(rs1_data) < $signed(rs2_data));
        BR_BNE:  should_br_next = (rs1_data != rs2_data);
        default: should_br_next = 0;
      endcase
    end else begin
      should_br_next = 'b0;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      p_ex_mem.alu_res <= 'b0;
      should_br        <= 'b0;
      br_target        <= 'h0;
    end else begin
      if (p_id_ex.br) begin
        if (!p_id_ex.br_taken && should_br_next) begin
          should_br      <= 'b1;
          br_mispredictd <= 'b0;
          br_target      <= p_id_ex.pc + p_id_ex.imm;
        end
        if (!should_br_next & p_id_ex.br_taken) begin
          br_target      <= p_id_ex.compressed ? (p_id_ex.pc + 2) : (p_id_ex.pc + 4);
          should_br      <= 'b0;
          br_mispredictd <= 'b1;
        end else begin
          should_br      <= 'b0;
          br_target      <= 'h0;
          br_mispredictd <= 'b0;
        end
      end else begin
        p_ex_mem.alu_res <= res_next;
        should_br        <= 'b0;
        br_target        <= 'h0;
        br_mispredictd   <= 'b0;
      end
    end
  end

  alu alu_0 (
    .a     (use_imm ? imm : rs1_data),
    .b     (rs2_data),
    .alu_op(alu_op),
    .res   (res_next)
  );

endmodule : ex_stage

import instr_defs::*;

module wb_stage (
  input logic      clk,
  input logic      rst_n,
  input p_mem_wb_t p_mem_wb
);

  always_ff @(posedge clk or negedge rst_n) begin
  end

endmodule

module mem_stage (
  input  logic             clk,
  input  logic             rst_n,
  input  p_ex_mem_t        p_ex_mem,
  input  logic      [31:0] mem_in,
  output p_mem_wb_t        p_mem_wb
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      p_mem_wb.rd_data <= 32'h0;
      p_mem_wb.rd_addr <= 32'h0;
      p_mem_wb.rd_en   <= 1'b0;
    end else begin
      p_mem_wb.rd_data <= p_ex_mem.lsu ? mem_in : p_ex_mem.alu_res;
      p_mem_wb.rd_addr <= p_ex_mem.rd_addr;
      p_mem_wb.rd_en   <= p_ex_mem.rd_en;
    end
  end

endmodule

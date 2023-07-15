module mem_stage (
  input  logic                       clk,
  input  logic                       rst_n,
  input  logic      [          31:0] mem_in,
  input  logic                       compressed_m,
  input  logic                       rd_en_m,
  input  reg_data_t                  alu_res_m,
  input  reg_data_t                  store_data_m,
  input  logic                       lsu_m,
  input  logic      [LsuOpWidth-1:0] lsu_op_m,
  input  logic                       br_taken_m,
  input  logic                       br_m,
  input  reg_addr_t                  rd_addr_m,
  output logic                       rd_en_wb,
  output reg_addr_t                  rd_addr_wb,
  output reg_data_t                  rd_data_wb
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_data_wb <= 32'h0;
      rd_addr_wb <= 32'h0;
      rd_en_wb   <= 1'b0;
    end else begin
      rd_data_wb <= lsu_m ? mem_in : alu_res_m;
      rd_addr_wb <= rd_addr_m;
      rd_en_wb   <= rd_en_m;
    end
  end

endmodule

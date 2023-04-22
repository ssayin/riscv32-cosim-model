module tb_top_level ();

  logic clk;
  logic rst_n;

  top_level top_level_0 (
    .clk  (clk),
    .rst_n(rst_n)
  );

  initial begin
    rst_n = 1'b0;
    #(5) rst_n = 1'b1;
    #(5) clk = 1'b0;


    for (int i = 0; i < 50; ++i) begin
      #(50) clk = ~clk;
    end
  end


endmodule

module tb_top_level ();

  logic   clk;
  logic   rst_n;

  integer cyc;

  top_level dut (.*);

  initial begin
    cyc = 0;
    clk = 0;
    #5 rst_n = 0;
    #2 rst_n = 1;
  end

  always #5000 clk = ~clk;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      $display("rst");
    end else begin
      if (cyc >= 10) $finish;
      cyc++;
    end
  end

endmodule

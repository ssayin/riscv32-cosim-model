
module test (
    input reg clk
);
  import "DPI-C" function void decodesv(
    input  logic [31:0] word,
    output logic [31:0] out
  );
  import "DPI-C" function void init();

  logic [31:0] res;

  logic [31:0] in;

  always #10 clk = ~clk;

  initial begin
    init();
    for (integer i = 0; i < 12; ++i) begin
      in = $urandom;
      decodesv(in, res);
      $display("%d - %d", in, res);
    end
    $finish;
  end
endmodule : test

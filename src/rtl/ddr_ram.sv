module ddr_ram #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32,
    parameter string INIT_FILE = "boot.hex"
) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [DATA_WIDTH-1:0] wr_data,
    input  logic                  wr_en,
    input  logic                  rd_en,
    output logic [DATA_WIDTH-1:0] rd_data
);

  logic [DATA_WIDTH-1:0] mem_array[0:2**ADDR_WIDTH - 1];

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      for (int i = 0; i < 2 ** ADDR_WIDTH; i++) begin
        mem_array[i] <= 0;
      end
    end else begin
      if (wr_en) begin
        mem_array[addr] <= wr_data;
      end
      if (rd_en) begin
        rd_data <= mem_array[addr];
      end
    end
  end

  initial begin
    $readmemh(INIT_FILE, mem_array);
  end
endmodule

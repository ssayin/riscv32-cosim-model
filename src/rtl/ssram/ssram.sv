module ssram #(
    parameter int ADDR_WIDTH = 10,
    parameter int DATA_WIDTH = 64   // divisible by 8
) (
  input  logic                    clka,
  input  logic                    rsta,
  input  logic                    ena,
  input  logic                    regcea,
  input  logic [DATA_WIDTH/8-1:0] wea,
  input  logic [  ADDR_WIDTH-1:0] addra,
  input  logic [  DATA_WIDTH-1:0] dina,
  output logic [  DATA_WIDTH-1:0] douta,
  input  logic                    clkb,
  input  logic                    rstb,
  input  logic                    enb,
  input  logic                    regceb,
  input  logic [DATA_WIDTH/8-1:0] web,
  input  logic [  ADDR_WIDTH-1:0] addrb,
  input  logic [  DATA_WIDTH-1:0] dinb,
  output logic [  DATA_WIDTH-1:0] doutb
);

  logic [DATA_WIDTH-1:0] mem_array[0:2**ADDR_WIDTH];

  always_ff @(posedge clka or negedge rsta) begin
    if (!rsta) begin
    end else if (!regcea) begin
      if (!wea) begin
        for (int i = 0; i < DATA_WIDTH / 8; i++) begin
          if (!wea[i]) begin
            mem_array[addra][8*i+:8] <= dina[8*i+:8];
          end
        end
      end
      if (!ena) begin
        for (int i = 0; i < DATA_WIDTH / 8; i++) begin
          douta[8*i+:8] <= mem_array[addra][8*i+:8];
        end
      end
    end
  end

  always_ff @(posedge clkb or negedge rstb) begin
    if (!rstb) begin
    end else if (!regceb) begin
      if (!web) begin
        for (int i = 0; i < DATA_WIDTH / 8; i++) begin
          if (!web[i]) begin
            mem_array[addrb][8*i+:8] <= dinb[8*i+:8];
          end
        end
      end
      if (!enb) begin
        for (int i = 0; i < DATA_WIDTH / 8; i++) begin
          doutb[8*i+:8] <= mem_array[addrb][8*i+:8];
        end
      end
    end
  end

endmodule

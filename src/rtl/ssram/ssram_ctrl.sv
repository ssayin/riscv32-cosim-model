// AXI4 Full SSRAM Controller Slave
// TODO: Impl.
import defs_pkg::*;
module ssram_ctrl (
  input  logic                  clk,
  input  logic                  rst_n,
  input  logic [AxiIdWidth-1:0] axi_awid,
  input  logic [          31:0] axi_awaddr,
  input  logic [           7:0] axi_awlen,
  input  logic [           2:0] axi_awsize,
  input  logic [           1:0] axi_awburst,
  input  logic                  axi_awlock,
  input  logic [           3:0] axi_awcache,
  input  logic [           2:0] axi_awprot,
  input  logic                  axi_awvalid,
  input  logic [           3:0] axi_awregion,
  input  logic [           3:0] axi_awqos,
  output logic                  axi_awready,
  input  logic [          63:0] axi_wdata,
  input  logic [           7:0] axi_wstrb,
  input  logic                  axi_wlast,
  input  logic                  axi_wvalid,
  output logic                  axi_wready,
  output logic [AxiIdWidth-1:0] axi_bid,
  output logic [           1:0] axi_bresp,
  output logic                  axi_bvalid,
  input  logic                  axi_bready,
  input  logic [AxiIdWidth-1:0] axi_arid,
  input  logic [          31:0] axi_araddr,
  input  logic [           7:0] axi_arlen,
  input  logic [           2:0] axi_arsize,
  input  logic [           1:0] axi_arburst,
  input  logic                  axi_arlock,
  input  logic [           3:0] axi_arcache,
  input  logic [           2:0] axi_arprot,
  input  logic                  axi_arvalid,
  input  logic [           3:0] axi_arqos,
  input  logic [           3:0] axi_arregion,
  output logic                  axi_arready,
  output logic [AxiIdWidth-1:0] axi_rid,
  output logic [          63:0] axi_rdata,
  output logic [           1:0] axi_rresp,
  output logic                  axi_rlast,
  output logic                  axi_rvalid,
  input  logic                  axi_rready,
  // SRAM ports
  output logic                  clka,
  output logic                  rsta,
  output logic                  ena,
  output logic [           7:0] wea,
  output logic [          31:0] addra,
  output logic [          63:0] dina,
  input  logic [          63:0] douta,
  output logic                  clkb,
  output logic                  rstb,
  output logic                  enb,
  output logic [           7:0] web,
  output logic [          31:0] addrb,
  output logic [          63:0] dinb,
  input  logic [          63:0] doutb
);
  logic [31:0] addr_porta;
  logic [31:0] addr_portb;
  assign addra = addr_porta;
  assign addrb = addr_portb;
  logic [1:0] aburst;
  logic [1:0] bburst;
  typedef enum logic [1:0] {
    IDLE,
    PREBURST,
    BURST
  } axi_state_t;
  axi_state_t state_porta = IDLE;
  axi_state_t state_porta_next = IDLE;
  axi_state_t state_portb = IDLE;
  axi_state_t state_portb_next = IDLE;
  always_comb begin
    case (state_porta)
      IDLE: begin
      end
      PREBURST: begin
      end
      BURST: begin
      end
      default: begin
      end
    endcase
  end
  always_comb begin
    case (state_portb)
      IDLE: begin
      end
      PREBURST: begin
      end
      BURST: begin
      end
      default: begin
      end
    endcase
  end
  assign axi_rdata[63:0] = douta[63:0];
  assign axi_rvalid      = 1;
  assign axi_arready     = 1;
  assign ena             = 0;
  assign enb             = 0;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
    end else begin
    end
  end
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      web[7:0]         <= 8'b11111111;
      addr_porta[31:0] <= 0;
      addr_portb[31:0] <= 0;
      // axi_rvalid       <= 0;
    end else begin
      if (axi_arvalid) begin
        addr_porta[31:0] <= axi_araddr[31:0];
        aburst[1:0]      <= axi_arburst[1:0];
        // axi_rvalid       <= 1;
      end
      if (axi_awvalid) begin
        addr_portb[31:0] <= axi_awaddr[31:0];
        axi_awready      <= 1;
        bburst[1:0]      <= axi_awburst[1:0];
        web[7:0]         <= 8'b00000000;
      end
    end
  end
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      axi_rvalid <= 0;
      axi_wready <= 0;
    end else begin
      if (axi_rready && axi_rvalid) begin
        //axi_rdata[63:0] <= douta[63:0];
        if (aburst == INCR) addr_porta <= addr_porta + 8;
      end
      if (axi_wvalid) begin
        dinb[63:0] <= axi_wdata[63:0];
        axi_wready <= 1;
        if (bburst == INCR) addr_portb <= addr_portb + 8;
      end
    end
  end
endmodule

typedef struct packed {
  logic [1:0]  arid;
  logic [31:0] araddr;
  logic [7:0]  arlen;
  logic [2:0]  arsize;
  logic [1:0]  arburst;
  logic        arlock;
  logic [3:0]  arcache;
  logic [2:0]  arprot;
  logic        arvalid;
  logic [3:0]  arqos;
  logic [3:0]  arregion;
  logic        arready;
} axi4ar_tx_s;

typedef struct packed {
  logic [1:0]  rid;
  logic [63:0] rdata;
  logic [1:0]  rresp;
  logic        rlast;
  logic        rvalid;
  logic        rready;
} axi4r_tx_s;

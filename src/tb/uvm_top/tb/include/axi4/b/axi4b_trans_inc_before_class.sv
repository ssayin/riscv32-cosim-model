typedef struct packed {
  logic [1:0] bid;
  logic [1:0] bresp;
  logic       bvalid;
  logic       bready;
} axi4b_tx_s;

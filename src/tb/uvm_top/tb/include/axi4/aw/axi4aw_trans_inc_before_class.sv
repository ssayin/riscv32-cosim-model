typedef struct packed {
  logic [1:0]  awid;
  logic [31:0] awaddr;
  logic [7:0]  awlen;
  logic [2:0]  awsize;
  logic [1:0]  awburst;
  logic        awlock;
  logic [3:0]  awcache;
  logic [2:0]  awprot;
  logic        awvalid;
  logic [3:0]  awregion;
  logic [3:0]  awqos;
  logic        awready;
} axi4aw_tx_s;

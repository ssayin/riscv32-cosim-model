typedef enum logic [1:0] {
  IDLE,
  PREBURST,
  BURST
} axi_state_t;

class axi4_logic;
  axi_state_t       state           = IDLE;
  bit         [7:0] arburst_counter = 0;
  bit         [1:0] arburst;
endclass : axi4_logic

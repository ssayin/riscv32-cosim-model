`ifndef DEC_DECODE_DEF
`define DEC_DECODE_DEF

typedef struct {
  rand logic [31:0] instr;
  rand logic [31:0] pc_in;
} decoder_in_t;

typedef struct {
  logic [31:0] imm;
  logic [4:0]  rs1_addr;
  logic [4:0]  rs2_addr;
  logic [4:0]  rd_addr;
  logic        alu;
  logic        lsu;
  logic        br;
  logic        illegal;
  logic        use_imm;
} decoder_out_t;

`endif

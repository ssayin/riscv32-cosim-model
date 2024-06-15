import defs_pkg::*;

// Stalling instruction fetches for now.
// DO NOT ROAST ME

module pipe_haz_ctrl (
  input  logic       valid_d,
  input  logic       valid_e,
  input  logic [4:0] rs1_addr,
  input  logic [4:0] rs2_addr,
  input  logic [4:0] rd_addr_d,
  input  logic [4:0] rd_addr_e,
  output logic       pipe_haz
);
  logic pipe_haz_c0, pipe_haz_c1;

  assign pipe_haz_c0 = (valid_d && ((rs1_addr == rd_addr_d) || (rs2_addr == rd_addr_d)) &&
                        (rd_addr_d != 0));

  assign pipe_haz_c1 = (valid_e && ((rs1_addr == rd_addr_e) || (rs2_addr == rd_addr_e)) &&
                        (rd_addr_e != 0));

  assign pipe_haz = pipe_haz_c0 || pipe_haz_c1;

endmodule

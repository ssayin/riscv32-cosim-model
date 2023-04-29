// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module reg_file #(
  parameter int DATA_WIDTH         = 32,
  parameter int NUM_READ_PORTS     = 2,
  parameter int NUM_WRITE_PORTS    = 1,
  parameter bit ENABLE_BYTE_WRITES = 1,
  parameter bit ENABLE_HALF_WRITES = 1,
  parameter bit ENABLE_REG_LOCK    = 0
) (
  input  logic                  clk,
  input  logic                  rst_n,
  input  logic [           4:0] i_rd_addr   [NUM_WRITE_PORTS],
  input  logic [           4:0] i_rs_addr   [ NUM_READ_PORTS],
  input  logic [DATA_WIDTH-1:0] i_rd_data   [NUM_WRITE_PORTS],
  input  logic                  i_wr_en     [NUM_WRITE_PORTS],
  input  logic                  i_byte_wr_en[NUM_WRITE_PORTS],
  input  logic                  i_half_wr_en[NUM_WRITE_PORTS],
  input  logic                  i_reg_lock  [NUM_WRITE_PORTS],
  output logic [DATA_WIDTH-1:0] o_rs_data   [ NUM_READ_PORTS]
);

  // Register File
  reg [DATA_WIDTH-1:0] reg_file[32];

  genvar i;

  // Clock gating
  logic [NUM_WRITE_PORTS-1:0] gated_clk;
  generate
    for (i = 0; i < NUM_WRITE_PORTS; i++) begin : g_clock_gating
      assign gated_clk[i] = clk & i_wr_en[i];
    end : g_clock_gating
  endgenerate

  // Write ports
  generate
    for (i = 0; i < NUM_WRITE_PORTS; i++) begin : g_wr_ports
      always @(posedge gated_clk[i] or negedge rst_n) begin
        if (!rst_n) begin
          for (int j = 0; j < 32; j++) begin
            reg_file[j] <= {DATA_WIDTH{1'b0}};
          end
        end else begin
          if (i_rd_addr[i] != 5'h0 && (!ENABLE_REG_LOCK || !i_reg_lock[i])) begin
            if (ENABLE_BYTE_WRITES && i_byte_wr_en[i]) begin
              reg_file[i_rd_addr[i]] <= {reg_file[i_rd_addr[i]][31:8], i_rd_data[i][7:0]};
            end else if (ENABLE_HALF_WRITES && i_half_wr_en[i]) begin
              reg_file[i_rd_addr[i]] <= {reg_file[i_rd_addr[i]][31:16], i_rd_data[i][15:0]};
            end else begin
              reg_file[i_rd_addr[i]] <= i_rd_data[i];
            end
          end
        end
      end
    end : g_wr_ports
  endgenerate

  // Read ports
  generate
    for (i = 0; i < NUM_READ_PORTS; i++) begin : g_rs_ports
      assign o_rs_data[i] = reg_file[i_rs_addr[i]];
    end : g_rs_ports
  endgenerate

endmodule

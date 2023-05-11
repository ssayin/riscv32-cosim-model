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
  input  logic [           4:0] rd_addr   [NUM_WRITE_PORTS],
  input  logic [           4:0] rs_addr   [ NUM_READ_PORTS],
  input  logic [DATA_WIDTH-1:0] rd_data   [NUM_WRITE_PORTS],
  input  logic                  wr_en     [NUM_WRITE_PORTS],
  input  logic                  byte_wr_en[NUM_WRITE_PORTS],
  input  logic                  half_wr_en[NUM_WRITE_PORTS],
  input  logic                  reg_lock  [NUM_WRITE_PORTS],
  output logic [DATA_WIDTH-1:0] rs_data   [ NUM_READ_PORTS]
);

  // Register File
  reg [DATA_WIDTH-1:0] reg_file[32];

  genvar i;

  // Clock gating
  logic [NUM_WRITE_PORTS-1:0] gated_clk;
  generate
    for (i = 0; i < NUM_WRITE_PORTS; i++) begin : g_clock_gating
      assign gated_clk[i] = clk & wr_en[i];
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
          if (rd_addr[i] != 5'h0 && (!ENABLE_REG_LOCK || !reg_lock[i])) begin
            if (ENABLE_BYTE_WRITES && byte_wr_en[i]) begin
              reg_file[rd_addr[i]] <= {reg_file[rd_addr[i]][31:8], rd_data[i][7:0]};
            end else if (ENABLE_HALF_WRITES && half_wr_en[i]) begin
              reg_file[rd_addr[i]] <= {reg_file[rd_addr[i]][31:16], rd_data[i][15:0]};
            end else begin
              reg_file[rd_addr[i]] <= rd_data[i];
            end
          end
        end
      end
    end : g_wr_ports
  endgenerate

  // Read ports
  generate
    for (i = 0; i < NUM_READ_PORTS; i++) begin : g_rs_ports
      assign rs_data[i] = reg_file[rs_addr[i]];
    end : g_rs_ports
  endgenerate

endmodule

// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module memory_model(
  input  logic        clk,
  input  logic        rst_n,
  input  logic [31:0] i_addr,
  input  logic [31:0] i_wr_data,
  input  logic [ 3:0] i_wr_en,
  input  logic        i_rd_en,
  output logic [31:0] o_rd_data
);

  logic   [7:0] mem_array[128];
  integer       i;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      o_rd_data <= 'h0;
    end else begin
      if (|i_wr_en) begin  // Perform a write operation if at least one byte is enabled
        for (i = 0; i < 4; i++) begin
          if (i_wr_en[i]) begin
            mem_array[i_addr[17:2]*4+i] <= i_wr_data[i*8+:8];  // TODO: fix byte order
          end
        end
      end else if (i_rd_en) begin
        // Perform a read operation
        o_rd_data <= {
          mem_array[i_addr[17:2]*4],
          mem_array[i_addr[17:2]*4+1],
          mem_array[i_addr[17:2]*4+2],
          mem_array[i_addr[17:2]*4+3]
        };
      end
    end
  end

`ifdef DEBUG_INIT_FILE
  initial begin
    $display("Booting from file %s", `DEBUG_INIT_FILE);
    $readmemh(INIT_FILE, mem_array);
  end
`endif
endmodule

// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module magic_memory (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] address[2],
    input  logic [31:0] data   [2],
    input  logic        enable,
    input  logic        rden   [2],
    input  logic [ 3:0] wren   [2],
    output logic [31:0] q      [2]
);
  logic   [7:0] mem_array[2 ** 11];
  integer       i;
  genvar j;

  logic [31:0] q_next      [2];

  generate
    for (j = 0; j < 2; j++) begin : g_ports

      always_comb begin
        q_next[j] =  {
              mem_array[address[j][17:2]*4],
              mem_array[address[j][17:2]*4+1],
              mem_array[address[j][17:2]*4+2],
              mem_array[address[j][17:2]*4+3]
            };
      end

      // TODO: Why sync reset?
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
        end else begin
          if (|wren[j]) begin  // Perform a write operation if at least one byte is enabled
            for (i = 0; i < 4; i++) begin
              if (wren[j][i]) begin
                mem_array[address[j][17:2]*4+i] <= data[j][i*8+:8];  // TODO: fix byte order
              end
            end
          end
          if (rden[j]) begin
            // Perform a read operation
            q[j] <= 
              {
              mem_array[address[j][17:2]*4],
              mem_array[address[j][17:2]*4+1],
              mem_array[address[j][17:2]*4+2],
              mem_array[address[j][17:2]*4+3]
            };
              //q_next[j];
            $display("%d", q[j]);
          end
        end
      end
    end : g_ports
  endgenerate

`ifdef DEBUG_INIT_FILE
  initial begin
    $display("Booting from file %s", `DEBUG_INIT_FILE);
    $readmemh(`DEBUG_INIT_FILE, mem_array);
    $display("%d", mem_array[0]);
  end
`endif

endmodule

module top_level
  import param_defs::*;
(
    input logic clk,
    input logic rst_n
);

  // logic [            3:0] mem_wr_en;  // TODO: Change this after cache impl.
  // Source
  logic [MemBusWidth-1:0] mem_data_in  [2];
  logic                   mem_ready;
  // IRQs
  logic                   irq_external;
  logic                   irq_timer;
  logic                   irq_software;
  // Memory signals
  logic                   mem_clk_en;
  logic [           31:0] address      [2];
  logic [           31:0] data         [2];
  logic                   rden         [2];
  logic [            3:0] wren         [2];
  logic [           31:0] q            [2];
  logic [           31:0] mem_addr     [2];

  assign irq_external = 'b0;
  assign irq_timer    = 'b0;
  assign irq_software = 'b0;
  assign mem_ready    = 'b1;
/*
   riscv_core core_0 (
      .clk         (clk),
      .rst_n       (rst_n),
      .mem_addr    (mem_addr),
      .mem_data_in (q),
      .mem_data_out(data),
      .mem_wr_en   (wren),
      .mem_rd_en   (rden),
      .mem_ready   (mem_ready),
      .irq_external(irq_external),
      .irq_timer   (irq_timer),
      .irq_software(irq_software),
      .mem_clk_en  (mem_clk_en)
  );
  

  assign rden[0] = 1;

  magic_memory fake_mem (
      .clk    (clk),
      .rst_n  (rst_n),
      .address(address),
      .data   (data),
      .enable (enable),
      .rden   (rden),
      .wren   (wren),
      .q      (q)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin

    end else begin
      $display("%d", address[0][31:0]);
    end
  end

  */

endmodule : top_level

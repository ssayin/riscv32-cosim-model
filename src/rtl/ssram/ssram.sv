// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module ssram #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 64   // divisible by 8
) (
  input  logic                    clka,
  input  logic                    rsta,
  input  logic                    ena,
  input  logic                    regcea,
  input  logic [DATA_WIDTH/8-1:0] wea,
  input  logic [  ADDR_WIDTH-1:0] addra,
  input  logic [  DATA_WIDTH-1:0] dina,
  output logic [  DATA_WIDTH-1:0] douta,
  input  logic                    clkb,
  input  logic                    rstb,
  input  logic                    enb,
  input  logic                    regceb,
  input  logic [DATA_WIDTH/8-1:0] web,
  input  logic [  ADDR_WIDTH-1:0] addrb,
  input  logic [  DATA_WIDTH-1:0] dinb,
  output logic [  DATA_WIDTH-1:0] doutb
);

  // logic [DATA_WIDTH-1:0] mem_array[0:2**ADDR_WIDTH];
  logic   [7:0] mem_array[0:2**ADDR_WIDTH];

  integer       i;
  initial begin
    for (i = 0; i < 1024; i++) begin
      mem_array[i] = $urandom;
    end
  end

  always_ff @(posedge clka or negedge rsta) begin
    if (!rsta) begin
    end else if (!regcea) begin
      if (!wea) begin
        for (int i = 0; i < DATA_WIDTH / 8; i++) begin
          if (!wea[i]) begin
            // mem_array[addra][8*i+:8] <= dina[8*i+:8];
            mem_array[addra+i] <= dina[8*i+:8];
          end
        end
      end
      if (!ena) begin
        for (int i = 0; i < DATA_WIDTH / 8; i++) begin
          // douta[8*i+:8] <= mem_array[addra][8*i+:8];
          douta[8*i+:8] <= mem_array[addra+i];
        end
      end
    end
  end

  always_ff @(posedge clkb or negedge rstb) begin
    if (!rstb) begin
    end else if (!regceb) begin
      if (!web) begin
        for (int i = 0; i < DATA_WIDTH / 8; i++) begin
          if (!web[i]) begin
            // mem_array[addrb][8*i+:8] <= dinb[8*i+:8];
            mem_array[addrb+i] <= dinb[8*i+:8];
          end
        end
      end
      if (!enb) begin
        for (int i = 0; i < DATA_WIDTH / 8; i++) begin
          // doutb[8*i+:8] <= mem_array[addrb][8*i+:8];
          doutb[8*i+:8] <= mem_array[addrb+i];
        end
      end
    end
  end

`ifdef DEBUG_INIT_FILE
  initial begin
    $display("Boot file is %s", `DEBUG_INIT_FILE);
    $readmemh(`DEBUG_INIT_FILE, mem_array);
    for (i = 0; i < 2 ** ADDR_WIDTH; i++) begin
      // $display("Data[%d] = %d", i, mem_array[i]);
      mem_array[i] = 0;
    end
  end
`endif

endmodule

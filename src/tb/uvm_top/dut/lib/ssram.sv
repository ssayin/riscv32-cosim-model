// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module ssram #(
    parameter int Q  = 1,   // Output registers
    parameter int AW = 10,
    parameter int DW = 64
) (
  input  logic          clka,
  input  logic          rsta,
  input  logic          ena,
  input  logic          rdena,
  input  logic          wrena,
  input  logic [   7:0] byteena,
  input  logic [AW-1:0] addra,
  input  logic [DW-1:0] dina,
  output logic [DW-1:0] douta,
  input  logic          clkb,
  input  logic          rstb,
  input  logic          enb,
  input  logic          rdenb,
  input  logic          wrenb,
  input  logic [   7:0] byteenb,
  input  logic [AW-1:0] addrb,
  input  logic [DW-1:0] dinb,
  output logic [DW-1:0] doutb
);

`ifndef DEBUG
  drw_ocram drw_ocram_0 (
    .aclr_a   (rsta),
    .aclr_b   (rstb),
    .address_a(addra),
    .address_b(addrb),
    .byteena_a(byteena),
    .byteena_b(byteenb),
    .clock_a  (clka),
    .clock_b  (clkb),
    .data_a   (dina),
    .data_b   (dinb),
    .enable_a (ena),
    .enable_b (enb),
    .rden_a   (rdena),
    .rden_b   (rdenb),
    .wren_a   (wrena),
    .wren_b   (wrenb),
    .q_a      (douta),
    .q_b      (doutb)
  );
`else
  logic [7:0] mem_array[1<<AW];

  generate
    genvar i;

    if (Q)
      always_ff @(posedge clka or posedge rsta) begin
        if (rsta) begin
        end else begin
          if (ena && rdena) begin
            for (int i = 0; i < DW / 8; i++) begin
              douta[8*i+:8] <= mem_array[addra+i][7:0];
`ifdef DEBUG_MEM
              $monitor("Address: %x", addra);
              $display("Iteration: %d, Byte: %x", i, douta[8*i+:8]);
`endif
            end
          end
        end
      end

    if (Q)
      always_ff @(posedge clkb or posedge rstb) begin
        if (rstb) begin
        end else begin
          if (enb && rdenb) begin
            for (int i = 0; i < DW / 8; i++) begin
              doutb[8*i+:8] <= mem_array[addrb+i][7:0];
            end
          end
        end
      end

    if (!Q) for (i = 0; i < DW / 8; i++) assign douta[8*i+:8] = mem_array[addra+i][7:0];
    if (!Q) for (i = 0; i < DW / 8; i++) assign doutb[8*i+:8] = mem_array[addrb+i][7:0];

  endgenerate

  always_ff @(posedge clka or posedge rsta) begin
    if (rsta) begin
    end else begin
      if (ena && |byteena) begin
        for (int i = 0; i < DW / 8; i++) begin
          if (byteena[i]) begin
            mem_array[addra+i][7:0] <= dina[8*i+:8];
`ifdef DEBUG_MEM
            $display("[SSRAM] Writing to %x, data: %d", addra + i, dina[8*i+:8]);
`endif
          end
        end
      end
    end
  end

  always_ff @(posedge clkb or posedge rstb) begin
    if (rstb) begin
    end else begin
      if (enb && |byteenb) begin
        for (int i = 0; i < DW / 8; i++) begin
          if (byteenb[i]) begin
            mem_array[addrb+i][7:0] <= dinb[8*i+:8];
`ifdef DEBUG_MEM
            $display("[SSRAM] Writing to %x, data: %d", addrb + i, dinb[8*i+:8]);
`endif
          end
        end
      end
    end
  end

`ifdef INIT_FILE
  initial $readmemh(`INIT_FILE, mem_array);
  initial $display("[SSRAM] Using ", `INIT_FILE);
`endif

`endif

endmodule

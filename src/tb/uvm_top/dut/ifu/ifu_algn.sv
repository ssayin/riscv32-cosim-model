// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

import defs_pkg::*;

module ifu_algn (
  input  logic         clk,
  input  logic         rst_n,
  input  logic         qwvalid,
  input  logic         qwready,
  input  logic [ 63:0] qw,
  input  logic         exu_pc_redir_en,
  input  logic         exu_pc_redir_en_d,
  input  logic [ 31:1] ifu_fetch_pc,
  input  logic [ 15:0] ifu_algn_part_in,         // Partial from prev fetch
  input  logic         ifu_algn_part_valid_in,
  output logic [ 15:0] ifu_algn_part_out,        // Partial
  output logic         ifu_algn_part_valid_out,
  output logic [127:0] ifu_algn_pkt,
  output logic [127:0] ifu_algn_pc_pkt,
  output logic [  3:0] ifu_algn_valid
);

  // logic [31:1] fetchsub;

  // assign fetchsub[31:1] = {31{ifu_algn_part_valid_in}};  // substract 2

  // NOTE: Due to an incorrect byte order in the SSRAM DEBUG, this workaround
  // was implemented. Identifying the byte order issue in the RAM
  // took a substantial amount of time, initially investigating the SEQ
  // module.

  // assign ifu_algn_pkt[31:0] = {qw[39:32], qw[47:40], qw[55:48], qw[63:56]};
  // assign ifu_algn_pkt[63:32] = {16'b????????????????, {qw[39:32], qw[47:40]}};
  // assign ifu_algn_pkt[95:64] = {qw[7:0], qw[15:8], qw[23:16], qw[31:24]};
  // assign ifu_algn_pkt[127:96] = {16'b????????????????, {qw[7:0], qw[15:8]}};
  // assign i16[0] = {qw[55:48], qw[63:56]};
  // assign i16[1] = {qw[39:32], qw[47:40]};
  // assign i16[2] = {qw[23:16], qw[31:24]};
  // assign i16[3] = {qw[7:0], qw[15:8]};

  // Assign the upper 16 bits of a compressed instruction as either don't care
  // or force them to be GND.

  localparam logic [15:0] IU16 = 16'b0000000000000000;  //  16'b????????????????

  // NOTE: The code below contains numerous duplicate cases. Consider improving
  // resource utilization.
  //
  // What are the benefits of extracting instructions to the same slices across
  // all cases? Would that save significant resources? It is worth
  // implementing a more advanced fetch buffer?
  //
  // TODO: Carefully assess the trade-offs and make an informed decision regarding
  // the approach to be adopted.

  // FIRST ATTEMPT

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) ifu_algn_valid[3:0] <= 4'b0000;
    else if (exu_pc_redir_en_d) ifu_algn_valid[3:0] <= 4'b0000;
    else if (qwvalid && qwready)
      casez ({
        {!(&qw[49:48]), !(&qw[33:32]), !(&qw[17:16]), !(&qw[1:0])}, ifu_algn_part_valid_in
      })
        5'b0?0?1: ifu_algn_valid[3:0] <= 4'b0011;  // & {4{qwvalid}} & {4{qwready}});
        5'b?0?00: ifu_algn_valid[3:0] <= 4'b0011;  // & {4{qwvalid}} & {4{qwready}});
        5'b?01?1: ifu_algn_valid[3:0] <= 4'b0111;  // & {4{qwvalid}} & {4{qwready}});
        5'b?0110: ifu_algn_valid[3:0] <= 4'b0111;  // & {4{qwvalid}} & {4{qwready}});
        5'b01?00: ifu_algn_valid[3:0] <= 4'b0011;  // & {4{qwvalid}} & {4{qwready}});
        5'b0?010: ifu_algn_valid[3:0] <= 4'b0011;  // & {4{qwvalid}} & {4{qwready}});
        5'b011?1: ifu_algn_valid[3:0] <= 4'b0111;  // & {4{qwvalid}} & {4{qwready}});
        5'b01110: ifu_algn_valid[3:0] <= 4'b0111;  // & {4{qwvalid}} & {4{qwready}});
        5'b1?0?1: ifu_algn_valid[3:0] <= 4'b0111;  // & {4{qwvalid}} & {4{qwready}});
        5'b1?010: ifu_algn_valid[3:0] <= 4'b0111;  // & {4{qwvalid}} & {4{qwready}});
        5'b?01?1: ifu_algn_valid[3:0] <= 4'b0111;  // & {4{qwvalid}} & {4{qwready}});
        5'b?0110: ifu_algn_valid[3:0] <= 4'b0111;  // & {4{qwvalid}} & {4{qwready}});
        5'b11?00: ifu_algn_valid[3:0] <= 4'b0111;  // & {4{qwvalid}} & {4{qwready}});
        5'b1?0?1: ifu_algn_valid[3:0] <= 4'b0111;  // & {4{qwvalid}} & {4{qwready}});
        5'b1?010: ifu_algn_valid[3:0] <= 4'b0111;  // & {4{qwvalid}} & {4{qwready}});
        5'b111?1: ifu_algn_valid[3:0] <= 4'b1111;  // & {4{qwvalid}} & {4{qwready}});
        5'b11110: ifu_algn_valid[3:0] <= 4'b1111;  // & {4{qwvalid}} & {4{qwready}});
        default:  ifu_algn_valid[3:0] <= 4'b0000;
      endcase
    else ifu_algn_valid[3:0] <= 4'b0000;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
        32'h0, 32'h0, 32'h0, 32'h0
      };
      ifu_algn_part_valid_out <= 0;
    end else if (qwvalid && qwready)
      casez ({
        {!(&qw[49:48]), !(&qw[33:32]), !(&qw[17:16]), !(&qw[1:0])}, ifu_algn_part_valid_in
      })
        5'b0?0?1: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            {qw[15:0], ifu_algn_part_in[15:0]}, qw[47:16], 32'h0, 32'h0
          };
          ifu_algn_part_valid_out <= 1;
          ifu_algn_part_out[15:0] <= qw[63:48];
        end
        5'b?0?00: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            qw[31:0], qw[63:32], 32'h0, 32'h0
          };
          ifu_algn_part_valid_out <= 0;
        end
        5'b?01?1: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            {qw[15:0], ifu_algn_part_in[15:0]}, qw[31:16], qw[63:32], 32'h0
          };
          ifu_algn_part_valid_out <= 0;
        end
        5'b?0110: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            {IU16, qw[15:0]}, {IU16, qw[31:16]}, qw[63:32], 32'h0
          };
          ifu_algn_part_valid_out <= 0;
        end
        5'b01?00: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            qw[31:0], qw[47:32], 32'h0, 32'h0
          };
          ifu_algn_part_valid_out <= 1;
          ifu_algn_part_out[15:0] <= qw[63:48];
        end
        5'b0?010: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            {IU16, qw[15:0]}, qw[47:16], 32'h0, 32'h0
          };
          ifu_algn_part_valid_out <= 1;
          ifu_algn_part_out[15:0] <= qw[63:48];
        end
        5'b011?1: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            {qw[15:0], ifu_algn_part_in[15:0]},
            {IU16, qw[31:16]},
            {IU16, qw[47:32]},
            {32'h0}
          };
          ifu_algn_part_valid_out <= 1;
          ifu_algn_part_out[15:0] <= qw[63:48];
        end
        5'b01110: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            {IU16, qw[15:0]}, {IU16, qw[31:16]}, {IU16, qw[47:32]}, {32'h0}
          };
          ifu_algn_part_valid_out <= 1;
          ifu_algn_part_out[15:0] <= qw[63:48];
        end
        5'b1?0?1: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            {qw[15:0], ifu_algn_part_in[15:0]}, qw[47:16], {IU16, qw[63:48]}, {32'h0}
          };
          ifu_algn_part_valid_out <= 0;
        end
        5'b1?010: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            {IU16, qw[15:0]}, qw[47:16], {IU16, qw[63:48]}, {32'h0}
          };
          ifu_algn_part_valid_out <= 0;
        end
        5'b?01?1: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            {qw[15:0], ifu_algn_part_in[15:0]},
            {IU16, qw[31:16]},
            {IU16, qw[63:32]},
            {32'h0}
          };
          ifu_algn_part_valid_out <= 0;
        end
        5'b?0110: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            {IU16, qw[15:0]}, {IU16, qw[31:16]}, qw[63:32], {32'h0}
          };
          ifu_algn_part_valid_out <= 0;
        end
        5'b11?00: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            qw[31:0], {IU16, qw[47:32]}, {IU16, qw[63:48]}, {32'h0}
          };
          ifu_algn_part_valid_out <= 0;
        end
        5'b1?0?1: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            {qw[15:0], ifu_algn_part_in[15:0]},
            {IU16, qw[47:16]},
            {IU16, qw[63:48]},
            {32'h0}
          };
          ifu_algn_part_valid_out <= 0;
        end
        5'b1?010: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            {IU16, qw[15:0]}, {IU16, qw[47:16]}, {IU16, qw[63:48]}, {32'h0}
          };
          ifu_algn_part_valid_out <= 0;
        end
        5'b111?1: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            {qw[15:0], ifu_algn_part_in[15:0]},
            {IU16, qw[31:16]},
            {IU16, qw[47:32]},
            {IU16, qw[63:48]}
          };
          ifu_algn_part_valid_out <= 0;
        end
        5'b11110: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            {IU16, qw[15:0]}, {IU16, qw[31:16]}, {IU16, qw[47:32]}, {IU16, qw[63:48]}
          };
          ifu_algn_part_valid_out <= 0;
        end
        default: begin
          {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
            32'h0, 32'h0, 32'h0, 32'h0
          };
          ifu_algn_part_valid_out <= 0;
        end
      endcase
    else begin
      {ifu_algn_pkt[31:0], ifu_algn_pkt[63:32], ifu_algn_pkt[95:64], ifu_algn_pkt[127:96]} <= {
        32'h0, 32'h0, 32'h0, 32'h0
      };
      ifu_algn_part_valid_out <= 0;
    end

  end

  // TODO: I am pretty sure there is a better way to implement this. I will
  // leave it as is for now and aim to make improvements after verification.
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) ifu_algn_pc_pkt <= 128'h0;
    else if (qwvalid && qwready)
      casez ({
        {!(&qw[49:48]), !(&qw[33:32]), !(&qw[17:16]), !(&qw[1:0])}, ifu_algn_part_valid_in
      })
        5'b0?0?1: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1] - 31'h1;
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h1;
        end
        5'b?0?00: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1];
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h2;
        end
        5'b?01?1: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1] - 31'h1;
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h1;
          ifu_algn_pc_pkt[95:65] <= ifu_fetch_pc[31:1] + 31'h2;
        end
        5'b?0110: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1];
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h1;
          ifu_algn_pc_pkt[95:65] <= ifu_fetch_pc[31:1] + 31'h2;
        end
        5'b01?00: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1];
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h2;
        end
        5'b0?010: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1];
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h1;
        end
        5'b011?1: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1] - 31'h1;
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h1;
          ifu_algn_pc_pkt[95:65] <= ifu_fetch_pc[31:1] + 31'h2;
        end
        5'b01110: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1];
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h1;
          ifu_algn_pc_pkt[95:65] <= ifu_fetch_pc[31:1] + 31'h2;
        end
        5'b1?0?1: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1] - 31'h1;
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h1;
          ifu_algn_pc_pkt[95:65] <= ifu_fetch_pc[31:1] + 31'h3;
        end
        5'b1?010: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1];
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h1;
          ifu_algn_pc_pkt[95:65] <= ifu_fetch_pc[31:1] + 31'h3;
        end
        5'b?01?1: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1] - 31'h1;
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h1;
          ifu_algn_pc_pkt[95:65] <= ifu_fetch_pc[31:1] + 31'h2;
        end
        5'b?0110: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1];
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h1;
          ifu_algn_pc_pkt[95:65] <= ifu_fetch_pc[31:1] + 31'h2;
        end
        5'b11?00: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1];
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h2;
          ifu_algn_pc_pkt[95:65] <= ifu_fetch_pc[31:1] + 31'h3;
        end
        5'b1?0?1: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1] - 31'h1;
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h1;
          ifu_algn_pc_pkt[95:65] <= ifu_fetch_pc[31:1] + 31'h3;
        end
        5'b1?010: begin
          ifu_algn_pc_pkt[31:1]  <= ifu_fetch_pc[31:1];
          ifu_algn_pc_pkt[63:33] <= ifu_fetch_pc[31:1] + 31'h1;
          ifu_algn_pc_pkt[95:65] <= ifu_fetch_pc[31:1] + 31'h3;
        end
        5'b111?1: begin
          ifu_algn_pc_pkt[31:1]   <= ifu_fetch_pc[31:1] - 31'h1;
          ifu_algn_pc_pkt[63:33]  <= ifu_fetch_pc[31:1] + 31'h1;
          ifu_algn_pc_pkt[95:65]  <= ifu_fetch_pc[31:1] + 31'h2;
          ifu_algn_pc_pkt[127:97] <= ifu_fetch_pc[31:1] + 31'h3;
        end
        5'b11110: begin
          ifu_algn_pc_pkt[31:1]   <= ifu_fetch_pc[31:1];
          ifu_algn_pc_pkt[63:33]  <= ifu_fetch_pc[31:1] + 31'h1;
          ifu_algn_pc_pkt[95:65]  <= ifu_fetch_pc[31:1] + 31'h2;
          ifu_algn_pc_pkt[127:97] <= ifu_fetch_pc[31:1] + 31'h3;
        end
        default: begin
          ifu_algn_pc_pkt <= 0;
        end
      endcase
    else ifu_algn_pc_pkt <= 0;
  end

`ifdef DEBUG_FULL
  always_ff @(posedge clk or negedge rst_n) begin
    casez ({
      {!(&qw[49:48]), !(&qw[33:32]), !(&qw[17:16]), !(&qw[1:0])}, ifu_algn_part_valid_in
    })
      5'b0?0?1: $strobe("5'b0?0?1");
      5'b?0?00: $strobe("5'b?0?00");
      5'b?01?1: $strobe("5'b?01?1");
      5'b?0110: $strobe("5'b?0110");
      5'b01?00: $strobe("5'b01?00");
      5'b0?010: $strobe("5'b0?010");
      5'b011?1: $strobe("5'b011?1");
      5'b01110: $strobe("5'b01110");
      5'b1?0?1: $strobe("5'b1?0?1");
      5'b1?010: $strobe("5'b1?010");
      5'b?01?1: $strobe("5'b?01?1");
      5'b?0110: $strobe("5'b?0110");
      5'b11?00: $strobe("5'b11?00");
      5'b1?0?1: $strobe("5'b1?0?1");
      5'b1?010: $strobe("5'b1?010");
      5'b111?1: $strobe("5'b111?1");
      5'b11110: $strobe("5'b11110");
      default:  $strobe("default");
    endcase
  end
`endif

endmodule

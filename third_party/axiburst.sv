////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	axi_addr.v
// {{{
// Project:	WB2AXIPSP: bus bridges and other odds and ends
//
// Purpose:	The AXI (full) standard has some rather complicated addressing
//		modes, where the address can either be FIXED, INCRementing, or
//	even where it can WRAP around some boundary.  When in either INCR or
//	WRAP modes, the next address must always be aligned.  In WRAP mode,
//	the next address calculation needs to wrap around a given value, and
//	that value is dependent upon the burst size (i.e. bytes per beat) and
//	length (total numbers of beats).  Since this calculation can be
//	non-trivial, and since it needs to be done multiple times, the logic
//	below captures it for every time it might be needed.
//
// 20200918 - modified to accommodate (potential) AXI3 burst lengths
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
// }}}
// Copyright (C) 2019-2022, Gisselquist Technology, LLC
// {{{
// This file is part of the WB2AXIP project.
//
// The WB2AXIP project contains free software and gateware, licensed under the
// Apache License, Version 2.0 (the "License").  You may not use this project,
// or this file, except in compliance with the License.  You may obtain a copy
// of the License at
//
//	http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
// License for the specific language governing permissions and limitations
// under the License.
//
////////////////////////////////////////////////////////////////////////////////
//
//

import defs_pkg::*;

module axiburst #(
    parameter int AW = 32,
    parameter int DW = 64
) (
  input  logic [AW-1:0] addrin,
  input  logic [   2:0] size,
  input  logic [   1:0] burst,
  input  logic [   7:0] len,
  output logic [AW-1:0] addrout
);

  localparam int HI = $clog2(DW) - 3;

  logic [AW-1:0] mask;
  logic [AW-1:0] incr;

  always_comb begin
    incr = 0;
    if (burst != 0) begin
      if (HI == 0) incr = 1;
      else if (HI == 1) incr = (size[0]) ? 2 : 1;
      else if (HI == 2) incr = (size[1]) ? 4 : ((size[0]) ? 2 : 1);
      else if (HI == 3)
        case (size[1:0])
          2'b00:   incr = 1;
          2'b01:   incr = 2;
          2'b10:   incr = 4;
          2'b11:   incr = 8;
          default: incr = 1;
        endcase
      else incr = (1 << size);
    end
  end

  always_comb begin
    mask = 1;

    if (HI < 2) mask = mask | ({{(AW - 4) {1'b0}}, len[3:0]} << (size[0]));
    else if (HI < 4) mask = mask | ({{(AW - 4) {1'b0}}, len[3:0]} << (size[1:0]));
    else mask = mask | ({{(AW - 4) {1'b0}}, len[3:0]} << (size));

    if (AW > 12) mask[(AW-1):((AW>12)?12 : (AW-1))] = 0;
  end

  always_comb begin
    addrout = addrin + incr;
    if (burst != FIXED) begin
      if (HI < 2) begin
        if (size[0]) addrout[0] = 0;
      end else if (HI < 4) begin
        case (size[1:0])
          2'b00:   addrout = addrout;
          2'b01:   addrout[0] = 0;
          2'b10:   addrout[(AW-1>1)?1 : (AW-1):0] = 0;
          2'b11:   addrout[(AW-1>2)?2 : (AW-1):0] = 0;
          default: addrout = addrout;
        endcase
      end else begin
        case (size)
          3'b001:  addrout[0] = 0;
          3'b010:  addrout[(AW-1>1)?1 : (AW-1):0] = 0;
          3'b011:  addrout[(AW-1>2)?2 : (AW-1):0] = 0;
          3'b100:  addrout[(AW-1>3)?3 : (AW-1):0] = 0;
          3'b101:  addrout[(AW-1>4)?4 : (AW-1):0] = 0;
          3'b110:  addrout[(AW-1>5)?5 : (AW-1):0] = 0;
          3'b111:  addrout[(AW-1>6)?6 : (AW-1):0] = 0;
          default: addrout = addrout;
        endcase
      end
    end

    if (burst[1]) addrout[AW-1:0] = (addrin & ~mask) | (addrout & mask);
    if (AW > 12) addrout[AW-1:((AW>12)?12 : (AW-1))] = addrin[AW-1:((AW>12)?12 : (AW-1))];
  end

endmodule

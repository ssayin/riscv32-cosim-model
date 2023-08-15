////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	skidbuffer.v
// {{{
// Project:	WB2AXIPSP: bus bridges and other odds and ends
//
// Purpose:	A basic SKID buffer.
// {{{
//	Skid buffers are required for high throughput AXI code, since the AXI
//	specification requires that all outputs be registered.  This means
//	that, if there are any stall conditions calculated, it will take a clock
//	cycle before the stall can be propagated up stream.  This means that
//	the data will need to be buffered for a cycle until the stall signal
//	can make it to the output.
//
//	Handling that buffer is the purpose of this core.
//
//	On one end of this core, you have the i_valid and i_data inputs to
//	connect to your bus interface.  There's also a registered o_ready
//	signal to signal stalls for the bus interface.
//
//	The other end of the core has the same basic interface, but it isn't
//	registered.  This allows you to interact with the bus interfaces
//	as though they were combinatorial logic, by interacting with this half
//	of the core.
//
//	If at any time the incoming !stall signal, i_ready, signals a stall,
//	the incoming data is placed into a buffer.  Internally, that buffer
//	is held in r_data with the r_valid flag used to indicate that valid
//	data is within it.
// }}}
// Parameters:
// {{{
//	DW or data width
//		In order to make this core generic, the width of the data in the
//		skid buffer is parameterized
//
//	OPT_LOWPOWER
//		Forces both o_data and r_data to zero if the respective *VALID
//		signal is also low.  While this costs extra logic, it can also
//		be used to guarantee that any unused values aren't toggling and
//		therefore unnecessarily using power.
//
//		This excess toggling can be particularly problematic if the
//		bus signals have a high fanout rate, or a long signal path
//		across an FPGA.
//
//	OPT_OUTREG
//		Causes the outputs to be registered
//
//	OPT_PASSTHROUGH
//		Turns the skid buffer into a passthrough.  Used for formal
//		verification only.
// }}}
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
// }}}
// Copyright (C) 2019-2024, Gisselquist Technology, LLC
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
module skidbuf #(
    parameter logic [0:0] OPT_LOWPOWER    = 0,
    parameter logic [0:0] OPT_OUTREG      = 1,
    parameter logic [0:0] OPT_PASSTHROUGH = 0,
    parameter int         DW              = 8,
    parameter logic [0:0] OPT_INITIAL     = 1'b1
) (
  input  logic          i_clk,
  input  logic          i_reset,
  input  logic          i_valid,
  output logic          o_ready,
  input  logic [DW-1:0] i_data,
  output logic          o_valid,
  input  logic          i_ready,
  output logic [DW-1:0] o_data
);

  logic [DW-1:0] w_data;

  generate
    if (OPT_PASSTHROUGH) begin : g_passthrough
      assign {o_valid, o_ready} = {i_valid, i_ready};
      always_comb
        if (!i_valid && OPT_LOWPOWER) o_data = 0;
        else o_data = i_data;
      assign w_data = 0;
    end else begin : g_logic
      logic          r_valid;
      logic [DW-1:0] r_data;
      initial if (OPT_INITIAL) r_valid = 0;
      always @(posedge i_clk)
        if (i_reset) r_valid <= 0;
        else if ((i_valid && o_ready) && (o_valid && !i_ready)) r_valid <= 1;
        else if (i_ready) r_valid <= 0;
      initial if (OPT_INITIAL) r_data = 0;
      always @(posedge i_clk)
        if (OPT_LOWPOWER && i_reset) r_data <= 0;
        else if (OPT_LOWPOWER && (!o_valid || i_ready)) r_data <= 0;
        else if ((!OPT_LOWPOWER || !OPT_OUTREG || i_valid) && o_ready) r_data <= i_data;

      assign w_data  = r_data;
      assign o_ready = !r_valid;

      if (!OPT_OUTREG) begin : g_net_output
        assign o_valid = !i_reset && (i_valid || r_valid);
        always_comb
          if (r_valid) o_data = r_data;
          else if (!OPT_LOWPOWER || i_valid) o_data = i_data;
          else o_data = 0;
      end else begin : g_reg_output

        logic ro_valid;

        initial if (OPT_INITIAL) ro_valid = 0;
        always @(posedge i_clk)
          if (i_reset) ro_valid <= 0;
          else if (!o_valid || i_ready) ro_valid <= (i_valid || r_valid);

        assign o_valid = ro_valid;

        initial if (OPT_INITIAL) o_data = 0;
        always @(posedge i_clk)
          if (OPT_LOWPOWER && i_reset) o_data <= 0;
          else if (!o_valid || i_ready) begin

            if (r_valid) o_data <= r_data;
            else if (!OPT_LOWPOWER || i_valid) o_data <= i_data;
            else o_data <= 0;
          end
      end
    end
  endgenerate
endmodule

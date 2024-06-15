////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	demofull.v
// {{{
// Project:	WB2AXIPSP: bus bridges and other odds and ends
//
// Purpose:	Demonstrate a formally verified AXI4 core with a (basic)
//		interface.  This interface is explained below.
//
// Performance: This core has been designed for a total throughput of one beat
//		per clock cycle.  Both read and write channels can achieve
//	this.  The write channel will also introduce two clocks of latency,
//	assuming no other latency from the master.  This means it will take
//	a minimum of 3+AWLEN clock cycles per transaction of (1+AWLEN) beats,
//	including both address and acknowledgment cycles.  The read channel
//	will introduce a single clock of latency, requiring 2+ARLEN cycles
//	per transaction of 1+ARLEN beats.
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
module demofull #(
    // {{{
    parameter int         IW           = 2,
    parameter int         DW           = 64,
    parameter int         AW           = 10,
    parameter logic [0:0] OPT_LOCK     = 1'b0,
    parameter logic [0:0] OPT_LOCKID   = 1'b1,
    parameter logic [0:0] OPT_LOWPOWER = 1'b0,
    // Some useful short-hand definitions
    parameter int         LSB          = 0,      //$clog2(DW) - 3
    parameter int         STRBW        = DW / 8
    // }}}
) (
  output logic              o_we,
  output logic [AW-LSB-1:0] o_waddr,
  output logic [    DW-1:0] o_wdata,
  output logic [  DW/8-1:0] o_wstrb,
  //
  output logic              o_rd,
  output logic [AW-LSB-1:0] o_raddr,
  input  logic [    DW-1:0] i_rdata,
  input  logic              clk,
  input  logic              rst_n,
  input  logic [    IW-1:0] m_axi_awid,
  input  logic [    AW-1:0] m_axi_awaddr,
  input  logic [       7:0] m_axi_awlen,
  input  logic [       2:0] m_axi_awsize,
  input  logic [       1:0] m_axi_awburst,
  input  logic              m_axi_awlock,
  input  logic [       3:0] m_axi_awcache,
  input  logic [       2:0] m_axi_awprot,
  input  logic [       3:0] m_axi_awqos,
  input  logic              m_axi_awvalid,
  output logic              m_axi_awready,
  input  logic [    DW-1:0] m_axi_wdata,
  input  logic [ STRBW-1:0] m_axi_wstrb,
  input  logic              m_axi_wlast,
  input  logic              m_axi_wvalid,
  output logic              m_axi_wready,
  output logic [    IW-1:0] m_axi_bid,
  output logic [       1:0] m_axi_bresp,
  output logic              m_axi_bvalid,
  input  logic              m_axi_bready,
  input  logic [    IW-1:0] m_axi_arid,
  input  logic [    AW-1:0] m_axi_araddr,
  input  logic [       7:0] m_axi_arlen,
  input  logic [       2:0] m_axi_arsize,
  input  logic [       1:0] m_axi_arburst,
  input  logic              m_axi_arlock,
  input  logic [       3:0] m_axi_arcache,
  input  logic [       2:0] m_axi_arprot,
  input  logic [       3:0] m_axi_arqos,
  input  logic              m_axi_arvalid,
  output logic              m_axi_arready,
  output logic [    IW-1:0] m_axi_rid,
  output logic [    DW-1:0] m_axi_rdata,
  output logic [       1:0] m_axi_rresp,
  output logic              m_axi_rlast,
  output logic              m_axi_rvalid,
  input  logic              m_axi_rready
);

  logic [IW-1:0] r_bid;
  logic          r_bvalid;
  logic [IW-1:0] axi_bid;
  logic          axi_bvalid;

  logic axi_awready, axi_wready;
  logic [AW-1:0] waddr;
  logic [AW-1:0] next_wr_addr;

  logic [   7:0] wlen;
  logic [   2:0] wsize;
  logic [   1:0] wburst;

  logic m_awvalid, m_awlock;
  logic          m_awready;
  logic [AW-1:0] m_awaddr;
  logic [   1:0] m_awburst;
  logic [   2:0] m_awsize;
  logic [   7:0] m_awlen;
  logic [IW-1:0] m_awid;

  logic [AW-1:0] next_rd_addr;

  logic [   7:0] rlen;
  logic [   2:0] rsize;
  logic [   1:0] rburst;
  logic [IW-1:0] rid;
  logic          rlock;
  logic          axi_arready;
  logic [   8:0] axi_rlen;
  logic [AW-1:0] raddr;

  // Read skid buffer
  logic rskd_valid, rskd_last, rskd_lock;
  logic          rskd_ready;
  logic [IW-1:0] rskd_id;

  // Exclusive address register checking
  logic exclusive_write, block_write;
  logic write_lock_valid;
  logic axi_exclusive_write;


  skidbuf #(
      // {{{
      .DW          (AW + 2 + 3 + 1 + 8 + IW),
      .OPT_LOWPOWER(OPT_LOWPOWER),
      .OPT_OUTREG  (1'b0)
      // }}}
  ) awbuf (
    // {{{
    .i_clk(clk),
    .i_reset(!rst_n),
    .i_valid(m_axi_awvalid),
    .o_ready(m_axi_awready),
    .i_data({
      m_axi_awaddr, m_axi_awburst, m_axi_awsize, m_axi_awlock, m_axi_awlen, m_axi_awid
    }),
    .o_valid(m_awvalid),
    .i_ready(m_awready),
    .o_data({m_awaddr, m_awburst, m_awsize, m_awlock, m_awlen, m_awid})
    // }}}
  );
  initial axi_awready = 1;
  initial axi_wready = 0;
  always @(posedge clk)
    if (!rst_n) begin
      axi_awready <= 1;
      axi_wready  <= 0;
    end else if (m_awvalid && m_awready) begin
      axi_awready <= 0;
      axi_wready  <= 1;
    end else if (m_axi_wvalid && m_axi_wready) begin
      axi_awready <= (m_axi_wlast) && (!m_axi_bvalid || m_axi_bready);
      axi_wready  <= (!m_axi_wlast);
    end else if (!axi_awready) begin
      if (m_axi_wready) axi_awready <= 1'b0;
      else if (r_bvalid && !m_axi_bready) axi_awready <= 1'b0;
      else axi_awready <= 1'b1;
    end
  // }}}

  // Exclusive write calculation
  // {{{
  always @(posedge clk)
    if (!rst_n || !OPT_LOCK) begin
      exclusive_write <= 0;
      block_write     <= 0;
    end else if (m_awvalid && m_awready) begin
      exclusive_write <= 1'b0;
      block_write     <= 1'b0;
      if (write_lock_valid) exclusive_write <= 1'b1;
      else if (m_awlock) block_write <= 1'b1;
    end else if (m_awready) begin
      exclusive_write <= 1'b0;
      block_write     <= 1'b0;
    end

  always @(posedge clk)
    if (!rst_n || !OPT_LOCK) axi_exclusive_write <= 0;
    else if (!m_axi_bvalid || m_axi_bready) begin
      axi_exclusive_write <= exclusive_write;
      if (OPT_LOWPOWER && (!m_axi_wvalid || !m_axi_wready || !m_axi_wlast) && !r_bvalid)
        axi_exclusive_write <= 0;
    end
  // }}}

  // Next write address calculation
  // {{{
  always @(posedge clk)
    if (m_awready) begin
      waddr  <= m_awaddr;
      wburst <= m_awburst;
      wsize  <= m_awsize;
      wlen   <= m_awlen;
    end else if (m_axi_wvalid) waddr <= next_wr_addr;

  axiburst #(
      // {{{
      .AW(AW),
      .DW(DW)
      // }}}
  ) get_next_wr_addr (
    // {{{
    waddr,
    wsize,
    wburst,
    wlen,
    next_wr_addr
    // }}}
  );
  // }}}

  // o_w*
  // {{{
  always @(posedge clk) begin
    o_we    <= (m_axi_wvalid && m_axi_wready);
    o_waddr <= waddr[AW-1:LSB];
    o_wdata <= m_axi_wdata;
    if (block_write) o_wstrb <= 0;
    else o_wstrb <= m_axi_wstrb;

    if (!rst_n) o_we <= 0;
    if (OPT_LOWPOWER && (!rst_n || !m_axi_wvalid || !m_axi_wready)) begin
      o_waddr <= 0;
      o_wdata <= 0;
      o_wstrb <= 0;
    end
  end
  // }}}

  //
  // Write return path
  // {{{
  // r_bvalid
  // {{{
  initial r_bvalid = 0;
  always @(posedge clk)
    if (!rst_n) r_bvalid <= 1'b0;
    else if (m_axi_wvalid && m_axi_wready && m_axi_wlast &&
             (m_axi_bvalid && !m_axi_bready))
      r_bvalid <= 1'b1;
    else if (m_axi_bready) r_bvalid <= 1'b0;
  // }}}

  // r_bid, axi_bid
  // {{{
  initial r_bid = 0;
  initial axi_bid = 0;
  always @(posedge clk) begin
    if (m_awready && (!OPT_LOWPOWER || m_awvalid)) r_bid <= m_awid;

    if (!m_axi_bvalid || m_axi_bready) axi_bid <= r_bid;

    if (OPT_LOWPOWER && !rst_n) begin
      r_bid   <= 0;
      axi_bid <= 0;
    end
  end
  // }}}

  // axi_bvalid
  // {{{
  initial axi_bvalid = 0;
  always @(posedge clk)
    if (!rst_n) axi_bvalid <= 0;
    else if (m_axi_wvalid && m_axi_wready && m_axi_wlast) axi_bvalid <= 1;
    else if (m_axi_bready) axi_bvalid <= r_bvalid;
  // }}}

  // m_awready
  // {{{
  always_comb begin
    m_awready = axi_awready;
    if (m_axi_wvalid && m_axi_wready && m_axi_wlast && (!m_axi_bvalid || m_axi_bready))
      m_awready = 1;
  end

  assign m_axi_wready = axi_wready;
  assign m_axi_bvalid = axi_bvalid;
  assign m_axi_bid    = axi_bid;
  assign m_axi_bresp  = {1'b0, axi_exclusive_write};

  initial axi_arready = 1;
  always @(posedge clk)
    if (!rst_n) axi_arready <= 1;
    else if (m_axi_arvalid && m_axi_arready) axi_arready <= (m_axi_arlen == 0) && (o_rd);
    else if (o_rd) axi_arready <= (axi_rlen <= 1);
  // }}}

  // axi_rlen
  // {{{
  initial axi_rlen = 0;
  always @(posedge clk)
    if (!rst_n) axi_rlen <= 0;
    else if (m_axi_arvalid && m_axi_arready) axi_rlen <= m_axi_arlen + (o_rd ? 0 : 1);
    else if (o_rd) axi_rlen <= axi_rlen - 1;
  // }}}

  // Next read address calculation
  // {{{
  always @(posedge clk)
    if (o_rd) raddr <= next_rd_addr;
    else if (m_axi_arready) begin
      raddr <= m_axi_araddr;
      if (OPT_LOWPOWER && !m_axi_arvalid) raddr <= 0;
    end

  // r*
  // {{{
  always @(posedge clk)
    if (m_axi_arready) begin
      rburst <= m_axi_arburst;
      rsize  <= m_axi_arsize;
      rlen   <= m_axi_arlen;
      rid    <= m_axi_arid;
      rlock  <= m_axi_arlock && m_axi_arvalid && OPT_LOCK;

      if (OPT_LOWPOWER && !m_axi_arvalid) begin
        rburst <= 0;
        rsize  <= 0;
        rlen   <= 0;
        rid    <= 0;
        rlock  <= 0;
      end
    end
  // }}}

  axiburst #(
      // {{{
      .AW(AW),
      .DW(DW)
      // }}}
  ) get_next_rd_addr (
    // {{{
    (m_axi_arready ? m_axi_araddr : raddr),
    (m_axi_arready ? m_axi_arsize : rsize),
    (m_axi_arready ? m_axi_arburst : rburst),
    (m_axi_arready ? m_axi_arlen : rlen),
    next_rd_addr
    // }}}
  );
  // }}}

  // o_rd, o_raddr
  // {{{
  always_comb begin
    o_rd = (m_axi_arvalid || !m_axi_arready);
    if (m_axi_rvalid && !m_axi_rready) o_rd = 0;
    if (rskd_valid && !rskd_ready) o_rd = 0;
    o_raddr = (m_axi_arready ? m_axi_araddr[AW-1:LSB] : raddr[AW-1:LSB]);
  end
  // }}}

  // rskd_valid
  // {{{
  initial rskd_valid = 0;
  always @(posedge clk)
    if (!rst_n) rskd_valid <= 0;
    else if (o_rd) rskd_valid <= 1;
    else if (rskd_ready) rskd_valid <= 0;
  // }}}

  // rskd_id
  // {{{
  always @(posedge clk)
    if (!rskd_valid || rskd_ready) begin
      if (m_axi_arvalid && m_axi_arready) rskd_id <= m_axi_arid;
      else rskd_id <= rid;
    end
  // }}}

  // rskd_last
  // {{{
  initial rskd_last = 0;
  always @(posedge clk)
    if (!rskd_valid || rskd_ready) begin
      rskd_last <= 0;
      if (o_rd && axi_rlen == 1) rskd_last <= 1;
      if (m_axi_arvalid && m_axi_arready && m_axi_arlen == 0) rskd_last <= 1;
    end
  // }}}

  // rskd_lock
  // {{{
  always @(posedge clk)
    if (!rst_n || !OPT_LOCK) rskd_lock <= 1'b0;
    else if (!rskd_valid || rskd_ready) begin
      rskd_lock <= 0;
      if (!OPT_LOWPOWER || o_rd) begin
        if (m_axi_arvalid && m_axi_arready) rskd_lock <= m_axi_arlock;
        else rskd_lock <= rlock;
      end
    end
  // }}}


  // Outgoing read skidbuf
  // {{{
  skidbuf #(
      // {{{
      .OPT_LOWPOWER(OPT_LOWPOWER),
      .OPT_OUTREG  (1),
      .DW          (IW + 2 + DW)
      // }}}
  ) rskid (
    // {{{
    .i_clk  (clk),
    .i_reset(!rst_n),
    .i_valid(rskd_valid),
    .o_ready(rskd_ready),
    .i_data ({rskd_id, rskd_lock, rskd_last, i_rdata}),
    .o_valid(m_axi_rvalid),
    .i_ready(m_axi_rready),
    .o_data ({m_axi_rid, m_axi_rresp[0], m_axi_rlast, m_axi_rdata})
    // }}}
  );
  // }}}

  assign m_axi_rresp[1] = 1'b0;
  assign m_axi_arready  = axi_arready;

  // }}}
  ////////////////////////////////////////////////////////////////////////
  //
  // Exclusive address caching
  // {{{
  ////////////////////////////////////////////////////////////////////////
  //
  //

  generate
    if (OPT_LOCK && !OPT_LOCKID) begin : g_exclusive_access_block
      reg
          w_valid_lock_request,
          w_cancel_lock,
          w_lock_request,
          lock_valid,
          returned_lock_valid;
      reg [AW-LSB-1:0] lock_start, lock_end;
      reg [   3:0] lock_len;
      reg [   1:0] lock_burst;
      reg [   2:0] lock_size;
      reg [IW-1:0] lock_id;
      reg          w_write_lock_valid;
      // }}}

      // w_lock_request
      // {{{
      always_comb begin
        w_lock_request = 0;
        if (m_axi_arvalid && m_axi_arready && m_axi_arlock) w_lock_request = 1;
      end
      // }}}

      // w_valid_lock_request
      // {{{
      always_comb begin
        w_valid_lock_request = 0;
        if (w_lock_request) w_valid_lock_request = 1;
        if (o_we && o_waddr == m_axi_araddr[AW-1:LSB]) w_valid_lock_request = 0;
      end
      // }}}

      // returned_lock_valid
      // {{{
      initial returned_lock_valid = 0;
      always @(posedge clk)
        if (!rst_n) returned_lock_valid <= 0;
        else if (m_axi_arvalid && m_axi_arready && m_axi_arlock && m_axi_arid == lock_id)
          returned_lock_valid <= 0;
        else if (w_cancel_lock) returned_lock_valid <= 0;
        else if (rskd_valid && rskd_lock && rskd_ready) returned_lock_valid <= lock_valid;
      // }}}

      // w_cancel_lock
      // {{{
      always_comb
        w_cancel_lock = (lock_valid && w_lock_request) ||
            (lock_valid && o_we && o_waddr >= lock_start && o_waddr <= lock_end &&
             o_wstrb != 0);
      // }}}

      // lock_valid
      // {{{
      initial lock_valid = 0;
      always @(posedge clk)
        if (!rst_n || !OPT_LOCK) lock_valid <= 0;
        else begin
          if (m_axi_arvalid && m_axi_arready && m_axi_arlock && m_axi_arid == lock_id)
            lock_valid <= 0;
          if (w_cancel_lock) lock_valid <= 0;
          if (w_valid_lock_request) lock_valid <= 1;
        end
      // }}}

      // lock_start, lock_end, lock_len, lock_size, lock_id
      // {{{
      always @(posedge clk)
        if (w_valid_lock_request) begin
          lock_start <= m_axi_araddr[AW-1:LSB];
          lock_end <= m_axi_araddr[AW-1:LSB] +
              ((m_axi_arburst == 2'b00) ? 0 : m_axi_arlen[3:0]);
          lock_len <= m_axi_arlen[3:0];
          lock_burst <= m_axi_arburst;
          lock_size <= m_axi_arsize;
          lock_id <= m_axi_arid;
        end
      // }}}

      // w_write_lock_valid
      // {{{
      always_comb begin
        w_write_lock_valid = returned_lock_valid;
        if (!m_awvalid || !m_awready || !m_awlock || !lock_valid) w_write_lock_valid = 0;
        if (m_awaddr[AW-1:LSB] != lock_start) w_write_lock_valid = 0;
        if (m_awid != lock_id) w_write_lock_valid = 0;
        if (m_awlen[3:0] != lock_len)  // MAX transfer size is 16 beats
          w_write_lock_valid = 0;
        if (m_awburst != 2'b01 && lock_len != 0) w_write_lock_valid = 0;
        if (m_awsize != lock_size) w_write_lock_valid = 0;
      end
      // }}}

      assign write_lock_valid = w_write_lock_valid;
      // }}}
    end else if (OPT_LOCK)  // && OPT_LOCKID
        begin : g_exclusive_access_per_id
      // {{{

      genvar gk;
      logic [(1<<IW)-1:0] write_lock_valid_per_id;

      for (gk = 0; gk < (1 << IW); gk = gk + 1) begin : g_per_id_logic
        // {{{
        // Local declarations
        // {{{
        reg w_valid_lock_request, w_cancel_lock, lock_valid, returned_lock_valid;
        reg [1:0] lock_burst;
        reg [2:0] lock_size;
        reg [3:0] lock_len;
        reg [AW-LSB-1:0] lock_start, lock_end;
        reg w_write_lock_valid;
        // }}}

        // valid_lock_request
        // {{{
        always_comb begin
          w_valid_lock_request = 0;
          if (m_axi_arvalid && m_axi_arready && m_axi_arid == gk[IW-1:0] && m_axi_arlock)
            w_valid_lock_request = 1;
          if (o_we && o_waddr == m_axi_araddr[AW-1:LSB]) w_valid_lock_request = 0;
        end
        // }}}

        // returned_lock_valid
        // {{{
        initial returned_lock_valid = 0;
        always @(posedge clk)
          if (!rst_n) returned_lock_valid <= 0;
          else if (m_axi_arvalid && m_axi_arready && m_axi_arlock &&
                   m_axi_arid == gk[IW-1:0])
            returned_lock_valid <= 0;
          else if (w_cancel_lock) returned_lock_valid <= 0;
          else if (rskd_valid && rskd_lock && rskd_ready && rskd_id == gk[IW-1:0])
            returned_lock_valid <= lock_valid;
        // }}}

        // w_cancel_lock
        // {{{
        always_comb
          w_cancel_lock = (lock_valid && w_valid_lock_request) ||
              (lock_valid && o_we && o_waddr >= lock_start && o_waddr <= lock_end &&
               o_wstrb != 0);
        // }}}

        // lock_valid
        // {{{
        initial lock_valid = 0;
        always @(posedge clk)
          if (!rst_n || !OPT_LOCK) lock_valid <= 0;
          else begin
            if (m_axi_arvalid && m_axi_arready && m_axi_arlock &&
                m_axi_arid == gk[IW-1:0])
              lock_valid <= 0;
            if (w_cancel_lock) lock_valid <= 0;
            if (w_valid_lock_request) lock_valid <= 1;
          end
        // }}}

        // lock_start, lock_end, lock_len, lock_size
        // {{{
        always @(posedge clk)
          if (w_valid_lock_request) begin
            lock_start <= m_axi_araddr[AW-1:LSB];
            // Verilator lint_off WIDTH
            lock_end <= m_axi_araddr[AW-1:LSB] +
                ((m_axi_arburst == 2'b00) ? 4'h0 : m_axi_arlen[3:0]);
            // Verilator lint_on  WIDTH
            lock_len <= m_axi_arlen[3:0];
            lock_size <= m_axi_arsize;
            lock_burst <= m_axi_arburst;
          end
        // }}}

        // w_write_lock_valid
        // {{{
        always_comb begin
          w_write_lock_valid = returned_lock_valid;
          if (!m_awvalid || !m_awready || !m_awlock || !lock_valid)
            w_write_lock_valid = 0;
          if (m_awaddr[AW-1:LSB] != lock_start) w_write_lock_valid = 0;
          if (m_awid[IW-1:0] != gk[IW-1:0]) w_write_lock_valid = 0;
          if (m_awlen[3:0] != lock_len)  // MAX transfer size is 16 beats
            w_write_lock_valid = 0;
          if (m_awburst != 2'b01 && lock_len != 0) w_write_lock_valid = 0;
          if (m_awsize != lock_size) w_write_lock_valid = 0;
        end
        // }}}

        assign write_lock_valid_per_id[gk] = w_write_lock_valid;
        // }}}
      end

      assign write_lock_valid = |write_lock_valid_per_id;
      // }}}
    end else begin : g_no_locking
      // {{{

      assign write_lock_valid = 1'b0;
      // Verilator lint_off UNUSED
      logic unused_lock;
      assign unused_lock = &{1'b0, m_axi_arlock, m_axi_awlock};
      // Verilator lint_on  UNUSED
      // }}}
    end
  endgenerate
  // }}}
endmodule

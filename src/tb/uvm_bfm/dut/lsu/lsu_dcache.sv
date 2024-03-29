// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module iscachable #(
    // {{{
    parameter int AW = 32,  // Just for ease of notation below
    parameter logic [AW-1:0] SDRAM_ADDR = 0,
    parameter logic [AW-1:0] SDRAM_MASK = 0,
    parameter logic [AW-1:0] BKRAM_ADDR = 32'h10000000,
    parameter logic [AW-1:0] BKRAM_MASK = 32'h10000000,
    parameter logic [AW-1:0] FLASH_ADDR = 0,
    parameter logic [AW-1:0] FLASH_MASK = 0
    // }}}
) (
  // {{{
  input  logic [AW-1:0] i_addr,
  output logic          o_cachable
  // }}}
);


  always_comb begin
    o_cachable = 1'b0;
    if ((SDRAM_ADDR != 0) && ((i_addr & SDRAM_MASK) == SDRAM_ADDR)) o_cachable = 1'b1;
    else if ((FLASH_ADDR != 0) && ((i_addr & FLASH_MASK) == FLASH_ADDR))
      o_cachable = 1'b1;
    else if ((BKRAM_ADDR != 0) && ((i_addr & BKRAM_MASK) == BKRAM_ADDR))
      o_cachable = 1'b1;
  end

endmodule

module axidcache #(
    // {{{
    // AXI Setup: address width, data width, ID width, and ID
    // {{{
    parameter C_AXI_ADDR_WIDTH = 32,
    parameter C_AXI_DATA_WIDTH = 64,
    parameter C_AXI_ID_WIDTH = 2,
    parameter [C_AXI_ID_WIDTH-1:0] AXI_ID = 2'b01,
    // }}}
    // LGCACHELEN
    // {{{
    // The log (base 2) of the cache size in bytes.
    parameter LGCACHELEN = 8 + $clog2(C_AXI_DATA_WIDTH / 8),
    parameter LGCACHEWORDS = LGCACHELEN - $clog2(C_AXI_DATA_WIDTH / 8),
    // }}}
    // LGNLINES
    // {{{
    // The log (base 2) of the number of cache lines.  A cache line
    // is the minimum amount of data read on a miss.  Each cache
    // line has a valid signal and a tag associated with it.
    parameter LGNLINES = (LGCACHEWORDS - 3),
    // }}}
    parameter [0:0] SWAP_WSTRB = 1'b0,
    // OPT_SIGN_EXTEND: When returning values to the CPU that are
    // {{{
    // less than word sized in length, if OPT_SIGN_EXTEND is true
    // these values will be sign extended.
    parameter [0:0] OPT_SIGN_EXTEND = 1'b0,
    // }}}
    parameter NAUX = 5,
    // OPT_PIPE: Set to 1 to allow multiple outstanding transactions
    // {{{
    // This is primarily used by write requests.  Read requests
    // will only ever read one cache line at a time.  Non-cache
    // reads are only ever done (at present) as singletons.
    parameter [0:0] OPT_PIPE = 1'b0,
    // }}}
    // OPT_WRAP: True if using AXI WRAP mode.  With AXI WRAP mode,
    // {{{
    // a cache read result will return its value before the entire
    // cache line read has been completed
    parameter [0:0] OPT_WRAP = 1'b0,
    // }}}
    // OPT_LOWPOWER: If true, sets unused AXI values to all zeros,
    // {{{
    // or, in the case of AxSIZE, to 3'd2.  This is to keep things
    // from toggling if they don't need to.
    parameter [0:0] OPT_LOWPOWER = 1'b0,
    // }}}
    // OPT_LOCK: Set to 1 in order to support exclusive access.
    // {{{
    parameter [0:0] OPT_LOCK = 1'b0,
    // }}}
    // Local parameters, mostly abbreviations
    // {{{
    // Verilator lint_off UNUSED
    parameter LGPIPE = (OPT_PIPE) ? 4 : 2,
    // Verilator lint_on  UNUSED
    parameter [0:0] OPT_DUAL_READ_PORT = 1'b0,
    parameter [1:0] DC_IDLE = 2'b00,
    DC_WRITE = 2'b01,
    DC_READS = 2'b10,
    DC_READC = 2'b11,
    parameter AW = C_AXI_ADDR_WIDTH,
    parameter DW = C_AXI_DATA_WIDTH,
    parameter IW = C_AXI_ID_WIDTH,
    parameter AXILSB = $clog2(C_AXI_DATA_WIDTH / 8),
    parameter CS = LGCACHELEN - AXILSB,  // Cache size, in wrds
    parameter LS = CS - LGNLINES,  // Cache lines, lg_2
    parameter TW = AW - (CS + AXILSB)  // Tag width
    // }}}
    // }}}
) (
  // {{{
  input  wire            clk,
  rst_n,
  input  wire            i_cpu_reset,
  i_clear,
  // Interface from the CPU
  // {{{
  input  wire            i_pipe_stb,
  i_lock,
  input  wire [     2:0] i_op,
  input  wire [  AW-1:0] i_addr,
  input  wire            i_restart_pc,
  input  wire [    31:0] i_data,
  input  wire [NAUX-1:0] i_oreg,
  // Outputs, going back to the CPU
  output reg             o_busy,
  o_rdbusy,
  output wire            o_pipe_stalled,
  output reg             o_valid,
  o_err,
  output reg  [NAUX-1:0] o_wreg,
  output reg  [    31:0] o_data,
  // }}}
  // AXI bus interface
  // {{{
  // Write address
  // {{{
  output wire            axi_awvalid_m,
  input  wire            axi_awready_m,
  // verilator coverage_off
  output wire [  IW-1:0] axi_awid_m,      // = constant
  // verilator coverage_on
  output wire [  AW-1:0] axi_awaddr_m,
  // verilator coverage_off
  output wire [     7:0] axi_awlen_m,     // = const 0
  // verilator coverage_on
  output wire [     2:0] axi_awsize_m,
  output wire [     1:0] axi_awburst_m,
  output wire            axi_awlock_m,
  output wire [     3:0] axi_awcache_m,
  // verilator coverage_off
  output wire [     2:0] axi_awprot_m,
  output wire [     3:0] axi_awqos_m,
  // verilator coverage_on
  // }}}
  // Write data
  // {{{
  output wire            axi_wvalid_m,
  input  wire            axi_wready_m,
  output wire [  DW-1:0] axi_wdata_m,
  output wire [DW/8-1:0] axi_wstrb_m,
  output wire            axi_wlast_m,
  // }}}
  // Write return
  // {{{
  input  wire            axi_bvalid_m,
  output wire            axi_bready_m,
  // verilator coverage_off
  input  wire [  IW-1:0] axi_bid_m,
  // verilator coverage_on
  input  wire [     1:0] axi_bresp_m,
  // }}}
  // Read address
  // {{{
  output wire            axi_arvalid_m,
  input  wire            axi_arready_m,
  // verilator coverage_off
  output wire [  IW-1:0] axi_arid_m,
  // verilator coverage_on
  output wire [  AW-1:0] axi_araddr_m,
  output wire [     7:0] axi_arlen_m,
  output wire [     2:0] axi_arsize_m,
  output wire [     1:0] axi_arburst_m,
  output wire            axi_arlock_m,
  output wire [     3:0] axi_arcache_m,
  // verilator coverage_off
  output wire [     2:0] axi_arprot_m,
  output wire [     3:0] axi_arqos_m,
  // verilator coverage_on
  // }}}
  // Read data returned
  // {{{
  input  wire            axi_rvalid_m,
  output wire            axi_rready_m,
  // verilator coverage_off
  input  wire [  IW-1:0] axi_rid_m,
  // verilator coverage_on
  input  wire [  DW-1:0] axi_rdata_m,
  input  wire            axi_rlast_m,
  input  wire [     1:0] axi_rresp_m
  // }}}
  // }}}
  // }}}
);

  // Declarations
  // {{{
  localparam [1:0] OKAY = 2'b00, EXOKAY = 2'b01;
  // Verilator lint_off UNUSED
  localparam DSZ = 2;
  // Verilator lint_on  UNUSED

  // The cache itself
  // {{{
  reg [(1<<(CS-LS))-1:0] cache_valid;
  reg [          TW-1:0] cache_tag   [0:(1<<LGNLINES)-1];
  reg [          DW-1:0] cache_mem   [      0:(1<<CS)-1];
  reg [DW-1:0] cached_iword, cached_rword;
  // }}}

  reg misaligned;

  wire cache_miss_inow, address_is_cachable;
  wire cachable_request, cachable_read_request;

  wire i_read, i_write;
  reg [AW-AXILSB-1:0] r_addr;
  wire [CS-LS-1:0] i_cline, r_cline;
  wire [CS-1:0] i_caddr, r_caddr;
  reg [TW-1:0] last_tag, r_itag, r_rtag, w_tag;
  reg [CS-LS-1:0] last_tag_line;
  wire [TW-1:0] r_ctag, i_ctag, axi_tag;
  wire [CS-LS-1:0] axi_line;

  reg r_iv, r_rv, r_check, w_v, set_vflag;
  reg zero_noutstanding, last_ack, full_pipe, nearly_full_pipe;
  wire                 w_pipe_stalled;
  reg     [LGPIPE-1:0] noutstanding;
  reg     [    CS-1:0] wcache_addr;
  reg     [    DW-1:0] wcache_data;
  reg     [  DW/8-1:0] wcache_strb;
  reg     [    TW-1:0] wcache_tag;
  integer              ik;

  reg                  good_cache_read;
  reg     [       1:0] state;

  reg
      r_dvalid,
      r_svalid,
      r_cachable,
      r_cache_miss,
      flushing,
      r_rd_pending,
      last_tag_valid,
      w_cache_miss;
  reg [DW-1:0] pre_data, shifted_data;
  reg  [AXILSB+1:0] req_data;
  wire [AXILSB-1:0] req_lsb;
  wire [       1:0] req_op;

  reg  [       1:0] suppress_miss;
  reg  [    CS-1:0] read_addr;

  assign i_write = i_op[0];
  assign i_read  = !i_op[0];

  // AXI registers
  // {{{
  reg axi_awvalid, axi_wvalid;
  reg  [  AW-1:0] axi_awaddr;
  reg  [     2:0] axi_awsize;
  reg  [  DW-1:0] axi_wdata;
  reg  [DW/8-1:0] axi_wstrb;
  wire [  DW-1:0] axi_rdata;
  wire            axi_awlock;

  reg             axi_arvalid;
  reg  [  AW-1:0] axi_araddr;
  reg  [     7:0] axi_arlen;
  reg  [     2:0] axi_arsize;
  wire [     1:0] axi_arburst;
  wire            axi_arlock;
  // }}}

  // LOCK handling declarations
  // {{{
  wire [  AW-1:0] restart_pc;
  wire locked_write_in_progress, locked_read_in_progress, locked_read_in_cache;
  // }}}
  // }}}

  // Fixed AXI outputs that aren't changing
  // {{{
  assign axi_awid_m    = AXI_ID;
  assign axi_arid_m    = AXI_ID;
  assign axi_awlen_m   = 0;  // All writes are one beat only

  assign axi_awburst_m = INCR;  // INCR addressing only
  assign axi_arburst_m = axi_arburst;

  assign axi_awlock_m  = OPT_LOCK && axi_awlock;
  assign axi_arlock_m  = OPT_LOCK && axi_arlock;

  assign axi_awcache_m = axi_awlock_m ? 0 : 4'b011;
  assign axi_arcache_m = axi_arlock_m ? 0 : 4'b011;

  assign axi_awprot_m  = 3'b0;  // == 3'b001 if GIE is clear, 3'b000 if
  assign axi_arprot_m  = 3'b0;  // not

  assign axi_awqos_m   = 0;
  assign axi_arqos_m   = 0;

  assign axi_wlast_m   = 1;

  assign axi_bready_m  = 1;
  assign axi_rready_m  = 1;
  // }}}

  // Misalignment detection
  // {{{
  always_comb misaligned = checklsb(i_op[2:1], i_addr[1:0]);

  function checklsb;
    input [1:0] op;
    input [1:0] addr;

    casez (op[1:0])
      2'b0?: checklsb = (addr[1:0] != 2'b00);  // 32'bit words
      2'b10: checklsb = addr[0];  // 16-bit words
      2'b11: checklsb = 1'b0;  // Bytes are never misaligned
    endcase
  endfunction
  // }}}

  // Address decoding
  //  {{{
  assign i_cline = i_addr[LS+AXILSB+:(CS-LS)];  // Cache line
  assign i_caddr = i_addr[AXILSB+:CS];  // Cache address
  assign i_ctag = i_addr[AW-1:CS+AXILSB];  // Associated tag

  // Unlike i_addr, r_addr doesn't include the AXI LSB's
  assign r_cline = r_addr[CS-1:LS];  // Cache line
  assign r_caddr = r_addr[CS-1:0];  // Cache address
  assign r_ctag = r_addr[AW-AXILSB-1 : CS];  // Associated tag

  assign cache_miss_inow = (!last_tag_valid || last_tag != i_ctag || last_tag_line != i_cline);
  // }}}

  // Cache lookup
  // {{{
  always @(posedge clk) r_check <= i_pipe_stb;

  always @(posedge clk) if (i_pipe_stb) r_itag <= cache_tag[i_cline];

  always @(posedge clk) if (o_pipe_stalled) r_rtag <= cache_tag[r_cline];

  always @(posedge clk) if (i_pipe_stb) r_iv <= cache_valid[i_cline];

  always @(posedge clk) r_rv <= cache_valid[r_cline] && r_rd_pending;

  always @(*) w_v = (r_check) ? r_iv : r_rv;

  always @(*) w_tag = (r_check) ? r_itag : r_rtag;

  // Cachability checking
  // {{{
  // Note that the correct address width must be built-in to the
  // iscachable routine.  It is *not* parameterizable.  iscachable must
  // be rewritten if the address width changes because, of necessity, that
  // also means the address map is changing and therefore what is and
  // isn't cachable.  etc.
  iscachable chkaddress (
    i_addr[AW-1:0],
    address_is_cachable
  );
  // }}}

  // Locked requests are *not* cachable, but *must* go to the bus
  assign cachable_request      = address_is_cachable && (!OPT_LOCK || !i_lock);
  assign cachable_read_request = i_pipe_stb && i_read && cachable_request;

  initial r_rd_pending = 0;
  initial r_cache_miss = 0;
  initial last_tag_valid = 0;
  initial r_dvalid = 0;
  always @(posedge clk) begin
    r_svalid <= cachable_read_request && !misaligned && !cache_miss_inow && (wcache_strb == 0);

    if (!o_pipe_stalled) r_addr <= i_addr[AW-1:AXILSB];

    if (!o_pipe_stalled && !r_rd_pending) begin
      r_cachable <= cachable_read_request;
      r_rd_pending <= cachable_read_request && !misaligned && (cache_miss_inow || (|wcache_strb));
    end else if (r_rd_pending) begin
      r_rd_pending <= (w_tag != r_ctag || !w_v);
      if (OPT_WRAP && axi_rvalid_m) r_rd_pending <= 0;
    end

    if (axi_rvalid_m && axi_rresp_m[1]) r_rd_pending <= 1'b0;

    // r_rd <= (i_pipe_stb && !i_read);

    r_dvalid <= !r_svalid && !r_dvalid && (w_tag == r_ctag) && w_v && r_cachable && r_rd_pending;

    if (w_tag == r_ctag && w_v && r_cachable && r_rd_pending) begin
      last_tag_valid <= 1'b1;
      last_tag_line  <= r_cline;
      last_tag       <= r_ctag;
    end else if (state == DC_READC)
      //	&& (last_tag == r_ctag)
      //	&& (axi_rvalid_m))
      last_tag_valid <= 1'b0;

    r_cache_miss <= (r_cachable && !r_svalid && (r_rd_pending && !r_svalid) && (w_tag != r_ctag || !w_v));

    if (i_clear) last_tag_valid <= 0;
    if (OPT_PIPE && axi_bvalid_m && axi_bresp_m[1]) last_tag_valid <= 0;

    if (!rst_n || i_cpu_reset) begin
      r_cachable     <= 1'b0;
      r_svalid       <= 1'b0;
      r_dvalid       <= 1'b0;
      r_cache_miss   <= 1'b0;
      r_rd_pending   <= 0;
      last_tag_valid <= 0;
    end
  end
  // }}}

  // Transaction counting
  // {{{
  initial noutstanding = 0;
  initial zero_noutstanding = 1;
  initial nearly_full_pipe = 0;
  always @(posedge clk)
    if (!rst_n) begin
      noutstanding      <= 0;
      zero_noutstanding <= 1;
      nearly_full_pipe  <= 0;
    end else
      case ({
        ((axi_awvalid_m && axi_awready_m) || (axi_arvalid_m && axi_arready_m)),
        ((axi_rvalid_m && axi_rlast_m) || axi_bvalid_m)
      })
        2'b10: begin
          noutstanding      <= noutstanding + 1;
          zero_noutstanding <= 1'b0;
          nearly_full_pipe  <= (noutstanding >= (1 << LGPIPE) - 3);
        end
        2'b01: begin
          noutstanding      <= noutstanding - 1;
          zero_noutstanding <= (noutstanding == 1);
          nearly_full_pipe  <= (&noutstanding);
        end
        default: begin
        end
      endcase

  always @(*) begin
    full_pipe = 1'b0;
    if (nearly_full_pipe) full_pipe = noutstanding[0] || (axi_awvalid_m || axi_wvalid_m);
  end

  always @(*) last_ack = (noutstanding <= 1) && (!axi_arvalid_m && !axi_awvalid_m);

  initial flushing = 0;
  always @(posedge clk)
    if (!rst_n) flushing <= 0;
    else if (flushing) begin  // Can we clear flushing?
      if (zero_noutstanding) flushing <= 1'b0;
      if (last_ack && (axi_bvalid_m || (axi_rvalid_m && axi_rlast_m))) flushing <= 1'b0;
      if (axi_awvalid_m || axi_arvalid_m || axi_wvalid_m) flushing <= 1'b1;
    end else if (i_cpu_reset || (axi_rvalid_m && axi_rresp_m[1]) || (axi_bvalid_m && axi_bresp_m[1]) || (OPT_PIPE && i_pipe_stb && misaligned)) begin  // Flushing causes
      flushing <= 1'b0;
      if (axi_arvalid_m || axi_awvalid_m || axi_wvalid_m) flushing <= 1'b1;
      if (!last_ack) flushing <= 1'b1;
      if ((noutstanding >= 1) && !axi_bvalid_m && (!axi_rvalid_m || !axi_rlast_m))
        flushing <= 1'b1;
    end
  // }}}

  // Read handling
  // {{{
  // Read state machine
  // {{{
  initial state = DC_IDLE;
  initial set_vflag = 1'b0;
  always @(posedge clk)
    if (!rst_n) begin
      // {{{
      cache_valid <= 0;
      // end_of_line <= 1'b0;
      // last_line_stb <= 1'b0;
      state       <= DC_IDLE;
      set_vflag   <= 1'b0;
      // }}}
    end else begin
      // {{{
      set_vflag <= 1'b0;
      if (set_vflag) cache_valid[r_cline] <= 1'b1;

      case (state)
        DC_IDLE: begin
          // {{{
          good_cache_read <= 1'b1;
          if (i_pipe_stb && i_write && !misaligned) state <= DC_WRITE;
          else if (w_cache_miss) state <= DC_READC;
          else if (i_pipe_stb && i_read && !cachable_request && !misaligned)
            state <= DC_READS;

          if (i_cpu_reset) state <= DC_IDLE;
        end
        // }}}
        DC_READC: begin  // Read cache line
          // {{{
          if (axi_rvalid_m) begin
            good_cache_read      <= good_cache_read && !axi_rresp_m[1];
            cache_valid[r_cline] <= 1'b0;
          end
          if (axi_rvalid_m && axi_rlast_m) begin
            state <= DC_IDLE;
            set_vflag <= !i_cpu_reset && !i_clear && !flushing && !axi_rresp_m[1] && good_cache_read;
          end
        end
        // }}}
        DC_READS: begin  // Read single value
          // {{{
          if (axi_rvalid_m && last_ack) state <= DC_IDLE;
        end
        // }}}
        DC_WRITE: begin
          // {{{
          if (axi_bvalid_m && axi_bready_m && (!OPT_PIPE || (last_ack && !i_pipe_stb)))
            state <= DC_IDLE;
        end
        // }}}
      endcase

      if (i_clear || i_cpu_reset) cache_valid <= 0;
      if (OPT_PIPE && axi_bvalid_m && axi_bresp_m[1]) cache_valid <= 0;
      // }}}
    end
  // }}}

  // axi_axlock
  // {{{
  generate
    if (OPT_LOCK) begin : GEN_AXLOCK

      reg r_arlock, r_awlock;
      reg [2:0] r_read_in_cache;

      initial r_arlock = 1'b0;
      always @(posedge clk)
        if (!rst_n) r_arlock <= 1'b0;
        else if (i_pipe_stb) begin
          r_arlock <= i_lock;

          if (misaligned || i_write) r_arlock <= 1'b0;
        end else if (axi_rvalid_m) r_arlock <= 1'b0;

      always @(posedge clk)
        if (!rst_n || r_rd_pending || axi_rvalid_m) r_read_in_cache <= 3'b00;
        else if (i_pipe_stb) begin
          r_read_in_cache    <= 3'b00;
          r_read_in_cache[0] <= address_is_cachable && i_read && i_lock;
        end else if (r_read_in_cache != 0) begin
          r_read_in_cache[2:1] <= {r_read_in_cache[1:0]};
          if (r_read_in_cache[1] && ((w_tag != r_ctag) || !w_v)) r_read_in_cache <= 0;
          // && (w_tag == r_ctag) && w_v
        end

      initial r_awlock = 1'b0;
      always @(posedge clk)
        if (!rst_n) r_awlock <= 1'b0;
        else if (i_pipe_stb) begin
          r_awlock <= i_lock;

          if (misaligned || i_read) r_awlock <= 1'b0;
        end else if (axi_bvalid_m) r_awlock <= 1'b0;

      assign locked_write_in_progress = r_awlock;
      assign locked_read_in_progress  = r_arlock;
      assign locked_read_in_cache     = r_read_in_cache[2];
      assign axi_awlock               = r_awlock;
      assign axi_arlock               = r_arlock;
    end else begin : NO_LOCK
      assign axi_awlock               = 1'b0;
      assign axi_arlock               = 1'b0;
      assign locked_write_in_progress = 1'b0;
      assign locked_read_in_progress  = 1'b0;
      assign locked_read_in_cache     = 1'b0;
    end
  endgenerate
  // }}}

  // axi_arvalid_m, axi_arvalid
  // {{{
  always @(posedge clk) suppress_miss <= {suppress_miss[0] || set_vflag, set_vflag};
  always @(*)
    w_cache_miss = r_cache_miss && state == DC_IDLE && !r_dvalid && !o_err && wcache_strb == 0 && !suppress_miss[1];

  initial axi_arvalid = 0;
  always @(posedge clk)
    if (!rst_n) axi_arvalid <= 0;
    else if (!axi_arvalid_m || axi_arready_m) begin
      axi_arvalid <= 1'b0;
      if (i_pipe_stb && i_read && !misaligned && ((OPT_LOCK && i_lock) || !address_is_cachable))
        axi_arvalid <= 1;
      if (w_cache_miss) axi_arvalid <= 1;
      if (i_cpu_reset) axi_arvalid <= 0;
    end

  assign axi_arvalid_m = axi_arvalid;
  // }}}

  // axi_araddr_m, axi_arsize_m, axi_arlen_m
  // {{{
  initial axi_araddr = 0;
  initial axi_arsize = 3'd2;
  initial axi_arlen = 0;
  always @(posedge clk)
    if (OPT_LOWPOWER && !rst_n) begin
      // {{{
      axi_araddr <= 0;
      axi_arsize <= 3'd2;
      axi_arlen  <= 0;
      // }}}
    end else if (!axi_arvalid_m || axi_arready_m) begin
      axi_arlen <= 0;
      if (r_cache_miss) begin
        // {{{
        if (OPT_WRAP) axi_araddr <= {r_ctag, r_caddr[CS-1:0], {(AXILSB) {1'b0}}};
        else axi_araddr <= {r_ctag, r_cline, {(LS + AXILSB) {1'b0}}};
        axi_arlen  <= (1 << LS) - 1;
        axi_arsize <= AXILSB[2:0];
        // }}}
      end else begin
        // {{{
        axi_araddr <= i_addr;
        axi_arlen  <= 0;
        casez (i_op[2:1])
          2'b0?: axi_arsize <= 3'd2;
          2'b10: axi_arsize <= 3'd1;
          2'b11: axi_arsize <= 3'd0;
          // default:  axi_arsize <= 3'd2; (Messes w/ coverage)
        endcase

        if (SWAP_WSTRB) begin
          // axi_araddr[AXILSB-1:0] <= ~i_addr[AXILSB-1:0];
          axi_araddr[1:0] <= 0;
          axi_arsize      <= 3'b010;
        end
        // }}}
      end

      if (OPT_LOWPOWER && (i_cpu_reset || (!w_cache_miss && (!i_pipe_stb || i_op[0] || misaligned || (address_is_cachable && !i_lock))))) begin
        // {{{
        axi_araddr <= 0;
        axi_arlen  <= 0;
        axi_arsize <= 3'd2;
        // }}}
      end
    end

  assign axi_tag      = axi_araddr[AW-1:AW-TW];
  assign axi_line     = axi_araddr[AXILSB+LS+:CS-LS];

  assign axi_araddr_m = axi_araddr;
  assign axi_arlen_m  = axi_arlen;
  assign axi_arsize_m = axi_arsize;
  // }}}

  // axi_arburst_m
  // {{{
  generate
    if (OPT_WRAP) begin : GEN_ARBURST
      reg r_wrap;

      initial r_wrap = 1'b0;
      always @(posedge clk)
        if (OPT_LOWPOWER && !rst_n) begin
          // {{{
          r_wrap <= 1'b0;
          // }}}
        end else if (!axi_arvalid_m || axi_arready_m) begin
          // {{{
          r_wrap <= 1'b0;
          if (r_cache_miss) r_wrap <= 1'b1;
          // }}}
        end

      assign axi_arburst = r_wrap ? WRAP : INCR;

    end else begin : NO_WRAPBURST

      assign axi_arburst = INCR;
    end
  endgenerate

  // }}}
  // }}}

  // Writes always go straight to the bus
  // {{{

  // axi_awvalid_m, axi_awvalid
  // {{{
  initial axi_awvalid = 0;
  always @(posedge clk)
    if (!rst_n) axi_awvalid <= 1'b0;
    else if (!axi_awvalid_m || axi_awready_m) begin
      axi_awvalid <= i_pipe_stb && i_op[0] && !misaligned;
      if (axi_bvalid_m && axi_bresp_m[1]) axi_awvalid <= 1'b0;
      if (i_cpu_reset || flushing) axi_awvalid <= 1'b0;
    end

  assign axi_awvalid_m = axi_awvalid;
  // }}}

  // axi_awaddr_m
  // {{{
  initial axi_awaddr = 0;
  initial axi_awsize = 3'd2;
  always @(posedge clk)
    if (!rst_n && OPT_LOWPOWER) begin
      axi_awaddr <= 0;
      axi_awsize <= 3'd2;
    end else if (!axi_awvalid_m || axi_awready_m) begin
      axi_awaddr <= i_addr;

      casez (i_op[2:1])
        2'b0?: axi_awsize <= 3'd2;
        2'b10: axi_awsize <= 3'd1;
        2'b11: axi_awsize <= 3'd0;
        // default:  axi_awsize <= 3'd2;	(Unused, messes w/ covr)
      endcase


      if (SWAP_WSTRB) begin
        // axi_awaddr[AXILSB-1:0] <= ~i_addr[AXILSB-1:0];
        axi_awaddr[1:0] <= 0;
        axi_awsize      <= 3'd2;
      end

      if (OPT_LOWPOWER && (!i_pipe_stb || !i_op[0] || misaligned || i_cpu_reset || flushing || (axi_bvalid_m && axi_bresp_m[1]))) begin
        axi_awaddr <= 0;
        axi_awsize <= 3'd2;
      end
    end

  assign axi_awaddr_m = axi_awaddr;
  assign axi_awsize_m = axi_awsize;
  // }}}

  // axi_wvalid_m
  // {{{
  initial axi_wvalid = 0;
  always @(posedge clk)
    if (!rst_n) axi_wvalid <= 0;
    else if (!axi_wvalid_m || axi_wready_m) begin
      axi_wvalid <= i_pipe_stb && i_op[0] && !misaligned;
      if (axi_bvalid_m && axi_bresp_m[1]) axi_wvalid <= 1'b0;
      if (i_cpu_reset || flushing) axi_wvalid <= 1'b0;
    end

  assign axi_wvalid_m = axi_wvalid;
  // }}}

  // axi_wdata_m, axi_wstrb_m
  // {{{
  initial axi_wdata = 0;
  initial axi_wstrb = 0;
  always @(posedge clk)
    if (!rst_n && OPT_LOWPOWER) begin
      axi_wdata <= 0;
      axi_wstrb <= 0;
    end else if (!axi_wvalid_m || axi_wready_m) begin

      // WDATA
      // {{{
      if (SWAP_WSTRB) begin
        // {{{
        casez (i_op[2:1])
          // Write a 16b half-word
          2'b10:
          axi_wdata <= {i_data[15:0], {(C_AXI_DATA_WIDTH - 16) {1'b0}}} >> (8 * i_addr[AXILSB-1:0]);
          // Write an 8b half-word
          2'b11:
          axi_wdata <= {i_data[7:0], {(C_AXI_DATA_WIDTH - 8) {1'b0}}} >> (8 * i_addr[AXILSB-1:0]);
          default:
          axi_wdata <= {i_data, {(C_AXI_DATA_WIDTH - 32) {1'b0}}} >> (8 * i_addr[AXILSB-1:0]);
        endcase
        // }}}
      end else begin
        // {{{
        casez (i_op[2:1])
          // Write a 16b half-word
          2'b10:
          axi_wdata <= {{(C_AXI_DATA_WIDTH - 16) {1'b0}}, i_data[15:0]} << (8 * i_addr[AXILSB-1:0]);
          // Write an 8b half-word
          2'b11:
          axi_wdata <= {{(C_AXI_DATA_WIDTH - 8) {1'b0}}, i_data[7:0]} << (8 * i_addr[AXILSB-1:0]);
          default:
          axi_wdata <= {{(C_AXI_DATA_WIDTH - 32) {1'b0}}, i_data} << (8 * i_addr[AXILSB-1:0]);
        endcase
        // }}}
      end
      // }}}

      // WSTRB
      // {{{
      if (SWAP_WSTRB) begin
        // {{{
        casez (i_op[2:1])
          // Write a 16b half-word
          2'b10:
          axi_wstrb <= {2'b11, {(C_AXI_DATA_WIDTH / 8 - 2) {1'b0}}} >> (i_addr[AXILSB-1:0]);
          // Write an 8b half-word
          2'b11:
          axi_wstrb <= {1'b1, {(C_AXI_DATA_WIDTH / 8 - 1) {1'b0}}} >> (i_addr[AXILSB-1:0]);
          default:
          axi_wstrb <= {4'b1111, {(C_AXI_DATA_WIDTH / 8 - 4) {1'b0}}} >> (i_addr[AXILSB-1:0]);
        endcase
        // }}}
      end else begin
        // {{{
        casez (i_op[2:1])
          // Write a 16b half-word
          2'b10:
          axi_wstrb <= {{(C_AXI_DATA_WIDTH / 8 - 4) {1'b0}}, 4'b0011} << (i_addr[AXILSB-1:0]);
          // Write an 8b half-word
          2'b11:
          axi_wstrb <= {{(C_AXI_DATA_WIDTH / 8 - 4) {1'b0}}, 4'b0001} << (i_addr[AXILSB-1:0]);
          default:
          axi_wstrb <= {{(C_AXI_DATA_WIDTH / 8 - 4) {1'b0}}, 4'b1111} << (i_addr[AXILSB-1:0]);
        endcase
        // }}}
      end
      // }}}

      // OPT_LOWPOWER: Clear if nothing is being used
      // {{{
      if (OPT_LOWPOWER && ((!i_pipe_stb || !i_op[0] || misaligned) || (axi_bvalid_m && axi_bresp_m[1]) || (i_cpu_reset || flushing))) begin
        axi_wdata <= 0;
        axi_wstrb <= 0;
      end
      // }}}
    end

  genvar gk;
  generate
    if (!SWAP_WSTRB) begin : NO_SWAP_WSTRB
      assign axi_wdata_m = axi_wdata;
      assign axi_wstrb_m = axi_wstrb;

      assign axi_rdata   = axi_rdata_m;
    end else begin : J
      for (gk = 0; gk < C_AXI_DATA_WIDTH / 32; gk = gk + 1) begin : GEN_SWAP_WSTRB
        assign axi_wdata_m[32*gk+:32] = axi_wdata[C_AXI_DATA_WIDTH-(gk+1)*32+:32];
        assign axi_wstrb_m[4*gk+:4]   = axi_wstrb[C_AXI_DATA_WIDTH/8-(gk+1)*4+:4];

        assign axi_rdata[32*gk+:32]   = axi_rdata_m[C_AXI_DATA_WIDTH-(gk+1)*32+:32];
      end
    end
  endgenerate
  // }}}
  // }}}

  // Writes take a clock to go to the cache
  // {{{
  reg [AW-1:0] rev_addr;
  always @(*) begin
    rev_addr = i_addr;
    /*
		if (SWAP_WSTRB && C_AXI_DATA_WIDTH != 32)
		begin
			rev_addr[AXILSB-1:0] = ~i_addr[AXILSB-1:0];
			rev_addr[1:0] = i_addr[1:0];
		end
		*/
  end

  always @(posedge clk) begin
    wcache_strb <= 0;

    if (i_pipe_stb && (!OPT_LOWPOWER || i_read)) begin
      if (i_lock && OPT_LOCK) read_addr <= i_addr[LGCACHELEN-1:AXILSB];
      else if (OPT_WRAP) read_addr <= i_addr[LGCACHELEN-1:AXILSB];
      else read_addr <= {i_addr[LGCACHELEN-1:AXILSB+LS], {(LS) {1'b0}}};
    end

    if (state == DC_READC) begin
      // {{{
      // Write returning read data to the cache
      if (axi_rvalid_m) read_addr[LS-1:0] <= read_addr[LS-1:0] + 1;
      read_addr[CS-1:LS] <= r_cline;
      wcache_addr        <= read_addr;
      wcache_data        <= axi_rdata;
      wcache_strb        <= -1;
      if (!axi_rvalid_m || flushing || i_cpu_reset || axi_rresp_m[1]) wcache_strb <= 0;
      wcache_tag <= w_tag;
      // }}}
    end else begin
      // {{{
      if (i_pipe_stb) {wcache_tag, wcache_addr} <= i_addr[AW-1:AXILSB];
      else if (locked_read_in_progress) wcache_addr <= read_addr;
      else wcache_addr[LS-1:0] <= 0;

      // wcache_data
      // {{{
      if (SWAP_WSTRB) begin
        casez (i_op[2:1])
          // Write a 16b half-word
          2'b10:
          wcache_data <= {i_data[15:0], {(DW - 16) {1'b0}}} >> (8 * i_addr[AXILSB-1:0]);
          // Write an 8b half-word
          2'b11:
          wcache_data <= {i_data[7:0], {(DW - 8) {1'b0}}} >> (8 * i_addr[AXILSB-1:0]);
          default:
          wcache_data <= {i_data, {(DW - 32) {1'b0}}} >> (8 * i_addr[AXILSB-1:0]);
        endcase
      end else begin
        casez (i_op[2:1])
          // Write a 16b half-word
          2'b10:
          wcache_data <= {{(DW - 16) {1'b0}}, i_data[15:0]} << (8 * i_addr[AXILSB-1:0]);
          // Write an 8b half-word
          2'b11:
          wcache_data <= {{(DW - 8) {1'b0}}, i_data[7:0]} << (8 * i_addr[AXILSB-1:0]);
          default:
          wcache_data <= {{(DW - 32) {1'b0}}, i_data} << (8 * i_addr[AXILSB-1:0]);
        endcase
      end

      if (locked_read_in_progress) wcache_data <= axi_rdata;
      // }}}

      // wcache_strb
      // {{{
      if (SWAP_WSTRB) begin
        case (i_op[2:1])
          // Write a 16b half-word
          2'b10:
          wcache_strb <= {2'h3, {(C_AXI_DATA_WIDTH / 8 - 2) {1'b0}}} >> (i_addr[AXILSB-1:0]);
          // Write an 8b byte
          2'b11:
          wcache_strb <= {1'b1, {(C_AXI_DATA_WIDTH / 8 - 1) {1'b0}}} >> (i_addr[AXILSB-1:0]);
          default:
          wcache_strb <= {4'hf, {(C_AXI_DATA_WIDTH / 8 - 4) {1'b0}}} >> (i_addr[AXILSB-1:0]);
        endcase
      end else begin
        case (i_op[2:1])
          // Write a 16b half-word
          2'b10:
          wcache_strb <= {{(C_AXI_DATA_WIDTH / 8 - 4) {1'b0}}, 4'h3} << (i_addr[AXILSB-1:0]);
          // Write an 8b byte
          2'b11:
          wcache_strb <= {{(C_AXI_DATA_WIDTH / 8 - 4) {1'b0}}, 4'h1} << (i_addr[AXILSB-1:0]);
          default:
          wcache_strb <= {{(C_AXI_DATA_WIDTH / 8 - 4) {1'b0}}, 4'hf} << (i_addr[AXILSB-1:0]);
        endcase
      end
      // }}}

      if (locked_read_in_progress) begin
        if (!locked_read_in_cache || !axi_rvalid_m || axi_rresp_m != EXOKAY)
          wcache_strb <= 0;
      end else if (!i_pipe_stb || !i_op[0] || misaligned) wcache_strb <= 0;
      // }}}
    end
  end
  // }}}

  // Actually write to the cache
  // {{{
  always @(posedge clk)
    if (state != DC_WRITE || (r_iv && wcache_tag == r_itag)) begin
      for (ik = 0; ik < DW / 8; ik = ik + 1)
        if (wcache_strb[ik]) cache_mem[wcache_addr][8*ik+:8] <= wcache_data[8*ik+:8];
    end
  // }}}

  // Update the cache tag
  // {{{
  always @(posedge clk)
    if (!flushing && axi_rvalid_m && state == DC_READC)
      cache_tag[r_cline] <= r_ctag;
  // }}}

  // o_busy
  // {{{
  always @(posedge clk)
    if (!rst_n) o_busy <= 1'b0;
    else if (flushing || (i_pipe_stb && !misaligned)) o_busy <= 1'b1;
    else if (state == DC_READS && axi_rvalid_m && last_ack) o_busy <= 1'b0;
    else if (OPT_WRAP
        // && state  == DC_READC && axi_rvalid_m && axi_rlast_m
        && state == DC_IDLE && !r_rd_pending)
      o_busy <= 1'b0;
    else if ((r_dvalid || r_svalid) && (!OPT_WRAP || state == DC_IDLE)) o_busy <= 1'b0;
    else if (axi_bvalid_m && last_ack && (!OPT_PIPE || !i_pipe_stb)) o_busy <= 1'b0;
  // }}}

  // o_rdbusy
  // {{{
  initial o_rdbusy = 1'b0;
  always @(posedge clk)
    if (!rst_n) o_rdbusy <= 1'b0;
    else if (i_cpu_reset) o_rdbusy <= 1'b0;
    else if (i_pipe_stb && (i_read || (i_lock && OPT_LOCK)) && !misaligned)
      o_rdbusy <= 1'b1;
    else if (state == DC_READS && axi_rvalid_m) o_rdbusy <= 1'b0;
    else if (state == DC_READC && axi_rvalid_m && (OPT_WRAP || axi_rresp_m[1]))
      o_rdbusy <= 1'b0;
    else if (locked_write_in_progress && axi_bvalid_m) o_rdbusy <= 1'b0;
    else if (r_svalid || r_dvalid) o_rdbusy <= 1'b0;
  // }}}

  // o_pipe_stalled
  // {{{
  generate
    if (OPT_PIPE) begin : GEN_PIPE_STALL
      reg r_pipe_stalled, pipe_stalled;
      (* keep *) reg [3:0] r_pipe_code;

      // else case( { ((axi_awvalid_m && axi_awready_m)
      //				||(axi_arvalid_m && axi_arready_m)),
      //		((axi_rvalid_m && axi_rlast_m) || axi_bvalid_m)
      //		})
      // 2'b10: noutstanding <= noutstanding + 1;
      // 2'b01: noutstanding <= noutstanding - 1;

      initial r_pipe_stalled = 1'b0;
      always @(posedge clk)
        if (!rst_n) begin
          r_pipe_stalled <= 1'b0;
          r_pipe_code    <= 4'h0;
        end else begin
          // Clear any stall on the last outstanding bus response
          if ((!OPT_WRAP && r_dvalid)
              // || (OPT_WRAP && state == DC_READC
              //		&& axi_rvalid_m && axi_rlast_m)
              || (OPT_WRAP && state == DC_IDLE && !r_rd_pending)) begin
            r_pipe_stalled <= 1'b0;
            r_pipe_code    <= 4'h1;
          end
          if (r_svalid) begin
            r_pipe_stalled <= 1'b0;
            r_pipe_code    <= 4'h2;
          end
          if (last_ack && (axi_bvalid_m
				||(OPT_WRAP && state == DC_IDLE && !r_rd_pending)
				||(state  == DC_READS && axi_rvalid_m
								&& last_ack)
				||(!OPT_WRAP && !r_rd_pending
					&& axi_rvalid_m && axi_rlast_m)))
			begin
            r_pipe_stalled <= 1'b0;
            r_pipe_code    <= 4'h3;
          end

          // If we have to start flushing, then we have to stall
          // while flushing

          if (i_cpu_reset || (axi_rvalid_m && axi_rresp_m[1]) || (axi_bvalid_m && axi_bresp_m[1]) || (i_pipe_stb && misaligned)) begin
            // {{{
            r_pipe_stalled <= 1'b0;
            r_pipe_code    <= 4'ha;

            // Always stall if we have to start flushing
            if (axi_arvalid_m || axi_awvalid_m || axi_wvalid_m) begin
              r_pipe_stalled <= 1'b1;
              r_pipe_code    <= 4'h4;
            end
            if (!last_ack) begin
              r_pipe_stalled <= 1'b1;
              r_pipe_code    <= 4'h5;
            end
            if ((noutstanding >= 1) && !axi_bvalid_m && (!axi_rvalid_m || !axi_rlast_m)) begin
              r_pipe_stalled <= 1'b1;
              r_pipe_code    <= 4'h6;
            end
            // }}}
          end

          // All cachable read requests will stall our pipeline
          if (!i_cpu_reset && i_pipe_stb && i_read && !misaligned) begin
            r_pipe_stalled <= 1'b1;
            r_pipe_code    <= 4'h7;
          end
          if (!i_cpu_reset && i_pipe_stb && i_lock && !misaligned) begin
            r_pipe_stalled <= 1'b1;
            r_pipe_code    <= 4'h8;
          end

          if (flushing && (axi_awvalid_m || axi_arvalid_m || axi_wvalid_m)) begin
            r_pipe_stalled <= 1'b1;
            r_pipe_code    <= 4'h9;
          end
        end

      always @(*)
        if (r_pipe_stalled) pipe_stalled = 1'b1;
        else if (axi_awvalid_m && !axi_awready_m) pipe_stalled = 1'b1;
        else if (axi_wvalid_m && !axi_wready_m) pipe_stalled = 1'b1;
        else if (full_pipe) pipe_stalled = 1'b1;
        else pipe_stalled = 1'b0;

      assign w_pipe_stalled = r_pipe_stalled;
      assign o_pipe_stalled = pipe_stalled;

      // Verilator lint_off UNUSED
      wire unused_pipe;
      assign unused_pipe = &{1'b0, r_pipe_code};
      // Verilator lint_on  UNUSED

    end else begin : PIPE_STALL_ON_BUSY
      assign w_pipe_stalled = 1'b0;
      assign o_pipe_stalled = o_busy;

      // Verilator lint_off UNUSED
      wire unused_pipe;
      assign unused_pipe = &{1'b0, full_pipe};
      // Verilator lint_on  UNUSED
    end
  endgenerate
  // }}}

  // o_wreg
  // {{{
  // generate if (!OPT_PIPE)
  always @(posedge clk)
    if (i_pipe_stb) begin
      o_wreg <= i_oreg;
      if (OPT_LOCK && i_lock && i_op[0]) o_wreg <= {i_oreg[4], 4'hf};
    end
  // }}}

  // restart_pc
  // {{{
  generate
    if (OPT_LOCK) begin : GEN_RESTART_PC
      reg [AW-1:0] r_pc;

      always @(posedge clk) if (i_pipe_stb && i_lock && i_op[0]) r_pc <= i_restart_pc;

      assign restart_pc = r_pc;

    end else begin : NO_RESTART_PC
      assign restart_pc = 0;

      // Verilator lint_off UNUSED
      wire unused_restart_pc;
      assign unused_restart_pc = &{1'b0, i_restart_pc};
      // Verilator lint_on  UNUSED
    end
  endgenerate
  // }}}

  // req_data
  // {{{
  always @(posedge clk) if (i_pipe_stb) req_data <= {i_op[2:1], rev_addr[AXILSB-1:0]};

  assign req_lsb = req_data[AXILSB-1:0];
  assign req_op  = req_data[AXILSB+:2];
  // }}}

  // o_err
  // {{{
  initial o_err = 1'b0;
  always @(posedge clk)
    if (!rst_n) o_err <= 1'b0;
    else if (i_cpu_reset || flushing) o_err <= 1'b0;
    else begin
      o_err <= 1'b0;
      if (axi_rvalid_m && axi_rresp_m[1] && o_rdbusy && !r_dvalid) o_err <= 1'b1;
      if (axi_rvalid_m && locked_read_in_progress && axi_rresp_m != EXOKAY) o_err <= 1'b1;
      if (axi_bvalid_m && axi_bresp_m[1]) o_err <= 1'b1;
      if (i_pipe_stb && misaligned) o_err <= 1'b1;
    end
  // }}}

  // Read from the cache
  // {{{
  generate
    if (OPT_DUAL_READ_PORT) begin : GEN_DUALREAD
      always @(posedge clk)
        if (!OPT_LOWPOWER || (i_pipe_stb && !i_op[0]))
          cached_iword <= cache_mem[i_caddr];

      always @(posedge clk)
        if (!OPT_LOWPOWER || o_rdbusy)
          cached_rword <= cache_mem[r_caddr];
    end else begin : GEN_SINGLE_READ_PORT

      always @(posedge clk) cached_rword <= cache_mem[(o_busy)?r_caddr : i_caddr];

      always @(*) cached_iword = cached_rword;
    end
  endgenerate
  // }}}

  // o_data, pre_data
  // {{{
  always @(*)
    if (r_svalid) pre_data = cached_iword;
    else if (state == DC_READS || (OPT_WRAP && state == DC_READC)) pre_data = axi_rdata;
    else pre_data = cached_rword;

  always @(*)
    if (SWAP_WSTRB) begin
      shifted_data = pre_data << (8 * req_lsb);

      casez (req_op)
        2'b10:   shifted_data[31:0] = {16'h0, shifted_data[DW-1:DW-16]};
        2'b11:   shifted_data[31:0] = {24'h0, shifted_data[DW-1:DW-8]};
        default: shifted_data[31:0] = shifted_data[DW-1:DW-32];
      endcase
    end else shifted_data = pre_data >> (8 * req_lsb);

  // o_data
  always @(posedge clk) begin
    o_data <= shifted_data[31:0];
    if (OPT_SIGN_EXTEND) begin
      // verilator coverage_off
      // Unused, would violate ZipCPU ISA
      casez (req_op)
        2'b10: o_data[31:16] <= {(16) {shifted_data[15]}};
        2'b11: o_data[31:8] <= {(24) {shifted_data[7]}};
        default: begin
        end
      endcase
      // verilator coverage_on
    end else begin
      casez (req_op)
        2'b10: o_data[31:16] <= 0;
        2'b11: o_data[31:8] <= 0;
        default: begin
        end
      endcase
    end

    if (locked_write_in_progress) begin
      o_data         <= 0;
      o_data[AW-1:0] <= restart_pc;
    end
  end
  // }}}

  // o_valid
  // {{{
  initial o_valid = 1'b0;
  always @(posedge clk)
    if (i_cpu_reset || flushing) o_valid <= 1'b0;
    else if (state == DC_READS) begin
      o_valid <= axi_rvalid_m && !axi_rresp_m[1];
      if (OPT_LOCK && locked_read_in_progress && axi_rresp_m != EXOKAY) o_valid <= 0;
    end else if (locked_write_in_progress && axi_bvalid_m && axi_bresp_m == OKAY)
      o_valid <= 1'b1;
    else if (OPT_WRAP && r_rd_pending && state == DC_READC)
      o_valid <= axi_rvalid_m && !axi_rresp_m[1];
    else o_valid <= r_svalid || r_dvalid;

endmodule

module ifu_icache #(
    parameter int            LGCACHESZ    = 8,
    parameter int            LGLINESZ     = 4,
    parameter int            IW           = 2,
    parameter int            AW           = 32,
    parameter int            DW           = 64,
    parameter logic [   0:0] OPT_LOWPOWER = 1'b0,
    parameter logic [IW-1:0] AXI_ID       = 0,
    parameter int            ADDRLSB      = $clog2(DW / 8),
    parameter int            LS           = LGLINESZ,
    parameter int            LSB          = LGLINESZ + ADDRLSB
) (

  input  logic          clk,
  input  logic          rst_n,
  output logic          axi_arvalid_f,
  input  logic          axi_arready_f,
  output logic [AW-1:0] axi_araddr_f,
  output logic [   7:0] axi_arlen_f,
  input  logic          axi_rvalid_f,
  input  logic          axi_rready_f,
  input  logic [IW-1:0] axi_rid_f,
  input  logic [DW-1:0] axi_rdata_f,
  input  logic          axi_rlast_f,
  input  logic [   1:0] axi_rresp_f,
  input  logic          ic_cpu_reset,
  input  logic          ic_clear,
  output logic [  63:0] ic_rd,
  input  logic          ic_ready,
  output logic          ic_valid,
  output logic          illegal,
  input  logic          ifu_npc_en,
  input  logic [AW-1:1] ifu_fetch_pc_d,
  input  logic [AW-1:1] ifu_fetch_pc,
  input  logic [AW-1:1] ifu_last_pc
);
  // localparam CACHELEN=(1<<LGCACHESZ); //Byte Size of our cache memory
  // localparam CACHELENW = CACHELEN/(DW/8); // Word sz
  localparam int CWB = LGCACHESZ;  // Short hand for LGCACHESZ
  localparam int CW = LGCACHESZ - ADDRLSB;  // now in words
  localparam int LGLINES = CWB - LSB;
  //

  logic [              DW-1:0] cache           [     1<<CW];
  logic [        (AW-CWB-1):0] cache_tags      [1<<LGLINES];
  logic [((1<<(LGLINES))-1):0] cache_valid;

  logic                        illegal_valid;
  logic                        request_pending;
  logic                        bus_abort;
  logic                        valid_line;
  logic [            AW-1:LSB] illegal_tag;
  logic [              LS-1:0] write_posn;
  logic                        axi_arvalid;
  logic [              AW-1:0] axi_araddr;
  logic                        start_read;
  logic                        wrap_valid;

  logic [         CWB-LSB-1:0] axi_line;
  logic [         CWB-LSB-1:0] pc_line;
  logic [         CWB-LSB-1:0] last_line;
  logic [          AW-CWB-1:0] axi_tag;

  logic [                63:0] cache_word;

  assign axi_line  = axi_araddr[CWB-1:LSB];
  assign axi_tag   = axi_araddr[AW-1:CWB];
  assign pc_line   = ifu_fetch_pc_d[CWB-1:LSB];
  assign last_line = ifu_last_pc[CWB-1:LSB];

  // verilog_format: off
  logic [            AW-1:LSB] pc_tag;
  logic [            AW-1:LSB] last_tag;

  mydffs from_pc_ff (.*, .din(ifu_npc_en || ic_clear || (ic_valid && ic_ready) ? 1'b1 : 1'b0), .dout(from_pc));
  mydffs pc_valid_ff     (.*, .din(cache_valid[pc_line]),   .dout(pc_valid));
  mydffs last_valid_ff   (.*, .din(cache_valid[last_line]), .dout(last_valid));

  mydffs #(.W(AW-LSB), .L(LSB)) pc_tagff   (.*, .din({cache_tags[pc_line], pc_line}), .dout(pc_tag));
  mydffs #(.W(AW-LSB), .L(LSB)) last_tagff   (.*, .din({cache_tags[last_line], last_line}), .dout(last_tag));

  // verilog_format: on

  always_ff @(posedge clk)
    if ((ic_cpu_reset) || (ic_clear)) illegal_tag <= 0;
    else if (axi_rvalid_f && axi_rresp_f[1]) illegal_tag <= axi_araddr[AW-1:LSB];

  always_ff @(posedge clk)
    if ((ic_cpu_reset) || (ic_clear)) illegal_valid <= 0;
    else if (axi_rvalid_f && axi_rresp_f[1]) illegal_valid <= 1'b1;

  always_comb begin
    valid_line = 1'b0;

    // Zero delay lookup: New PC, but staying w/in same cache line
    //   This only works if the entire line is full--so no requests
    //   may be pending at this time.
    if (ifu_npc_en)
      valid_line = !request_pending && pc_valid && pc_tag == ifu_fetch_pc_d[AW-1:LSB];
    else if (ic_valid && ic_ready) begin
      // Zero delay lookup, tag matches last lookup
      valid_line = pc_valid && (ifu_fetch_pc_d[AW-1:LSB] == pc_tag[AW-1:LSB]);
      if (wrap_valid && ifu_fetch_pc_d[AW-1:LSB] == axi_araddr[AW-1:LSB]) valid_line = 1;
    end else begin
      // Longer lookups.  Several possibilities here.

      // 1. We might be working through recent reads from the
      //    cache, for which the cache line isn't yet full
      valid_line = wrap_valid;

      // 2. One delay lookup.  Request was for an address with
      //    a different tag.  Since it was different, we had
      //    to do a memory read to look it up.  After lookup,
      //    the tag now matches.
      if (from_pc && pc_valid && pc_tag == ifu_last_pc[AW-1:LSB]) valid_line = 1'b1;

      // 3. Many delay lookup.  The tag didn't match, so we
      //    had to go search for it from memory.  The cache
      //    line is now valid, so now we can use it.
      if (!from_pc && last_valid && last_tag == ifu_last_pc[AW-1:LSB]) valid_line = 1'b1;

      // 4. Illegal lookup.
      if (!ic_valid && illegal_valid && illegal_tag == ifu_last_pc[AW-1:LSB])
        valid_line = 1;
    end
  end

  // start_read

  // Issue a bus transaction -- the cache line requested couldn't be
  // found in the bus anywhere, so we need to go look for it
  logic wait_on_read;
  always_ff @(posedge clk)
    if (!rst_n) wait_on_read <= 1;
    else begin
      wait_on_read <= request_pending;  // axi_rvalid_f && axi_rlast_f;
      if (ic_clear || ifu_npc_en || ic_cpu_reset) wait_on_read <= 1;
    end

  always_comb begin
    start_read = !valid_line && !ic_valid;
    if (ic_clear || ifu_npc_en || wait_on_read || illegal || axi_arvalid_f ||
        request_pending || ic_cpu_reset || !rst_n)
      start_read = 0;
  end
  // }}}

  // axi_arvalid

  always_ff @(posedge clk)
    if (!rst_n) axi_arvalid <= 0;
    else if (!axi_arvalid_f || axi_arready_f) axi_arvalid <= start_read;
  // }}}

  // request_pending, bus_abort

  always_ff @(posedge clk)
    if (!rst_n) begin
      request_pending <= 0;
      bus_abort       <= 0;
    end else if (request_pending) begin
      if (ic_cpu_reset || ic_clear) bus_abort <= 1;
      if (axi_rvalid_f && axi_rresp_f[1]) bus_abort <= 1;
      if (ifu_npc_en && ifu_fetch_pc_d[AW-1:LSB] != axi_araddr[AW-1:LSB]) bus_abort <= 1;

      if (axi_rvalid_f && axi_rlast_f) begin
        request_pending <= 0;
        bus_abort       <= 0;
      end
    end else if (!axi_arvalid_f || axi_arready_f) begin
      request_pending <= start_read;
      bus_abort       <= 0;
    end
  // }}}

  // axi_araddr

  always_ff @(posedge clk)
    if ((!axi_arvalid_f || axi_arready_f) && !request_pending) begin
      axi_araddr              <= ifu_last_pc;
      axi_araddr[ADDRLSB-1:0] <= 0;

      if (OPT_LOWPOWER && !start_read) axi_araddr <= 0;
    end
  // }}}

  // write_posn -- the sub-address w/in the cache to write to

  always_ff @(posedge clk)
    if (!request_pending) write_posn <= ifu_last_pc[LSB-1:ADDRLSB];
    else if (axi_rvalid_f && axi_rready_f) write_posn <= write_posn + 1;
  // }}}

  // cache -- Actually do the write to cache memory


  always_ff @(posedge clk)
    if (axi_rvalid_f && axi_rready_f)
      cache[{axi_araddr[CWB-1:LSB], write_posn}] <= axi_rdata_f;
  // }}}
  // }}}

  // cache_tags, set/control/write-to the cache tags array

  always_ff @(posedge clk) if (request_pending) cache_tags[axi_line] <= axi_tag;
  // }}}

  // cache_valid--keep track of which cache entry has valid data w/in it

  always_ff @(posedge clk)
    if (ic_cpu_reset || ic_clear) cache_valid <= 0;
    else if (request_pending)
      cache_valid[axi_line] <=
          (axi_rvalid_f && axi_rready_f && axi_rlast_f && !axi_rresp_f[1]);
  // }}}



  logic r_wrap, r_valid, r_poss;
  logic [(1<<LS):0] r_count;

  // r_wrap-- Can we keep continuing prior to the cache being vld?

  always_ff @(posedge clk)
    if (!rst_n) r_wrap <= 0;
    else if (axi_arvalid_f) r_wrap <= 1;
    else if (axi_rvalid_f && (&write_posn)) r_wrap <= 0;
  // }}}

  // r_poss, r_count

  always_ff @(posedge clk)
    if (!rst_n) begin
      r_poss  <= 0;
      r_count <= 0;
    end else if (ifu_npc_en || ic_clear || ic_cpu_reset ||
                 (axi_rvalid_f && (axi_rlast_f || axi_rresp_f[1]))) begin
      r_poss  <= 0;
      r_count <= 0;
    end else if (axi_arvalid_f &&
                 axi_araddr_f[AW-1:ADDRLSB] == ifu_last_pc[AW-1:ADDRLSB]) begin
      r_poss  <= !bus_abort;
      r_count <= 0;
    end else if (r_poss)
      case ({
        (axi_rvalid_f && axi_rready_f && r_wrap), (ic_valid && ic_ready)
      })
        2'b01: begin
          r_count <= r_count - 1;
          r_poss  <= (r_count > 1) || r_wrap;
        end
        2'b10: r_count <= r_count + 1;
        default: begin
        end
      endcase

  always_ff @(posedge clk)
    if (!rst_n) r_valid <= 0;
    else if (ic_cpu_reset || ifu_npc_en || ic_clear || bus_abort ||
             (axi_rvalid_f && axi_rresp_f[1]) || !r_poss)
      r_valid <= 0;
    else if (!r_valid || !ic_valid || ic_ready) begin
      // We can be valid if there's one more in the buffer
      // than we've read so far.
      r_valid <=
          (r_count > ((r_valid && (!ic_valid || ic_ready)) ? 1 : 0) + (ic_valid ? 1 : 0));
      // We can also be valid if another one has just been
      //   read--as long as it's not due to a bus error.
      if (axi_rvalid_f && r_wrap) r_valid <= 1'b1;
    end

  assign wrap_valid = r_valid;

  always_ff @(posedge clk)
    if (ifu_npc_en || (!ic_valid || ic_ready)) begin
      cache_word <= cache[(ifu_npc_en||ic_valid)?ifu_fetch_pc_d[CWB-1:ADDRLSB] :
                          ifu_fetch_pc[CWB-1:ADDRLSB]];
    end


  // Are we returning a valid instruction to the CPU on this cycle?
  always_ff @(posedge clk)
    if (ic_cpu_reset || ic_clear) ic_valid <= 0;
    else if (ic_valid && (ic_ready || ifu_npc_en)) begin
      // Grab the next instruction--always ready on the same cycle
      // if we stay within the same cache line
      ic_valid <= valid_line;
      if (illegal) ic_valid <= 0;
    end else if (!ic_valid && !ifu_npc_en) begin
      // We're stuck waiting for the cache line to become valid.
      // Don't forget to check for the illegal flag.
      ic_valid <= valid_line;
      if (illegal_valid && ifu_fetch_pc[AW-1:LSB] == illegal_tag) ic_valid <= 1;
    end
  // }}}

  always_ff @(posedge clk)
    if (ic_cpu_reset || ic_clear || ifu_npc_en) illegal <= 1'b0;
    else if (ic_valid && !illegal) illegal <= 1'b0;
    else if (illegal_valid && ifu_fetch_pc[AW-1:LSB] == illegal_tag) illegal <= 1'b1;

  assign axi_arvalid_f = axi_arvalid;
  assign axi_araddr_f  = axi_araddr;

  assign axi_arlen_f   = (1 << LS) - 1;

  assign ic_rd         = cache_word >> (ifu_fetch_pc[2:1] * 16);

endmodule

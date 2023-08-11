// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4_seq_item.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Fri Aug 11 07:29:11 2023
//=============================================================================
// Description: Sequence item for axi4_sequencer
//=============================================================================

`ifndef AXI4_SEQ_ITEM_SV
`define AXI4_SEQ_ITEM_SV

// Start of inlined include file src/tb/uvm_bfm/tb/include/axi4_trans_inc_before_class.sv
typedef struct packed {
  logic [1:0]  awid;
  logic [31:0] awaddr;
  logic [7:0]  awlen;
  logic [2:0]  awsize;
  logic [1:0]  awburst;
  logic        awlock;
  logic [3:0]  awcache;
  logic [2:0]  awprot;
  logic        awvalid;
  logic [3:0]  awregion;
  logic [3:0]  awqos;
  logic        awready;
  logic [63:0] wdata;
  logic [7:0]  wstrb;
  logic        wlast;
  logic        wvalid;
  logic        wready;
  logic [1:0]  bid;
  logic [1:0]  bresp;
  logic        bvalid;
  logic        bready;
  logic [1:0]  arid;
  logic [31:0] araddr;
  logic [7:0]  arlen;
  logic [2:0]  arsize;
  logic [1:0]  arburst;
  logic        arlock;
  logic [3:0]  arcache;
  logic [2:0]  arprot;
  logic        arvalid;
  logic [3:0]  arqos;
  logic [3:0]  arregion;
  logic        arready;
  logic [1:0]  rid;
  logic [63:0] rdata;
  logic [1:0]  rresp;
  logic        rlast;
  logic        rvalid;
  logic        rready;
} axi4_tx_s;
// End of inlined include file

class axi4_tx extends uvm_sequence_item; 

  `uvm_object_utils(axi4_tx)

  // To include variables in copy, compare, print, record, pack, unpack, and compare2string, define them using trans_var in file tools/gen/axi4bfm/axi4.tpl
  // To exclude variables from compare, pack, and unpack methods, define them using trans_meta in file tools/gen/axi4bfm/axi4.tpl

  // Transaction variables
  rand logic [ 1:0] awid;
  rand logic [31:0] awaddr;
  rand logic [ 7:0] awlen;
  rand logic [ 2:0] awsize;
  rand logic [ 1:0] awburst;
  rand logic        awlock;
  rand logic [ 3:0] awcache;
  rand logic [ 2:0] awprot;
  rand logic        awvalid;
  rand logic [ 3:0] awregion;
  rand logic [ 3:0] awqos;
  rand logic        awready;
  rand logic [63:0] wdata;
  rand logic [ 7:0] wstrb;
  rand logic        wlast;
  rand logic        wvalid;
  rand logic        wready;
  rand logic [1:0] bid;
  rand logic [1:0] bresp;
  rand logic       bvalid;
  rand logic       bready;
  rand logic [ 1:0] arid;
  rand logic [31:0] araddr;
  rand logic [ 7:0] arlen;
  rand logic [ 2:0] arsize;
  rand logic [ 1:0] arburst;
  rand logic        arlock;
  rand logic [ 3:0] arcache;
  rand logic [ 2:0] arprot;
  rand logic        arvalid;
  rand logic [ 3:0] arqos;
  rand logic [ 3:0] arregion;
  rand logic        arready;
  rand logic [ 1:0] rid;
  rand logic [63:0] rdata;
  rand logic [ 1:0] rresp;
  rand logic        rlast;
  rand logic        rvalid;
  rand logic        rready;


  extern function new(string name = "");

  // You can remove do_copy/compare/print/record and convert2string method by setting trans_generate_methods_inside_class = no in file tools/gen/axi4bfm/axi4.tpl
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function void do_record(uvm_recorder recorder);
  extern function void do_pack(uvm_packer packer);
  extern function void do_unpack(uvm_packer packer);
  extern function string convert2string();

  // You can insert code here by setting trans_inc_inside_class in file tools/gen/axi4bfm/axi4.tpl

endclass : axi4_tx 


function axi4_tx::new(string name = "");
  super.new(name);
endfunction : new


// You can remove do_copy/compare/print/record and convert2string method by setting trans_generate_methods_after_class = no in file tools/gen/axi4bfm/axi4.tpl

function void axi4_tx::do_copy(uvm_object rhs);
  axi4_tx rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);
  awid     = rhs_.awid;    
  awaddr   = rhs_.awaddr;  
  awlen    = rhs_.awlen;   
  awsize   = rhs_.awsize;  
  awburst  = rhs_.awburst; 
  awlock   = rhs_.awlock;  
  awcache  = rhs_.awcache; 
  awprot   = rhs_.awprot;  
  awvalid  = rhs_.awvalid; 
  awregion = rhs_.awregion;
  awqos    = rhs_.awqos;   
  awready  = rhs_.awready; 
  wdata    = rhs_.wdata;   
  wstrb    = rhs_.wstrb;   
  wlast    = rhs_.wlast;   
  wvalid   = rhs_.wvalid;  
  wready   = rhs_.wready;  
  bid      = rhs_.bid;     
  bresp    = rhs_.bresp;   
  bvalid   = rhs_.bvalid;  
  bready   = rhs_.bready;  
  arid     = rhs_.arid;    
  araddr   = rhs_.araddr;  
  arlen    = rhs_.arlen;   
  arsize   = rhs_.arsize;  
  arburst  = rhs_.arburst; 
  arlock   = rhs_.arlock;  
  arcache  = rhs_.arcache; 
  arprot   = rhs_.arprot;  
  arvalid  = rhs_.arvalid; 
  arqos    = rhs_.arqos;   
  arregion = rhs_.arregion;
  arready  = rhs_.arready; 
  rid      = rhs_.rid;     
  rdata    = rhs_.rdata;   
  rresp    = rhs_.rresp;   
  rlast    = rhs_.rlast;   
  rvalid   = rhs_.rvalid;  
  rready   = rhs_.rready;  
endfunction : do_copy


function bit axi4_tx::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  axi4_tx rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  result = super.do_compare(rhs, comparer);
  result &= comparer.compare_field("awid", awid,         rhs_.awid,     $bits(awid));
  result &= comparer.compare_field("awaddr", awaddr,     rhs_.awaddr,   $bits(awaddr));
  result &= comparer.compare_field("awlen", awlen,       rhs_.awlen,    $bits(awlen));
  result &= comparer.compare_field("awsize", awsize,     rhs_.awsize,   $bits(awsize));
  result &= comparer.compare_field("awburst", awburst,   rhs_.awburst,  $bits(awburst));
  result &= comparer.compare_field("awlock", awlock,     rhs_.awlock,   $bits(awlock));
  result &= comparer.compare_field("awcache", awcache,   rhs_.awcache,  $bits(awcache));
  result &= comparer.compare_field("awprot", awprot,     rhs_.awprot,   $bits(awprot));
  result &= comparer.compare_field("awvalid", awvalid,   rhs_.awvalid,  $bits(awvalid));
  result &= comparer.compare_field("awregion", awregion, rhs_.awregion, $bits(awregion));
  result &= comparer.compare_field("awqos", awqos,       rhs_.awqos,    $bits(awqos));
  result &= comparer.compare_field("awready", awready,   rhs_.awready,  $bits(awready));
  result &= comparer.compare_field("wdata", wdata,       rhs_.wdata,    $bits(wdata));
  result &= comparer.compare_field("wstrb", wstrb,       rhs_.wstrb,    $bits(wstrb));
  result &= comparer.compare_field("wlast", wlast,       rhs_.wlast,    $bits(wlast));
  result &= comparer.compare_field("wvalid", wvalid,     rhs_.wvalid,   $bits(wvalid));
  result &= comparer.compare_field("wready", wready,     rhs_.wready,   $bits(wready));
  result &= comparer.compare_field("bid", bid,           rhs_.bid,      $bits(bid));
  result &= comparer.compare_field("bresp", bresp,       rhs_.bresp,    $bits(bresp));
  result &= comparer.compare_field("bvalid", bvalid,     rhs_.bvalid,   $bits(bvalid));
  result &= comparer.compare_field("bready", bready,     rhs_.bready,   $bits(bready));
  result &= comparer.compare_field("arid", arid,         rhs_.arid,     $bits(arid));
  result &= comparer.compare_field("araddr", araddr,     rhs_.araddr,   $bits(araddr));
  result &= comparer.compare_field("arlen", arlen,       rhs_.arlen,    $bits(arlen));
  result &= comparer.compare_field("arsize", arsize,     rhs_.arsize,   $bits(arsize));
  result &= comparer.compare_field("arburst", arburst,   rhs_.arburst,  $bits(arburst));
  result &= comparer.compare_field("arlock", arlock,     rhs_.arlock,   $bits(arlock));
  result &= comparer.compare_field("arcache", arcache,   rhs_.arcache,  $bits(arcache));
  result &= comparer.compare_field("arprot", arprot,     rhs_.arprot,   $bits(arprot));
  result &= comparer.compare_field("arvalid", arvalid,   rhs_.arvalid,  $bits(arvalid));
  result &= comparer.compare_field("arqos", arqos,       rhs_.arqos,    $bits(arqos));
  result &= comparer.compare_field("arregion", arregion, rhs_.arregion, $bits(arregion));
  result &= comparer.compare_field("arready", arready,   rhs_.arready,  $bits(arready));
  result &= comparer.compare_field("rid", rid,           rhs_.rid,      $bits(rid));
  result &= comparer.compare_field("rdata", rdata,       rhs_.rdata,    $bits(rdata));
  result &= comparer.compare_field("rresp", rresp,       rhs_.rresp,    $bits(rresp));
  result &= comparer.compare_field("rlast", rlast,       rhs_.rlast,    $bits(rlast));
  result &= comparer.compare_field("rvalid", rvalid,     rhs_.rvalid,   $bits(rvalid));
  result &= comparer.compare_field("rready", rready,     rhs_.rready,   $bits(rready));
  return result;
endfunction : do_compare


function void axi4_tx::do_print(uvm_printer printer);
  if (printer.knobs.sprint == 0)
    `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
  else
    printer.m_string = convert2string();
endfunction : do_print


function void axi4_tx::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  // Use the record macros to record the item fields:
  `uvm_record_field("awid",     awid)    
  `uvm_record_field("awaddr",   awaddr)  
  `uvm_record_field("awlen",    awlen)   
  `uvm_record_field("awsize",   awsize)  
  `uvm_record_field("awburst",  awburst) 
  `uvm_record_field("awlock",   awlock)  
  `uvm_record_field("awcache",  awcache) 
  `uvm_record_field("awprot",   awprot)  
  `uvm_record_field("awvalid",  awvalid) 
  `uvm_record_field("awregion", awregion)
  `uvm_record_field("awqos",    awqos)   
  `uvm_record_field("awready",  awready) 
  `uvm_record_field("wdata",    wdata)   
  `uvm_record_field("wstrb",    wstrb)   
  `uvm_record_field("wlast",    wlast)   
  `uvm_record_field("wvalid",   wvalid)  
  `uvm_record_field("wready",   wready)  
  `uvm_record_field("bid",      bid)     
  `uvm_record_field("bresp",    bresp)   
  `uvm_record_field("bvalid",   bvalid)  
  `uvm_record_field("bready",   bready)  
  `uvm_record_field("arid",     arid)    
  `uvm_record_field("araddr",   araddr)  
  `uvm_record_field("arlen",    arlen)   
  `uvm_record_field("arsize",   arsize)  
  `uvm_record_field("arburst",  arburst) 
  `uvm_record_field("arlock",   arlock)  
  `uvm_record_field("arcache",  arcache) 
  `uvm_record_field("arprot",   arprot)  
  `uvm_record_field("arvalid",  arvalid) 
  `uvm_record_field("arqos",    arqos)   
  `uvm_record_field("arregion", arregion)
  `uvm_record_field("arready",  arready) 
  `uvm_record_field("rid",      rid)     
  `uvm_record_field("rdata",    rdata)   
  `uvm_record_field("rresp",    rresp)   
  `uvm_record_field("rlast",    rlast)   
  `uvm_record_field("rvalid",   rvalid)  
  `uvm_record_field("rready",   rready)  
endfunction : do_record


function void axi4_tx::do_pack(uvm_packer packer);
  super.do_pack(packer);
  `uvm_pack_int(awid)     
  `uvm_pack_int(awaddr)   
  `uvm_pack_int(awlen)    
  `uvm_pack_int(awsize)   
  `uvm_pack_int(awburst)  
  `uvm_pack_int(awlock)   
  `uvm_pack_int(awcache)  
  `uvm_pack_int(awprot)   
  `uvm_pack_int(awvalid)  
  `uvm_pack_int(awregion) 
  `uvm_pack_int(awqos)    
  `uvm_pack_int(awready)  
  `uvm_pack_int(wdata)    
  `uvm_pack_int(wstrb)    
  `uvm_pack_int(wlast)    
  `uvm_pack_int(wvalid)   
  `uvm_pack_int(wready)   
  `uvm_pack_int(bid)      
  `uvm_pack_int(bresp)    
  `uvm_pack_int(bvalid)   
  `uvm_pack_int(bready)   
  `uvm_pack_int(arid)     
  `uvm_pack_int(araddr)   
  `uvm_pack_int(arlen)    
  `uvm_pack_int(arsize)   
  `uvm_pack_int(arburst)  
  `uvm_pack_int(arlock)   
  `uvm_pack_int(arcache)  
  `uvm_pack_int(arprot)   
  `uvm_pack_int(arvalid)  
  `uvm_pack_int(arqos)    
  `uvm_pack_int(arregion) 
  `uvm_pack_int(arready)  
  `uvm_pack_int(rid)      
  `uvm_pack_int(rdata)    
  `uvm_pack_int(rresp)    
  `uvm_pack_int(rlast)    
  `uvm_pack_int(rvalid)   
  `uvm_pack_int(rready)   
endfunction : do_pack


function void axi4_tx::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  `uvm_unpack_int(awid)     
  `uvm_unpack_int(awaddr)   
  `uvm_unpack_int(awlen)    
  `uvm_unpack_int(awsize)   
  `uvm_unpack_int(awburst)  
  `uvm_unpack_int(awlock)   
  `uvm_unpack_int(awcache)  
  `uvm_unpack_int(awprot)   
  `uvm_unpack_int(awvalid)  
  `uvm_unpack_int(awregion) 
  `uvm_unpack_int(awqos)    
  `uvm_unpack_int(awready)  
  `uvm_unpack_int(wdata)    
  `uvm_unpack_int(wstrb)    
  `uvm_unpack_int(wlast)    
  `uvm_unpack_int(wvalid)   
  `uvm_unpack_int(wready)   
  `uvm_unpack_int(bid)      
  `uvm_unpack_int(bresp)    
  `uvm_unpack_int(bvalid)   
  `uvm_unpack_int(bready)   
  `uvm_unpack_int(arid)     
  `uvm_unpack_int(araddr)   
  `uvm_unpack_int(arlen)    
  `uvm_unpack_int(arsize)   
  `uvm_unpack_int(arburst)  
  `uvm_unpack_int(arlock)   
  `uvm_unpack_int(arcache)  
  `uvm_unpack_int(arprot)   
  `uvm_unpack_int(arvalid)  
  `uvm_unpack_int(arqos)    
  `uvm_unpack_int(arregion) 
  `uvm_unpack_int(arready)  
  `uvm_unpack_int(rid)      
  `uvm_unpack_int(rdata)    
  `uvm_unpack_int(rresp)    
  `uvm_unpack_int(rlast)    
  `uvm_unpack_int(rvalid)   
  `uvm_unpack_int(rready)   
endfunction : do_unpack


function string axi4_tx::convert2string();
  string s;
  $sformat(s, "%s\n", super.convert2string());
  $sformat(s, {"%s\n",
    "awid     = 'h%0h  'd%0d\n", 
    "awaddr   = 'h%0h  'd%0d\n", 
    "awlen    = 'h%0h  'd%0d\n", 
    "awsize   = 'h%0h  'd%0d\n", 
    "awburst  = 'h%0h  'd%0d\n", 
    "awlock   = 'h%0h  'd%0d\n", 
    "awcache  = 'h%0h  'd%0d\n", 
    "awprot   = 'h%0h  'd%0d\n", 
    "awvalid  = 'h%0h  'd%0d\n", 
    "awregion = 'h%0h  'd%0d\n", 
    "awqos    = 'h%0h  'd%0d\n", 
    "awready  = 'h%0h  'd%0d\n", 
    "wdata    = 'h%0h  'd%0d\n", 
    "wstrb    = 'h%0h  'd%0d\n", 
    "wlast    = 'h%0h  'd%0d\n", 
    "wvalid   = 'h%0h  'd%0d\n", 
    "wready   = 'h%0h  'd%0d\n", 
    "bid      = 'h%0h  'd%0d\n", 
    "bresp    = 'h%0h  'd%0d\n", 
    "bvalid   = 'h%0h  'd%0d\n", 
    "bready   = 'h%0h  'd%0d\n", 
    "arid     = 'h%0h  'd%0d\n", 
    "araddr   = 'h%0h  'd%0d\n", 
    "arlen    = 'h%0h  'd%0d\n", 
    "arsize   = 'h%0h  'd%0d\n", 
    "arburst  = 'h%0h  'd%0d\n", 
    "arlock   = 'h%0h  'd%0d\n", 
    "arcache  = 'h%0h  'd%0d\n", 
    "arprot   = 'h%0h  'd%0d\n", 
    "arvalid  = 'h%0h  'd%0d\n", 
    "arqos    = 'h%0h  'd%0d\n", 
    "arregion = 'h%0h  'd%0d\n", 
    "arready  = 'h%0h  'd%0d\n", 
    "rid      = 'h%0h  'd%0d\n", 
    "rdata    = 'h%0h  'd%0d\n", 
    "rresp    = 'h%0h  'd%0d\n", 
    "rlast    = 'h%0h  'd%0d\n", 
    "rvalid   = 'h%0h  'd%0d\n", 
    "rready   = 'h%0h  'd%0d\n"},
    get_full_name(), awid, awid, awaddr, awaddr, awlen, awlen, awsize, awsize, awburst, awburst, awlock, awlock, awcache, awcache, awprot, awprot, awvalid, awvalid, awregion, awregion, awqos, awqos, awready, awready, wdata, wdata, wstrb, wstrb, wlast, wlast, wvalid, wvalid, wready, wready, bid, bid, bresp, bresp, bvalid, bvalid, bready, bready, arid, arid, araddr, araddr, arlen, arlen, arsize, arsize, arburst, arburst, arlock, arlock, arcache, arcache, arprot, arprot, arvalid, arvalid, arqos, arqos, arregion, arregion, arready, arready, rid, rid, rdata, rdata, rresp, rresp, rlast, rlast, rvalid, rvalid, rready, rready);
  return s;
endfunction : convert2string


// You can insert code here by setting trans_inc_after_class in file tools/gen/axi4bfm/axi4.tpl

`endif // AXI4_SEQ_ITEM_SV


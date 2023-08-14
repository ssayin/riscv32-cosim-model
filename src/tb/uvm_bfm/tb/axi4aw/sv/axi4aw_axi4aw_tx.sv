// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4aw_seq_item.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 18:56:08 2023
//=============================================================================
// Description: Sequence item for axi4aw_sequencer
//=============================================================================

`ifndef AXI4AW_SEQ_ITEM_SV
`define AXI4AW_SEQ_ITEM_SV

// Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/aw/axi4aw_trans_inc_before_class.sv
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
} axi4aw_tx_s;
// End of inlined include file

class axi4aw_tx extends uvm_sequence_item; 

  `uvm_object_utils(axi4aw_tx)

  // To include variables in copy, compare, print, record, pack, unpack, and compare2string, define them using trans_var in file tools/config/uvm/tpl/bfm/axi4aw.tpl
  // To exclude variables from compare, pack, and unpack methods, define them using trans_meta in file tools/config/uvm/tpl/bfm/axi4aw.tpl

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


  extern function new(string name = "");
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function void do_record(uvm_recorder recorder);
  extern function void do_pack(uvm_packer packer);
  extern function void do_unpack(uvm_packer packer);
  extern function string convert2string();

endclass : axi4aw_tx 


function axi4aw_tx::new(string name = "");
  super.new(name);
endfunction : new


function void axi4aw_tx::do_copy(uvm_object rhs);
  axi4aw_tx rhs_;
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
endfunction : do_copy


function bit axi4aw_tx::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  axi4aw_tx rhs_;
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
  return result;
endfunction : do_compare


function void axi4aw_tx::do_print(uvm_printer printer);
  if (printer.knobs.sprint == 0)
    `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
  else
    printer.m_string = convert2string();
endfunction : do_print


function void axi4aw_tx::do_record(uvm_recorder recorder);
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
endfunction : do_record


function void axi4aw_tx::do_pack(uvm_packer packer);
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
endfunction : do_pack


function void axi4aw_tx::do_unpack(uvm_packer packer);
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
endfunction : do_unpack


function string axi4aw_tx::convert2string();
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
    "awready  = 'h%0h  'd%0d\n"},
    get_full_name(), awid, awid, awaddr, awaddr, awlen, awlen, awsize, awsize, awburst, awburst, awlock, awlock, awcache, awcache, awprot, awprot, awvalid, awvalid, awregion, awregion, awqos, awqos, awready, awready);
  return s;
endfunction : convert2string


`endif // AXI4AW_SEQ_ITEM_SV


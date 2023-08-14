// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4ar_seq_item.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 18:56:08 2023
//=============================================================================
// Description: Sequence item for axi4ar_sequencer
//=============================================================================

`ifndef AXI4AR_SEQ_ITEM_SV
`define AXI4AR_SEQ_ITEM_SV

// Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/ar/axi4ar_trans_inc_before_class.sv
typedef struct packed {
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
} axi4ar_tx_s;
// End of inlined include file

class axi4ar_tx extends uvm_sequence_item; 

  `uvm_object_utils(axi4ar_tx)

  // To include variables in copy, compare, print, record, pack, unpack, and compare2string, define them using trans_var in file tools/config/uvm/tpl/bfm/axi4ar.tpl
  // To exclude variables from compare, pack, and unpack methods, define them using trans_meta in file tools/config/uvm/tpl/bfm/axi4ar.tpl

  // Transaction variables
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


  extern function new(string name = "");
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function void do_record(uvm_recorder recorder);
  extern function void do_pack(uvm_packer packer);
  extern function void do_unpack(uvm_packer packer);
  extern function string convert2string();

endclass : axi4ar_tx 


function axi4ar_tx::new(string name = "");
  super.new(name);
endfunction : new


function void axi4ar_tx::do_copy(uvm_object rhs);
  axi4ar_tx rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);
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
endfunction : do_copy


function bit axi4ar_tx::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  axi4ar_tx rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  result = super.do_compare(rhs, comparer);
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
  return result;
endfunction : do_compare


function void axi4ar_tx::do_print(uvm_printer printer);
  if (printer.knobs.sprint == 0)
    `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
  else
    printer.m_string = convert2string();
endfunction : do_print


function void axi4ar_tx::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  // Use the record macros to record the item fields:
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
endfunction : do_record


function void axi4ar_tx::do_pack(uvm_packer packer);
  super.do_pack(packer);
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
endfunction : do_pack


function void axi4ar_tx::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
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
endfunction : do_unpack


function string axi4ar_tx::convert2string();
  string s;
  $sformat(s, "%s\n", super.convert2string());
  $sformat(s, {"%s\n",
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
    "arready  = 'h%0h  'd%0d\n"},
    get_full_name(), arid, arid, araddr, araddr, arlen, arlen, arsize, arsize, arburst, arburst, arlock, arlock, arcache, arcache, arprot, arprot, arvalid, arvalid, arqos, arqos, arregion, arregion, arready, arready);
  return s;
endfunction : convert2string


`endif // AXI4AR_SEQ_ITEM_SV


// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4r_seq_item.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Mon Aug 14 20:27:19 2023
//=============================================================================
// Description: Sequence item for axi4r_sequencer
//=============================================================================

`ifndef AXI4R_SEQ_ITEM_SV
`define AXI4R_SEQ_ITEM_SV

// Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/r/axi4r_trans_inc_before_class.sv
typedef struct packed {
  logic [1:0]  rid;
  logic [63:0] rdata;
  logic [1:0]  rresp;
  logic        rlast;
  logic        rvalid;
  logic        rready;
} axi4r_tx_s;
// End of inlined include file

class axi4r_tx extends uvm_sequence_item; 

  `uvm_object_utils(axi4r_tx)

  // To include variables in copy, compare, print, record, pack, unpack, and compare2string, define them using trans_var in file tools/config//uvm/tpl/bfm/axi4r.tpl
  // To exclude variables from compare, pack, and unpack methods, define them using trans_meta in file tools/config//uvm/tpl/bfm/axi4r.tpl

  // Transaction variables
  rand logic [ 1:0] rid;
  rand logic [63:0] rdata;
  rand logic [ 1:0] rresp;
  rand logic        rlast;
  rand logic        rvalid;
  rand logic        rready;


  extern function new(string name = "");
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function void do_record(uvm_recorder recorder);
  extern function void do_pack(uvm_packer packer);
  extern function void do_unpack(uvm_packer packer);
  extern function string convert2string();

endclass : axi4r_tx 


function axi4r_tx::new(string name = "");
  super.new(name);
endfunction : new


function void axi4r_tx::do_copy(uvm_object rhs);
  axi4r_tx rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);
  rid    = rhs_.rid;   
  rdata  = rhs_.rdata; 
  rresp  = rhs_.rresp; 
  rlast  = rhs_.rlast; 
  rvalid = rhs_.rvalid;
  rready = rhs_.rready;
endfunction : do_copy


function bit axi4r_tx::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  axi4r_tx rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  result = super.do_compare(rhs, comparer);
  result &= comparer.compare_field("rid", rid,       rhs_.rid,    $bits(rid));
  result &= comparer.compare_field("rdata", rdata,   rhs_.rdata,  $bits(rdata));
  result &= comparer.compare_field("rresp", rresp,   rhs_.rresp,  $bits(rresp));
  result &= comparer.compare_field("rlast", rlast,   rhs_.rlast,  $bits(rlast));
  result &= comparer.compare_field("rvalid", rvalid, rhs_.rvalid, $bits(rvalid));
  result &= comparer.compare_field("rready", rready, rhs_.rready, $bits(rready));
  return result;
endfunction : do_compare


function void axi4r_tx::do_print(uvm_printer printer);
  if (printer.knobs.sprint == 0)
    `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
  else
    printer.m_string = convert2string();
endfunction : do_print


function void axi4r_tx::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  // Use the record macros to record the item fields:
  `uvm_record_field("rid",    rid)   
  `uvm_record_field("rdata",  rdata) 
  `uvm_record_field("rresp",  rresp) 
  `uvm_record_field("rlast",  rlast) 
  `uvm_record_field("rvalid", rvalid)
  `uvm_record_field("rready", rready)
endfunction : do_record


function void axi4r_tx::do_pack(uvm_packer packer);
  super.do_pack(packer);
  `uvm_pack_int(rid)    
  `uvm_pack_int(rdata)  
  `uvm_pack_int(rresp)  
  `uvm_pack_int(rlast)  
  `uvm_pack_int(rvalid) 
  `uvm_pack_int(rready) 
endfunction : do_pack


function void axi4r_tx::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  `uvm_unpack_int(rid)    
  `uvm_unpack_int(rdata)  
  `uvm_unpack_int(rresp)  
  `uvm_unpack_int(rlast)  
  `uvm_unpack_int(rvalid) 
  `uvm_unpack_int(rready) 
endfunction : do_unpack


function string axi4r_tx::convert2string();
  string s;
  $sformat(s, "%s\n", super.convert2string());
  $sformat(s, {"%s\n",
    "rid    = 'h%0h  'd%0d\n", 
    "rdata  = 'h%0h  'd%0d\n", 
    "rresp  = 'h%0h  'd%0d\n", 
    "rlast  = 'h%0h  'd%0d\n", 
    "rvalid = 'h%0h  'd%0d\n", 
    "rready = 'h%0h  'd%0d\n"},
    get_full_name(), rid, rid, rdata, rdata, rresp, rresp, rlast, rlast, rvalid, rvalid, rready, rready);
  return s;
endfunction : convert2string


`endif // AXI4R_SEQ_ITEM_SV


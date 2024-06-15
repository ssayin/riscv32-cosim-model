// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4w_seq_item.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Thu Mar 21 22:59:05 2024
//=============================================================================
// Description: Sequence item for axi4w_sequencer
//=============================================================================

`ifndef AXI4W_SEQ_ITEM_SV
`define AXI4W_SEQ_ITEM_SV

// Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/w/axi4w_trans_inc_before_class.sv
typedef struct packed {
  logic [63:0] wdata;
  logic [7:0]  wstrb;
  logic        wlast;
  logic        wvalid;
  logic        wready;
} axi4w_tx_s;
// End of inlined include file

class axi4w_tx extends uvm_sequence_item; 

  `uvm_object_utils(axi4w_tx)

  // To include variables in copy, compare, print, record, pack, unpack, and compare2string, define them using trans_var in file tools/config//uvm/tpl/bfm/axi4w.tpl
  // To exclude variables from compare, pack, and unpack methods, define them using trans_meta in file tools/config//uvm/tpl/bfm/axi4w.tpl

  // Transaction variables
  rand logic [63:0] wdata;
  rand logic [ 7:0] wstrb;
  rand logic        wlast;
  rand logic        wvalid;
  rand logic        wready;


  extern function new(string name = "");
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function void do_record(uvm_recorder recorder);
  extern function void do_pack(uvm_packer packer);
  extern function void do_unpack(uvm_packer packer);
  extern function string convert2string();

endclass : axi4w_tx 


function axi4w_tx::new(string name = "");
  super.new(name);
endfunction : new


function void axi4w_tx::do_copy(uvm_object rhs);
  axi4w_tx rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);
  wdata  = rhs_.wdata; 
  wstrb  = rhs_.wstrb; 
  wlast  = rhs_.wlast; 
  wvalid = rhs_.wvalid;
  wready = rhs_.wready;
endfunction : do_copy


function bit axi4w_tx::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  axi4w_tx rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  result = super.do_compare(rhs, comparer);
  result &= comparer.compare_field("wdata", wdata,   rhs_.wdata,  $bits(wdata));
  result &= comparer.compare_field("wstrb", wstrb,   rhs_.wstrb,  $bits(wstrb));
  result &= comparer.compare_field("wlast", wlast,   rhs_.wlast,  $bits(wlast));
  result &= comparer.compare_field("wvalid", wvalid, rhs_.wvalid, $bits(wvalid));
  result &= comparer.compare_field("wready", wready, rhs_.wready, $bits(wready));
  return result;
endfunction : do_compare


function void axi4w_tx::do_print(uvm_printer printer);
  if (printer.knobs.sprint == 0)
    `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
  else
    printer.m_string = convert2string();
endfunction : do_print


function void axi4w_tx::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  // Use the record macros to record the item fields:
  `uvm_record_field("wdata",  wdata) 
  `uvm_record_field("wstrb",  wstrb) 
  `uvm_record_field("wlast",  wlast) 
  `uvm_record_field("wvalid", wvalid)
  `uvm_record_field("wready", wready)
endfunction : do_record


function void axi4w_tx::do_pack(uvm_packer packer);
  super.do_pack(packer);
  `uvm_pack_int(wdata)  
  `uvm_pack_int(wstrb)  
  `uvm_pack_int(wlast)  
  `uvm_pack_int(wvalid) 
  `uvm_pack_int(wready) 
endfunction : do_pack


function void axi4w_tx::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  `uvm_unpack_int(wdata)  
  `uvm_unpack_int(wstrb)  
  `uvm_unpack_int(wlast)  
  `uvm_unpack_int(wvalid) 
  `uvm_unpack_int(wready) 
endfunction : do_unpack


function string axi4w_tx::convert2string();
  string s;
  $sformat(s, "%s\n", super.convert2string());
  $sformat(s, {"%s\n",
    "wdata  = 'h%0h  'd%0d\n", 
    "wstrb  = 'h%0h  'd%0d\n", 
    "wlast  = 'h%0h  'd%0d\n", 
    "wvalid = 'h%0h  'd%0d\n", 
    "wready = 'h%0h  'd%0d\n"},
    get_full_name(), wdata, wdata, wstrb, wstrb, wlast, wlast, wvalid, wvalid, wready, wready);
  return s;
endfunction : convert2string


`endif // AXI4W_SEQ_ITEM_SV


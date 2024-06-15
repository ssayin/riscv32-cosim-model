// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_bfm
//
// File Name: axi4b_seq_item.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Thu Mar 21 22:59:05 2024
//=============================================================================
// Description: Sequence item for axi4b_sequencer
//=============================================================================

`ifndef AXI4B_SEQ_ITEM_SV
`define AXI4B_SEQ_ITEM_SV

// Start of inlined include file src/tb/uvm_bfm/tb/include/axi4/b/axi4b_trans_inc_before_class.sv
typedef struct packed {
  logic [1:0] bid;
  logic [1:0] bresp;
  logic       bvalid;
  logic       bready;
} axi4b_tx_s;
// End of inlined include file

class axi4b_tx extends uvm_sequence_item; 

  `uvm_object_utils(axi4b_tx)

  // To include variables in copy, compare, print, record, pack, unpack, and compare2string, define them using trans_var in file tools/config//uvm/tpl/bfm/axi4b.tpl
  // To exclude variables from compare, pack, and unpack methods, define them using trans_meta in file tools/config//uvm/tpl/bfm/axi4b.tpl

  // Transaction variables
  rand logic [1:0] bid;
  rand logic [1:0] bresp;
  rand logic       bvalid;
  rand logic       bready;


  extern function new(string name = "");
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function void do_record(uvm_recorder recorder);
  extern function void do_pack(uvm_packer packer);
  extern function void do_unpack(uvm_packer packer);
  extern function string convert2string();

endclass : axi4b_tx 


function axi4b_tx::new(string name = "");
  super.new(name);
endfunction : new


function void axi4b_tx::do_copy(uvm_object rhs);
  axi4b_tx rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);
  bid    = rhs_.bid;   
  bresp  = rhs_.bresp; 
  bvalid = rhs_.bvalid;
  bready = rhs_.bready;
endfunction : do_copy


function bit axi4b_tx::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  axi4b_tx rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  result = super.do_compare(rhs, comparer);
  result &= comparer.compare_field("bid", bid,       rhs_.bid,    $bits(bid));
  result &= comparer.compare_field("bresp", bresp,   rhs_.bresp,  $bits(bresp));
  result &= comparer.compare_field("bvalid", bvalid, rhs_.bvalid, $bits(bvalid));
  result &= comparer.compare_field("bready", bready, rhs_.bready, $bits(bready));
  return result;
endfunction : do_compare


function void axi4b_tx::do_print(uvm_printer printer);
  if (printer.knobs.sprint == 0)
    `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
  else
    printer.m_string = convert2string();
endfunction : do_print


function void axi4b_tx::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  // Use the record macros to record the item fields:
  `uvm_record_field("bid",    bid)   
  `uvm_record_field("bresp",  bresp) 
  `uvm_record_field("bvalid", bvalid)
  `uvm_record_field("bready", bready)
endfunction : do_record


function void axi4b_tx::do_pack(uvm_packer packer);
  super.do_pack(packer);
  `uvm_pack_int(bid)    
  `uvm_pack_int(bresp)  
  `uvm_pack_int(bvalid) 
  `uvm_pack_int(bready) 
endfunction : do_pack


function void axi4b_tx::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  `uvm_unpack_int(bid)    
  `uvm_unpack_int(bresp)  
  `uvm_unpack_int(bvalid) 
  `uvm_unpack_int(bready) 
endfunction : do_unpack


function string axi4b_tx::convert2string();
  string s;
  $sformat(s, "%s\n", super.convert2string());
  $sformat(s, {"%s\n",
    "bid    = 'h%0h  'd%0d\n", 
    "bresp  = 'h%0h  'd%0d\n", 
    "bvalid = 'h%0h  'd%0d\n", 
    "bready = 'h%0h  'd%0d\n"},
    get_full_name(), bid, bid, bresp, bresp, bvalid, bvalid, bready, bready);
  return s;
endfunction : convert2string


`endif // AXI4B_SEQ_ITEM_SV


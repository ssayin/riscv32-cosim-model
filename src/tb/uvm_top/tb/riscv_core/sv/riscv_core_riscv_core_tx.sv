// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : src/tb/uvm_top
//
// File Name: riscv_core_seq_item.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Fri Aug 11 03:44:41 2023
//=============================================================================
// Description: Sequence item for riscv_core_sequencer
//=============================================================================

`ifndef RISCV_CORE_SEQ_ITEM_SV
`define RISCV_CORE_SEQ_ITEM_SV

// You can insert code here by setting trans_inc_before_class in file tools/gen/riscv_core/riscv_core.tpl

class riscv_core_tx extends uvm_sequence_item; 

  `uvm_object_utils(riscv_core_tx)

  // To include variables in copy, compare, print, record, pack, unpack, and compare2string, define them using trans_var in file tools/gen/riscv_core/riscv_core.tpl
  // To exclude variables from compare, pack, and unpack methods, define them using trans_meta in file tools/gen/riscv_core/riscv_core.tpl

  // Transaction variables
  rand logic [63:0] rdata;


  extern function new(string name = "");

  // You can remove do_copy/compare/print/record and convert2string method by setting trans_generate_methods_inside_class = no in file tools/gen/riscv_core/riscv_core.tpl
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function void do_record(uvm_recorder recorder);
  extern function void do_pack(uvm_packer packer);
  extern function void do_unpack(uvm_packer packer);
  extern function string convert2string();

  // You can insert code here by setting trans_inc_inside_class in file tools/gen/riscv_core/riscv_core.tpl

endclass : riscv_core_tx 


function riscv_core_tx::new(string name = "");
  super.new(name);
endfunction : new


// You can remove do_copy/compare/print/record and convert2string method by setting trans_generate_methods_after_class = no in file tools/gen/riscv_core/riscv_core.tpl

function void riscv_core_tx::do_copy(uvm_object rhs);
  riscv_core_tx rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);
  rdata = rhs_.rdata;
endfunction : do_copy


function bit riscv_core_tx::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  riscv_core_tx rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  result = super.do_compare(rhs, comparer);
  result &= comparer.compare_field("rdata", rdata, rhs_.rdata, $bits(rdata));
  return result;
endfunction : do_compare


function void riscv_core_tx::do_print(uvm_printer printer);
  if (printer.knobs.sprint == 0)
    `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
  else
    printer.m_string = convert2string();
endfunction : do_print


function void riscv_core_tx::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  // Use the record macros to record the item fields:
  `uvm_record_field("rdata", rdata)
endfunction : do_record


function void riscv_core_tx::do_pack(uvm_packer packer);
  super.do_pack(packer);
  `uvm_pack_int(rdata) 
endfunction : do_pack


function void riscv_core_tx::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  `uvm_unpack_int(rdata) 
endfunction : do_unpack


function string riscv_core_tx::convert2string();
  string s;
  $sformat(s, "%s\n", super.convert2string());
  $sformat(s, {"%s\n",
    "rdata = 'h%0h  'd%0d\n"},
    get_full_name(), rdata, rdata);
  return s;
endfunction : convert2string


// You can insert code here by setting trans_inc_after_class in file tools/gen/riscv_core/riscv_core.tpl

`endif // RISCV_CORE_SEQ_ITEM_SV


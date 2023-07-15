// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

//=============================================================================
// Project  : ../tb/uvm_top
//
// File Name: riscv_core_seq_item.sv
//
// Author   : Name   : Serdar Sayın
//            Email  : serdarsayin@pm.me
//            Year   : 2023
//
// Version:   0.1
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Jul 15 22:09:49 2023
//=============================================================================
// Description: Sequence item for riscv_core_sequencer
//=============================================================================

`ifndef RISCV_CORE_SEQ_ITEM_SV
`define RISCV_CORE_SEQ_ITEM_SV

// Start of inlined include file ../tb/uvm_top/tb/include/riscv_core_inc_before_class.sv
import param_defs::*;
import instr_defs::*;
// End of inlined include file

class riscv_core_tx extends uvm_sequence_item; 

  `uvm_object_utils(riscv_core_tx)

  // To include variables in copy, compare, print, record, pack, unpack, and compare2string, define them using trans_var in file riscv_core.tpl
  // To exclude variables from compare, pack, and unpack methods, define them using trans_meta in file riscv_core.tpl

  // Transaction variables
  logic irq_external;
  logic irq_timer;
  logic irq_software;
  logic [31:0] mem_data_in [2];
  logic mem_ready;
  logic [31:0] mem_data_out[2];
  logic mem_wr_en [2];
  logic mem_rd_en [2];
  logic mem_clk_en;
  logic [31:0] mem_addr [2];


  extern function new(string name = "");

  // You can remove do_copy/compare/print/record and convert2string method by setting trans_generate_methods_inside_class = no in file riscv_core.tpl
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function void do_record(uvm_recorder recorder);
  extern function void do_pack(uvm_packer packer);
  extern function void do_unpack(uvm_packer packer);
  extern function string convert2string();

  // You can insert code here by setting trans_inc_inside_class in file riscv_core.tpl

endclass : riscv_core_tx 


function riscv_core_tx::new(string name = "");
  super.new(name);
endfunction : new


// You can remove do_copy/compare/print/record and convert2string method by setting trans_generate_methods_after_class = no in file riscv_core.tpl

function void riscv_core_tx::do_copy(uvm_object rhs);
  riscv_core_tx rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);
  irq_external = rhs_.irq_external;
  irq_timer    = rhs_.irq_timer;   
  irq_software = rhs_.irq_software;
  mem_data_in  = rhs_.mem_data_in; 
  mem_ready    = rhs_.mem_ready;   
  mem_data_out = rhs_.mem_data_out;
  mem_wr_en    = rhs_.mem_wr_en;   
  mem_rd_en    = rhs_.mem_rd_en;   
  mem_clk_en   = rhs_.mem_clk_en;  
  mem_addr     = rhs_.mem_addr;    
endfunction : do_copy


function bit riscv_core_tx::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  riscv_core_tx rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  result = super.do_compare(rhs, comparer);
  result &= comparer.compare_field("irq_external", irq_external,      rhs_.irq_external,    $bits(irq_external));
  result &= comparer.compare_field("irq_timer", irq_timer,            rhs_.irq_timer,       $bits(irq_timer));
  result &= comparer.compare_field("irq_software", irq_software,      rhs_.irq_software,    $bits(irq_software));
  for (int i = 0; i < 2; i++)
    result &= comparer.compare_field("mem_data_in", mem_data_in[i],   rhs_.mem_data_in[i],  $bits(mem_data_in[i]));
  result &= comparer.compare_field("mem_ready", mem_ready,            rhs_.mem_ready,       $bits(mem_ready));
  for (int i = 0; i < 2; i++)
    result &= comparer.compare_field("mem_data_out", mem_data_out[i], rhs_.mem_data_out[i], $bits(mem_data_out[i]));
  for (int i = 0; i < 2; i++)
    result &= comparer.compare_field("mem_wr_en", mem_wr_en[i],       rhs_.mem_wr_en[i],    $bits(mem_wr_en[i]));
  for (int i = 0; i < 2; i++)
    result &= comparer.compare_field("mem_rd_en", mem_rd_en[i],       rhs_.mem_rd_en[i],    $bits(mem_rd_en[i]));
  result &= comparer.compare_field("mem_clk_en", mem_clk_en,          rhs_.mem_clk_en,      $bits(mem_clk_en));
  for (int i = 0; i < 2; i++)
    result &= comparer.compare_field("mem_addr", mem_addr[i],         rhs_.mem_addr[i],     $bits(mem_addr[i]));
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
  `uvm_record_field("irq_external",                         irq_external)   
  `uvm_record_field("irq_timer",                            irq_timer)      
  `uvm_record_field("irq_software",                         irq_software)   
  for (int i = 0; i < 2; i++)
    `uvm_record_field({"mem_data_in_",$sformatf("%0d",i)},  mem_data_in[i]) 
  `uvm_record_field("mem_ready",                            mem_ready)      
  for (int i = 0; i < 2; i++)
    `uvm_record_field({"mem_data_out_",$sformatf("%0d",i)}, mem_data_out[i])
  for (int i = 0; i < 2; i++)
    `uvm_record_field({"mem_wr_en_",$sformatf("%0d",i)},    mem_wr_en[i])   
  for (int i = 0; i < 2; i++)
    `uvm_record_field({"mem_rd_en_",$sformatf("%0d",i)},    mem_rd_en[i])   
  `uvm_record_field("mem_clk_en",                           mem_clk_en)     
  for (int i = 0; i < 2; i++)
    `uvm_record_field({"mem_addr_",$sformatf("%0d",i)},     mem_addr[i])    
endfunction : do_record


function void riscv_core_tx::do_pack(uvm_packer packer);
  super.do_pack(packer);
  `uvm_pack_int(irq_external)    
  `uvm_pack_int(irq_timer)       
  `uvm_pack_int(irq_software)    
  `uvm_pack_sarray(mem_data_in)  
  `uvm_pack_int(mem_ready)       
  `uvm_pack_sarray(mem_data_out) 
  `uvm_pack_sarray(mem_wr_en)    
  `uvm_pack_sarray(mem_rd_en)    
  `uvm_pack_int(mem_clk_en)      
  `uvm_pack_sarray(mem_addr)     
endfunction : do_pack


function void riscv_core_tx::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  `uvm_unpack_int(irq_external)    
  `uvm_unpack_int(irq_timer)       
  `uvm_unpack_int(irq_software)    
  `uvm_unpack_sarray(mem_data_in)  
  `uvm_unpack_int(mem_ready)       
  `uvm_unpack_sarray(mem_data_out) 
  `uvm_unpack_sarray(mem_wr_en)    
  `uvm_unpack_sarray(mem_rd_en)    
  `uvm_unpack_int(mem_clk_en)      
  `uvm_unpack_sarray(mem_addr)     
endfunction : do_unpack


function string riscv_core_tx::convert2string();
  string s;
  $sformat(s, "%s\n", super.convert2string());
  $sformat(s, {"%s\n",
    "irq_external = 'h%0h  'd%0d\n",
    "irq_timer    = 'h%0h  'd%0d\n",
    "irq_software = 'h%0h  'd%0d\n",
    "mem_data_in  = %p\n",          
    "mem_ready    = 'h%0h  'd%0d\n",
    "mem_data_out = %p\n",          
    "mem_wr_en    = %p\n",          
    "mem_rd_en    = %p\n",          
    "mem_clk_en   = 'h%0h  'd%0d\n",
    "mem_addr     = %p\n"},         
    get_full_name(), irq_external, irq_external, irq_timer, irq_timer, irq_software, irq_software, mem_data_in, mem_ready, mem_ready, mem_data_out, mem_wr_en, mem_rd_en, mem_clk_en, mem_clk_en, mem_addr);
  return s;
endfunction : convert2string


// You can insert code here by setting trans_inc_after_class in file riscv_core.tpl

`endif // RISCV_CORE_SEQ_ITEM_SV


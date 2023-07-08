// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : generated_tb
//
// File Name: reference.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sun Jul  9 00:13:28 2023
//=============================================================================
// Description: Reference model for use with Syosil scoreboard
//=============================================================================

`ifndef REFERENCE_SV
`define REFERENCE_SV

// You can insert code here by setting ref_model_inc_before_class in file common.tpl


`uvm_analysis_imp_decl(_reference_0)

class reference extends uvm_component;
  `uvm_component_utils(reference)

  uvm_analysis_imp_reference_0 #(riscv_core_tx, reference) analysis_export_0; // m_riscv_core_agent


  extern function new(string name, uvm_component parent);
  extern function void write_reference_0(input riscv_core_tx t);

  // Start of inlined include file generated_tb/tb/include/reference_inc_inside_class.sv
  extern function void send(riscv_core_tx core_tx);
  // End of inlined include file

endclass


function reference::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_export_0 = new("analysis_export_0", this);
endfunction : new


// Start of inlined include file generated_tb/tb/include/reference_inc_after_class.sv
function void reference::write_reference_0(riscv_core_tx t);
  send(t);
endfunction

function void reference::send(riscv_core_tx core_tx);
  riscv_core_tx m_tx;
  m_tx = riscv_core_tx::type_id::create("m_tx");
  //analysis_port.write(m_tx);
endfunction


// End of inlined include file

`endif // REFERENCE_SV


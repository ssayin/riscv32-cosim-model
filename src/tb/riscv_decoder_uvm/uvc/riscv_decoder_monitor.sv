// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_DECODER_MONITOR
`define RISCV_DECODER_MONITOR

class riscv_decoder_monitor extends uvm_monitor;

  virtual riscv_decoder_if vif;

  uvm_analysis_port #(riscv_decoder_transaction) mon2sb_port;

  riscv_decoder_transaction act_trans;


  `uvm_component_utils(riscv_decoder_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    act_trans   = new();
    mon2sb_port = new("mon2sb_port", this);
  endfunction : new


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual riscv_decoder_if)::get(this, "", "intf", vif))
      `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction : build_phase


  virtual task run_phase(uvm_phase phase);
    forever begin
      collect_trans();
      mon2sb_port.write(act_trans);
    end
  endtask : run_phase

  task collect_trans();
    wait (!vif.rst_n);
    @(vif.rc_cb);
    @(vif.rc_cb);
    act_trans.dec_in  = vif.rc_cb.dec_in;
    act_trans.dec_out = vif.rc_cb.dec_out;
    `uvm_info(get_full_name(), $sformatf("TRANSACTION FROM MONITOR"), UVM_HIGH);
    // act_trans.print();

  endtask : collect_trans

endclass : riscv_decoder_monitor

`endif

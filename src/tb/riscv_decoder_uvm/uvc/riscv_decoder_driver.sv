// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

`ifndef RISCV_DECODER_DRIVER
`define RISCV_DECODER_DRIVER

class riscv_decoder_driver extends uvm_driver #(riscv_decoder_transaction);

  riscv_decoder_transaction trans;

  virtual riscv_decoder_if  vif;

  `uvm_component_utils(riscv_decoder_driver)

  uvm_analysis_port #(riscv_decoder_transaction) drv2rm_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual riscv_decoder_if)::get(this, "", "intf", vif))
      `uvm_fatal("NO_VIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});

    drv2rm_port = new("drv2rm_port", this);
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    reset();
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      `uvm_info(get_full_name(), $sformatf("TRANSACTION FROM DRIVER"), UVM_HIGH);

      // req.print();
      @(vif.dr_cb);
      $cast(rsp, req.clone());
      rsp.set_id_info(req);
      drv2rm_port.write(rsp);
      seq_item_port.item_done();
      seq_item_port.put(rsp);
    end
  endtask : run_phase


  task drive();
    wait (!vif.rst_n);
    @(vif.dr_cb);
    vif.dr_cb.dec_in <= req.dec_in;
  endtask : drive

  task reset();
    vif.dr_cb.dec_in.pc_in <= 0;
    vif.dr_cb.dec_in.instr <= 0;
  endtask : reset

endclass : riscv_decoder_driver

`endif

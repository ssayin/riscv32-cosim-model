`ifndef DEC_DECODE_MONITOR
`define DEC_DECODE_MONITOR

class dec_decode_monitor extends uvm_monitor;

  virtual dec_decode_if vif;

  uvm_analysis_port #(dec_decode_transaction) mon2sb_port;

  dec_decode_transaction act_trans;


  `uvm_component_utils(dec_decode_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    act_trans   = new();
    mon2sb_port = new("mon2sb_port", this);
  endfunction : new


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dec_decode_if)::get(this, "", "intf", vif))
      `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction : build_phase


  virtual task run_phase(uvm_phase phase);
    forever begin
      collect_trans();
      mon2sb_port.write(act_trans);
    end
  endtask : run_phase

  task collect_trans();
    wait (!vif.reset);
    @(vif.rc_cb);
    @(vif.rc_cb);
    act_trans.dec_in  = vif.rc_cb.dec_in;
    act_trans.dec_out = vif.rc_cb.dec_out;
    `uvm_info(get_full_name(), $sformatf("TRANSACTION FROM MONITOR"), UVM_LOW);
    // act_trans.print();

  endtask : collect_trans

endclass : dec_decode_monitor

`endif

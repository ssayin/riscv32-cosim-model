`ifndef DEC_DECODE_SCOREBOARD
`define DEC_DECODE_SCOREBOARD

class dec_decode_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(dec_decode_scoreboard)

  uvm_analysis_export #(dec_decode_transaction) rm2sb_export, mon2sb_export;
  uvm_tlm_analysis_fifo #(dec_decode_transaction) rm2sb_export_fifo, mon2sb_export_fifo;
  dec_decode_transaction exp_trans, act_trans;
  dec_decode_transaction exp_trans_fifo[$], act_trans_fifo[$];
  bit error;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rm2sb_export = new("rm2sb_export", this);
    mon2sb_export = new("mon2sb_export", this);
    rm2sb_export_fifo = new("rm2sb_export_fifo", this);
    mon2sb_export_fifo = new("mon2sb_export_fifo", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rm2sb_export.connect(rm2sb_export_fifo.analysis_export);
    mon2sb_export.connect(mon2sb_export_fifo.analysis_export);
  endfunction : connect_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      mon2sb_export_fifo.get(act_trans);
      if (act_trans == null) $stop;
      act_trans_fifo.push_back(act_trans);
      rm2sb_export_fifo.get(exp_trans);
      if (exp_trans == null) $stop;
      exp_trans_fifo.push_back(exp_trans);
      compare_trans();
    end
  endtask : run_phase

  task compare_trans();
    dec_decode_transaction exp_trans, act_trans;
    if (exp_trans_fifo.size != 0) begin
      exp_trans = exp_trans_fifo.pop_front();
      if (act_trans_fifo.size != 0) begin
        act_trans = act_trans_fifo.pop_front();
        `uvm_info(get_full_name(), $sformatf("expected ILLEGAL =%d , actual  ILLEGAL =%d ",
                                             exp_trans.dec_out.illegal, act_trans.dec_out.illegal),
                  UVM_LOW);

        if (exp_trans.dec_out.illegal == act_trans.dec_out.illegal) begin
          `uvm_info(get_full_name(), $sformatf("ILLEGAL MATCHES"), UVM_LOW);
        end else begin
          `uvm_error(get_full_name(), $sformatf("ILLEGAL MIS-MATCHES"));
          error = 1;
        end
      end
    end
  endtask : compare_trans

  function void report_phase(uvm_phase phase);
    if (error == 0) begin
      $write("%c[7;32m", 27);
      $display("PASS");
      $write("%c[0m", 27);
    end else begin
      $write("%c[7;31m", 27);
      $display("FAIL");
      $write("%c[0m", 27);
    end
  endfunction : report_phase
endclass : dec_decode_scoreboard

`endif

`ifndef DEC_DECODE_SEQUENCER
`define DEC_DECODE_SEQUENCER

class dec_decode_sequencer extends uvm_sequencer #(dec_decode_transaction);
  `uvm_component_utils(dec_decode_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

`endif

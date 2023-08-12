`ifndef AXI4B_ENV_REG_SEQ_SV
`define AXI4B_ENV_REG_SEQ_SV

class axi4b_env_reg_seq extends axi4b_env_default_seq;

  axi4b_reg_block      regmodel;
  rand uvm_reg_data_t data;
  uvm_status_e        status;

  `uvm_object_utils(axi4b_env_reg_seq)

  function new(string name = "");
    super.new(name);
  endfunction : new

  task body();
  endtask : body

endclass : axi4b_env_reg_seq

`endif

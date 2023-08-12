`ifndef AXI4R_ENV_REG_SEQ_SV
`define AXI4R_ENV_REG_SEQ_SV

class axi4r_env_reg_seq extends axi4r_env_default_seq;

  axi4r_reg_block      regmodel;
  rand uvm_reg_data_t data;
  uvm_status_e        status;

  `uvm_object_utils(axi4r_env_reg_seq)

  function new(string name = "");
    super.new(name);
  endfunction : new

  task body();
  endtask : body

endclass : axi4r_env_reg_seq

`endif

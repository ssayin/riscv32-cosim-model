class basic_rw_reg extends uvm_reg;
  `uvm_object_utils(basic_rw_reg)

  rand uvm_reg_field F;

  function new(string name = "");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    F = uvm_reg_field::type_id::create("F");
    F.configure(this, 8, 0, "RW", 1, 8'h00, 1, 1, 1);
  endfunction
endclass

class axi4master_reg_block extends uvm_reg_block;
  `uvm_object_utils(axi4master_reg_block)

  rand basic_rw_reg reg0;

  uvm_reg_map axi4master_map;

  function new(string name="");
    super.new(name, UVM_NO_COVERAGE);
  endfunction


  virtual function void build();

    reg0 = basic_rw_reg::type_id::create("reg0");
    reg0.configure(this);
    reg0.build();

    axi4master_map = create_map("axi4master_map", 'h0, 1, UVM_BIG_ENDIAN);
    default_map = axi4master_map;

    axi4master_map.add_reg(reg0, 'h0, "RW");

    lock_model();
  endfunction

endclass

class top_reg_block extends uvm_reg_block;
  `uvm_object_utils(top_reg_block)

  axi4master_reg_block axi4master;
  //axi4master_reg_block axi4master_1;

  uvm_reg_map axi4master_map;
  //uvm_reg_map axi4master_map_1;

  function new(string name= "");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    axi4master = axi4master_reg_block::type_id::create("axi4master");
    axi4master.configure(this);
    axi4master.build();

   // axi4master_1 = axi4master_reg_block::type_id::create("axi4master_1");
   // axi4master_1.configure(this);
   // axi4master_1.build();

    axi4master_map = create_map("axi4master_map", 'h0, 1, UVM_BIG_ENDIAN);
    default_map = axi4master_map;
    axi4master_map.add_submap(axi4master.axi4master_map, 'h0);

   // axi4master_map_1 = create_map("axi4master_map_1", 'h0, 1, UVM_BIG_ENDIAN);
   // default_map = axi4master_map_1;
   // axi4master_map_1.add_submap(axi4master_1.axi4master_map, 'h0);

    lock_model();
  endfunction

endclass

typedef enum logic [1:0] {
  IDLE,
  PREBURST,
  BURST
} axi_state_t;

axi_state_t state = IDLE;

bit [7:0] arburst_counter = 0;
bit [1:0] arburst;

task run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), {"req item\n", req.sprint}, UVM_HIGH)
    do_drive();
    seq_item_port.item_done();
  end
endtask : run_phase

task do_drive();
  case (state)
    IDLE: begin
      if (vif.arvalid) begin
        arburst_counter = vif.arlen + 1;
        arburst         = vif.arburst;
        state           = PREBURST;
        vif.rvalid      = 0;
        vif.arready     = 1;
      end
      vif.rlast = 0;
    end
    PREBURST: begin
      if (vif.arvalid && vif.arready) begin
        state       = BURST;
        vif.rdata   = req.rdata;
        vif.rvalid  = 1;
        vif.arready = 0;
      end
      vif.rlast = 0;
    end
    BURST: begin
      vif.rlast = 0;
      if (vif.rvalid && vif.rready) begin
        arburst_counter = arburst_counter - 1;
        vif.rdata       = req.rdata;
        vif.rvalid      = 1;
        vif.arready     = 0;
      end
      if (arburst_counter == 0) begin
        state     = IDLE;
        vif.rlast = 1;
      end
    end
    default: begin
    end
  endcase
  @(posedge vif.clk);
endtask : do_drive


task riscv_core_driver::do_drive();
  case (m_axi4_logic.state)
    IDLE: begin
      if (vif.arvalid) begin
        m_axi4_logic.arburst_counter <= vif.arlen + 1;
        m_axi4_logic.arburst         <= vif.arburst;
        m_axi4_logic.state           <= PREBURST;
        vif.rvalid                   <= 0;
        vif.arready                  <= 1;
      end
      vif.rlast <= 0;
    end
    PREBURST: begin
      if (vif.arvalid && vif.arready) begin
        m_axi4_logic.state <= BURST;
        vif.rdata          <= req.rdata;
        vif.rvalid         <= 1;
        vif.arready        <= 0;
      end
      vif.rlast <= 0;
    end
    BURST: begin
      vif.rlast <= 0;
      if (vif.rvalid && vif.rready) begin
        m_axi4_logic.arburst_counter <= m_axi4_logic.arburst_counter - 1;
        vif.rdata                    <= req.rdata;
        vif.rvalid                   <= 1;
        vif.arready                  <= 0;
      end
      if (m_axi4_logic.arburst_counter == 0) begin
        m_axi4_logic.state <= IDLE;
        vif.rlast          <= 1;
      end
    end
    default: begin
    end
  endcase
  @(posedge vif.clk);
endtask : do_drive

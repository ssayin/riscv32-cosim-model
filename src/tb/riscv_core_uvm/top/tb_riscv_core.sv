// SPDX-FileCopyrightText: 2023 Serdar Sayın <https://serdarsayin.com>
//
// SPDX-License-Identifier: Apache-2.0

module tb_riscv_core
  import param_defs::*;
  import uvm_pkg::*;
();

  logic clk;
  logic rst_n;

  riscv_core_if riscv_core_intf (
    .clk  (clk),
    .rst_n(rst_n)
  );

  riscv_core dut (
    .clk         (clk),
    .rst_n       (rst_n),
    .mem_addr    (riscv_core_intf.mem_addr),
    .mem_data_in (riscv_core_intf.mem_data_in),
    .mem_data_out(riscv_core_intf.mem_data_out),
    .mem_wr_en   (riscv_core_intf.mem_wr_en),
    .mem_rd_en   (riscv_core_intf.mem_rd_en),
    .mem_valid   (riscv_core_intf.mem_valid),
    .mem_ready   (riscv_core_intf.mem_ready),
    .irq_external(riscv_core_intf.irq_external),
    .irq_timer   (riscv_core_intf.irq_timer),
    .irq_software(riscv_core_intf.irq_software)
  );



  initial begin
    $dumpfile("waveform.vcd");

    $dumpvars(0, dut);

    clk   = 0;
    rst_n = 1;
    #10;

    rst_n = 0;

    uvm_config_db#(virtual riscv_core_if)::set(uvm_root::get(), "*", "riscv_core_if",
                                               riscv_core_intf);
    run_test();

  end

  always #5 clk = ~clk;

endmodule : tb_riscv_core

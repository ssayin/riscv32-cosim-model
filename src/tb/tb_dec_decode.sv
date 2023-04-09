`ifndef TB_DEC_DECODE
`define TB_DEC_DECODE

module tb_dec_decode
  import uvm_pkg::*;
  import dec_decode_test_list::*;
  import svdpi_pkg::decoder_in_t;
  import svdpi_pkg::decoder_out_t;
#(
    `include "uvm_macros.svh"
    `include "dec_decode_if.sv"
);


  bit clk;
  bit reset;

  initial begin
    clk = 0;
    forever #(50) clk = ~clk;
  end

  initial begin
    // reset = 1;
    // #(25) reset = 0;
  end

  dec_decode_if dec_decode_intf (
      .clk  (clk),
      .reset(reset)
  );

  dec_decode decoder_inst (
      .clk(clk),
      .rst_n(reset),
      .instr(dec_decode_intf.dec_in.instr),
      .pc_in(dec_decode_intf.dec_in.pc_in),
      .rs1_addr(dec_decode_intf.dec_out.rs1_addr),
      .rs2_addr(dec_decode_intf.dec_out.rs2_addr),
      .rd_addr(dec_decode_intf.dec_out.rd_addr),
      .rd_data(),
      .imm(dec_decode_intf.dec_out.imm),
      .rd_en(),
      .mem_rd_en(),
      .mem_wr_en(),
      .use_imm(dec_decode_intf.dec_out.use_imm),
      .alu(dec_decode_intf.dec_out.alu),
      .lsu(dec_decode_intf.dec_out.lsu),
      .br(dec_decode_intf.dec_out.br),
      .illegal(dec_decode_intf.dec_out.illegal)
  );

  initial begin
    run_test();
  end

  initial begin
    uvm_config_db#(virtual dec_decode_if)::set(uvm_root::get(), "*", "intf", dec_decode_intf);
  end

  // initial begin
  // init();
  ///  clk = 0;
  //  for (integer i = 0; i < 160; ++i) begin
  //   in.instr = $urandom;
  //dpi_decoder_process(in, out_2);
  //  #100 in.clk = 1;
  //  if (!out_2.illegal) begin
  //    $display("------------------");
  //   $display("%p", out);
  //  $display("%p", out_2);
  // $display("------------------");
  //  end
  //  #100 in.clk = 0;
  // end
  // $finish;
  // end
endmodule : tb_dec_decode


`endif

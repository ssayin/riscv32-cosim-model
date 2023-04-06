module tb_dec_decode (
    input reg clk
);

  typedef struct {
    logic [31:0] instr;
    logic [31:0] pc_in;
    logic clk;
    logic rst_n;
  } decoder_in_t;

  typedef struct {
    logic [4:0]  rs1_addr;
    logic [4:0]  rs2_addr;
    logic [4:0]  rd_addr;
    logic [31:0] imm;
    logic        alu;
    logic        lsu;
    logic        br;
    logic        illegal;
    logic        use_imm;
  } decoder_out_t;

  import "DPI-C" function void init();
  import "DPI-C" function void dpi_decoder_input(decoder_in_t io);
  import "DPI-C" function void dpi_decoder_output(decoder_out_t io);

  import "DPI-C" function void dpi_decoder_process(
    input  decoder_in_t  in,
    output decoder_out_t out
  );


  // always #10 clk = ~clk;

  decoder_in_t  in;
  decoder_out_t out;
  decoder_out_t out_2;

  dec_decode decoder_inst (
      .clk(in.clk),
      .rst_n(in.rst_n),
      .instr(in.instr),
      .pc_in(in.pc_in),
      .rs1_addr(out.rs1_addr),
      .rs2_addr(out.rs2_addr),
      .rd_addr(out.rd_addr),
      .rd_data(),
      .imm(out.imm),
      .rd_en(),
      .mem_rd_en(),
      .mem_wr_en(),
      .use_imm(out.use_imm),
      .alu(out.alu),
      .lsu(out.lsu),
      .br(out.br),
      .illegal(out.illegal)
  );

  initial begin
    init();
    clk = 0;
    for (integer i = 0; i < 160; ++i) begin
      in.instr = $urandom;
      dpi_decoder_process(in, out_2);
      #100 in.clk = 1;
      if (!out_2.illegal) begin
        $display("------------------");
        $display("%p", out);
        $display("%p", out_2);
        $display("------------------");
      end
      #100 in.clk = 0;
    end
    $finish;
  end
endmodule : tb_dec_decode

module tb_decoder (
    input reg clk
);

  typedef struct packed {
    logic alu;
    logic mul;
    logic lsu;
    logic br;
    logic illegal;
  } pipeline_t;

  typedef struct {
    logic [31:0] instr;
    logic [31:0] pc_target;
    logic [4:0]  rs1_addr;
    logic [4:0]  rs2_addr;
    logic [4:0]  rd_addr;
    logic [31:0] rd_data;
    logic [31:0] imm;
    logic [2:0]  funct3;
    logic [6:0]  funct7;
    pipeline_t   pt;
    logic        clk;
    logic        rst_n;
    logic        is_compressed;
    logic        rd_en;
    logic        mem_rd_en;
    logic        mem_wr_en;
    logic        use_imm;
    logic        load_upper;
  } Decoder_IO;

  import "DPI-C" function void init();
  import "DPI-C" function void dpi_decoder_input(Decoder_IO io);
  import "DPI-C" function void dpi_decoder_output(Decoder_IO io);

  import "DPI-C" function void dpi_decoder_process(
    input  Decoder_IO in,
    output Decoder_IO out
  );


  // always #10 clk = ~clk;

  Decoder_IO in;
  Decoder_IO out;

  decoder decoder_inst (
      .clk(in.clk),
      .rst_n(in.rst_n),
      .instr(in.instr),
      .is_compressed(in.is_compressed),
      .pc_target(in.pc_target),
      .rs1_addr(in.rs1_addr),
      .rs2_addr(in.rs2_addr),
      .rd_addr(in.rd_addr),
      .rd_data(in.rd_data),
      .imm(in.imm),
      .rd_en(in.rd_en),
      .mem_rd_en(in.mem_rd_en),
      .mem_wr_en(in.mem_wr_en),
      .use_imm(in.use_imm),
      .load_upper(in.load_upper),
      .pt(in.pt),
      .funct3(in.funct3),
      .funct7(in.funct7)
  );

  initial begin
    init();
    clk = 0;
    for (integer i = 0; i < 12; ++i) begin
      in.instr = $urandom;
      #10 in.clk = 1;
      dpi_decoder_process(in, out);
      $display("rd_addr %p --- %p", in.rd_addr, out.rd_addr);
      $display("rs1_addr %p --- %p", in.rs1_addr, out.rs1_addr);
      $display("rs2_addr %p --- %p", in.rs2_addr, out.rs2_addr);
      $display("imm %p --- %p", in.imm, out.imm);
      $display("funct3 %p --- %p", in.funct3, out.funct3);
      $display("funct7 %p --- %p", in.funct7, out.funct7);
      $display("is_compressed %p --- %p", in.is_compressed, out.is_compressed);
      $display("%p", in.pt);
      $display("%p", out.pt);
      #10 in.clk = 0;
    end
    $finish;
  end
endmodule : tb_decoder

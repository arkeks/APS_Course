`timescale 1ns / 1ps

module tb_miriscv_top();

  parameter     HF_CYCLE = 2.5;       // 200 MHz clock
  parameter     RST_WAIT = 10;         // 10 ns reset
  parameter     RAM_SIZE = 512;       // in 32-bit words

  // clock, reset
  reg clk;
  reg rst_n;
  
  logic  [31:0]  instr_d;
  logic  [31:0]  pc_d;
  logic  [31:0]  data_rdata_d;
  logic  [31:0]  data_addr_d;
  logic          stall_deb;
  logic  [31:0]  rs_1_d;
  logic  [31:0]  rs_2_d;

  miriscv_top #(
    .RAM_SIZE       ( RAM_SIZE           ),
    .RAM_INIT_FILE  ( "program_sort.dat" )
  ) dut (
    .clk_i    ( clk   ),
    .rst_n_i  ( rst_n ),
	 .instr_d  ( instr_d ),
	 .pc_d     (pc_d ),
	 .data_rdata_d (data_rdata_d ),
	 .data_addr_d (data_addr_d ),
	 .stall_deb(stall_deb),
	 .rs_1_d(rs_1_d),
	 .rs_2_d(rs_2_d)
  );

  initial begin
    clk   = 1'b0;
    rst_n = 1'b1;
    #RST_WAIT;
    rst_n = 1'b0;
	 #200;
	 $finish;
  end

  always begin
    #HF_CYCLE;
    clk = ~clk;
  end

endmodule
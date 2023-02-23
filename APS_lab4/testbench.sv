module testbench;

parameter WIDTH = 32;


// dut ports
logic clk;
logic rst;
logic [WIDTH - 1:0] IN;
logic [WIDTH - 1:0] OUT_RD1;

logic [7:0]          pc_dbg;
logic [WIDTH - 1:0]  instr_dbg;
logic [WIDTH - 1:0]  OUT_RD2;
logic [WIDTH - 1:0]  SE_dbg;
logic [7:0]          next_pc;

cyber_cobra DUT (
  clk,
  rst,
  IN,
  
  OUT_RD1,
  pc_dbg,
  instr_dbg,
  OUT_RD2,
  SE_dbg,
  next_pc
);




always begin
  clk = ~clk;
  #5;
end

// cycle shift left

initial begin
  $dumpvars;
  $monitor("x1 = %b", OUT_RD1);
  IN = 'b0;
  
  clk = 'b0;
  rst = 'b1;
  #10;
  rst = 'b0;
  
  #100
  $finish;
end


endmodule
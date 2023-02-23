// operations
`define ADD  5'b00000
`define SUB  5'b01000
`define SLL  5'b00001
`define SLT  5'b00010
`define SLTU 5'b00011
`define XOR  5'b00100
`define SRL  5'b00101
`define SRA  5'b01101
`define OR   5'b00110
`define AND  5'b00111
`define BEQ  5'b11000
`define BNE  5'b11001
`define BLT  5'b11100
`define BGE  5'b11101
`define BLTU 5'b11110
`define BGEU 5'b11111



module testbench;

// inputs
logic [32 - 1:0] a;
logic [32 - 1:0] b;
logic [5 - 1 :0] alu_op;

// outputs
logic            flag;
logic [32 - 1:0] result;


ALU dut(
  a,
  b,
  alu_op,
  
  flag,
  result
);

initial begin
  a = 'd25;
  b = 'd123;
  alu_op = 'd0;
  
  $dumpvars;
  $monitor("alu_op = %b, A_b = %b, B_b = %b, result_b = %b \n", alu_op, a, b, result);
  
  $monitor("alu_op = %b, A_d = %d, B_d = %d, result_d = %d \n", alu_op, a, b, result);
  
  #5
  
  alu_op = `ADD;
  
  #5
  
  alu_op = `SUB;
  
  #5
  a = { {28{1'b0}}, 4'b1001};
  b = 'd2;
  
  alu_op = `SLL;
  
  #5
  a = -32'd25;
  b = 32'd123;
  
  alu_op = `SLT;
  
  #5
  a = 32'd123;
  b = 32'd25;
  alu_op = `SLTU;
  
  #5
  a = { {28{1'b0}}, 4'b1010};
  b = { {28{1'b0}}, 4'b0010};
  //result       1000
  
  alu_op = `XOR;
  
  #5
  a = { {28{1'b0}}, 4'b1100};
  b = 'd2;
  alu_op = `SRL;
  
  #5
  a = 'd32;
  b = 'd2;
  alu_op = `SRA;
  
  #5
  
  $finish;
  
  end
  
endmodule
  
  
  
  
  
  
  
  
  
  
  
  
  
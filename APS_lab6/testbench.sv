
module testbench;

logic        clk;
logic        rst;
logic [31:0] result;

logic [31:0] rd1_deb;
logic [31:0] rd2_deb;
logic [31:0] pc_deb;
logic [31:0] instr_deb;
logic [31:0] alu_res_deb;

riscv DUT (
	clk,
	rst,
	
	rd1_deb,
	rd2_deb,
	pc_deb,
	instr_deb,
	alu_res_deb,
	result
);

initial begin
	clk = 'b0;
	rst = 'b1;
	#2;
	rst = 'b0;
	#20;
	$finish;
end

initial begin
	$dumpvars;
	$monitor("rd1 is %b", rd1_deb);
end

always begin
	clk = ~clk;
	#1;
end

endmodule
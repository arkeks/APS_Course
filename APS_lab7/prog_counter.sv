module prog_counter
#
(
  parameter DEPTH      = 1024,
            PC_WIDTH   = $clog2(DEPTH),
				WORD_WIDTH = 32
				
)
(
  input  logic                    clk,
  input  logic                    rst,
  input  logic                    stall,
  
  input  logic                    jal,
  input  logic                    jalr,
  input  logic                    comp,
  input  logic                    branch,
  input  logic [WORD_WIDTH - 1:0] imm_J, imm_B, imm_I,
  input  logic [WORD_WIDTH - 1:0] RD1,
  
  output logic [WORD_WIDTH - 1:0] pc
  
  // for debug
  // output logic [WIDTH - 1:0] next_pc_dbg
);

logic [WORD_WIDTH - 1:0] next_pc;

// logic for next value of pc
always_comb
	if(jal)
		next_pc = pc + imm_J;
 
	else if(branch && comp)
		next_pc = pc + imm_B;
 
	else if(jalr)
		next_pc = RD1 + imm_I;
 
	else
		next_pc = pc + 'd4;
		

// pc register
always_ff @ (posedge clk or posedge rst)
	if (rst)
		pc <= 'b0;
		
	else if(stall)
		pc <= pc;
		
	else
		pc <= next_pc;
	
	
 
endmodule
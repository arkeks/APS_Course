module prog_counter
#
(
  parameter DEPTH = 256,
            WIDTH = $clog2(DEPTH),
				BC_W = 2,
				CONST_W = 8
				
)
(
  input  logic                 clk,
  input  logic                 rst,
  input  logic [BC_W - 1:0]    BC,
  input  logic                 flag,
  input  logic [CONST_W - 1:0] CONST,
  
  output logic [WIDTH - 1:0]   pc,
  
  // for debug
  output logic [WIDTH - 1:0] next_pc_dbg
);

logic [WIDTH - 1:0] next_pc;

// logic for next value of pc
always_comb
  if (BC[1] || (BC[0] & flag))
    next_pc = pc + CONST;
  else
    next_pc = pc + 'd1;

// pc register
always_ff @ (posedge clk or posedge rst)
  if (rst)
    pc <= 'b0;
  else
    pc <= next_pc;
	 
	 
// FOR DEBUG
assign next_pc_dbg = next_pc;
	 
endmodule
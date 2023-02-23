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



module ALU 
# (
  parameter IO_WIDTH = 32,
            OP_WIDTH = 5
)

(

  // inputs
  input  logic [IO_WIDTH - 1:0] a,
  input  logic [IO_WIDTH - 1:0] b,
  input  logic [OP_WIDTH - 1:0] alu_op,

  // outputs
  output logic                  flag,
  output logic [IO_WIDTH - 1:0] result
);


  always_comb
    case(alu_op)
	 
	   `ADD:
		  begin
		    result = a + b;
			 flag   = 'b0;
		  end
		  
	   `SUB:
		  begin
		    result = a - b;
			 flag   = 'b0;
		  end
		
		`SLL:
		  begin
		    result = a << b;
			 flag   = 'b0;
		  end
		  
		`SLT:
		  begin
		    result = $signed(a) < $signed(b);
			 flag   = 'b0;
		  end
		
		`SLTU:
		  begin
		    result = a < b;
			 flag   = 'b0;
		  end
		  
		`XOR:
		  begin
		    result = a ^ b;
			 flag   = 'b0;
		  end
		  
		`SRL:
		  begin
		    result = a >> b;
			 flag   = 'b0;
		  end
		  
		`SRA:
		  begin
		    result = $signed(a) >>> b;
			 flag   = 'b0;
		  end
		  
		`OR:
		  begin
		    result = a | b;
			 flag   = 'b0;
		  end
		  
		`AND:
		  begin
		    result = a & b;
			 flag   = 'b0;
		  end
		  
		`BEQ:
		  begin
		    result = 'b0;
			 flag   = (a == b);
		  end
		  
		`BNE:
		  begin
		    result = 'b0;
			 flag   = (a != b);
		  end
		  
		`BLT:
		  begin
		    result = 'b0;
			 flag   = $signed(a) < $signed(b);
		  end
		  
		`BGE:
		  begin
		    result = 'b0;
			 flag   = $signed(a) >= $signed(b);
		  end
		  
		`BLTU:
		  begin
		    result = 'b0;
			 flag   = a < b;
		  end
		  
		`BGEU:
		  begin
		    result = 'b0;
			 flag   = a >= b;
		  end
		  
		default:
		  begin
		    result = 'b0;
		    flag   = 'b0;
		  end
    endcase
		  
endmodule
		  
		  
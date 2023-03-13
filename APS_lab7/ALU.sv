// operations
`define ADD   5'b00000
`define SUB   5'b01000

`define XOR   5'b00100
`define OR    5'b00110
`define AND   5'b00111

// shifts
`define SRA   5'b01101
`define SRL   5'b00101
`define SLL   5'b00001

// comparisons
`define BLT   5'b11100
`define BLTU  5'b11110
`define BGE   5'b11101
`define BGEU  5'b11111
`define BEQ   5'b11000
`define BNE   5'b11001

// set lower than operations
`define SLT   5'b00010
`define SLTU  5'b00011


module ALU 
# (
  parameter IO_WIDTH = 32,
            OP_WIDTH = 5
)

(

  // inputs
  input  logic [IO_WIDTH - 1:0] a, b,
  input  logic [OP_WIDTH - 1:0] alu_op,

  // outputs
  output logic                  comp,
  output logic [IO_WIDTH - 1:0] result
);


  always_comb
    case(alu_op)
	 
	   `ADD:
		  begin
		    result = a + b;
			 comp   = 'b0;
		  end
		  
	   `SUB:
		  begin
		    result = a - b;
			 comp   = 'b0;
		  end
		
		`SLL:
		  begin
		    result = a << b;
			 comp   = 'b0;
		  end
		  
		`SLT:
		  begin
		    result = $signed(a) < $signed(b);
			 comp   = 'b0;
		  end
		
		`SLTU:
		  begin
		    result = a < b;
			 comp   = 'b0;
		  end
		  
		`XOR:
		  begin
		    result = a ^ b;
			 comp   = 'b0;
		  end
		  
		`SRL:
		  begin
		    result = a >> b;
			 comp   = 'b0;
		  end
		  
		`SRA:
		  begin
		    result = $signed(a) >>> b;
			 comp   = 'b0;
		  end
		  
		`OR:
		  begin
		    result = a | b;
			 comp   = 'b0;
		  end
		  
		`AND:
		  begin
		    result = a & b;
			 comp   = 'b0;
		  end
		  
		`BEQ:
		  begin
		    result = 'b0;
			 comp   = (a == b);
		  end
		  
		`BNE:
		  begin
		    result = 'b0;
			 comp   = (a != b);
		  end
		  
		`BLT:
		  begin
		    result = 'b0;
			 comp   = $signed(a) < $signed(b);
		  end
		  
		`BGE:
		  begin
		    result = 'b0;
			 comp   = $signed(a) >= $signed(b);
		  end
		  
		`BLTU:
		  begin
		    result = 'b0;
			 comp   = a < b;
		  end
		  
		`BGEU:
		  begin
		    result = 'b0;
			 comp   = a >= b;
		  end
		  
		default:
		  begin
		    result = 'b0;
		    comp   = 'b0;
		  end
    endcase
		  
endmodule
		  
		  
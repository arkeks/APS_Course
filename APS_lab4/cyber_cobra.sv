module cyber_cobra
#(
   parameter WIDTH = 32,
	          DEPTH = 256,
				 ADR_WIDTH = $clog2(DEPTH)
)
(
   input  logic               clk,
	input  logic               rst,
	input  logic [WIDTH - 1:0] IN,
	
	output logic [WIDTH - 1:0] OUT_RD1,
	
	// FOR DEBUG
	output logic [ADR_WIDTH - 1:0] pc_dbg,
	output logic [WIDTH - 1:0]     instr_dbg,
	output logic [WIDTH - 1:0]     OUT_RD2,
	output logic [WIDTH - 1:0]     SE_dbg,
	output logic [ADR_WIDTH - 1:0] next_pc
);

// common signals
logic               ALU_flag;
logic [WIDTH - 1:0] ALU_out;
logic [WIDTH - 1:0] RD_1, RD_2;
logic [WIDTH - 1:0] SE_out;


// dividing instruction into logic fields
logic [WIDTH - 1:0] instr;

logic [1:0] BC;
assign      BC     = instr[31:30];

logic [1:0] WS;
assign      WS     = instr[29:28];

logic [4:0] ALU_op;
assign      ALU_op = instr[27:23];

logic [4:0] RA_1;
assign      RA_1   = instr[22:18]; //read address

logic [4:0] RA_2;
assign      RA_2   = instr[17:13];

logic [7:0] CONST;
assign      CONST  = instr[12:5];

logic [4:0] WA;
assign      WA     = instr[4:0];  // write address

logic [22:0]  SE_in;
assign      SE_in  = instr[27:5]; // input sign extension constant


//----------pc instance-----------
logic [ADR_WIDTH - 1:0] pc_out;

prog_counter pc (
  // inputs
  clk,
  rst,
  BC,
  ALU_flag,
  CONST,
  
  // outputs
  pc_out,
  
  // FOR DEBUG
  next_pc
);

// FOR DEBUG
assign pc_dbg = pc_out;

//----instruction memory instance-----
ROM instr_mem (
  // inputs
  clk,
  pc_out,
  
  // outputs
  instr
);

// FOR DEBUG
assign instr_dbg = instr;


//------register file instance-------
logic WE;
assign WE = (WS > 0);  // write enable logic

logic [WIDTH - 1:0] WD;  // write data


sign_ext SE (
  .in_const(SE_in),
  .out_const(SE_out)
);

// write data mux
always_comb
  case(WS)
    'b01:
	   WD = IN;
	 
	 'b10:
	   WD = SE_out;
		
	 'b11:
	   WD = ALU_out;
	 
	 default:
	   WD = 'b0;
	endcase
	 

reg_file regs (
  // inputs
  clk,
  WE,
  RA_1, RA_2, WA,
  WD,
  
  // outputs
  RD_1, RD_2
);

// FOR DEBUG
assign SE_dbg = SE_out;

assign OUT_RD1 = RD_1;
assign OUT_RD2 = RD_2;

//---------ALU instance----------

ALU alu (
  // inputs
  RD_1,
  RD_2,
  ALU_op,
  
  // outputs
  ALU_flag,
  ALU_out
);
 
endmodule
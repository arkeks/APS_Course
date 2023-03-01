module riscv #(
	parameter WORD_WIDTH = 32,
	          REG_ADR_W  = 5
)
(
	input  logic                    clk,
	input  logic                    rst,
	
	
	output logic [WORD_WIDTH - 1:0] rd1_deb,
	output logic [WORD_WIDTH - 1:0] rd2_deb,
	output logic [WORD_WIDTH - 1:0] pc_deb,
	output logic [WORD_WIDTH - 1:0] instr_deb,
	output logic [WORD_WIDTH - 1:0] alu_res_deb,
	
	output logic [WORD_WIDTH - 1:0] result
);

logic [WORD_WIDTH - 1:0] pc;
logic [WORD_WIDTH - 1:0] instr;
logic [WORD_WIDTH - 1:0] rd_1, rd_2;
logic [WORD_WIDTH - 1:0] wd_3;
logic [WORD_WIDTH - 1:0] mem_data;
logic [WORD_WIDTH - 1:0] imm_I, imm_S, imm_J, imm_B;
logic [WORD_WIDTH - 1:0] alu_res;
logic                    comp;


// instruction fetching
logic        rs_1_sel;
logic [2:0]  rs_2_sel;
logic [4:0]  alu_op;
logic        mem_req;
logic        mem_we;
logic [2:0]  mem_size;
logic        reg_we;
logic        wd_3_sel;
logic        illegal_instr;
logic        branch;
logic        jal;
logic        jalr;

logic [REG_ADR_W - 1:0] a_1, a_2, a_3;
assign a_1 = instr[19:15];
assign a_2 = instr[24:20];
assign a_3 = instr[11:7];



// instr_mem
ROM instr_mem (
	clk,
   pc,
	
	instr
);

// FOR DEBUG
assign instr_deb = instr;


// decoder
decoder FETCH (
	instr,
	
	rs_1_sel,
	rs_2_sel,
	alu_op,
	mem_req,
	mem_we,
	mem_size,
	reg_we,
	wd_3_sel,
	illegal_instr,
	branch,
	jal,
	jalr
);



// program counter
prog_counter PC (
	clk,
	rst,
	jal,
	jalr,
	comp,
	branch,
	imm_J,
	imm_B,
	imm_I,
	rd_1,
	
	pc
);

// FOR DEBUG
assign pc_deb = pc;


// register file
always_comb
	if(wd_3_sel == 'd0)
		wd_3 = alu_res;
	else
		wd_3 = mem_data;

reg_file regs (
	clk,
	reg_we,
	a_1, a_2, a_3,
	wd_3,
	
	rd_1, rd_2
);

// FOR DEBUG
assign rd1_deb = rd_1;
assign rd2_deb = rd_2;

// alu
logic [WORD_WIDTH - 1:0] rs_1, rs_2;

always_comb
	case(rs_1_sel)
		'd0:
			rs_1 = rd_1;
		'd1:
			rs_1 = pc;
		'd2:
			rs_1 = 'd0;
			
		default:
			rs_1 = 'hFFFF;
	endcase
	
always_comb
	case(rs_2_sel)
		'd0:
			rs_2 = rd_2;
		'd1:
			rs_2 = imm_I; // TODO: declarate all imms
		'd2:
			rs_2 = {instr[31:12], 12'b0};
		'd3:
			rs_2 = imm_S;
		'd4:
			rs_2 = 'd4;
			
		default:
			rs_2 = 'hFFFF;
	endcase

ALU alu (
	rs_1, rs_2,
	alu_op,
	
	comp,
	alu_res
);


// data memory
RAM data_mem (
	clk,
	mem_we,
	alu_res,
	rd_2,
	
	mem_data
);

// FOR DEBUG
assign alu_res_deb = alu_res;

// sign extensions
sign_ext se (
	instr,
	
	imm_I, imm_S, imm_J, imm_B
);

assign result = mem_data;

endmodule
module miriscv_core #(
	parameter WORD_WIDTH = 32,
	          REG_ADR_W  = 5,
				 BYTES_IN_WORD = 4
)
(
	input  logic                       clk_i,
	input  logic                       arstn_i,
	
	input  logic [WORD_WIDTH - 1:0]    instr_rdata_i,
	output logic [WORD_WIDTH - 1:0]    instr_addr_o,
	
	
	input  logic [WORD_WIDTH - 1:0]    data_rdata_i,
	input  logic                       data_flag_i,
	
	output logic                       data_req_o,
	output logic                       data_we_o,
	output logic [BYTES_IN_WORD - 1:0] data_be_o,
	output logic [WORD_WIDTH    - 1:0] data_addr_o,
	output logic [WORD_WIDTH    - 1:0] data_wdata_o,
	
	output logic                       stall_deb,
	output logic [WORD_WIDTH - 1:0]    rs_1_o,
	output logic [WORD_WIDTH - 1:0]    rs_2_o
);

logic [WORD_WIDTH - 1:0] pc;
logic [WORD_WIDTH - 1:0] rd_1, rd_2;
logic [WORD_WIDTH - 1:0] wd_3;
logic [WORD_WIDTH - 1:0] mem_data;
logic [WORD_WIDTH - 1:0] imm_I, imm_S, imm_J, imm_B;
logic [WORD_WIDTH - 1:0] alu_res;
logic                    comp;
logic                    lsu_stall_req_o;


// FOR DEBUG
assign stall_deb = lsu_stall_req_o;

// instruction fetching
logic [1:0]  rs_1_sel;
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
assign a_1 = instr_rdata_i[19:15];
assign a_2 = instr_rdata_i[24:20];
assign a_3 = instr_rdata_i[11:7];




// decoder
decoder FETCH (
	instr_rdata_i,
	
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
	clk_i,
	arstn_i,
	lsu_stall_req_o,
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

assign instr_addr_o = pc;


// register file
always_comb
	if(wd_3_sel == 'd0)
		wd_3 = alu_res;
	else
		wd_3 = mem_data;

reg_file regs (
	clk_i,
	reg_we,
	a_1, a_2, a_3,
	wd_3,
	
	rd_1, rd_2
);


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
			rs_2 = imm_I;
		'd2:
			rs_2 = {instr_rdata_i[31:12], 12'b0};
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

// FOR DEBUG
assign rs_1_o = rs_1;
assign rs_2_o = rs_2;

// sign extensions
sign_ext se (
	instr_rdata_i,
	
	imm_I, imm_S, imm_J, imm_B
);

// load-store unit
miriscv_lsu lsu (
	clk_i,
	arstn_i,
	
	// core protocol
	alu_res,
	mem_we,
	mem_size,
	rd_2,
	mem_req,
	
	lsu_stall_req_o,
	mem_data,
	
	// memory protocol
	data_rdata_i,
	data_flag_i,
	data_req_o,
	data_we_o,
	data_be_o,
	data_addr_o,
	data_wdata_o
);

endmodule
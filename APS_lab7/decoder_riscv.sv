`include "./defines_riscv.v"

module decoder (
  input  logic [31:0]  fetched_instr_i,
  
  output logic [1:0]   ex_op_a_sel_o,
  output logic [2:0]   ex_op_b_sel_o,
  output logic [4:0]   alu_op_o,
  output logic         mem_req_o,
  output logic         mem_we_o,
  output logic [2:0]   mem_size_o,
  output logic         gpr_we_a_o,
  output logic         wb_src_sel_o,
  output logic         illegal_instr_o,
  output logic         branch_o,
  output logic         jal_o,
  output logic         jalr_o
);

logic [6:0] op_code;
logic [2:0] funct_3;
logic [6:0] funct_7;

assign op_code = fetched_instr_i[6:0];
assign funct_3 = fetched_instr_i[14:12];
assign funct_7 = fetched_instr_i[31:25];

// opcode
always_comb
  case(op_code[6:2])
    `LOAD_OPCODE:
		 begin
			ex_op_a_sel_o = `OP_A_RS1;
			ex_op_b_sel_o = `OP_B_IMM_I;
			alu_op_o      = `ALU_ADD;
			wb_src_sel_o  = `WB_LSU_DATA;
			mem_req_o     = 'd1;
			mem_we_o      = 'd0;
			branch_o      = 'd0;
			jal_o         = 'd0;
			jalr_o        = 'd0;
			
			if( (op_code[1:0] != 2'b11) || (funct_3 == 'd3) || (funct_3 == 'd6) || (funct_3 == 'd7) )
			  begin
				 illegal_instr_o = 'd1;
				 mem_size_o      = 'd0;
				 gpr_we_a_o      = 'd0;
			  end
			else
			  begin
				 illegal_instr_o = 'd0;
				 mem_size_o      = funct_3;
				 gpr_we_a_o      = 'd1;
			  end
		 end

	 `OP_IMM_OPCODE:
		 begin
			ex_op_a_sel_o = `OP_A_RS1;
			ex_op_b_sel_o = `OP_B_IMM_I;
			wb_src_sel_o  = `WB_EX_RESULT;
			mem_req_o     = 'd0;
			mem_we_o      = 'd0;
			mem_size_o    = 'd0;
			branch_o      = 'd0;
			jal_o         = 'd0;
			jalr_o        = 'd0;
			
			if(op_code[1:0] != 2'b11)
			  begin
				 illegal_instr_o = 'd1;
				 alu_op_o        = 'd0;
				 gpr_we_a_o      = 'd0;
			  end
			  
			else if(funct_3 == 'b101)
			  if (funct_7 != 'b0 && funct_7 != 'b0100000)
				 begin
					illegal_instr_o = 'd1;
					alu_op_o        = 'd0;
					gpr_we_a_o      = 'd0;
				 end
			  else
				 begin
					illegal_instr_o = 'd0;
					alu_op_o        = { {2'b0}, funct_3 };
					gpr_we_a_o      = 'd1;
				 end
			
			else if(funct_3 == 'd1 && funct_7 != 'd0)
			  begin
				 illegal_instr_o = 'd1;
				 alu_op_o        = 'd0;
				 gpr_we_a_o      = 'd0;
			  end
			
			else
			  begin
				 illegal_instr_o = 'd0;
				 alu_op_o        = { {2'b0}, funct_3 };
				 gpr_we_a_o      = 'd1;
			  end
		 end
		  
    `AUIPC_OPCODE:
		 begin
			ex_op_a_sel_o = `OP_A_CURR_PC;
			ex_op_b_sel_o = `OP_B_IMM_U;
			wb_src_sel_o  = `WB_EX_RESULT;
			alu_op_o      = `ALU_ADD;
			mem_req_o     = 'd0;
			mem_we_o      = 'd0;
			mem_size_o    = 'd0;
			branch_o      = 'd0;
			jal_o         = 'd0;
			jalr_o        = 'd0;
	
			if( (op_code[1:0] != 2'b11) )
			  begin
				 illegal_instr_o = 'd1;
				 gpr_we_a_o      = 'd0;
			  end
			else
			  begin
				 illegal_instr_o = 'd0;
				 gpr_we_a_o      = 'd1;
			  end
		 end
		  
    `STORE_OPCODE:
		 begin
			ex_op_a_sel_o = `OP_A_RS1;
			ex_op_b_sel_o = `OP_B_IMM_S;
			wb_src_sel_o  = `WB_LSU_DATA;
			alu_op_o      = `ALU_ADD;
			mem_req_o     = 'd1;
			mem_we_o      = 'd1;
			gpr_we_a_o    = 'd0;
			branch_o      = 'd0;
			jal_o         = 'd0;
			jalr_o        = 'd0;
			
			if( (op_code[1:0] != 2'b11) || (funct_3 != 'd0 && funct_3 != 'd1 && funct_3 != 'd2) )
			  begin
				 illegal_instr_o = 'd1;
				 mem_size_o      = 'd0;
			  end
			else
			  begin
				 illegal_instr_o = 'd0;
				 mem_size_o      = funct_3;
			  end
		 end
		
    `OP_OPCODE:
		 begin
			ex_op_a_sel_o = `OP_A_RS1;
			ex_op_b_sel_o = `OP_B_RS2;
			wb_src_sel_o  = `WB_EX_RESULT;
			mem_req_o     = 'd0;
			mem_we_o      = 'd0;
			mem_size_o    = 'd0;
			branch_o      = 'd0;
			jal_o         = 'd0;
			jalr_o        = 'd0;
			
			if( (op_code[1:0] != 2'b11) || (funct_7 != 'b0 && funct_7 != 7'b0100000) )
			  begin
				 illegal_instr_o = 'd1;
				 alu_op_o        = 'd0;
				 gpr_we_a_o      = 'd0;
			  end
			else
			  begin
				 illegal_instr_o = 'd0;
				 alu_op_o        = {funct_7[6:5], funct_3};
				 gpr_we_a_o      = 'd1;
			  end
		 end

    `LUI_OPCODE:
		 begin
			ex_op_a_sel_o = `OP_A_ZERO;
			ex_op_b_sel_o = `OP_B_IMM_U;
			alu_op_o      = `ALU_ADD;
			wb_src_sel_o  = `WB_EX_RESULT;
			mem_req_o     = 'd0;
			mem_we_o      = 'd0;
			mem_size_o    = 'd0;
			branch_o      = 'd0;
			jal_o         = 'd0;
			jalr_o        = 'd0;
			
			if(op_code[1:0] != 2'b11)
			  begin
				 illegal_instr_o = 'd1;
				 gpr_we_a_o      = 'd0;
			  end
			else
			  begin
				 illegal_instr_o = 'd0;
				 gpr_we_a_o      = 'd1;
			  end
		 end
		  
    `BRANCH_OPCODE:
		 begin
			ex_op_a_sel_o = `OP_A_RS1;
			ex_op_b_sel_o = `OP_B_RS2;
			mem_req_o     = 'd0;
			mem_we_o      = 'd0;
			mem_size_o    = 'd0;
			gpr_we_a_o    = 'd0;
			wb_src_sel_o  = 'd0;
			branch_o      = 'd1;
			jal_o         = 'd0;
			jalr_o        = 'd0;
			
			if( (op_code[1:0] != 2'b11) || (funct_3 == 'd2) || (funct_3 == 'b011) )
			  begin
				 illegal_instr_o = 'd1;
				 alu_op_o        = 'd0;
			  end
			else
			  begin
				 illegal_instr_o = 'd0;
				 alu_op_o        = {2'b11, funct_3};
			  end
		 end
		  
    `JALR_OPCODE:
		 begin
			ex_op_a_sel_o = `OP_A_CURR_PC;
			ex_op_b_sel_o = `OP_B_INCR;
			wb_src_sel_o  = `WB_EX_RESULT;
			alu_op_o      = `ALU_ADD;
			mem_req_o     = 'd0;
			mem_we_o      = 'd0;
			mem_size_o    = 'd0;
			branch_o      = 'd0;
			jal_o         = 'd0;
			jalr_o        = 'd1;
			
			if(op_code[1:0] != 2'b11 || funct_3 != 'd0)
			  begin
				 illegal_instr_o = 'd1;
				 gpr_we_a_o      = 'd0;
			  end
			else
			  begin
				 illegal_instr_o = 'd0;
				 gpr_we_a_o      = 'd1;
			  end
		 end
		  
    `JAL_OPCODE:
		 begin
			ex_op_a_sel_o = `OP_A_CURR_PC;
			ex_op_b_sel_o = `OP_B_INCR;
			wb_src_sel_o  = `WB_EX_RESULT;
			alu_op_o      = `ALU_ADD;
			mem_req_o     = 'd0;
			mem_we_o      = 'd0;
			mem_size_o    = 'd0;
			branch_o      = 'd0;
			jal_o         = 'd1;
			jalr_o        = 'd0;
			
			if(op_code[1:0] != 2'b11)
			  begin
				 illegal_instr_o = 'd1;
				 gpr_we_a_o      = 'd0;
			  end
			else
			  begin
				 illegal_instr_o = 'd0;
				 gpr_we_a_o      = 'd1;
			  end
		 end
		  
    `MISC_MEM_OPCODE:
		 begin
			ex_op_a_sel_o   = 'd0;
			ex_op_b_sel_o   = 'd0;
			alu_op_o        = 'd0;
			mem_req_o       = 'd0;
			mem_we_o        = 'd0;
			mem_size_o      = 'd0;
			gpr_we_a_o      = 'd0;
			wb_src_sel_o    = 'd0;
			branch_o        = 'd0;
			jal_o           = 'd0;
			jalr_o          = 'd0;
			illegal_instr_o = 'd0;
			
			if(op_code[1:0] != 2'b11)
			  begin
				 illegal_instr_o = 'd1;
			  end
			else
			  begin
				 illegal_instr_o = 'd0;
			  end
			
		 end

    `SYSTEM_OPCODE:
		 begin
			ex_op_a_sel_o   = 'd0;
			ex_op_b_sel_o   = 'd0;
			alu_op_o        = 'd0;
			mem_req_o       = 'd0;
			mem_we_o        = 'd0;
			mem_size_o      = 'd0;
			gpr_we_a_o      = 'd0;
			wb_src_sel_o    = 'd0;
			branch_o        = 'd0;
			jal_o           = 'd0;
			jalr_o          = 'd0;
			illegal_instr_o = 'd0;
			
			if(op_code[1:0] != 2'b11)
			  begin
				 illegal_instr_o = 'd1;
			  end
			else
			  begin
				 illegal_instr_o = 'd0;
			  end
		 end

    default:
		 begin
			ex_op_a_sel_o   = 'd0;
			ex_op_b_sel_o   = 'd0;
			alu_op_o        = 'd0;
			mem_req_o       = 'd0;
			mem_we_o        = 'd0;
			mem_size_o      = 'd0;
			gpr_we_a_o      = 'd0;
			wb_src_sel_o    = 'd0;
			branch_o        = 'd0;
			jal_o           = 'd0;
			jalr_o          = 'd0;
			illegal_instr_o = 'd1;
		 end
  endcase
		
endmodule
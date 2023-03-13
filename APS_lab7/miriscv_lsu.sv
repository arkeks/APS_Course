`include "defines_riscv.v"

module miriscv_lsu
(
	input  logic clk_i,
	input  logic arst_i,
	
	// core protocol
	input  logic [31:0] lsu_addr_i,
	input  logic        lsu_we_i,
	input  logic [2 :0] lsu_size_i,
	input  logic [31:0] lsu_data_i,
	input  logic        lsu_req_i,
	
	output logic        lsu_stall_req_o,
	output logic [31:0] lsu_data_o,
	
	// memory protocol
	input  logic [31:0] data_rdata_i,
	input  logic        data_flag_i,
	
	output logic        data_req_o,
	output logic        data_we_o,
	output logic [3:0]  data_be_o,
	output logic [31:0] data_addr_o,
	output logic [31:0] data_wdata_o
);
/*
always_ff @ (posedge clk_i)
	if (lsu_req_i)
		begin
			lsu_stall_req_o <= ~lsu_stall_req_o;
			data_req_o      <= ~data_req_o;
		end
	else
		begin
			lsu_stall_req_o <= 'd0;
			data_req_o      <= 'd0;
		end
*/

always_comb
	if(lsu_req_i && ~data_flag_i)
		begin
			lsu_stall_req_o = 'd1;
			data_req_o      = 'd1;
		end
	else
		begin
			lsu_stall_req_o = 'd0;
			data_req_o      = 'd0;
		end
		
assign data_we_o    = lsu_we_i;
assign data_addr_o  = lsu_addr_i;

logic [1:0] adr_diff;
assign adr_diff = lsu_addr_i % 4;

always_comb
	case(lsu_size_i)
		`LDST_B:
			case(adr_diff)
				'd0:
					lsu_data_o = { {24{data_rdata_i[7]}}, data_rdata_i[7:0]};
					
				'd1:
					lsu_data_o = { {24{data_rdata_i[15]}}, data_rdata_i[15:8]};
					
				'd2:
					lsu_data_o = { {24{data_rdata_i[23]}}, data_rdata_i[23:16]};
			
				'd3:
					lsu_data_o = { {24{data_rdata_i[31]}}, data_rdata_i[31:24]};
					
				default:
					lsu_data_o = 'b1;
					
			endcase
			
			
		`LDST_BU:
			case(adr_diff)
				'd0:
					lsu_data_o = { 24'b0, data_rdata_i[7:0]};
					
				'd1:
					lsu_data_o = { 24'b0, data_rdata_i[15:8]};
					
				'd2:
					lsu_data_o = { 24'b0, data_rdata_i[23:16]};
			
				'd3:
					lsu_data_o = { 24'b0, data_rdata_i[31:24]};
					
				default:
					lsu_data_o = 'b1;
					
			endcase
			
			
		`LDST_H:
			case(adr_diff)
				'd0:
					lsu_data_o = { {16{data_rdata_i[15]}}, data_rdata_i[15:0]};
					
				'd2:
					lsu_data_o = { {16{data_rdata_i[31]}}, data_rdata_i[31:16]};
			
				default:
					lsu_data_o = 'b1;
					
			endcase
			
		`LDST_HU:
			case(adr_diff)
				'd0:
					lsu_data_o = { 16'b0, data_rdata_i[15:0]};
					
				'd2:
					lsu_data_o = { 16'b0, data_rdata_i[31:16]};
			
				default:
					lsu_data_o = 'b1;
					
			endcase
			
		`LDST_W:
			case(adr_diff)
				'd0:
					lsu_data_o = data_rdata_i[31:0];
			
				default:
					lsu_data_o = 'b1;
					
			endcase
			
		default:
			lsu_data_o = 'b1;
			
	endcase
		

always_comb
	case(lsu_size_i)
		`LDST_B:
			begin
				data_wdata_o = { 4{lsu_data_i[7:0]} };
				
				case(adr_diff)
					'd0:
						data_be_o = 'b0001;
					'd1:
						data_be_o = 'b0010;
					'd2:
						data_be_o = 'b0100;
					'd3:
						data_be_o = 'b1000;
					default:
						data_be_o = 'b0;
				endcase
			end
		`LDST_BU:
			begin
				data_wdata_o = { 4{lsu_data_i[7:0]} };
				
				case(adr_diff)
					'd0:
						data_be_o = 'b0001;
					'd1:
						data_be_o = 'b0010;
					'd2:
						data_be_o = 'b0100;
					'd3:
						data_be_o = 'b1000;
					default:
						data_be_o = 'b0;
				endcase
			end
			
		`LDST_H:
			begin
				data_wdata_o = { 2{lsu_data_i[15:0]} };
				
				case(adr_diff)             // почему нельзя data_be = 'b0110 ???
					'd0:
						data_be_o = 'b0011;
					'd2:
						data_be_o = 'b1100;
					default:
						data_be_o = 'b0;
				endcase
			end
		`LDST_HU:
			begin
				data_wdata_o = { 2{lsu_data_i[15:0]} };
				
				case(adr_diff)             // почему нельзя data_be = 'b0110 ???
					'd0:
						data_be_o = 'b0011;
					'd2:
						data_be_o = 'b1100;
					default:
						data_be_o = 'b0;
				endcase
			end
			
		`LDST_W:
			begin
				data_wdata_o = lsu_data_i;
			
				case(adr_diff)
					'd0:
						data_be_o = 'b1111;
					default:
						data_be_o = 'b0;
				endcase
			end
			
		default:
			begin
				data_wdata_o = 'b0;
				data_be_o    = 'b0;
			end
	endcase

endmodule
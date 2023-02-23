module reg_file
#
(
  parameter WIDTH = 32,
            DEPTH = 32,
            ADR_WIDTH = $clog2(DEPTH)
)

(
  input logic                    clk,
  input logic                    wr_en,
  input logic  [ADR_WIDTH - 1:0] adr_1, adr_2, adr_3,
  input logic  [WIDTH - 1:0]     wd_3,               // write data in adr_3 port
  
  output logic [WIDTH - 1:0]     rd_1, rd_2          // read data ports
);

logic [WIDTH - 1:0] regs [DEPTH - 1:0];

// write operation
always_ff @ (posedge clk)
  if (wr_en && (adr_3 != 'b0))
    regs[adr_3] <= wd_3;
	 
	 
// read operation

assign rd_1 = (adr_1 == 'b0) ? 'b0 : regs[adr_1];
assign rd_2 = (adr_2 == 'b0) ? 'b0 : regs[adr_2];

endmodule
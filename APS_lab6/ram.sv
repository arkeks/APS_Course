module RAM
#
(
  parameter WORD_WIDTH = 32,           // WORD
            CELL_WIDTH = 8,            // SIZE OF CELL = BYTE
            DEPTH      = 'd1 << 19,    // NUMBER OF CELLS (2^19)
            ADR_WIDTH  = $clog2(DEPTH) // NUMBERS OF CELL ADDRESSES
)

(
  input  logic                    clk,
  input  logic                    wr_en,
  input  logic [WORD_WIDTH - 1:0] adr,
  input  logic [WORD_WIDTH - 1:0] wr_data,
  
  
  output logic [WORD_WIDTH - 1:0] rd_data
);

logic [WORD_WIDTH - 1:0] ram [DEPTH - 1:0];

logic [ADR_WIDTH - 1:0] adr_w;

assign adr_w = adr >> 'd2;

// write operation
always_ff @(posedge clk)
	if (wr_en)
		begin
			ram[adr_w] <= wr_data;
		end
	 
	 
// read operation
assign rd_data = ( adr >= 'h43000000 &&  adr <= 'h430003FC) ? ram[adr_w] : 'h0;

endmodule





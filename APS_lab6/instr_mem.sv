module ROM 
#
(
  parameter WORD_WIDTH = 32,           // WORD
            CELL_WIDTH = 8,            // SIZE OF CELL = BYTE
            DEPTH      = 256,          // NUMBER OF CELLS
            ADR_WIDTH  = $clog2(DEPTH) // NUMBERS OF CELL ADDRESSES
)

(
  input  logic                    clk,
  input  logic [WORD_WIDTH - 1:0] pc,
  
  output logic [WORD_WIDTH - 1:0] data
);

logic [ADR_WIDTH  - 1:0] adr;

logic [WORD_WIDTH - 1:0] mem [DEPTH - 1:0];

initial $readmemh("CSL_code.txt", mem);

assign adr  = pc >> 'd2;

assign data = mem[adr];
	 
endmodule
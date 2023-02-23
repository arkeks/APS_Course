module RAM
#
(
  parameter WIDTH     = 32,
            DEPTH     = 256
)

(
  input  logic               clk,
  input  logic               wr_en,
  input  logic [WIDTH - 1:0] adr,
  input  logic [WIDTH - 1:0] wr_data,
  
  
  output logic [WIDTH - 1:0] rd_data
);

logic [WIDTH - 1:0] ram [DEPTH - 1:0];


// write operation
always_ff @(posedge clk)
  if (wr_en)
    ram[adr[9:2]] <= wr_data;
	 
	 
// read operation
assign rd_data = ram[adr[9:2]];

endmodule





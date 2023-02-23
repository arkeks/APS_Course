module ROM 
#
(
  parameter WIDTH     = 32,
            DEPTH     = 4,
            ADR_WIDTH = $clog2(DEPTH)
)

(
  input  logic [ADR_WIDTH - 1:0] adr,
  
  output logic [WIDTH - 1:0]     data
);

logic [WIDTH - 1:0] mem [DEPTH - 1:0];

initial $readmemh("../../rom_dataset.txt", mem);

assign data = mem[adr];

endmodule
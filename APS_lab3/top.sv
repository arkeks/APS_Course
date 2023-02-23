module top
(
  input logic [7:0] adr_rom,
  output logic [31:0] rom_data,


  input logic        clk,
  input logic        wr_en,
  input logic [31:0] wr_data,
  input logic [31:0] ram_adr,
  input logic [31:0] ram_data,
  input logic [4:0]  adr_1, adr_2, adr_3,
  
  output logic [31:0] rd_1, rd_2

);

ROM instr_mem (
  adr_rom,
  rom_data
);


RAM ram_mem (
  clk,
  wr_en,
  ram_adr,
  wr_data,
  
  ram_data
);
  


reg_file registers (
  clk,
  wr_en,
  adr_1, adr_2, adr_3,
  rd_1, rd_2
);

endmodule
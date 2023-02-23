module testbench();

//---common for all tests---
logic         clk;

initial begin
  #1;
  clk = 'b0;
end


always begin
  #1;
  clk = ~clk;
end


integer i, rom_file, ram_file, regs_file;


//---for instr_mem test---
/*
// inputs
logic  [1:0]  rom_adr;

// outputs
logic  [31:0] rom_data;


ROM #(.WIDTH(32), .DEPTH(4))

rom_tst (
  .adr(rom_adr),
  
  .data(rom_data)
);

logic [31:0] rom_dataset;


initial begin
  rom_file = $fopen("../../rom_dataset.txt", "r");
end

initial begin
  rom_adr = 'b0;
  for (i = 0; i < 4; i = i + 1) begin
    $fscanf(rom_file, "%x", rom_dataset);
	 #5;
	 if (rom_data != rom_dataset)
	   $display($time, "BAD!  ADR = %d, ADR_DATA = %h, READ_DATA = %h", rom_adr, rom_dataset, rom_data);
	 else
	   $display($time, "GOOD:  ADR = %d, ADR_DATA = %h, READ_DATA = %h", rom_adr, rom_dataset, rom_data);
		
	 rom_adr = rom_adr + 1;
  end
  
  $fclose(rom_file);
  $finish;
end
*/


//-----for ram test-----
/*
// inputs
logic        wr_en_ram;
logic [31:0] ram_adr;
logic [31:0] wr_data;

// outputs
logic [31:0] rd_data;

RAM #(.WIDTH(32), .DEPTH(256))
ram_tst (
  clk,
  wr_en_ram,
  ram_adr,
  wr_data,
  
  rd_data
);


initial begin
  ram_adr = {23'b0, 7'b0000001, 2'b00};
  wr_en_ram = 'b1;
  
  for (i = 0; i < 4; i = i + 1) begin
    wr_data = $urandom() % 32;
	 #1
	 
	 if (rd_data != wr_data)
	   $display($time, "BAD!  ADR = %d, WR_DATA = %h, READ_DATA = %h", ram_adr[9:2], wr_data, rd_data);
	 else
	   $display($time, "GOOD:  ADR = %d, WR_DATA = %h, READ_DATA = %h", ram_adr[9:2], wr_data, rd_data);
		
	 ram_adr += 'd1;
	 wr_en_ram = 'b1;
  end
  
  $finish;
  
end
*/


//---for reg_file test--- 

// inputs
logic        wr_en_regs;
logic [4:0]  adr_1, adr_2, adr_3;
logic [31:0] wd_3;

// outputs
logic [31:0] rd_1, rd_2;

reg_file # (.WIDTH(32), .DEPTH(32))
regs_tst (
  clk,
  wr_en_regs,
  adr_1, adr_2, adr_3,
  wd_3,
  
  rd_1, rd_2
);


initial begin
  adr_1 = 'b0;
  adr_2 = 'b0;
  wr_en_regs = 'b0;
  #1;
  
  for (i = 1; i <= 10; i = i + 1) begin
    wr_en_regs = ~wr_en_regs;
	 adr_3 = i;
    wd_3 = 'h5 + i;
	 #2;
  end
  
  
  for (i = 1; i <= 10; i = i + 1) begin
    adr_1 = i;
	 adr_2 = i + 1;
	 #2;
  end
  
  $finish;
  
end

endmodule
  
  
  
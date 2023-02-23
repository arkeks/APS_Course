module testbench();    // <- Не имеет ни входов, ни выходов!
	// inputs
	reg  [31:0] A;
	reg  [31:0] B;
	reg         P_in;
	
	// outputs
	wire [31:0] S;
	wire        P_out;
	
	adder_32bit DUT(         // <- Подключаем проверяемый модуль
	  .a(A),
	  .b(B),
	  .Pin(P_in),
	  
	  .S(S),
	  .Pout(P_out)
	);
	
	initial begin
	   $dumpvars;
		$monitor("result = %d", S);
		A = 'd25; B = 'd12; P_in = 0;
		#5;
      		
		$finish;
	end
	
endmodule
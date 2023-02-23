module full_adder(
	input a,
	input b,
	input Pin,
	
	output S,
	output Pout
	);
	
	assign S    = a ^ b ^ Pin;
	assign Pout = (a & b) | (a & Pin) | (b & Pin);
	
endmodule
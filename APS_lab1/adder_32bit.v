module adder_32bit (
  input  [31:0] a,
  input  [31:0] b,
  input         Pin,
  
  output [31:0] S,
  output        Pout
 );
 
 wire [30:0] P;
 
 genvar i;
 
 generate
  for (i = 0; i < 32; i = i + 1) begin : gen_32_adders
    if (i == 0) begin
	 
      full_adder adder (
	     .a(a[i]),
		  .b(b[i]),
		  .Pin(Pin),
		  
		  .S(S[i]),
		  .Pout(P[i])
		  );
		
    end else if (i < 31) begin
	 
	   full_adder adder (
		  .a(a[i]),
		  .b(b[i]),
		  .Pin(P[i-1]),
		  
		  .S(S[i]),
		  .Pout(P[i])
		  );
		  
	 end else begin
	 
	   full_adder adder (
		  .a(a[i]),
		  .b(b[i]),
		  .Pin(P[i-1]),
		  
		  .S(S[i]),
		  .Pout(Pout)
		  );
		  
	 end
   end
 endgenerate
 
 endmodule
		  
		  
		  
		  
		  
		  
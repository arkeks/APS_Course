module sign_ext
# (
  parameter WIDTH_IN = 23,
            WIDTH_OUT = 32
)
(
  input  logic [WIDTH_IN - 1:0] in_const,

  output logic [WIDTH_OUT - 1:0] out_const
);

parameter diff = WIDTH_OUT - WIDTH_IN;

assign out_const = in_const[WIDTH_IN - 1] ? { {diff {1'b1}}, in_const} : { {diff {1'b0}}, in_const};

endmodule
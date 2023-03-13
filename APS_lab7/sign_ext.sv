module sign_ext
# (
  parameter WIDTH = 32
)
(
  input  logic [WIDTH - 1:0] instr,

  output logic [WIDTH - 1:0] imm_I, imm_S, imm_J, imm_B
);

assign imm_I = { {20{instr[31]}}, instr[31:20] };

assign imm_S = { {20{instr[31]}}, instr[31:25], instr[11:7] };

assign imm_J = { {12{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21] };

assign imm_B = { {20{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8] };


endmodule
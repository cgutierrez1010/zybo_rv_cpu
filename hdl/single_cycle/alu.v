module alu(
	input wire [31:0]a. 
	input wire [31:0]b.
	input wire [3:0]alu_op.
	output reg[31:0]y,
	output wire zero
	);
	always 

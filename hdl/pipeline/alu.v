module alu(
	input wire [31:0]a, 
	input wire [31:0]b,
	input wire [3:0]alu_op,
	output reg[31:0]y,
	output wire zero
	);
	always @(*) begin
		case (alu_op)
			4'd0: y = a + b;  //addition
			4'd1: y = a - b; //subtract
			4'd2: y = a & b;     //and
			4'd3: y = a | b;    //or
			4'd4: y = a ^ b;  //exor
			4'd5: y = a << b[4:0];    //shiftleft
			4'd6: y = a >> b[4:0]; //shftright
			4'd7: y = ($signed(a) >>> b[4:0]); //shftrightsin
			4'd8: y = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; 
			default: y = 32'd0;
		endcase
	end
	assign zero = (y == 32'd0);
	endmodule

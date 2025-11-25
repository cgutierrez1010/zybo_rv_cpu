module regfile  (
	 input clk, //system clock
	 input we, //wrte
	 input [4:0] rs1, //firsts source register
	 input [4:0] rs2, //second source reg
	 input [4:0] rd, //destination register to be written
         input [31:0] rd_data, //data to be written destination reg
	 output [31:0] rs1_data, //rs1 output data
	 output [31:0] rs2_data //rs2 output data
	 );
	  reg [31:0] regs [31:0]; //32x32 array regs
	  integer i;
	  initial for (i=0;i<32;i=i+1) regs[i] = 32'd0; //initalize regs to zero
	  assign rs1_data = (rs1 == 5'd0) ? 32'd0 : regs[rs1]; //
	  assign rs2_data = (rs2 == 5'd0) ? 32'd0 : regs[rs2];
	  always @(posedge clk) begin
	    if (we && (rd != 5'd0)) regs[rd] <= rd_data;
	 end
         endmodule

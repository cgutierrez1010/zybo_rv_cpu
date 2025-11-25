module instr_mem (
  input  wire [31:0] addr, //memory address requested 
  output reg  [31:0] instr //hold instruction from addr
);
  reg [31:0] rom [0:1023]; //declares our memory array 'rom' and holds 1024 elements
  initial begin
     // load from instr_mem.hex a$readmemh("../sim/instr_mem.hex", rom);
  end
  always @(*) begin
    instr = rom[addr[11:2]]; // word address
  end
endmodule

`timescale 1ns / 1ps

module inst_memory(
  input logic [31:0]A ,
  output logic [31:0]RD 
    );
   logic [31:0] Mem [0:1024];
   assign RD =  Mem[A[12:2]];//11 - bit index for 1024 words

initial begin
    // Clear memory
    for (int i = 0; i < 1024; i++)
        Mem[i] = 32'h00000013; // NOP in RISC-V (addi x0,x0,0)

    // Load program
    $readmemh("program.mem", Mem);
end
endmodule

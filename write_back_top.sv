`timescale 1ns / 1ps

module Write_back_stage(
input logic RegWriteW,
input logic  [1:0] ResultSrcW,
input logic [31:0] ALUResultW,
input logic [31:0] ReadDataW,
input logic [4:0]RdW,
input logic [31:0] PcPlus4W,
output logic [31:0] ResultW
    );
    
    
     mux_3_1 m3 (
               .a(ALUResultW),
               .b(ReadDataW),
               .c(PcPlus4W),
               .s(ResultSrcW),
               .muxout(ResultW));
         
               
endmodule

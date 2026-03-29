`timescale 1ns / 1ps
module Fetch_Instruction(
input logic clk,rst,
input logic PcSrcE,
input logic StallF,
input logic [31:0] PcTargetE,
output logic [31:0] InstrD,
output logic [31:0]PcD,
output logic [31:0] PcPlus4D 
    );
    //declaration of internal wires 
    logic [31:0]PC_F,PCF, PcPlus4F,InstF;
    
    //declaration of registers
    logic [31:0] InstF_Reg,PCF_Reg,PcPlus4F_Reg;
    // declare pc mux
    MUX_2_1 mux(
       .a(PcPlus4F),
       .b(PcTargetE),
       .sel(PcSrcE),
       .c(PC_F));
       
    //declare  pc module 
   Pc_Module Pc(
       .clk(clk),
       .rst(rst),
       .Pc_next(PC_F),
       . Pc(PCF),
       .StallF(StallF));
       
    //declare inst memory
   inst_memory inst_mem(
       .A(PCF[31:2]),
       .RD(InstF));
       
       
   // declare pcadder
   Pc_adder pc_adder(
       .PcF(PCF),
       .PcF_4(PcPlus4F)
   );
   
   //fetch cycle register logic
   always_ff @(posedge clk  or  negedge rst)
   if (!rst)
   begin 
   InstF_Reg <= 32'h00000000;
   PCF_Reg  <= 32'h00000000;
   PcPlus4F_Reg <= 32'h00000000;
   end
   else if (!StallF)
   begin
   InstF_Reg <= InstF;
   PCF_Reg  <= PCF;
   PcPlus4F_Reg <= PcPlus4F;
   end

   
   //assigning outputs 
   assign InstrD = (!rst)?32'h00000000:InstF_Reg;
   assign PcD = (!rst)?32'h00000000:PCF_Reg;
   assign PcPlus4D = (!rst)?32'h00000000:PcPlus4F_Reg;
    
endmodule

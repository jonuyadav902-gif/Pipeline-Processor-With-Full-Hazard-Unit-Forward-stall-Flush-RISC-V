`timescale 1ns / 1ps

module Execute_cycle(
input logic clk,rst,
input logic RegWriteE,
input logic [1:0] ResultSrcE,
input logic  MemWriteE,
input logic  jumpE,
input logic  BranchE,
input logic [2:0] ALUControlE,
input logic  ALUSrcE,
input logic [31:0] RD1E,
input logic [31:0] RD2E,
input logic [31:0] PCE,
input logic [4:0] RdE,RS1E,RS2E,
input logic [31:0] ImmExtendE,
input logic [31:0] PcPlus4E,
input logic [31:0] ResultW,
input logic [1:0] ForwardAE,
input logic [1:0] ForwardBE,
input logic FlushE,
output logic RegWriteM,
output logic [1:0]ResultSrcM,
output logic MemWriteM,
output logic [31:0]ALUResultM,
output logic [31:0]WriteDataM,
output logic [4:0]RdM,
output logic [31:0] PcPlus4M,
output logic [31:0]PcTargetE,
output logic PcSrcE
    );
    
    //declaration of registers
   logic  RegWriteE_r,MemWriteE_r;
    logic [31:0] PcPlus4E_r,WriteDataE_r,ALUOut_r;
    logic [4:0]RdE_r;
    logic [1:0]ResultSrcE_r;

   //declatation of wires 
    logic [31:0] SrcBE,ALUOut,SrcAE,mux_hazard_2_out;
    logic and_out;
    
    //declaration of alu
    logic zeroE;

ALU A1 (
    .SrcAE(SrcAE),
    .SrcBE(SrcBE),
    .ALUControlE(ALUControlE),
    .ALUResult(ALUOut),
    .zeroE(zeroE)
);

    Adder Add (
        .PCE(PCE),
        .ImmExtendE(ImmExtendE),
        .PcTargetE(PcTargetE));
        
     MUX_2_1 m2 (
           .a(mux_hazard_2_out),
           .b(ImmExtendE),
           .sel(ALUSrcE),
           .c(SrcBE)); 
           
      //////////////HAZARD UNIT /////////////
      
       mux_3_1 mux_hazard_1 (
               .a(RD1E),
               .b(ResultW),
               .c(ALUResultM),
               .s(ForwardAE),
               .muxout(SrcAE));
               
       mux_3_1 mux_hazard_2 (
              .a(RD2E),
               .b(ResultW),
               .c(ALUResultM),
               .s(ForwardBE),
               .muxout(mux_hazard_2_out));
        
           
   always_ff @(posedge clk  or  negedge rst)
   if (!rst )
   begin 
 {RegWriteE_r,MemWriteE_r} <= 0;
 PcPlus4E_r <= 0;
 RdE_r <= 0;
 ResultSrcE_r <= 0;
 WriteDataE_r <= 0;
  ALUOut_r <=0;
   end
     else if (FlushE)
    begin
        RegWriteE_r <= 0;
        MemWriteE_r <= 0;
        ResultSrcE_r <= 0;
        RdE_r <= 0;
        WriteDataE_r <= 0;
        ALUOut_r <= 0;
        PcPlus4E_r <= 0;
    end
   else
   begin
   RegWriteE_r <= RegWriteE;
   MemWriteE_r <= MemWriteE;
   RdE_r <= RdE;
   PcPlus4E_r <= PcPlus4E;
   ResultSrcE_r <= ResultSrcE;
   WriteDataE_r <= mux_hazard_2_out;
   ALUOut_r <= ALUOut;
   end
  //assigning outputs 
    assign RegWriteM = (!rst)?1'b0:RegWriteE_r;
    assign MemWriteM = (!rst)?1'b0:MemWriteE_r;
    assign RdM = (!rst)?5'b0:RdE_r;
    assign PcPlus4M = (!rst)?32'h00000000:PcPlus4E_r ;
    assign ResultSrcM = (!rst)?2'b0:ResultSrcE_r;
   assign and_out = zeroE & BranchE;
    assign PcSrcE = jumpE|and_out;
    assign ALUResultM = (!rst) ? 32'h0 : ALUOut_r;
    assign WriteDataM = (!rst) ? 32'h0 : WriteDataE_r;
endmodule

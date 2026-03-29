`timescale 1ns / 1ps

module decode_cycle(
input clk,rst,RegWriteW,
input logic [31:0] InstrD,
input logic [31:0]PCD,
input logic [31:0] PcPlus4D,
input logic [31:0]ResultW,
input logic [4:0]RdW,
input logic StallD,
//input logic FlushE,
input logic FlushD,
output logic RegWriteE,
output logic [1:0] ResultSrcE,
output logic  MemWriteE,
output logic  jumpE,
output logic  BranchE,
output logic [2:0] ALUControlE,
output logic  ALUSrcE,
output logic [31:0] RD1E,
output logic [31:0] RD2E,
output logic [31:0] PCE,
output logic [4:0] RdE,RS1E,RS2E,
output logic [31:0] ImmExtendE,
output logic [31:0] PcPlus4E,
output  logic [4:0] RS1D,RS2D

    );
    
    //declaration of wire 
    logic RegWriteD,MemWriteD,jumpD,BranchD,ALUSrcD;
    logic [31:0] RD1D,RD2D,ImmExtend;
    logic [1:0]ResultSrcD;
    logic [2:0]ALUControlD;
   logic [4:0]RdD;
    logic [1:0] ImmSrcD;
    assign RdD = InstrD[11:7];
    assign RS1D = InstrD[19:15];
    assign RS2D = InstrD[24:20];
    
    //decleration of registers
    logic  RegWriteD_r,MemWriteD_r,jumpD_r,BranchD_r,ALUSrcD_r;
    logic [31:0] RD1D_r,RD2D_r,PCD_r,PcPlus4D_r,ImmExtend_r;
    logic [4:0]RdD_r;
    logic [4:0]RS1D_r;
    logic [4:0]RS2D_r;
    logic [1:0]ResultSrcD_r,ImmSrcD_r;
    logic [2:0]ALUControlD_r;
    
    //control unit top
     control_unit_top control (
               .op(InstrD[6:0]),
               .funct3(InstrD[14:12]),
               .funct7(InstrD[31:25]),
               .RegWriteD(RegWriteD),
               .ResultSrcD(ResultSrcD),
               .MemWriteD(MemWriteD),
               .jumpD(jumpD),
               .BranchD(BranchD),
               .ALUControlD(ALUControlD),
               .ALUSrcD(ALUSrcD),
               .ImmSrcD(ImmSrcD)
                 );
               
     //register file
     registerfile register (
              .clk(clk),
              .rst(rst),
              .A1(InstrD[19:15]),
              . A2(InstrD[24:20]),
              .A3(RdW),
              .WD3(ResultW),
              .WE3(RegWriteW),
              .RD1(RD1D),
              .RD2(RD2D));
              
    //extender
    sign_extend extend (
               .Instr(InstrD),
               .ImmSrc(ImmSrcD),
               .ImmExtend(ImmExtend) );
               
               
  //decode cycle register logic
   always_ff @(posedge clk  or  negedge rst)
   if (!rst)
   begin 
 {RegWriteD_r,MemWriteD_r,jumpD_r,BranchD_r,ALUSrcD_r} <= 0;
 {RD1D_r,RD2D_r,PCD_r,PcPlus4D_r,ImmExtend_r} <= 0;
 RdD_r <= 0;
 RS1D_r <= 0;
 RS2D_r <= 0;
 ResultSrcD_r <= 0;
 ImmSrcD_r <= 0;
 ALUControlD_r <= 0;
end
else if(FlushD )
begin
  {RegWriteD_r,MemWriteD_r,jumpD_r,BranchD_r,ALUSrcD_r} <= 0;
  {RD1D_r,RD2D_r,ImmExtend_r,PCD_r,PcPlus4D_r} <= 0;
  RdD_r <= 0;
  RS1D_r <= 0;
  RS2D_r <= 0;
  ResultSrcD_r <= 0;
  ALUControlD_r <= 0; 
end
   else if (!StallD)
   begin
   RegWriteD_r <= RegWriteD;
   MemWriteD_r <= MemWriteD;
   jumpD_r<= jumpD;
   BranchD_r <= BranchD;
   ALUSrcD_r <= ALUSrcD;
   RD1D_r <= RD1D;
   RD2D_r <= RD2D;
   PCD_r <= PCD;
   PcPlus4D_r <= PcPlus4D;
   ImmExtend_r <= ImmExtend;
   ResultSrcD_r <= ResultSrcD;
   ALUControlD_r <=  ALUControlD;
   RdD_r <= RdD;
   RS1D_r <= RS1D;
   RS2D_r <= RS2D;
   
   end  
    assign RegWriteE  = RegWriteD_r;
    assign MemWriteE  = MemWriteD_r;
    assign jumpE      = jumpD_r;
    assign BranchE    = BranchD_r;
    assign ALUSrcE    = ALUSrcD_r;
    assign RD1E       = RD1D_r;
    assign RD2E       = RD2D_r;
    assign PCE        = PCD_r;
    assign RdE        = RdD_r;
    assign RS1E       = RS1D_r;   // clean — no ternary masking the real issue
    assign RS2E       = RS2D_r;
    assign PcPlus4E   = PcPlus4D_r;
    assign ImmExtendE = ImmExtend_r;
    assign ResultSrcE = ResultSrcD_r;
    assign ALUControlE= ALUControlD_r;
  
endmodule

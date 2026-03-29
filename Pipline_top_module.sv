`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////PIPLINE PROCESSOR RICSV///////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


module pipline_top_module(
input logic clk,rst
  );
  
// Fetch stage interconnect wires 
logic [31:0] InstrD, PcD, PcPlus4D; 
 // Decode Stage Wires 
logic RegWriteW;
logic [31:0] ResultW;
 // Execute stage interconnect signals
logic RegWriteE;
logic [1:0] ResultSrcE;
logic MemWriteE;
logic jumpE, BranchE;
logic [2:0] ALUControlE;
logic ALUSrcE;
logic [31:0] RD1E, RD2E;
logic [31:0] PCE;
logic [4:0] RdE;
logic [31:0] ImmExtendE;
logic [31:0] PcPlus4E;
logic PcSrcE;
logic [31:0] PcTargetE;
// Memory Stage Interconnects 
logic        RegWriteM;
logic [1:0]  ResultSrcM;
logic        MemWriteM;
logic [31:0] ALUResultM;
logic [31:0] WriteDataM;
logic [4:0]  RdM;
logic [31:0] PcPlus4M;
// Writeback Stage Interconnects (W-Stage)
logic [1:0]  ResultSrcW;
logic [31:0] ALUResultW;
logic [31:0] ReadDataW;
logic [4:0]  RdW;
logic [31:0] PcPlus4W;
//hazard unit interconnects
 logic [4:0] RS1E;
 logic [4:0] RS2E;
 logic [1:0] ForwardAE;
 logic [1:0] ForwardBE;
 logic StallF,StallD,FlushE,FlushD;
 logic [4:0]Rs1D,Rs2D;
 
 ////////FETCG STAGE////////////////////
Fetch_Instruction fetch(
              .clk(clk),
              .rst(rst),
              .PcSrcE(PcSrcE),
              .PcTargetE(PcTargetE),
              .InstrD(InstrD),
              .PcD(PcD),
              .PcPlus4D(PcPlus4D),
              .StallF(StallF) );
              
 //////////DECODE STAGE///////////////
  decode_cycle decode (
                .clk(clk),
                .rst(rst),
                .RegWriteW(RegWriteW),
                .InstrD(InstrD),
                .PCD(PcD),
                .PcPlus4D(PcPlus4D),
                .ResultW(ResultW),
                .RdW(RdW),
                .RegWriteE(RegWriteE),
                .ResultSrcE(ResultSrcE),
                .MemWriteE(MemWriteE),
                .jumpE(jumpE),
                .BranchE(BranchE),
                .ALUControlE(ALUControlE),
                .ALUSrcE(ALUSrcE),
                .RD1E(RD1E),
                .RD2E(RD2E),
                .PCE(PCE),
                .RdE(RdE),
                .RS1E(RS1E),
                .RS2E(RS2E),
                .ImmExtendE(ImmExtendE),
                .PcPlus4E(PcPlus4E),
                .StallD(StallD),
                .FlushD(FlushD),
                .RS1D(Rs1D),
                .RS2D(Rs2D));
  /////////EXECUTE CYCLE ///////////////////
             
  Execute_cycle execute(
               .clk(clk),
               .rst(rst),
               .RegWriteE(RegWriteE),
               .ResultSrcE(ResultSrcE),
               .MemWriteE(MemWriteE),
               .jumpE(jumpE),
               .BranchE(BranchE),
               .ALUControlE(ALUControlE),
               .ALUSrcE(ALUSrcE),
               .RD1E(RD1E),
               .RD2E(RD2E),
               .PCE(PCE),
               .RdE(RdE),
               .ImmExtendE(ImmExtendE),
               .RegWriteM(RegWriteM),
               .ResultSrcM(ResultSrcM),
               .MemWriteM(MemWriteM),
               .ALUResultM(ALUResultM),
               .WriteDataM(WriteDataM),
               .RdM(RdM),
               .PcPlus4M(PcPlus4M),
               .PcPlus4E(PcPlus4E),
               .PcTargetE(PcTargetE),
               .PcSrcE(PcSrcE),
               .RS2E(RS2E),
               .RS1E(RS1E),
               .ResultW(ResultW),  // FIX: was missing
               .ForwardAE(ForwardAE),  // FIX: was missing
               .ForwardBE(ForwardBE),
               .FlushE(FlushE));
////////////////DATA MEMORY /////////////
data_memory_cycle data_memory_stage (
               .clk(clk),
               .rst(rst),
               .RegWriteM(RegWriteM),
               .ResultSrcM(ResultSrcM),
               .MemWriteM(MemWriteM),
               .ALUResultM(ALUResultM),
               .WriteDataM(WriteDataM),
               .RdM(RdM),
               .PcPlus4M(PcPlus4M),
               .RegWriteW(RegWriteW),
               .ResultSrcW(ResultSrcW),
               .ALUResultW(ALUResultW),
               .ReadDataW(ReadDataW),
               .RdW(RdW),
               .PcPlus4W(PcPlus4W));
             
 ///////////////WRITE BACK STAGE///////////// 
            
          Write_back_stage WB (
               .RegWriteW(RegWriteW),
               .ResultSrcW(ResultSrcW),
               .ALUResultW(ALUResultW),
               .ReadDataW(ReadDataW),
               .RdW(RdW),
               .PcPlus4W(PcPlus4W),
               .ResultW(ResultW));
               
            //////////////HAZARD UNIT ///////////////
 hazard_forwarding hazard (
               .rst(rst),
               .RegWriteM(RegWriteM),
               .RegWriteW(RegWriteW),
               .RdM(RdM),
               .RdW(RdW),
               .Rs1E(RS1E),
               .Rs2E(RS2E),
               .Rs1D(Rs1D),
               .Rs2D(Rs2D),
               .StallF(StallF),
               .StallD(StallD),
               .FlushE(FlushE),
               .ForwardAE(ForwardAE),
               .ForwardBE(ForwardBE),
               .ResultSrcE(ResultSrcE),
               .RdE(RdE),
               .FlushD(FlushD),
               .PcSrcE(PcSrcE));
          
endmodule

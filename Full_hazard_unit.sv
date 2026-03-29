`timescale 1ns / 1ps

module hazard_forwarding(
input logic rst,RegWriteM,RegWriteW,
input logic [4:0] RdM,RdW,
input logic [4:0] Rs1E,Rs2E,
input logic [4:0] Rs1D,Rs2D,
input logic [4:0] RdE,
input logic [1:0] ResultSrcE,
input logic PcSrcE,
output logic StallF,StallD,FlushE,
output logic FlushD,
output logic [1:0] ForwardAE,ForwardBE
    );
    logic lw_stall;
    assign ForwardAE = (rst == 1'b0)? 2'b00:
        ((RegWriteM == 1'b1) && (RdM != 5'b00000) && (RdM == Rs1E)) ? 2'b10:
        ((RegWriteW == 1'b1) && (RdW != 5'b00000) && (RdW == Rs1E)) ? 2'b01:2'b00;
    assign ForwardBE = (rst == 1'b0)? 2'b00:
        ((RegWriteM == 1'b1) && (RdM != 5'b00000) && (RdM == Rs2E)) ? 2'b10:
        ((RegWriteW == 1'b1) && (RdW != 5'b00000) && (RdW == Rs2E)) ? 2'b01:2'b00;
        
    assign lw_stall = (ResultSrcE[0] &(RdE != 5'd0) & ((Rs1D == RdE) | (Rs2D == RdE)));
     assign StallF = lw_stall;
     assign StallD = lw_stall;
     assign FlushE = lw_stall || PcSrcE;  
     assign FlushD = PcSrcE;
      
        
        
endmodule

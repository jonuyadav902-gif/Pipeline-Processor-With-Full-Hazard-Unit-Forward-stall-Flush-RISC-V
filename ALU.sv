`timescale 1ns / 1ps

module ALU(
input logic [31:0]SrcAE,
input logic [31:0]SrcBE,
input logic [2:0]ALUControlE,
output logic [31:0]ALUResult,
output logic zeroE
    );
    always_comb begin
    case(ALUControlE)
    3'b000 : ALUResult = SrcAE + SrcBE; //add
    3'b001 : ALUResult = SrcAE - SrcBE; //sub
    3'b010 : ALUResult = SrcAE & SrcBE; //and
    3'b011 : ALUResult = SrcAE | SrcBE; //or
    3'b101 : ALUResult =  ($signed(SrcAE) < $signed(SrcBE)) ? 32'd1 : 32'd0;
    default ALUResult = 32'h0;
    endcase
    zeroE = (ALUResult == 0)?1'b1:1'b0;
    end
endmodule

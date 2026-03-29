`timescale 1ns / 1ps

module main_decoder(
input logic [6:0]op,
output logic [1:0]ResultSrc,
output logic MemWrite,
output logic ALUSrc,
output logic [1:0]ImmSrc,
output logic RegWrite,
output logic jump,
output logic Branch,
output logic [1:0]ALUOp
    );
    assign RegWrite = (op == 7'b0000011 || op == 7'b0110011 || op == 7'b0010011 || op == 7'b1101111)?1'b1:1'b0;
    assign ALUSrc = (op == 7'b0000011 || op == 7'b0100011 || op == 7'b0010011)?1'b1:1'b0;
    assign ImmSrc = (op == 7'b0100011)?2'b01:(op == 7'b1100011)?2'b10:(op == 7'b1101111)?2'b11:2'b00;
    assign MemWrite = (op == 7'b0100011)?1'b1:1'b0;
    assign ResultSrc = (op == 7'b0000011)?2'b01:(op == 7'b1101111)?2'b10:2'b00;
    assign Branch = (op == 7'b1100011)?1'b1:1'b0;
    assign ALUOp = (op == 7'b0110011)?2'b10:(op == 7'b1100011)?2'b01:(op ==7'b0010011)?2'b10:2'b00;
    assign jump = (op == 7'b1101111)?1'b1:1'b0;
endmodule

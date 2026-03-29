`timescale 1ns / 1ps

module ALU_Decoder(
input logic [6:0] op,
input logic [2:0] funct3,
input logic [6:0]funct7 ,
input logic [1:0]ALUOp ,
output logic [2:0]ALUControl
    );
    always_comb begin
    case (ALUOp)
    2'b00 : ALUControl = 3'b000;
    2'b01 : ALUControl = 3'b001;
    2'b10 : begin
    case (funct3)
  
    3'b000: begin
    if({op[5],funct7[5]} == 2'b11)
    ALUControl = 3'b001;
    else 
    ALUControl = 3'b000;
    end
    3'b010: ALUControl = 3'b101;
    3'b110: ALUControl = 3'b011;
    3'b111: ALUControl = 3'b010;
   default : ALUControl = 3'b000;
    endcase
    end
    default : ALUControl = 3'b000;
    endcase
    end
    
    
    
    
    
endmodule

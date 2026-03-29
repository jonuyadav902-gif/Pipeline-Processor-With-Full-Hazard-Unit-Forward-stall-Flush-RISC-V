`timescale 1ns / 1ps

module registerfile(
    input  logic clk,
    input  logic rst,
    input  logic [4:0] A1, A2, A3,
    input  logic [31:0] WD3,
    input  logic WE3,
    output logic [31:0] RD1, RD2
);

    logic [31:0] register [31:0];
    always_ff @(posedge clk) begin
        if (!rst) begin
            for (int i = 0; i < 32; i = i + 1) begin
                register[i] <= 32'd0;
            end
            register[1]  <= 32'd5;  
            register[2] <= 32'd10;   
        end 
        else if (WE3 && (A3 != 5'd0)) begin
            register[A3] <= WD3;
        end
    end
    assign RD1 = (A1 == 5'd0) ? 32'd0 : register[A1];
    assign RD2 = (A2 == 5'd0) ? 32'd0 : register[A2];

endmodule

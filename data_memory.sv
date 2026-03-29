`timescale 1ns / 1ps

module data_memory(
    input  logic clk,
    input  logic [31:0] A,
    input  logic [31:0] WD,
    input  logic WE,
    output logic [31:0] RD
);

    // Reduced size to 256 words for efficiency
    logic [31:0] Mem [0:255];

    // Initialize memory to avoid 'X' (Red) states in simulation
    initial begin
        for (int i = 0; i < 256; i++) begin
            Mem[i] = 32'h0;
        end
    end
    always_ff @(posedge clk) begin
        if (WE)
            Mem[A[9:2]] <= WD;
    end
    assign RD = Mem[A[9:2]];

endmodule

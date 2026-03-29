`timescale 1ns / 1ps

module data_memory_cycle(
input logic clk,rst,
input logic RegWriteM,
input logic [1:0]ResultSrcM,
input logic MemWriteM,
input logic [31:0]ALUResultM,
input logic [31:0]WriteDataM,
input logic [4:0]RdM,
input logic [31:0] PcPlus4M,

output logic RegWriteW,
output logic [1:0] ResultSrcW,
output logic [31:0] ALUResultW,
output logic [31:0] ReadDataW,
output logic [4:0] RdW,
output logic [31:0] PcPlus4W
);

logic [31:0] RDResult;

// memory
data_memory dm(
   .clk(clk),
   .A(ALUResultM),
   .WD(WriteDataM),
   .WE(MemWriteM),
   .RD(RDResult)
);

// pipeline registers
always_ff @(posedge clk or negedge rst )//or negedge rst)
begin
  if (!rst) begin
    ResultSrcW <= 0;
    ALUResultW <= 0;
    ReadDataW  <= 0;
    RdW        <= 0;
    PcPlus4W   <= 0;
    RegWriteW  <= 0;
  end
  else begin
    ResultSrcW <= ResultSrcM;
    ALUResultW <= ALUResultM;
    ReadDataW  <= RDResult;
    RdW        <= RdM;
    PcPlus4W   <= PcPlus4M;
    RegWriteW  <= RegWriteM;
  end
end

endmodule

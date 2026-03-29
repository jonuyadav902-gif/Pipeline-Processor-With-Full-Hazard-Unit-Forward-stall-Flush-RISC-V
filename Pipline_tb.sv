`timescale 1ns / 1ps

module pipline_tb;
logic clk,rst;
  pipline_top_module dut (
    .clk(clk),
    .rst(rst)
 );

 // Clock generation
 always begin 
    #5 clk = ~clk;
 end

 // Initialization
 initial begin
    clk = 0;
//    rst = 1;
    rst = 0;
    #10 rst = 1;
     #5000 $finish;
 end
endmodule  


  

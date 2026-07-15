`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2026 15:07:10
// Design Name: 
// Module Name: test_baud_rate_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_baud_rate_generator();

logic clk;
logic rst;
wire tick;

initial begin
    clk = 1'b0;
    forever #5 clk = !clk;
end

initial begin
    rst <= 1'b1;
    repeat(2) @(posedge clk);

    rst <= 1'b0;
    repeat(1400) @(posedge clk);

    $finish;
end

baud_rate_generator dut (
    .clk(clk),
    .rst(rst),
    .tick(tick)
);

endmodule

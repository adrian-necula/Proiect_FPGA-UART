`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2026 21:18:36
// Design Name: 
// Module Name: test_uart_rx
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


module test_uart_rx();

logic clk;
logic rst;
logic rx_in;

wire tick;
wire [7:0] rx_data;
wire rx_done;
wire sample_pulse;

initial begin
    clk = 1'b0;
    forever #5 clk = !clk;
end

assign tick = 1'b1;

// A = 8'h41
initial begin
    rst   <= 1'b1;
    rx_in <= 1'b1;

    repeat(2) @(posedge clk);
    rst <= 1'b0;

    repeat(4) @(posedge clk);

    rx_in <= 1'b0;
    repeat(16) @(posedge clk);

    rx_in <= 1'b1;
    repeat(16) @(posedge clk);

    rx_in <= 1'b0;
    repeat(80) @(posedge clk);

    rx_in <= 1'b1;
    repeat(16) @(posedge clk);

    rx_in <= 1'b0;
    repeat(16) @(posedge clk);

    rx_in <= 1'b1;

    wait(rx_done == 1'b1);

    repeat(2) @(posedge clk);
    $finish;
end


uart_rx dut (
    .clk(clk),
    .rst(rst),
    .tick(tick),
    .rx_in(rx_in),
    .rx_data(rx_data),
    .rx_done(rx_done),
    .sample_pulse(sample_pulse)
);

endmodule

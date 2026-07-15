`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2026 22:00:41
// Design Name: 
// Module Name: test_top_uart
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

module test_top_uart();

logic clk;
logic btn_rst;
logic uart_rx;

wire uart_tx;

localparam integer clocks_per_bit = 10416;

initial begin
    clk = 1'b0;
    forever #5 clk = !clk;
end

//A = 8'h41
initial begin
    btn_rst <= 1'b1;
    uart_rx <= 1'b1;

    repeat(5) @(posedge clk);
    btn_rst <= 1'b0;

    wait(dut.clk_locked == 1'b1);
    repeat(10) @(posedge clk);

    uart_rx <= 1'b0;
    repeat(clocks_per_bit) @(posedge clk);

    uart_rx <= 1'b1;
    repeat(clocks_per_bit) @(posedge clk);

    uart_rx <= 1'b0;
    repeat(5 * clocks_per_bit) @(posedge clk);

    uart_rx <= 1'b1;
    repeat(clocks_per_bit) @(posedge clk);

    uart_rx <= 1'b0;
    repeat(clocks_per_bit) @(posedge clk);

    uart_rx <= 1'b1;
    repeat(clocks_per_bit) @(posedge clk);

    wait(dut.rx_data == 8'h41);

    wait(dut.tx_done == 1'b1);

    repeat(2) @(posedge clk);
    $finish;
end

top_uart dut (
    .clk(clk),
    .btn_rst(btn_rst),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx)
);

endmodule

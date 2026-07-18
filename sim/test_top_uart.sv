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

localparam integer CLK_FREQ = 100_000_000;
localparam integer BAUD_RATE = 9_600;
localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

logic clk;
logic btn_rst;
logic uart_rx;

logic [3:0] uart_segment;

wire uart_tx;

initial begin
    clk = 1'b0;
    forever #5 clk = !clk;
end

task send_byte(input logic [7:0] data);
integer i;
begin
    // bit de start
    uart_segment <= 4'd0;
    uart_rx <= 1'b0;
    repeat(CLKS_PER_BIT) @(posedge clk);

    // biti de date LSB -> MSB
    for (i = 0; i < 8; i = i + 1) begin
        uart_segment <= i + 1;
        uart_rx <= data[i];
        repeat(CLKS_PER_BIT) @(posedge clk);
    end

    // bit de stop
    uart_segment <= 4'd9;
    uart_rx <= 1'b1;
    repeat(CLKS_PER_BIT) @(posedge clk);
    
    uart_segment <= 4'd15;
end
endtask

initial begin
    btn_rst <= 1'b1;
    uart_rx <= 1'b1;
    uart_segment <= 4'd15;

    repeat(5) @(posedge clk);
    btn_rst <= 1'b0;

    wait(dut.clk_locked == 1'b1);
    repeat(10) @(posedge clk);

    // A = 8'h41
    send_byte(8'h41);

    wait(dut.tx_done == 1'b1);

    repeat(5) @(posedge clk);
    $finish;
end

top_uart #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) dut (
    .clk(clk),
    .btn_rst(btn_rst),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx)
);

endmodule

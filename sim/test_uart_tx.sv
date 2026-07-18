`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2026 17:02:04
// Design Name: 
// Module Name: test_uart_tx
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

module test_uart_tx();

localparam integer CLK_FREQ = 100_000_000;
localparam integer BAUD_RATE = 9_600;

logic clk;
logic rst;
logic tx_start;
logic [7:0] tx_data;

wire tx_out;
wire tx_busy;
wire tx_done;
wire bit_start;

initial begin
    clk = 1'b0;
    forever #5 clk = !clk;
end

task send_byte(input logic [7:0] data);
begin
    @(negedge clk);
    tx_data <= data;
    tx_start <= 1'b1;

    @(negedge clk);
    tx_start <= 1'b0;

    wait(tx_done == 1'b1);
end 
endtask

initial begin
    rst <= 1'b1;
    tx_start <= 1'b0;
    tx_data <= 8'd0;

    repeat(5) @(posedge clk);
    rst <= 1'b0;

    repeat(5) @(posedge clk);

    // A = 8'h41 = 0100_0001 
    send_byte(8'h41);

    repeat(5) @(posedge clk);
    $finish;
end

uart_tx #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) dut (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx_out(tx_out),
    .tx_busy(tx_busy),
    .tx_done(tx_done),
    .bit_start(bit_start)
);

endmodule

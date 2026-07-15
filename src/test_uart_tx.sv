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

logic clk;
logic rst;
logic tx_start;
logic [7:0] tx_data;

wire tick;
wire tx_out;
wire tx_busy;
wire tx_done;
wire bit_pulse;

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

assign tick = 1'b1;

//A = 8'h41
initial begin
    rst      <= 1'b1;
    tx_start <= 1'b0;
    tx_data  <= 8'd0;

    repeat(2) @(posedge clk);
    rst <= 1'b0;

    repeat(2) @(posedge clk);

    tx_data  <= 8'h41;
    tx_start <= 1'b1;

    @(posedge clk);
    tx_start <= 1'b0;

    wait(tx_done == 1'b1);

    repeat(2) @(posedge clk);
    $finish;
end

uart_tx dut (
    .clk(clk),
    .rst(rst),
    .tick(tick),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx_out(tx_out),
    .tx_busy(tx_busy),
    .tx_done(tx_done),
    .bit_pulse(bit_pulse)
);

endmodule

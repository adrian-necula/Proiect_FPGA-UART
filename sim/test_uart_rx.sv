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

localparam integer CLK_FREQ = 100_000_000;
localparam integer BAUD_RATE = 9_600;
localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

logic clk;
logic rst;
logic rx_in;

logic [3:0] uart_segment;

wire [7:0] rx_data;
wire rx_done;
wire sample_acquisition;

initial begin
    clk = 1'b0;
    forever #5 clk = !clk;
end

task send_byte(input logic [7:0] data);
integer i;
begin
    // bit de start
    uart_segment <= 4'd0;
    rx_in <= 1'b0;
    repeat(CLKS_PER_BIT) @(posedge clk);

    // biti de date
    for (i = 0; i < 8; i = i + 1) begin
        uart_segment <= i + 1;
        rx_in <= data[i];
        repeat(CLKS_PER_BIT) @(posedge clk);
    end

    // bit de stop
    uart_segment <= 4'd9;
    rx_in <= 1'b1;
    repeat(CLKS_PER_BIT) @(posedge clk);
    
    uart_segment <= 4'd15;
end
endtask

initial begin
    rst <= 1'b1;
    rx_in <= 1'b1;
    uart_segment <= 4'd15;

    repeat(5) @(posedge clk);
    rst <= 1'b0;

    repeat(5) @(posedge clk);

    // A = 8'h41 = 8'd56
    send_byte(8'h41);

    repeat(5) @(posedge clk);
    $finish;
end

uart_rx #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) dut (
    .clk(clk),
    .rst(rst),
    .rx_in(rx_in),
    .rx_data(rx_data),
    .rx_done(rx_done),
    .sample_acquisition(sample_acquisition)
);

endmodule

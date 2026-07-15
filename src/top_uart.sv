`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.07.2026 16:17:39
// Design Name: 
// Module Name: top_uart
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

module top_uart(
    input clk,
    input btn_rst,
    input uart_rx,
    output uart_tx
);

wire clk_sys;
wire clk_locked;
wire rst_global;
wire tick_uart;

wire [7:0] rx_data;
wire rx_done;
wire sample_pulse;

wire tx_busy;
wire tx_done;
wire bit_pulse;

clk_wiz_uart c1 (
    .clk_out1(clk_sys),
    .reset(btn_rst),
    .locked(clk_locked),
    .clk_in1(clk)
);

assign rst_global = btn_rst | ~clk_locked;

baud_rate_generator c2 (
    .clk(clk_sys),
    .rst(rst_global),
    .tick(tick_uart)
);

uart_rx c3 (
    .clk(clk_sys),
    .rst(rst_global),
    .tick(tick_uart),
    .rx_in(uart_rx),
    .rx_data(rx_data),
    .rx_done(rx_done),
    .sample_pulse(sample_pulse)
);

uart_tx c4 (
    .clk(clk_sys),
    .rst(rst_global),
    .tick(tick_uart),
    .tx_start(rx_done),
    .tx_data(rx_data),
    .tx_out(uart_tx),
    .tx_busy(tx_busy),
    .tx_done(tx_done),
    .bit_pulse(bit_pulse)
);

endmodule
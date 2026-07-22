`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2026 02:43:05
// Design Name: 
// Module Name: top_uart_logger
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


`timescale 1ns / 1ps

module top_uart_logger
    #(parameter integer CLK_FREQ = 100_000_000,
      parameter integer BAUD_RATE = 9_600
)(
    input clk,
    input rst,
    input uart_rx_in,
    input btn_inc,
    input btn_dec,
    input btn_count_reset,
    output uart_tx_out,
    output [15:0] led
);

wire clk_sys;
wire clk_locked;
wire rst_global;

wire [7:0] rx_data;
wire rx_done;
wire sample_acquisition;

wire [7:0] rx_fifo_din;
wire rx_fifo_wr_en;
wire rx_fifo_full;
wire [7:0] rx_fifo_dout;
wire rx_fifo_rd_en;
wire rx_fifo_empty;

wire [2:0] command;

wire btn_inc_sync;
wire btn_dec_sync;
wire btn_reset_sync;

wire btn_inc_stable;
wire btn_dec_stable;
wire btn_reset_stable;

wire btn_inc_pulse;
wire btn_dec_pulse;
wire btn_reset_pulse;

wire inc;
wire dec;
wire count_reset;

wire [15:0] count;
wire overflow;
wire underflow;

wire [47:0] ascii_hex;

wire message_start;
wire [3:0] message_code;
wire [7:0] unknown_char;
wire message_busy;
wire message_done;

wire [7:0] tx_fifo_din;
wire tx_fifo_wr_en;
wire tx_fifo_full;
wire [7:0] tx_fifo_dout;
wire tx_fifo_rd_en;
wire tx_fifo_empty;

wire [7:0] tx_data;
wire tx_start;
wire tx_busy;
wire tx_done;
wire bit_start;

assign rst_global = rst | !clk_locked;

assign led = count;

assign rx_fifo_din = rx_data;
assign rx_fifo_wr_en = rx_done && !rx_fifo_full;

assign tx_data = tx_fifo_dout;
assign tx_start = !tx_fifo_empty && !tx_busy;
assign tx_fifo_rd_en = tx_start;

clk_wiz_uart c1 (
    .clk_out1(clk_sys),
    .reset(rst),
    .locked(clk_locked),
    .clk_in1(clk)
);

uart_rx #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) c2 (
    .clk(clk_sys),
    .rst(rst_global),
    .rx_in(uart_rx_in),
    .rx_data(rx_data),
    .rx_done(rx_done),
    .sample_acquisition(sample_acquisition)
);

fifo_uart c3 (
    .clk(clk_sys),
    .srst(rst_global),
    .din(rx_fifo_din),
    .wr_en(rx_fifo_wr_en),
    .rd_en(rx_fifo_rd_en),
    .dout(rx_fifo_dout),
    .full(rx_fifo_full),
    .empty(rx_fifo_empty)
);

uart_command_decoder c4 (
    .data_in(rx_fifo_dout),
    .command(command)
);

button_sync c5 (
    .clk(clk_sys),
    .rst(rst_global),
    .btn_in(btn_inc),
    .btn_sync(btn_inc_sync)
);

debouncer c6 (
    .clk(clk_sys),
    .rst(rst_global),
    .btn_in(btn_inc_sync),
    .btn_stable(btn_inc_stable)
);

edge_detector c7 (
    .clk(clk_sys),
    .rst(rst_global),
    .signal_in(btn_inc_stable),
    .pulse_out(btn_inc_pulse)
);

button_sync c8 (
    .clk(clk_sys),
    .rst(rst_global),
    .btn_in(btn_dec),
    .btn_sync(btn_dec_sync)
);

debouncer c9 (
    .clk(clk_sys),
    .rst(rst_global),
    .btn_in(btn_dec_sync),
    .btn_stable(btn_dec_stable)
);

edge_detector c10 (
    .clk(clk_sys),
    .rst(rst_global),
    .signal_in(btn_dec_stable),
    .pulse_out(btn_dec_pulse)
);

button_sync c11 (
    .clk(clk_sys),
    .rst(rst_global),
    .btn_in(btn_count_reset),
    .btn_sync(btn_reset_sync)
);

debouncer c12 (
    .clk(clk_sys),
    .rst(rst_global),
    .btn_in(btn_reset_sync),
    .btn_stable(btn_reset_stable)
);

edge_detector c13 (
    .clk(clk_sys),
    .rst(rst_global),
    .signal_in(btn_reset_stable),
    .pulse_out(btn_reset_pulse)
);

uart_command_control c14 (
    .clk(clk_sys),
    .rst(rst_global),
    .command(command),
    .rx_fifo_data(rx_fifo_dout),
    .rx_fifo_empty(rx_fifo_empty),
    .count(count),
    .btn_inc_pulse(btn_inc_pulse),
    .btn_dec_pulse(btn_dec_pulse),
    .btn_reset_pulse(btn_reset_pulse),
    .message_done(message_done),
    .rx_fifo_rd_en(rx_fifo_rd_en),
    .inc(inc),
    .dec(dec),
    .count_reset(count_reset),
    .message_start(message_start),
    .message_code(message_code),
    .unknown_char(unknown_char)
);

counter16b c15 (
    .clk(clk_sys),
    .rst(rst_global),
    .inc(inc),
    .dec(dec),
    .count_reset(count_reset),
    .count(count),
    .overflow(overflow),
    .underflow(underflow)
);

counter_to_ascii c16 (
    .count(count),
    .ascii_hex(ascii_hex)
);

message_sender c17 (
    .clk(clk_sys),
    .rst(rst_global),
    .start(message_start),
    .message_code(message_code),
    .unknown_char(unknown_char),
    .ascii_hex(ascii_hex),
    .tx_fifo_full(tx_fifo_full),
    .tx_fifo_din(tx_fifo_din),
    .tx_fifo_wr_en(tx_fifo_wr_en),
    .busy(message_busy),
    .done(message_done)
);

fifo_uart c18 (
    .clk(clk_sys),
    .srst(rst_global),
    .din(tx_fifo_din),
    .wr_en(tx_fifo_wr_en),
    .rd_en(tx_fifo_rd_en),
    .dout(tx_fifo_dout),
    .full(tx_fifo_full),
    .empty(tx_fifo_empty)
);

uart_tx #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) c19 (
    .clk(clk_sys),
    .rst(rst_global),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx_out(uart_tx_out),
    .tx_busy(tx_busy),
    .tx_done(tx_done),
    .bit_start(bit_start)
);

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2026 22:46:58
// Design Name: 
// Module Name: test_command_control
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

module test_command_control();

logic clk;
logic rst;
logic [2:0] command;
logic [7:0] rx_fifo_data;
logic rx_fifo_empty;
logic [15:0] count;
logic btn_inc_pulse;
logic btn_dec_pulse;
logic btn_reset_pulse;
logic message_done;

wire rx_fifo_rd_en;
wire inc;
wire dec;
wire count_reset;
wire message_start;
wire [3:0] message_code;
wire [7:0] unknown_char;

initial begin
    clk = 1'b0;
    forever #5 clk = !clk;
end

initial begin
    rst <= 1'b1;
    command <= 3'd0;
    rx_fifo_data <= 8'h00;
    rx_fifo_empty <= 1'b1;
    count <= 16'h0000;
    btn_inc_pulse <= 1'b0;
    btn_dec_pulse <= 1'b0;
    btn_reset_pulse <= 1'b0;
    message_done <= 1'b0;

    repeat (2) @(posedge clk);
    rst <= 1'b0;

    // test 0 mesaj welcome
    wait (message_start == 1'b1);

    @(posedge clk);
    message_done <= 1'b1;

    @(posedge clk);
    message_done <= 1'b0;

    @(posedge clk);

    // test 1 comanda UART I
    count <= 16'h0005;
    command <= 3'd0;
    rx_fifo_data <= 8'h49;
    rx_fifo_empty <= 1'b0;

    wait (rx_fifo_rd_en == 1'b1);
    rx_fifo_empty <= 1'b1;

    wait (message_start == 1'b1);

    @(posedge clk);
    message_done <= 1'b1;

    @(posedge clk);
    message_done <= 1'b0;

    @(posedge clk);

    // test 2 buton dec
    count <= 16'h0005;
    btn_dec_pulse <= 1'b1;

    @(posedge clk);
    btn_dec_pulse <= 1'b0;

    wait (message_start == 1'b1);

    @(posedge clk);
    message_done <= 1'b1;

    @(posedge clk);
    message_done <= 1'b0;

    @(posedge clk);

    // test 3 buton reset
    count <= 16'h000A;
    btn_reset_pulse <= 1'b1;

    @(posedge clk);
    btn_reset_pulse <= 1'b0;

    wait (message_start == 1'b1);

    @(posedge clk);
    message_done <= 1'b1;

    @(posedge clk);
    message_done <= 1'b0;

    @(posedge clk);

    $finish;
end

uart_command_control dut (
    .clk(clk),
    .rst(rst),
    .command(command),
    .rx_fifo_data(rx_fifo_data),
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

endmodule
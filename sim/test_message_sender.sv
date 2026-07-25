`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2026 22:07:09
// Design Name: 
// Module Name: test_message_sender
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

module test_message_sender();

logic clk;
logic rst;
logic start;
logic [3:0] msg_code;
logic [7:0] unknown_char;
logic [47:0] ascii_hex;
logic tx_fifo_full;

wire [7:0] tx_fifo_din;
wire data_valid;
wire tx_fifo_wr_en;
wire busy;
wire done;

initial begin
    clk = 1'b0;
    forever #5 clk = !clk;
end

task send_message(
    input [3:0] code,
    input [7:0] character
);
begin
    wait (busy == 1'b0);

    msg_code <= code;
    unknown_char <= character;

    @(posedge clk);
    start <= 1'b1;

    @(posedge clk);
    start <= 1'b0;

    wait (done == 1'b1);
    @(posedge clk);
end
endtask

initial begin
    rst <= 1'b1;
    start <= 1'b0;
    msg_code <= 4'd0;
    unknown_char <= 8'h00;
    ascii_hex <= 48'h307833413746; // 0x3A7F
    tx_fifo_full <= 1'b0;

    repeat (2) @(posedge clk);
    rst <= 1'b0;

    send_message(4'd11, 8'h00); // welcome
    
    send_message(4'd0, 8'h00); // inc

    ascii_hex <= 48'h307830303031; // 0x0001
    send_message(4'd1, 8'h00); // dec

    ascii_hex <= 48'h307830303030; // 0x0000
    send_message(4'd2, 8'h00); // rst

    ascii_hex <= 48'h307831324142; // 0x12AB
    send_message(4'd3, 8'h00); // status

    send_message(4'd4, 8'h00); // help

    send_message(4'd5, 8'h58); // unknown, char X

    ascii_hex <= 48'h307830303031; // 0x0001
    send_message(4'd8, 8'h00); // btn inc

    @(posedge clk);
    $finish;
end

message_sender dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .msg_code(msg_code),
    .unknown_char(unknown_char),
    .ascii_hex(ascii_hex),
    .tx_fifo_full(tx_fifo_full),
    .tx_fifo_din(tx_fifo_din),
    .data_valid(data_valid),
    .tx_fifo_wr_en(tx_fifo_wr_en),
    .busy(busy),
    .done(done)
);

endmodule
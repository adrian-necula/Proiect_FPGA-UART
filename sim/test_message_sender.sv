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
logic [3:0] message_code;
logic [7:0] unknown_char;
logic [47:0] ascii_hex;
logic tx_fifo_full;

wire [7:0] tx_fifo_din;
wire tx_fifo_wr_en;
wire busy;
wire done;

initial begin
    clk = 1'b0;
    forever #5 clk = !clk;
end

initial begin
    rst <= 1'b1;
    start <= 1'b0;
    message_code <= 4'd0;
    unknown_char <= 8'h00;
    ascii_hex <= 48'h307833413746; // "0x3A7F"
    tx_fifo_full <= 1'b0;

    repeat (2) @(posedge clk);
    rst <= 1'b0;

    @(posedge clk);
    start <= 1'b1;

    @(posedge clk);
    start <= 1'b0;

    wait (done == 1'b1);

    @(posedge clk);
    $finish;
end

message_sender dut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .message_code(message_code),
    .unknown_char(unknown_char),
    .ascii_hex(ascii_hex),
    .tx_fifo_full(tx_fifo_full),
    .tx_fifo_din(tx_fifo_din),
    .tx_fifo_wr_en(tx_fifo_wr_en),
    .busy(busy),
    .done(done)
);

endmodule

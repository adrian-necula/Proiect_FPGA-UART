`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2026 11:45:50
// Design Name: 
// Module Name: test_top_uart_logger
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

module test_top_uart_logger();

localparam integer CLK_FREQ = 100_000_000;
localparam integer BAUD_RATE = 1_000_000;
localparam integer BIT_TIME = 1_000_000_000 / BAUD_RATE;

logic clk;
logic rst;
logic uart_rx_in;
logic btn_inc;
logic btn_dec;
logic btn_count_reset;

wire uart_tx_out;
wire [15:0] led;

integer message_count;

initial begin
    clk = 1'b0;
    forever #5 clk = !clk;
end

always @(posedge clk) begin
    if (rst)
        message_count <= 0;
    else if (dut.message_done)
        message_count <= message_count + 1;
end

task send_uart_byte;
    input [7:0] data;
    integer i;
    begin
        uart_rx_in <= 1'b0;
        #(BIT_TIME);

        for (i = 0; i < 8; i = i + 1) begin
            uart_rx_in <= data[i];
            #(BIT_TIME);
        end

        uart_rx_in <= 1'b1;
        #(BIT_TIME);
    end
endtask

initial begin
    rst <= 1'b1;
    uart_rx_in <= 1'b1;
    btn_inc <= 1'b0;
    btn_dec <= 1'b0;
    btn_count_reset <= 1'b0;

    repeat (5) @(posedge clk);
    rst <= 1'b0;

    wait (dut.clk_locked == 1'b1);

    // msj welcome
    wait (message_count >= 1);

    // dec la val 0000 -> FFFF
    send_uart_byte(8'h44);

    wait (led == 16'hFFFF);
    wait (message_count >= 2);

    // inc la val FFFF -> 0000
    send_uart_byte(8'h49);

    wait (led == 16'h0000);
    wait (message_count >= 3);

    // inc
    send_uart_byte(8'h49);

    wait (led == 16'h0001);
    wait (message_count >= 4);

    // status
    send_uart_byte(8'h53);

    wait (message_count >= 5);

    // help
    send_uart_byte(8'h3F);

    wait (message_count >= 6);

    // com necunoscuta
    send_uart_byte(8'h58);

    wait (message_count >= 7);

    // btn_inc
    btn_inc <= 1'b1;
    repeat (10) @(posedge clk);
    btn_inc <= 1'b0;
    repeat (10) @(posedge clk);

    wait (led == 16'h0002);
    wait (message_count >= 8);

    // btn_dec
    btn_dec <= 1'b1;
    repeat (10) @(posedge clk);
    btn_dec <= 1'b0;
    repeat (10) @(posedge clk);

    wait (led == 16'h0001);
    wait (message_count >= 9);

    // btn_count_rst
    btn_count_reset <= 1'b1;
    repeat (10) @(posedge clk);
    btn_count_reset <= 1'b0;
    repeat (10) @(posedge clk);

    wait (led == 16'h0000);
    wait (message_count >= 10);

    repeat (10) @(posedge clk);

    $finish;
end

top_uart_logger #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE),
    .DEBOUNCE_COUNT(4)
) dut (
    .clk(clk),
    .rst(rst),
    .uart_rx_in(uart_rx_in),
    .btn_inc(btn_inc),
    .btn_dec(btn_dec),
    .btn_count_reset(btn_count_reset),
    .uart_tx_out(uart_tx_out),
    .led(led)
);

endmodule
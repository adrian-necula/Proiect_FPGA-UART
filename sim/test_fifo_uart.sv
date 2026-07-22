`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2026 22:50:03
// Design Name: 
// Module Name: test_fifo_uart
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


module test_fifo_uart();

logic clk;
logic rst;

logic [7:0] din;
logic wr_en;
logic rd_en;

wire [7:0] dout;
wire full;
wire empty;

initial begin
    clk = 1'b0;
    forever #5 clk = !clk;
end

initial begin
    rst <= 1'b1;
    din <= 8'd0;
    wr_en <= 1'b0;
    rd_en <= 1'b0;

    repeat(5) @(posedge clk);
    rst <= 1'b0;

    repeat(3) @(posedge clk);

    // scriere A
    @(negedge clk);
    din <= 8'h41;
    wr_en <= 1'b1;

    @(negedge clk);
    wr_en <= 1'b0;

    // scriere B
    @(negedge clk);
    din <= 8'h42;
    wr_en <= 1'b1;

    @(negedge clk);
    wr_en <= 1'b0;

    // scriere C
    @(negedge clk);
    din <= 8'h43;
    wr_en <= 1'b1;

    @(negedge clk);
    wr_en <= 1'b0;

    repeat(5) @(posedge clk);

    // citire A
    @(negedge clk);
    rd_en <= 1'b1;

    @(negedge clk);
    rd_en <= 1'b0;

    repeat(3) @(posedge clk);

    // citire B
    @(negedge clk);
    rd_en <= 1'b1;

    @(negedge clk);
    rd_en <= 1'b0;

    repeat(3) @(posedge clk);

    // citire C
    @(negedge clk);
    rd_en <= 1'b1;

    @(negedge clk);
    rd_en <= 1'b0;

    repeat(5) @(posedge clk);

    $finish;
end

fifo_uart dut(
            .clk(clk),
            .srst(rst),
            .din(din),
            .wr_en(wr_en),
            .rd_en(rd_en),
            .dout(dout),
            .full(full),
            .empty(empty)
);

endmodule
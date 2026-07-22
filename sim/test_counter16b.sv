`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2026 00:53:15
// Design Name: 
// Module Name: test_counter16b
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

module test_counter16b();

logic clk;
logic rst;
logic inc;
logic dec;
logic count_reset;

wire [15:0] count;
wire overflow;
wire underflow;

initial begin
    clk = 1'b0;
    forever #5 clk = !clk;
end

initial begin
    rst <= 1'b1;
    inc <= 1'b0;
    dec <= 1'b0;
    count_reset <= 1'b0;

    repeat(3) @(posedge clk);

    @(negedge clk);
    rst <= 1'b0;

    // incrementare 0000 -> 0001
    @(negedge clk);
    inc <= 1'b1;

    @(negedge clk);
    inc <= 1'b0;

    // decrementare 0001 -> 0000
    @(negedge clk);
    dec <= 1'b1;

    @(negedge clk);
    dec <= 1'b0;

    // underflow 0000 -> FFFF
    @(negedge clk);
    dec <= 1'b1;

    @(negedge clk);
    dec <= 1'b0;

    // overflow FFFF -> 0000
    @(negedge clk);
    inc <= 1'b1;

    @(negedge clk);
    inc <= 1'b0;

    // doua incrementari
    repeat(2) begin
        @(negedge clk);
        inc <= 1'b1;

        @(negedge clk);
        inc <= 1'b0;
    end

    // rst contor
    @(negedge clk);
    count_reset <= 1'b1;

    @(negedge clk);
    count_reset <= 1'b0;

    // inc si dec simultan
    @(negedge clk);
    inc <= 1'b1;
    dec <= 1'b1;

    @(negedge clk);
    inc <= 1'b0;
    dec <= 1'b0;

    repeat(3) @(posedge clk);
    $finish;
end

counter16b dut(
            .clk(clk),
            .rst(rst),
            .inc(inc),
            .dec(dec),
            .count_reset(count_reset),
            .count(count),
            .overflow(overflow),
            .underflow(underflow)
);

endmodule

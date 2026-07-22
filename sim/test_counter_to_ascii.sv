`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2026 15:49:56
// Design Name: 
// Module Name: test_counter_to_ascii
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


module test_counter_to_ascii();

logic [15:0] count;
wire  [47:0] ascii_hex;

initial begin
    // 0000_0000_0000_0000 = 0000 -> "0x0000"
    count <= 16'b0000_0000_0000_0000;
    #10;

    // 0000_0000_0000_1001 = 0009 -> 0x0009
    count <= 16'b0000_0000_0000_1001;
    #10;

    // 0000_0000_0000_1010 = 000A -> 0x000A
    count <= 16'b0000_0000_0000_1010;
    #10;

    // 0001_0010_1010_1011 = 12AB -> 0x12AB
    count <= 16'b0001_0010_1010_1011;
    #10;

    // 0011_1010_0111_1111 = 3A7F -> 0x3A7F
    count <= 16'b0011_1010_0111_1111;
    #10;

    // 1111_1111_1111_1111 = FFFF -> 0xFFFF
    count <= 16'b1111_1111_1111_1111;
    #10;

    $finish;
end

counter_to_ascii dut(
    .count(count),
    .ascii_hex(ascii_hex)
);

endmodule

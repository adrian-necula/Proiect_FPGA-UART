`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2026 15:36:41
// Design Name: 
// Module Name: counter_to_ascii
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

module counter_to_ascii(
    input [15:0] count,
    output [47:0] ascii_hex
    );

assign ascii_hex[47:40] = 8'h30; // "0"
assign ascii_hex[39:32] = 8'h78; // "x"
    
assign ascii_hex[31:24] = (count[15:12] <= 4'd9) ? (8'h30 + count[15:12]) : (8'h37 + count[15:12]);

assign ascii_hex[23:16] = (count[11:8] <= 4'd9) ? (8'h30 + count[11:8]) : (8'h37 + count[11:8]);

assign ascii_hex[15:8] = (count[7:4] <= 4'd9) ? (8'h30 + count[7:4]) : (8'h37 + count[7:4]);

assign ascii_hex[7:0] = (count[3:0] <= 4'd9) ? (8'h30 + count[3:0]) : (8'h37 + count[3:0]);

endmodule
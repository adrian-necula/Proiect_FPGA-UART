`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2026 00:28:35
// Design Name: 
// Module Name: counter16b
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


module counter16b(
    input clk,
    input rst,
    input inc,
    input dec,
    input count_reset,
    output logic [15:0] count,
    output logic overflow,
    output logic underflow
    );
    
always @(posedge clk) begin
    if (rst) begin
        count <= '0;
        overflow <= 1'b0;
        underflow <= 1'b0;
    end
    else begin
        overflow <= 1'b0;
        underflow <= 1'b0;

        if (count_reset) begin
            count <= '0;
        end
        else if (inc && !dec) begin
            if (count == 16'hFFFF) begin
                count <= 16'h0000;
                overflow <= 1'b1;
            end
            else begin
                count <= count + 1'b1;
            end
        end
        else if (dec && !inc) begin
            if (count == 16'h0000) begin
                count <= 16'hFFFF;
                underflow <= 1'b1;
            end
            else begin
                count <= count - 1'b1;
            end
        end
    end
end

endmodule
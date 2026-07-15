`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.07.2026 23:00:32
// Design Name: 
// Module Name: baud_rate_generator
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


module baud_rate_generator(
    input clk,
    input rst,
    output logic tick
);

logic [9:0] counter;

always @(posedge clk) begin
    if (rst) begin
        counter <= 10'd0;
        tick <= 1'b0;
    end
    else begin
        if (counter == 10'd650) begin
            counter <= 10'd0;
            tick <= 1'b1;
        end
        else begin
            counter <= counter + 10'd1;
            tick <= 1'b0;
        end
    end
end

endmodule

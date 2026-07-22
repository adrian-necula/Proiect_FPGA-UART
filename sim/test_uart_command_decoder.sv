`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2026 23:56:33
// Design Name: 
// Module Name: test_uart_command_decoder
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

module test_uart_command_decoder();

logic [7:0] data_in;
wire [2:0] command;

localparam logic [2:0] CMD_INC = 3'd0;
localparam logic [2:0] CMD_DEC = 3'd1;
localparam logic [2:0] CMD_RESET = 3'd2;
localparam logic [2:0] CMD_STATUS = 3'd3;
localparam logic [2:0] CMD_HELP = 3'd4;
localparam logic [2:0] CMD_UNKNOWN = 3'd5;

initial begin
    data_in = "I";
    #10;

    data_in = "d";
    #10;

    data_in = "R";
    #10;

    data_in = "s";
    #10;

    data_in = "?";
    #10;

    data_in = "X";
    #10;

    $finish;
end

uart_command_decoder dut(
    .data_in(data_in),
    .command(command)
);

endmodule
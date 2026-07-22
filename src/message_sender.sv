`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2026 21:53:52
// Design Name: 
// Module Name: message_sender
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


module message_sender (
    input clk,
    input rst,
    input start,
    input [3:0] message_code,
    input [7:0] unknown_char,
    input [47:0] ascii_hex,
    input tx_fifo_full,
    output wire [7:0] tx_fifo_din,
    output wire tx_fifo_wr_en,
    output logic busy,
    output logic done
);

localparam logic [3:0]
    MSG_INC = 4'd0,
    MSG_DEC = 4'd1,
    MSG_RESET = 4'd2,
    MSG_STATUS = 4'd3,
    MSG_HELP = 4'd4,
    MSG_UNKNOWN = 4'd5,
    MSG_OVERFLOW = 4'd6,
    MSG_UNDERFLOW = 4'd7,
    MSG_BTN_INC = 4'd8,
    MSG_BTN_DEC = 4'd9,
    MSG_BTN_RESET = 4'd10,
    MSG_WELCOME = 4'd11;

logic [655:0] message_buffer;
logic [7:0] bytes_left;

assign tx_fifo_din = message_buffer[655:648];
assign tx_fifo_wr_en = busy && !tx_fifo_full;

always @(posedge clk) begin
    if (rst) begin
        message_buffer <= 656'd0;
        bytes_left <= 8'd0;
        busy <= 1'b0;
        done <= 1'b0;
    end
    else begin
        done <= 1'b0;

        if (!busy) begin
            if (start) begin
                case (message_code)

                    MSG_INC: begin
                        message_buffer <= {
                            "[CMD] INC | Counter: ",
                            ascii_hex,
                            8'h0D,
                            8'h0A,
                            {53{8'h00}}
                        };
                        bytes_left <= 8'd29;
                        busy <= 1'b1;
                    end

                    MSG_DEC: begin
                        message_buffer <= {
                            "[CMD] DEC | Counter: ",
                            ascii_hex,
                            8'h0D,
                            8'h0A,
                            {53{8'h00}}
                        };
                        bytes_left <= 8'd29;
                        busy <= 1'b1;
                    end

                    MSG_RESET: begin
                        message_buffer <= {
                            "[CMD] RESET | Counter: ",
                            ascii_hex,
                            8'h0D,
                            8'h0A,
                            {51{8'h00}}
                        };
                        bytes_left <= 8'd31;
                        busy <= 1'b1;
                    end

                    MSG_STATUS: begin
                        message_buffer <= {
                            "[STATUS] Counter: ",
                            ascii_hex,
                            8'h0D,
                            8'h0A,
                            {56{8'h00}}
                        };
                        bytes_left <= 8'd26;
                        busy <= 1'b1;
                    end

                    MSG_HELP: begin
                        message_buffer <= {
                            "Commands:",
                            8'h0D,
                            8'h0A,
                            "I/i - Increment",
                            8'h0D,
                            8'h0A,
                            "D/d - Decrement",
                            8'h0D,
                            8'h0A,
                            "R/r - Reset",
                            8'h0D,
                            8'h0A,
                            "S/s - Status",
                            8'h0D,
                            8'h0A,
                            "? - Help",
                            8'h0D,
                            8'h0A
                        };
                        bytes_left <= 8'd82;
                        busy <= 1'b1;
                    end

                    MSG_UNKNOWN: begin
                        message_buffer <= {
                            "[ERR] Unknown: '",
                            unknown_char,
                            8'h27,
                            8'h0D,
                            8'h0A,
                            {62{8'h00}}
                        };
                        bytes_left <= 8'd20;
                        busy <= 1'b1;
                    end

                    MSG_OVERFLOW: begin
                        message_buffer <= {
                            "[WARN] Overflow | Counter: ",
                            ascii_hex,
                            8'h0D,
                            8'h0A,
                            {47{8'h00}}
                        };
                        bytes_left <= 8'd35;
                        busy <= 1'b1;
                    end

                    MSG_UNDERFLOW: begin
                        message_buffer <= {
                            "[WARN] Underflow | Counter: ",
                            ascii_hex,
                            8'h0D,
                            8'h0A,
                            {46{8'h00}}
                        };
                        bytes_left <= 8'd36;
                        busy <= 1'b1;
                    end

                    MSG_BTN_INC: begin
                        message_buffer <= {
                            "[BTN] INC | Counter: ",
                            ascii_hex,
                            8'h0D,
                            8'h0A,
                            {53{8'h00}}
                        };
                        bytes_left <= 8'd29;
                        busy <= 1'b1;
                    end

                    MSG_BTN_DEC: begin
                        message_buffer <= {
                            "[BTN] DEC | Counter: ",
                            ascii_hex,
                            8'h0D,
                            8'h0A,
                            {53{8'h00}}
                        };
                        bytes_left <= 8'd29;
                        busy <= 1'b1;
                    end

                    MSG_BTN_RESET: begin
                        message_buffer <= {
                            "[BTN] RESET | Counter: ",
                            ascii_hex,
                            8'h0D,
                            8'h0A,
                            {51{8'h00}}
                        };
                        bytes_left <= 8'd31;
                        busy <= 1'b1;
                    end

                    MSG_WELCOME: begin
                        message_buffer <= {
                            "UART Counter Logger",
                            8'h0D,
                            8'h0A,
                            "Press ? for help",
                            8'h0D,
                            8'h0A,
                            {43{8'h00}}
                        };
                        bytes_left <= 8'd39;
                        busy <= 1'b1;
                    end

                    default: begin
                        message_buffer <= {
                            "[ERR] Invalid message",
                            8'h0D,
                            8'h0A,
                            {59{8'h00}}
                        };
                        bytes_left <= 8'd23;
                        busy <= 1'b1;
                    end

                endcase
            end
        end
        else if (!tx_fifo_full) begin
            message_buffer <= {message_buffer[647:0], 8'h00};

            if (bytes_left == 8'd1) begin
                bytes_left <= 8'd0;
                busy <= 1'b0;
                done <= 1'b1;
            end
            else begin
                bytes_left <= bytes_left - 1'b1;
            end
        end
    end
end

endmodule

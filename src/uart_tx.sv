`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2026 16:14:06
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
    input clk,
    input rst,
    input tick,
    input tx_start,
    input [7:0] tx_data,

    output logic tx_out,
    output logic tx_busy,
    output logic tx_done,
    output logic bit_pulse
);

typedef enum logic [1:0] {
    TX_IDLE,
    TX_START,
    TX_DATA,
    TX_STOP
} state_t;

state_t state;

logic [3:0] tick_count;
logic [2:0] bit_index;
logic [7:0] data_reg;

always @(posedge clk) begin
    if (rst) begin
        state <= TX_IDLE;
        tick_count <= 4'd0;
        bit_index <= 3'd0;
        data_reg <= 8'd0;
        tx_out <= 1'b1;
        tx_busy <= 1'b0;
        tx_done <= 1'b0;
        bit_pulse <= 1'b0;
    end
    else begin
        tx_done <= 1'b0;
        bit_pulse <= 1'b0;

        case (state)

            TX_IDLE: begin
                tx_out <= 1'b1;
                tx_busy <= 1'b0;

                if (tx_start) begin
                    data_reg <= tx_data;
                    tick_count <= 4'd0;
                    bit_index <= 3'd0;
                    tx_out <= 1'b0;
                    tx_busy <= 1'b1;
                    bit_pulse <= 1'b1;
                    state <= TX_START;
                end
            end

            TX_START: begin
                if (tick) begin
                    if (tick_count == 4'd15) begin
                        tick_count <= 4'd0;
                        tx_out <= data_reg[0];
                        bit_pulse <= 1'b1;
                        state <= TX_DATA;
                    end
                    else begin
                        tick_count <= tick_count + 4'd1;
                    end
                end
            end

            TX_DATA: begin
                if (tick) begin
                    if (tick_count == 4'd15) begin
                        tick_count <= 4'd0;
                        bit_pulse <= 1'b1;

                        if (bit_index == 3'd7) begin
                            tx_out <= 1'b1;
                            state <= TX_STOP;
                        end
                        else begin
                            bit_index <= bit_index + 3'd1;
                            tx_out <= data_reg[bit_index + 3'd1];
                        end
                    end
                    else begin
                        tick_count <= tick_count + 4'd1;
                    end
                end
            end

            TX_STOP: begin
                if (tick) begin
                    if (tick_count == 4'd15) begin
                        tick_count <= 4'd0;
                        tx_busy <= 1'b0;
                        tx_done <= 1'b1;
                        state <= TX_IDLE;
                    end
                    else begin
                        tick_count <= tick_count + 4'd1;
                    end
                end
            end

            default: begin
                state <= TX_IDLE;
                tick_count <= 4'd0;
                bit_index <= 3'd0;
                data_reg <= 8'd0;
                tx_out <= 1'b1;
                tx_busy <= 1'b0;
                tx_done <= 1'b0;
                bit_pulse <= 1'b0;
            end

        endcase
    end
end

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2026 21:13:19
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
    input clk,
    input rst,
    input tick,
    input rx_in,

    output logic [7:0] rx_data,
    output logic rx_done,
    output logic sample_pulse
);

typedef enum logic [1:0] {
    RX_IDLE,
    RX_START,
    RX_DATA,
    RX_STOP
} state_t;

state_t state;

logic rx_meta;
logic rx_sync;

logic [3:0] tick_count;
logic [2:0] bit_index;
logic [7:0] data_reg;

always @(posedge clk) begin
    if (rst) begin
        rx_meta <= 1'b1;
        rx_sync <= 1'b1;
    end
    else begin
        rx_meta <= rx_in;
        rx_sync <= rx_meta;
    end
end

always @(posedge clk) begin
    if (rst) begin
        state        <= RX_IDLE;
        tick_count   <= 4'd0;
        bit_index    <= 3'd0;
        data_reg     <= 8'd0;
        rx_data      <= 8'd0;
        rx_done      <= 1'b0;
        sample_pulse <= 1'b0;
    end
    else begin
        rx_done      <= 1'b0;
        sample_pulse <= 1'b0;

        case (state)

            RX_IDLE: begin
                tick_count <= 4'd0;
                bit_index  <= 3'd0;

                if (rx_sync == 1'b0) begin
                    state <= RX_START;
                end
            end


            RX_START: begin
                if (tick) begin

                    if (tick_count == 4'd7) begin
                        tick_count   <= 4'd0;
                        sample_pulse <= 1'b1;

                        if (rx_sync == 1'b0) begin
                            state <= RX_DATA;
                        end
                        else begin
                            state <= RX_IDLE;
                        end
                    end
                    else begin
                        tick_count <= tick_count + 4'd1;
                    end
                end
            end


            RX_DATA: begin
                if (tick) begin
                    if (tick_count == 4'd15) begin
                        tick_count           <= 4'd0;
                        data_reg[bit_index]  <= rx_sync;
                        sample_pulse         <= 1'b1;

                        if (bit_index == 3'd7) begin
                            bit_index <= 3'd0;
                            state     <= RX_STOP;
                        end
                        else begin
                            bit_index <= bit_index + 3'd1;
                        end
                    end
                    else begin
                        tick_count <= tick_count + 4'd1;
                    end
                end
            end


            RX_STOP: begin
                if (tick) begin
                    if (tick_count == 4'd15) begin
                        tick_count   <= 4'd0;
                        sample_pulse <= 1'b1;

                        if (rx_sync == 1'b1) begin
                            rx_data <= data_reg;
                            rx_done <= 1'b1;
                        end

                        state <= RX_IDLE;
                    end
                    else begin
                        tick_count <= tick_count + 4'd1;
                    end
                end
            end


            default: begin
                state        <= RX_IDLE;
                tick_count   <= 4'd0;
                bit_index    <= 3'd0;
                data_reg     <= 8'd0;
                rx_data      <= 8'd0;
                rx_done      <= 1'b0;
                sample_pulse <= 1'b0;
            end

        endcase
    end
end

endmodule

`timescale 1ns / 1ps

module mealy_fsm(
    input clk,
    input rst,
    input din_bit, // 입력 bit
    output dout_bit // 출력 bit
);
    reg [2:0] state_reg, next_state;

    // parameter로 상태 정의
    parameter start = 3'b000;
    parameter rd0_once = 3'b001;
    parameter rd1_once = 3'b010;
    parameter rd0_twice = 3'b011;
    parameter rd1_twice = 3'b100;

    // Next State Combinational Logic
    always @(state_reg or din_bit) begin // 현재 상태 + 입력
        case (state_reg)
           start : if (din_bit == 0) begin
            next_state = rd0_once;
           end else if(din_bit == 1) begin
            next_state = rd1_once;
           end else begin
            next_state = start;
           end
            rd0_once : if (din_bit == 0) begin
            next_state = rd0_twice;
           end else if(din_bit == 1) begin
            next_state = rd1_once;
           end else begin
            next_state = start;
           end
            rd0_twice : if (din_bit == 0) begin
            next_state = rd0_twice;
           end else if(din_bit == 1) begin
            next_state = rd1_once;
           end else begin
            next_state = start;
           end
            rd1_once : if (din_bit == 0) begin
            next_state = rd0_once;
           end else if(din_bit == 1) begin
            next_state = rd1_twice;
           end else begin
            next_state = start;
           end
            rd1_twice : if (din_bit == 0) begin
            next_state = rd0_once;
           end else if(din_bit == 1) begin
            next_state = rd1_twice;
           end else begin
            next_state = start;
           end
            default: next_state = start;
        endcase
    end

    // State Register
    always @(posedge clk or posedge rst) begin
        if(rst == 1) state_reg <= start;
        else state_reg <= next_state;
    end

    // Output Combinational Logic
    assign dout_bit = (((state_reg == rd0_twice) && (din_bit == 0) || (state_reg == rd1_twice) && (din_bit == 1))) ? 1 : 0;
endmodule

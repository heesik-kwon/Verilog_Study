`timescale 1ns / 1ps

module moore_fsm (
    input clk,
    input reset,
    input [2:0] sw,
    output reg [2:0] led
);

    // 상태 정의.
    parameter IDLE = 3'b000, STATE_1 = 3'b001, STATE_2 = 3'b010, STATE_3 = 3'b011, STATE_4 = 3'b100, STATE_5 = 3'b111; 
    reg [2:0] c_state, n_state;

    // state register
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            c_state <= 3'b000; // reset이 걸려있으면 항상 stop(current state)
        end else begin
            c_state <= n_state;
        end
    end

    // next state Combinational Logic
    always @(*) begin
        n_state = c_state;  // 초기화
        case (c_state)
            IDLE: begin
                // 입력 조건에 따라 next state를 처리한다.
                if (sw == 3'b001) begin
                    n_state = STATE_1;
                end
                if (sw == 3'b111) begin
                    n_state = STATE_3;
                end
            end
            STATE_1: begin
                if (sw == 3'b010) begin
                    n_state = STATE_2;
                end
                if (sw == 3'b100) begin
                    n_state = STATE_4;
                end
            end
            STATE_2: begin
                if (sw == 3'b011) begin
                    n_state = STATE_3;
                end
            end
            STATE_3: begin
                if (sw == 3'b100) begin
                    n_state = STATE_4;
                end
            end
            STATE_4: begin
                if (sw == 3'b101) begin
                    n_state = STATE_5;
                end
            end
            STATE_5: begin
                if (sw == 3'b110) begin
                    n_state = IDLE;
                end
            end
            default: n_state = IDLE;
        endcase
    end

    // Output Combinational Logic
    always @(*) begin
        led = 3'b000;  // 초기화
        case (c_state)
            IDLE: begin
                led = 3'b000;
            end
            STATE_1: begin
                led = 3'b001;
            end
            STATE_2: begin
                led = 3'b010;
            end
            STATE_3: begin
                led = 3'b011;
            end
            STATE_4: begin
                led = 3'b100;
            end
            STATE_5: begin
                led = 3'b111;
            end
        endcase
    end

    // assign led = (c_state == STOP) ? 2'b10 : 2'b01;

endmodule
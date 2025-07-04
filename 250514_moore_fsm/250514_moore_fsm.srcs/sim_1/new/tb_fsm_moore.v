`timescale 1ns / 1ps

module tb_fsm_moore();

    reg clk;
    reg reset;
    reg [2:0] sw;
    wire [2:0] led;

    fsm uut (
        .clk(clk),
        .reset(reset),
        .sw(sw),
        .led(led)
    );

    // 클럭 생성 (10ns 주기)
    always #5 clk = ~clk;

    initial begin
        // 초기값 설정
        clk = 0;
        reset = 1;
        sw = 3'b000;

        // 리셋 해제
        #10 reset = 0;

        // IDLE → STATE_1
        #10 sw = 3'b001;
        #10 sw = 3'b000; // 입력 해제

        // STATE_1 → STATE_2
        #10 sw = 3'b010;
        #10 sw = 3'b000;

        // STATE_2 → STATE_3
        #10 sw = 3'b011;
        #10 sw = 3'b000;

        // STATE_3 → STATE_4
        #10 sw = 3'b100;
        #10 sw = 3'b000;

        // STATE_4 → STATE_5
        #10 sw = 3'b101;
        #10 sw = 3'b000;

        // STATE_5 → IDLE
        #10 sw = 3'b110;
        #10 sw = 3'b000;

        // IDLE → STATE_3 (직행)
        #10 sw = 3'b111;
        #10 sw = 3'b000;

        // 종료
        #50 $finish;
    end

endmodule

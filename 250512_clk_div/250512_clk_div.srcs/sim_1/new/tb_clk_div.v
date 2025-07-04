`timescale 1ns / 1ps

module tb_clk_div;

    reg clk;
    reg reset;
    wire clk_div3;

    // DUT 인스턴스화
    clk_div uut (
        .clk(clk),
        .reset(reset),
        .clk_div3(clk_div3)
    );

    // 10ns 주기의 클럭 생성 (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // 초기값 설정
        reset = 1;
        #12;
        reset = 0;

        // 일정 시간 동안 시뮬레이션
        #200;

        // 시뮬레이션 종료
        $finish;
    end

endmodule
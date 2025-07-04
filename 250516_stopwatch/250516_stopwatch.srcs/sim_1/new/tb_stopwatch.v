`timescale 1ns / 1ps

module tb_stopwatch;

    // 입력 신호
    reg clk;
    reg rst;
    reg btnL_Clear;
    reg btnR_RunStrop;

    // 출력 신호
    wire [3:0] fnd_com;
    wire [7:0] fnd_data;

    // DUT 인스턴스
    stopwatch UUT (
        .clk(clk),
        .rst(rst),
        .btnL_Clear(btnL_Clear),
        .btnR_RunStrop(btnR_RunStrop),
        .fnd_com(fnd_com),
        .fnd_data(fnd_data)
    );

    // 클럭 생성: 100MHz (10ns 주기)
    initial clk = 0;
    always #5 clk = ~clk;

    // 테스트 시나리오
    initial begin
        // 초기 상태
        rst = 1;
        btnL_Clear = 0;
        btnR_RunStrop = 0;
        #50;

        // 리셋 해제
        rst = 0;
        #50;

        // 스톱워치 시작
        btnR_RunStrop = 1; #20; btnR_RunStrop = 0;
        #50;

        // 정지
        btnR_RunStrop = 1; #20; btnR_RunStrop = 0;
        #50;

        // 초기화
        btnL_Clear = 1; #20; btnL_Clear = 0;
        #50;

        // 재시작
        btnR_RunStrop = 1; #20; btnR_RunStrop = 0;
        #50;

        $stop;
    end

endmodule

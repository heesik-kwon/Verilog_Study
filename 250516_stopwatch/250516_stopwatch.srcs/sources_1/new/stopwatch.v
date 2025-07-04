// stopwatch.v

`timescale 1ns / 1ps

module stopwatch (
    input        clk,
    input        rst,
    input        btnL_Clear,
    input        btnR_RunStrop,
    output [3:0] fnd_com,
    output [7:0] fnd_data
);

    // 내부 연결 신호
    wire [6:0] w_msec;
    wire [5:0] w_sec;
    wire       w_clear, w_runstop;

    // 제어 유닛: 버튼 입력 -> 제어 신호 생성
    stopwatch_cu U_Stopwatch_CU (
        .clk(clk),
        .rst(rst),
        .i_clear(btnL_Clear),       // btnL
        .i_runstop(btnR_RunStrop),  // btnR
        .o_clear(w_clear),
        .o_runstop(w_runstop)
    );

    // 데이터 경로: 시간 계산
    stopwatch_dp U_Stopwatch_DP (
        .clk(clk),
        .rst(rst),
        .run_stop(w_runstop),
        .clear(w_clear),
        .msec(w_msec),
        .sec(w_sec)
    );

    // FND 표시
    fnd_controller U_FND_CTRL (
        .clk(clk),
        .reset(rst),
        .msec(w_msec),
        .sec(w_sec),
        .fnd_data(fnd_data),
        .fnd_com(fnd_com)
    );

endmodule

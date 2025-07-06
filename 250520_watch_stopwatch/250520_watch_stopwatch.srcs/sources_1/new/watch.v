`timescale 1ns / 1ps

module watch (
    input  clk,
    input  rst,
    input  btnL,     // 선택 이전
    input  btnR,     // 선택 다음
    input  btnU,     // +1
    input  btnD,     // -1
    output [4:0] o_hour,
    output [5:0] o_min,
    output [5:0] o_sec,
    output [6:0] o_msec
);

    // 내부 연결 신호
    wire w_hour_sel, w_min_sel, w_sec_sel;
    wire o_btnL, o_btnR, o_btnU, o_btnD;

    btn_debounce U_DB_L (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btnL),
        .o_btn(o_btnL)
    );
    btn_debounce U_DB_R (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btnR),
        .o_btn(o_btnR)
    );
    btn_debounce U_DB_U (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btnU),
        .o_btn(o_btnU)
    );
    btn_debounce U_DB_D (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btnD),
        .o_btn(o_btnD)
    );

    watch_cu U_WATCH_CU (
        .clk(clk),
        .rst(rst),
        .btnL(o_btnL),
        .btnR(o_btnR),
        .o_hour(w_hour_sel),
        .o_min(w_min_sel),
        .o_sec(w_sec_sel)
    );

    watch_dp U_WATCH_DP (
        .clk(clk),
        .rst(rst),
        .up(o_btnU),
        .down(o_btnD),
        .sel_hour(w_hour_sel),
        .sel_min(w_min_sel),
        .sel_sec(w_sec_sel),
        .msec(o_msec),
        .sec(o_sec),
        .min(o_min),
        .hour(o_hour)
    );

endmodule

`timescale 1ns / 1ps

module stopwatch (
    input clk,
    input rst,
    input btnL,
    input btnR,
    output [4:0] o_hour,
    output [5:0] o_min,
    output [5:0] o_sec,
    output [6:0] o_msec
);

    wire w_clear, w_runstop;
    wire o_clear, o_runstop;

    btn_debounce U_BTN_DB_CLEAR (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btnL),
        .o_btn(o_clear)
    );
    btn_debounce U_BTN_DB_RUNSTOP (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btnR),
        .o_btn(o_runstop)
    );

    stopwatch_cu U_StopWatch_CU (
        .clk(clk),
        .rst(rst),
        .i_clear(o_clear),
        .i_runstop(o_runstop),
        .o_clear(w_clear),
        .o_runstop(w_runstop)
    );

    stopwatch_dp U_StopWatch_DP (
        .clk(clk),
        .rst(rst),
        .run_stop(w_runstop),
        .clear(w_clear),
        .msec(o_msec),
        .sec(o_sec),
        .min(o_min),
        .hour(o_hour)
    );
endmodule

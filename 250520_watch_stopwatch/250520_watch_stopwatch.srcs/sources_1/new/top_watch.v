`timescale 1ns / 1ps

module top_watch (
    input clk,
    input rst,
    input btnL,  
    input btnR,  
    input btnU,  
    input btnD,  
    input  [1:0] sw,       
    output [7:0] fnd_data,
    output [3:0] fnd_com
);

    wire [4:0] w_hour_watch, w_hour_stopwatch;
    wire [5:0] w_min_watch, w_sec_watch;
    wire [5:0] w_min_stopwatch, w_sec_stopwatch;
    wire [6:0] w_msec_watch, w_msec_stopwatch;

    wire [4:0] hour;
    wire [5:0] min, sec;
    wire [6:0] msec;

    // 인스턴스: watch
    watch U_WATCH (
        .clk(clk),
        .rst(rst),
        .btnL(btnL),
        .btnR(btnR),
        .btnU(btnU),
        .btnD(btnD),
        .o_hour(w_hour_watch),
        .o_min(w_min_watch),
        .o_sec(w_sec_watch),
        .o_msec(w_msec_watch)
    );

    // 인스턴스: stopwatch
    stopwatch U_STOPWATCH (
        .clk(clk),
        .rst(rst),
        .btnL(btnL),  // run/stop
        .btnR(btnR),  // clear
        .o_hour(w_hour_stopwatch),
        .o_min(w_min_stopwatch),
        .o_sec(w_sec_stopwatch),
        .o_msec(w_msec_stopwatch)
    );

    // 2:1 MUX로 watch/stopwatch 선택
    assign hour = (sw[1] == 1'b0) ? w_hour_watch : w_hour_stopwatch;
    assign min  = (sw[1] == 1'b0) ? w_min_watch : w_min_stopwatch;
    assign sec  = (sw[1] == 1'b0) ? w_sec_watch : w_sec_stopwatch;
    assign msec = (sw[1] == 1'b0) ? w_msec_watch : w_msec_stopwatch;

    // FND Controller
    fnd_controllr U_FND (
        .clk     (clk),
        .reset   (rst),
        .sw_mode (sw[0]),     // 0: 시:분 or 초:밀리초
        .msec    (msec),
        .sec     (sec),
        .min     (min),
        .hour    (hour),
        .fnd_data(fnd_data),
        .fnd_com (fnd_com)
    );

endmodule

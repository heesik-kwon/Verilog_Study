// stopwatch_dp.v

`timescale 1ns / 1ps

module stopwatch_dp (
    input clk,
    input rst,
    input run_stop,
    input clear,
    output [6:0] msec,
    output [5:0] sec
);

    wire w_tick_100hz, w_sec_tick, w_min_tick;

    time_counter #(
        .BIT_WIDTH (7),
        .TICK_COUNT(100)
    ) U_MSEC (

        .clk(clk),
        .rst(rst | clear),
        .i_tick(w_tick_100hz),
        .o_time(msec),
        .o_tick(w_sec_tick)
    );

    time_counter #(
        .BIT_WIDTH (6),
        .TICK_COUNT(60)
    ) U_SEC (
        .clk(clk),
        .rst(rst | clear),
        .i_tick(w_sec_tick),
        .o_time(sec),
        .o_tick(w_min_tick)
    );

    tick_gen_100hz U_Tick_100hz (
        .clk(clk & run_stop),
        .rst(rst | clear),
        .o_tick_100(w_tick_100hz)
    );

endmodule

module time_counter #(
    parameter BIT_WIDTH = 7,
    TICK_COUNT = 100
) (
    input                   clk,
    input                   rst,
    input                   i_tick,
    output [BIT_WIDTH -1:0] o_time,
    output                  o_tick
);

    reg [$clog2(TICK_COUNT)-1:0] count_reg, count_next;
    reg o_tick_reg, o_tick_next;
    assign o_time = count_reg;
    assign o_tick = o_tick_reg;

    // state register
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            count_reg  <= 0;
            o_tick_reg <= 0;
        end else begin
            count_reg  <= count_next;
            o_tick_reg <= o_tick_next;
        end
    end

    // CL next state
    always @(*) begin
        count_next  = count_reg;
        o_tick_next = 1'b0;
        if (i_tick == 1'b1) begin // i_tick(100hz)가 0.01초마다 HIGH가 될 때 카운트 시작
            if (count_reg == (TICK_COUNT - 1)) begin // 최대 카운트에 도달하면
                count_next  = 0; // count를 0으로 리셋하고
                o_tick_next = 1'b1; // o_tick을 1로 설정(-> 1클럭만 HIGH)
            end else begin // 최대 카운트에 도달한게 아니면
                count_next  = count_reg + 1; // 카운트를 1 증가시키고
                o_tick_next = 1'b0; // o_tick은 0을 유지
            end
        end
    end

endmodule

module tick_gen_100hz (
    input clk,
    input rst,
    output reg o_tick_100
);
    // clk = 100_000_000
    parameter FCOUNT = 1_000_000;
    reg [$clog2(FCOUNT)-1:0] r_counter;

    // state register
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            r_counter  <= 0;
            o_tick_100 <= 0;
        end else begin
            if (r_counter == FCOUNT - 1) begin
                o_tick_100 <= 1'b1;  // 카운트 값이 일치했을때, o-tick을 상승
                r_counter <= 0;
            end else begin
                o_tick_100 <= 1'b0;
                r_counter  <= r_counter + 1;
            end
        end
    end



endmodule


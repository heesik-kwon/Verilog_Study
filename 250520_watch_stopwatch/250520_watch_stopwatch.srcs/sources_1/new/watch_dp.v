module watch_dp (
    input        clk,
    input        rst,
    input        up,        // btnU
    input        down,      // btnD
    input        sel_hour,  // CU에서 hour 선택
    input        sel_min,
    input        sel_sec,
    output [6:0] msec,
    output [5:0] sec,
    output [5:0] min,
    output [4:0] hour
);

    wire w_tick_100hz, w_sec_tick, w_min_tick, w_hour_tick;

    // 선택 신호에 따라 inc/dec 분기
    wire inc_hour = (sel_hour && up);
    wire dec_hour = (sel_hour && down);
    wire inc_min  = (sel_min && up);
    wire dec_min  = (sel_min && down);
    wire inc_sec  = (sel_sec && up);
    wire dec_sec  = (sel_sec && down);

    // tick 생성기 (run_stop이 1일 때만 동작)
    tick_gen_100hz U_Tick_100hz (
        .clk(clk),
        .rst(rst),
        .o_tick_100(w_tick_100hz)
    );

    // msec (자동 흐름만)
    time_counter #(
        .BIT_WIDTH (7),
        .TICK_COUNT(100)
    ) U_MSEC (
        .clk(clk),
        .rst(rst),
        .i_tick(w_tick_100hz),
        .inc(1'b0),
        .dec(1'b0),
        .o_time(msec),
        .o_tick(w_sec_tick)
    );

    // sec (자동 흐름 + 수동 조작)
    time_counter #(
        .BIT_WIDTH (6),
        .TICK_COUNT(60)
    ) U_SEC (
        .clk(clk),
        .rst(rst),
        .i_tick(w_sec_tick),
        .inc(inc_sec),
        .dec(dec_sec),
        .o_time(sec),
        .o_tick(w_min_tick)
    );

    // min
    time_counter #(
        .BIT_WIDTH (6),
        .TICK_COUNT(60)
    ) U_MIN (
        .clk(clk),
        .rst(rst),
        .i_tick(w_min_tick),
        .inc(inc_min),
        .dec(dec_min),
        .o_time(min),
        .o_tick(w_hour_tick)
    );

    // hour
    time_counter #(
        .BIT_WIDTH (5),
        .TICK_COUNT(24)
    ) U_HOUR (
        .clk(clk),
        .rst(rst),
        .i_tick(w_hour_tick),
        .inc(inc_hour),
        .dec(dec_hour),
        .o_time(hour),
        .o_tick()
    );

endmodule

module time_counter #(
    parameter BIT_WIDTH = 7,
    TICK_COUNT = 100
) (
    input                  clk,
    input                  rst,
    input                  i_tick,
    input                  inc,        
    input                  dec,        
    output [BIT_WIDTH-1:0] o_time,
    output                 o_tick
);
    reg [$clog2(TICK_COUNT)-1:0] count_reg, count_next;
    reg o_tick_reg, o_tick_next;

    assign o_time = count_reg;
    assign o_tick = o_tick_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count_reg  <= 0;
            o_tick_reg <= 0;
        end else begin
            count_reg  <= count_next;
            o_tick_reg <= o_tick_next;
        end
    end

    always @(*) begin
        count_next  = count_reg;
        o_tick_next = 1'b0;

        if (inc) begin
            count_next = (count_reg == TICK_COUNT - 1) ? 0 : count_reg + 1;
        end else if (dec) begin
            count_next = (count_reg == 0) ? TICK_COUNT - 1 : count_reg - 1;
        end else if (i_tick == 1'b1) begin
            if (count_reg == (TICK_COUNT - 1)) begin
                count_next  = 0;
                o_tick_next = 1'b1;
            end else begin
                count_next  = count_reg + 1;
                o_tick_next = 1'b0;
            end
        end
    end

endmodule

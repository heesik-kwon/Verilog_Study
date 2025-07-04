// 10000_counter.v

`timescale 1ns / 1ps

module top_10000_counter (
    input        clk,
    input        reset,
    input  [1:0] sw,
    output [7:0] fnd_data,
    output [3:0] fnd_com
);

    wire [13:0] w_count_data;
    wire w_clk_100hz;

    wire w_run_stop_clk;
    wire w_clear;

    assign w_run_stop_clk = clk & sw[0];
    assign w_clear = reset | sw[1];

    clk_div_100hz U_CLK_DIV_100 (
        .clk(w_run_stop_clk),
        .reset(w_clear),
        .o_clk_100hz(w_clk_100hz)
    );

    counter_10000 U_COUNTER_10000 (
        .clk(w_clk_100hz),
        .reset(w_clear),
        .count_data(w_count_data)
    );

    fnd_controller U_FND_CTRL (
        .clk(clk),
        .reset(reset),
        .count_data(w_count_data),
        .fnd_data(fnd_data),
        .fnd_com(fnd_com)
    );

endmodule


module clk_div_100hz #(
    parameter F_COUNT = 1_000_000
) (
    input  clk,
    input  reset,
    output o_clk_100hz
);

    //parameter F_COUNT = 1_000_000;

    reg [$clog2(F_COUNT)-1:0] r_counter;
    reg r_clk;
    assign o_clk_100hz = r_clk;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_clk <= 0;
        end else begin
            if (r_counter == F_COUNT - 1) begin
                r_counter <= 0;
                r_clk <= 1'b1;
            end else if (r_counter >= F_COUNT / 2) begin  //duty ratio 50%
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end else begin
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end
        end
    end

endmodule

module counter_10000 (
    input         clk,
    input         reset,
    output [13:0] count_data
);

    reg [13:0] r_counter;
    assign count_data = r_counter;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
        end else begin
            if (r_counter == 10000 - 1) begin
                r_counter <= 0;
            end else begin
                r_counter <= r_counter + 1;
            end
        end
    end

endmodule
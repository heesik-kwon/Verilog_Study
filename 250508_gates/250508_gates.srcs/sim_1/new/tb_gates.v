`timescale 1ns / 1ps

module tb_gates;

    // 입력은 reg, 출력은 wire로 선언
    reg a, b;
    wire y0, y1, y2, y3, y4, y5;

    // DUT (Device Under Test) 인스턴스
    gates dut (
        .a(a),
        .b(b),
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .y4(y4),
        .y5(y5)
    );


    initial begin
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;
        $finish;
    end

endmodule

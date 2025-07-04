`timescale 1ns / 1ps

module tb_fnd;

    // 입력 신호
    reg clk;
    reg reset;
    reg [13:0] count_data;

    // 출력 신호
    wire [7:0] fnd_data;
    wire [3:0] fnd_com;

    fnd_controller UUT (
        .clk(clk),
        .reset(reset),
        .count_data(count_data),
        .fnd_data(fnd_data),
        .fnd_com(fnd_com)
    );

    // 클럭 생성: 100MHz → 10ns 주기
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // 초기화
        reset = 1;
        count_data = 14'd0;

        #20;
        reset = 0;

        // 0 출력
        #1000;
        count_data = 14'd0;

        // 1234 출력
        #500000;
        count_data = 14'd1234;

        // 9999 출력
        #500000;
        count_data = 14'd9999;

        #500000;
        $finish;
    end

endmodule

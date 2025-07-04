`timescale 1ns / 1ps

module tb_btn_debounce;

    reg  clk;
    reg  rst;
    reg  i_btn;
    wire o_btn;

    // DUT instantiation
    btn_debounce #(
        .F_COUNT(100)  // 테스트용 빠른 분주
    ) uut (
        .clk  (clk),
        .rst  (rst),
        .i_btn(i_btn),
        .o_btn(o_btn)
    );

    // 1MHz 시스템 클럭 생성 (1us 주기)
    initial begin
        clk = 0;
        forever #0.5 clk = ~clk;  // 1MHz → 1us 주기
    end

    initial begin
        rst   = 1;
        i_btn = 0;
        #5;
        rst = 0;

        // 튐 없이 바로 누르고 계속 유지
        #10 i_btn = 1;  // 버튼 눌림 시작
        #1000;  // 충분히 유지 (1000ns = 1us × 1000 = 1000 샘플)

        // 뗌
        i_btn = 0;
        #200;

        $finish;
    end

endmodule
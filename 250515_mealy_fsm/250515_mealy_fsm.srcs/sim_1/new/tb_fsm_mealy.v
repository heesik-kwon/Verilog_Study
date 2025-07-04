`timescale 1ns / 1ps

module mealy_fsm_tb;


    reg clk;
    reg rst;
    reg din_bit; 
    wire dout_bit; 

    // FSM 모듈 인스턴스화
    mealy_fsm dut (
        .clk(clk),
        .rst(rst),
        .din_bit(din_bit),
        .dout_bit(dout_bit)
    );

    // 클럭 생성
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 5ns마다 clk 토글
    end

    initial begin
        // 초기화
        rst = 1; din_bit = 0;
        #10 rst = 0; 
        
        // 테스트 케이스
        #10 din_bit = 0;  
        #10 din_bit = 0;  
        #10 din_bit = 1;  
        #10 din_bit = 1;  
        #10 din_bit = 0;  
        #10 din_bit = 1;  
        #10 din_bit = 1; 
        #5  din_bit = 0;
        #15  din_bit = 1;
        #20;
        
        // 리셋 테스트
        #10 rst = 1; 
        #10 rst = 0;

        #10 din_bit = 0;
        #10 din_bit = 1;
        #10 din_bit = 1;
        #10 din_bit = 0;
        #10 din_bit = 0;
        
        // 시뮬레이션 종료
        #20 $finish;
    end

endmodule

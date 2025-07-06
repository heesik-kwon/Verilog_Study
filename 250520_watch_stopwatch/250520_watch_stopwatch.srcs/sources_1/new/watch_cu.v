`timescale 1ns / 1ps

module watch_cu (
    input  clk,
    input  rst,
    input  btnL,
    input  btnR,
    output o_hour,
    output o_min,
    output o_sec
);

    parameter S_HOUR = 2'b00, S_MIN = 2'b01, S_SEC = 2'b10;

    reg [1:0] c_state, n_state;

    assign o_hour = (c_state == S_HOUR) ? 1 : 0;
    assign o_min  = (c_state == S_MIN) ? 1 : 0;
    assign o_sec  = (c_state == S_SEC) ? 1 : 0;


    // 상태 레지스터
    always @(posedge clk or posedge rst) begin
        if (rst) c_state <= S_HOUR;  // 초기값을 시(hour)로 설정
        else c_state <= n_state;
    end

    // 상태 전이
    always @(*) begin
        n_state = c_state;
        case (c_state)
            S_HOUR: begin
                if (btnR) n_state = S_MIN;
                else if (btnL) n_state = S_SEC;
            end
            S_MIN: begin
                if (btnL) n_state = S_HOUR;
                else if(btnR) n_state = S_SEC;
            end
            S_SEC: begin
                if (btnL) n_state = S_MIN;
                else if(btnR) n_state = S_SEC;
            end
        endcase
    end

endmodule

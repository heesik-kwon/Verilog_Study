`timescale 1ns / 1ps

module tb_adder();

    reg [7:0] a,b;
    wire [7:0] s;
    wire cout;

    Adder dut (
    .a(a),
    .b(b),
    .s(s),
    .cout(cout)
);

integer i, j;

initial begin
#0;
a = 8'b0000_0000; b = 8'h00;

for(i = 0; i <= 255; i = i + 1)begin
    for(j = 0; j <= 255; j = j + 1)begin
    a = i;
    b = j;
    #10;     
    end
end
$finish;
end

endmodule

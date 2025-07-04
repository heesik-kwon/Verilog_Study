`timescale 1ns / 1ps

module adder (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] s,
    output cout
);

wire w_c;

full_adder_4bit U_FA4_H (
    .a(a[7:4]),
    .b(b[7:4]),
    .cin(w_c),
    .s(s[7:4]),
    .cout(cout)
);

full_adder_4bit U_FA4_L (
    .a(a[3:0]),
    .b(b[3:0]),
    .cin(1'b0),
    .s(s[3:0]),
    .cout(w_c)
);
    
endmodule

module full_adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] s,
    output cout
);

wire w_c0, w_c1, w_c2;

full_adder U_FA3(
    .a(a[3]), 
    .b(b[3]), 
    .cin(w_c2),
    .s(s[3]), 
    .cout(cout)
    );

full_adder U_FA2(
    .a(a[2]), 
    .b(b[2]), 
    .cin(w_c1),
    .s(s[2]), 
    .cout(w_c2)
    );

full_adder U_FA1(
    .a(a[1]), 
    .b(b[1]), 
    .cin(w_c0),
    .s(s[1]), 
    .cout(w_c1)
    );

full_adder U_FA0(
    .a(a[0]), 
    .b(b[0]), 
    .cin(1'b0),
    .s(s[0]), 
    .cout(w_c0)
    );
    
endmodule

module full_adder(
    input a, b, cin,
    output s, cout
    );

wire w_s0, w_c0, w_c1;

assign cout = w_c0 | w_C1;

half_adder U_HA1 (
    .a(w_s0), 
    .b(cin),
    .s(s), 
    .c(w_C1)
);

half_adder U_HA0 (
    .a(a), 
    .b(b),
    .s(w_s0), 
    .c(w_c0)
);

endmodule

module half_adder (
    input a, b,
    output s, c
);

assign s = a ^ b;
assign c = a & b;
    
endmodule
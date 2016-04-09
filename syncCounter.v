module syncCounter#(parameter N = 4)(
    output [N - 1:0] count,
    output overflow,
    input clr,
    input enable,
    input clk
);
    wire [N - 1:0] nextCount;
    register#(N) r0(count, nextCount, enable, clr, clk);
    incBy1#(N) u0(nextCount, overflow, count);
endmodule

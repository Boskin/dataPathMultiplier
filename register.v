module register#(parameter N = 1)(
    output reg [N - 1:0] q,
    input [N - 1:0] d,
    input write,
    input clr,
    input clk
);
    always@(posedge clk, posedge clr) begin
        if(clr == 1) begin
            q <= {N{1'b0}};
        end else if(write == 1) begin
            q <= d;
        end
    end
endmodule

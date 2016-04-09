/* N-bit wide register module */
module register#(parameter N = 1)(
    output reg [N - 1:0] q, // Current data latched in register
    input [N - 1:0] d, // Data to be written to the register
    input write, // Flag that enables writing to the register
    input clr, // Asynchronously sets register contents to 0 if high
    input clk // Clock pulse
);
    // Only function on positive edge of clock pulse or if clear is used
    always@(posedge clk, posedge clr) begin
        if(clr == 1) begin
            q <= {N{1'b0}};
        end else if(write == 1) begin
            q <= d;
        end
    end
endmodule

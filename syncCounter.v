/* N-bit synchronous counter */
module syncCounter#(parameter N = 4)(
    output [N - 1:0] count, // Register value of the count
    output overflow, // Set high for a clock cycle if the counter rolls over
    input clr, // Asynchronously clears the counter to 0
    input enable, // Allows the counter to count if high
    input clk // Clock input
);
    /* Wire fed to the input of the register to be latched on
       positive clock edge */
    wire [N - 1:0] nextCount;
    // Register that stores the current count
    register#(N) r0(count, nextCount, enable, clr, clk);
    // Module that adds 1 to the current count
    incBy1#(N) u0(nextCount, overflow, count);
    
    assign overflow = (~&nextCount) & enable; 
endmodule

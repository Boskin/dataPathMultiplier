/* Top-level module, multiplies 2 N-bit numbers, the result is 2N bits wide,
   proper evaluation of the current 2 inputs a and b on evalButton release,
   topology simply adds the appropriate number of times to multiply, not
   necessarily the best solution for multiplication */
module dataPathMultiplier#(parameter N = 4)(
    output [N * 7 / 2 - 1:0] productDisp, // 7 segment display driver
    input [N - 1:0] a, // Input operand
    input [N - 1:0] b, // Input operand
    input evalButton, // Evaluation button
    input clk // Input clock
);
    // Partial product signal latched in register
    wire [N * 2 - 1:0] partialProduct;
    // Partial product signal to write to register
    wire [N * 2 - 1:0] nextPartialProduct;
    
    // Keep count of how many times partialProduct has been added to
    wire [N - 1:0] partialProductCount;
    // Flag that checks if the count is at its limit
    wire countNotEqual;
    
    // Debounced button signal (active high)
    wire evalButtonDebounce;
    
    // Debounce the button signal
    buttonDebounce b0(evalButtonDebounce, evalButton, clk);
    
    // Check if the counter is done yet, if it is, clear countNotEqual signal
    notEqual#(N) u0(countNotEqual, partialProductCount, a);
    
    /* Keep count of how many times b has been adder, if the evaluation button
       has been pressed, clear the counter and prepare for a new evaluation,
       freeze the counter if it has reached the value of a */
    syncCounter#(N)(partialProductCount, /* NC */,  evalButtonDebounce,
        countNotEqual, clk);
    
    /* Store the current partial product in this register and write the next
       sum on positive clock edge and if the operation is not yet finished */
    register#(N * 2) r0(partialProduct, nextPartialProduct, countNotEqual, 
        evalButtonDebounce, clk);
    /* Add the binary number b to the nextPartialProduct to be prepared 
       for storage */
    claBlock#(N * 2) add0(nextPartialProduct, /* NC */, partialProduct, b, 0);
    
    // Display the multi-digit result in hexadecimal
    genvar i;
    generate
        for(i = 0; i < N * 2; i = i + 4) begin: displayHexDigits
            hexDisplayDecoder(productDisp[i * 7 / 4 + 6:i * 7 / 4],
                partialProduct[i + 3:i]);
        end
    endgenerate
endmodule

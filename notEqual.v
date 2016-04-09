/* Oddly specific module that outputs a 1 and 0 otherwise if a != b */
module notEqual#(parameter N = 4)(
    output notEqual,
    input [N - 1:0] a,
    input [N - 1:0] b
);
    // Bitwise XOR of 2 input numbers
    wire [N - 1:0] bitwiseXor;
    
    // If all of the XOR's are 0, then they are equal
    assign notEqual = |bitwiseXor;
    
    genvar i;
    generate
        for(i = 0; i < N; i = i + 1) begin: xorCalculations
            xor(bitwiseXor[i], a[i], b[i]);
        end
    endgenerate
endmodule

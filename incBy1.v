module incBy1#(parameter N = 4)(
    output [N - 1:0] s,
    output cOut,
    input [N - 1:0] a
);
    // Carries
    wire [N:1] c;
    
    // The first digit is always inverted
    not(s[0], a[0]);
    
    // Connect cOut with the last signal in the carry vector
    assign cOut = c[N];
    
    genvar i;
    genvar j;
    generate
        // Compute the rest of the digits
        for(i = 1; i < N; i = i + 1) begin: sumCalculation
            xor(s[i], a[i], c[i]);
        end
        
        // Carry expression derived from carry look-ahead adder
        for(i = 1; i <= N; i = i + 1) begin: carryCalculation
            assign c[i] = (&a[i - 1:0]);
        end
    endgenerate
endmodule

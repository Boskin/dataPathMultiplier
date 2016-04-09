/* N-bit carry look-ahead adder block */
module claBlock#(parameter N = 1)(
    output [N - 1:0] s, // Sum bits
    output cOut, // Output carry
    input [N - 1:0] a, // Operand a
    input [N - 1:0] b, // Operand b
    input cIn // Input carry
);
    // Generate terms
    wire [N - 1:0] g;
    // Propagate terms
    wire [N - 1:0] p;
    // Intermediate carry terms
    wire [N:0] c;
    
    wire [N:0] cProducts [N:1];
     
    /* Assign the input and output carries to their respective vector
       locations */
    assign c[0] = cIn;
    assign cOut = c[N];
    
    // Generate block iterators
    genvar i;
    genvar j;
    
    generate
        // Prepare the generate and propagate terms
        for(i = 0; i < N; i = i + 1) begin: generateAndPropagate
            and(g[i], a[i], b[i]);
            or(p[i], a[i], b[i]);
        end
        
        // Prepare the carry terms
        for(i = 1; i <= N; i = i + 1) begin: carryGenerate
            assign cProducts[i][0] = cIn & (&p[i - 1:0]);
            assign cProducts[i][i] = g[i - 1];
            for(j = 1; j < i; j = j + 1) begin: carryProductTermGenerate
                assign cProducts[i][j] = g[j - 1] & (&p[i - 1:j]);
            end
            
            assign c[i] = |cProducts[i][i:0];
        end
        
        // Sum the bits
        for(i = 0; i < N; i = i + 1) begin: sums
            xor(s[i], a[i], b[i], c[i]);
        end
    endgenerate
endmodule

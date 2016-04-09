module claBlock#(parameter N = 1)(
    output [N - 1:0] s,
    input [N - 1:0] a,
    input [N - 1:0] b,
    input cIn
);
    // Generate terms
    wire [N - 1:0] g;
    // Propagate terms
    wire [N - 1:0] p;
    // Intermediate carry terms
    wire [N:0] c;
    
    wire [N:0] cProducts [N:1];
    
    assign c[0] = cIn;
    assign cOut = c[N];
    
    genvar i;
    genvar j;
    
    generate
        for(i = 0; i < N; i = i + 1) begin: generateAndPropagate
            and(g[i], a[i], b[i]);
            or(p[i], a[i], b[i]);
        end
        
        for(i = 1; i <= N; i = i + 1) begin: carryGenerate
            assign cProducts[i][0] = cIn & (&p[i - 1:0]);
            assign cProducts[i][i] = g[i - 1];
            for(j = 1; j < i; j = j + 1) begin: carryProductTermGenerate
                assign cProducts[i][j] = g[j - 1] & (&p[i - 1:j]);
            end
            
            assign c[i] = |cProducts[i][i:0];
        end
        
        for(i = 0; i < N; i = i + 1) begin: sums
            xor(s[i], a[i], b[i], c[i]);
        end
    endgenerate
endmodule

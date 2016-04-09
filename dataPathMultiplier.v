module dataPathMultiplier#(parameter N = 4)(
    output [N * 7 / 2 - 1:0] productDisp,
    input [N - 1:0] a,
    input [N - 1:0] b,
    input evalButton,
    input clk
);
    wire [N * 2 - 1:0] partialProduct;
    wire [N * 2 - 1:0] nextPartialProduct;
    
    wire [N - 1:0] partialProductCount;
    wire countNotEqual;
    
    wire evalButtonDebounce;
    
    buttonDebounce b0(evalButtonDebounce, evalButton, clk);
    
    notEqual#(N) u0(countNotEqual, partialProductCount, a);
    
    syncCounter#(N)(partialProductCount, /* NC */,  evalButtonDebounce,
        countNotEqual, clk);
    
    register#(N * 2) r0(partialProduct, nextPartialProduct, countNotEqual, 
        evalButtonDebounce, clk);
    claBlock#(N * 2) add0(nextPartialProduct, /* NC */, partialProduct, b, 0);
    
    genvar i;
    generate
        for(i = 0; i < N * 2; i = i + 4) begin: displayHexDigits
            hexDisplayDecoder(productDisp[i * 7 / 4 + 6:i * 7 / 4],
                partialProduct[i + 3:i]);
        end
    endgenerate
endmodule

module buttonDebounce(
    output buttonState,
    input buttonSignal,
    input clk
);
    reg delay0;
    reg delay1;
    reg delay2;
    
    always@(posedge clk) begin
        delay0 <= ~buttonSignal;
        delay1 <= delay0;
        delay2 <= delay1;
    end
    
    assign buttonState = delay0 & delay1 & delay2;
endmodule

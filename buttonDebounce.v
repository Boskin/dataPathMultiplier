/* Module that debounces active low button signal */
module buttonDebounce(
    output buttonState, // Debounced signal
    input buttonSignal, // Raw button signal
    input clk // Clock for synchronization
);
    // Delay registers
    reg delay0;
    reg delay1;
    reg delay2;
    
    /* Use non-blocking assignment to synchronize the registers in 3 clock
       cycles */
    always@(posedge clk) begin
        delay0 <= ~buttonSignal;
        delay1 <= delay0;
        delay2 <= delay1;
    end
    
    // If all three are equal, then the button is assumed to not be bouncing
    assign buttonState = delay0 & delay1 & delay2;
endmodule

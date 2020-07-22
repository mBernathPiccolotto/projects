module audio_clocker(input clk,
                     input reset,
                     output audio_clock);
    
    reg [31:0] audio_clock_counter;
    
    initial audio_clock_counter = 32'd0;

    always @(posedge clk)
        if (reset)
            audio_clock_counter = 32'd0;
        else
            audio_clock_counter = audio_clock_counter + 32'd4123168; // Add 2^32 * 48kHz/50MHz
    
    assign audio_clock = audio_clock_counter[31];

endmodule
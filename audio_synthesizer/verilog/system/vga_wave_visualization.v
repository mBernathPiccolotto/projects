module vga_wave_visualization(input [7:0] x,
                              input [6:0] y,
                              input signed [5:0] wave_amplitude, // -32 to 31, signed
                              output [7:0] wave_requested,
                              output reg [2:0] color);
    
    parameter YELLOW = 3'h6;
    parameter GREEN  = 3'h2;
    parameter BLACK  = 3'h0;
    parameter CYAN = 3'h3;
    parameter MAGENTA = 3'h5;
    
    wire signed [5:0] wave_amplitude_clipped;
    wire [6:0] wave_amplitude_ext;

    assign wave_requested = x;

    assign wave_amplitude_clipped = (wave_amplitude < -30) ? -30 : (wave_amplitude > 29) ? 29 : wave_amplitude;

    assign wave_amplitude_ext = 6'd29 - {wave_amplitude_clipped[5], wave_amplitude_clipped[5:0]};
    
    always @(*)
        if (wave_amplitude_ext == y)
            color = wave_amplitude > 0 ? GREEN : CYAN;
        else
            color = BLACK;
        
endmodule

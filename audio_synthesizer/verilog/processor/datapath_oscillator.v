module datapath_oscillator (input clk,
                            input [4:0] note,
                            input [31:0] note_phase,
                            input [2:0] osc_choice,        // Which wave type to generate (sine, square, triangle, sawtooth, noise)
                            input [31:0] osc_rom_dout,     // Input from oscillator look-up ROM
                            input en_osc_noise,
                            input en_osc_out,
                            input s_osc_noise,
                            input [1:0] s_osc_out,
                            output [31:0] next_note_phase,
                            output [9:0] osc_rom_raddr,    // Read address for oscillator look-up ROM
                            output osc_choice_is_noise,
                            output reg signed [31:0] out); // Output signal after processing
    
    /***************************************************************************
     * Parameter Declarations *
     ***************************************************************************/
    
    // 2^32 / 48kHz (step per note frequency)
    localparam BASE_FREQ_STEP = 32'd89478;

    // Choice constant
    localparam OSC_CHOICE_NOISE = 4;
    
    /***************************************************************************
     * Internal Wire and Register Declarations *
     ***************************************************************************/
    
    reg [31:0] freq;
    wire [31:0] osc_phase_step;
    wire signed [31:0] noise_out;
    
    /***************************************************************************
     * Submodules instantation *
     ***************************************************************************/
    
    datapath_noise datapath_noise(
    .clk(clk),
    .en_noise(en_osc_noise),
    .s_noise(s_osc_noise),
    .out(noise_out)
    );
    
    /***************************************************************************
     * Sequential Logic *
     ***************************************************************************/
    
    // Sound output
    always @(posedge clk)
        if (en_osc_out)
            case (s_osc_out)
                2'd0:    out <= 0;
                2'd1:    out <= osc_rom_dout;
                2'd2:    out <= noise_out;
                default: out <= 0;
            endcase
    
    /***************************************************************************
     * Combinational Logic *
     ***************************************************************************/
    
    // How many phases to add per sample clock
    assign osc_phase_step = BASE_FREQ_STEP * freq;
    
    // Indicate next phase to be written to memory
    assign next_note_phase = note_phase + osc_phase_step;
    
    // Memory access
    assign osc_rom_raddr = {osc_choice[1:0], note_phase[31:24]};
    
    // Simple test to move states
    assign osc_choice_is_noise = osc_choice == OSC_CHOICE_NOISE;
    
    // Note code to frequency
    always @(*)
        case (note)
            5'd0:    freq = 32'd261;
            5'd1:    freq = 32'd277;
            5'd2:    freq = 32'd294;
            5'd3:    freq = 32'd311;
            5'd4:    freq = 32'd330;
            5'd5:    freq = 32'd349;
            5'd6:    freq = 32'd370;
            5'd7:    freq = 32'd392;
            5'd8:    freq = 32'd415;
            5'd9:    freq = 32'd440;
            5'd10:   freq = 32'd466;
            5'd11:   freq = 32'd494;
            5'd12:   freq = 32'd523;
            5'd13:   freq = 32'd554;
            5'd14:   freq = 32'd587;
            5'd15:   freq = 32'd622;
            5'd16:   freq = 32'd659;
            5'd17:   freq = 32'd698;
            5'd18:   freq = 32'd740;
            5'd19:   freq = 32'd784;
            5'd20:   freq = 32'd831;
            5'd21:   freq = 32'd880;
            5'd22:   freq = 32'd932;
            5'd23:   freq = 32'd988;
            default: freq = 0;
        endcase
    
endmodule

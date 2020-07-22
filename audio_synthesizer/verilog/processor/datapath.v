module datapath(input clk,                      // 50 MHz clock
                input sample_clock,             // DAC sample clock
                input [7:0] evt,                // Key input event
                input [31:0] osc_rom_dout,      // Input from oscillator look-up ROM
                input [31:0] ram_dout,          // Input from ram
                input en_previous_sample_clock,
                input en_note,
                input en_note_on,
                input en_note_phase,
                input en_note_duration,
                input en_osc_choice,
                input en_osc_noise,
                input en_osc_out,
                input en_filter_choice,
                input en_filter,
                input en_volume,
                input en_mix,
                input en_mix_out,
                input en_menu_choice,
                input en_out_history_index,
                input en_wait_history_index,
                input s_menu_choice,
                input s_previous_sample_clock,
                input [1:0] s_note,
                input s_note_on,
                input s_note_phase,
                input s_note_duration,
                input s_osc_choice,
                input s_osc_noise,
                input [1:0] s_osc_out,
                input [2:0] s_ram_raddr,
                input [2:0] s_ram_waddr,
                input [2:0] s_ram_din,
                input s_filter_choice,
                input s_filter,
                input s_clear_evt,
                input s_volume,
                input s_mix,
                input s_mix_out,
                input s_out_history_index,
                input s_wait_history_index,
                output [9:0] osc_rom_raddr,     // Read address for oscillator look-up ROM
                output reg [7:0] ram_raddr,     // Read address
                output reg [7:0] ram_waddr,     // Write address for synthesizer parameters RAM
                output reg [31:0] ram_din,      // Write data to ram
                output clear_evt,               // Indicates that event has been processed
                output signed [31:0] out,   // Output signal after processing
                output posedge_sample_clock,    // True if sample clock changed from 0 to 1 in this clock
                output note_is_last,
                output osc_choice_is_noise,
                output event_key_press,
                output event_key_release,
                output event_increase,
                output event_decrease,
                output event_menu_change,
                output current_menu_volume,
                output current_menu_filter,
                output current_menu_osc,
                output should_write_out_history);
    
    /***************************************************************************
     * Parameter Declarations *
     ***************************************************************************/
    
    // Ram addresses
    localparam VOLUME_RAM_ADDRESS          = 8'd0;
    localparam FILTER_CHOICE_ADDRESS       = 8'd1;
    localparam OSC_CHOICE_ADDRESS          = 8'd2;
    localparam SETTINGS_MENU_ADDRESS       = 8'd3;
    localparam NOTE_ON_START_ADDRESS       = 8'd4;
    localparam NOTE_PHASE_START_ADDRESS    = NOTE_ON_START_ADDRESS + 8'd24;
    localparam OUT_HISTORY_START_ADDRESS   = NOTE_PHASE_START_ADDRESS + 8'd24;
    
    // Event types
    localparam EVT_INVALID     = 3'h0;
    localparam EVT_PRESS_KEY   = 3'h1;
    localparam EVT_RELEASE_KEY = 3'h2;
    localparam EVT_INCREASE    = 3'h3;
    localparam EVT_DECREASE    = 3'h4;
    localparam EVT_CHANGE_MENU = 3'h5;

    // Choice constant
    localparam OSC_CHOICE_NOISE = 4;
    
    /***************************************************************************
     * Internal Wire and Register Declarations *
     ***************************************************************************/
    
    reg previous_sample_clock;
    
    // From 0 to 23
    reg [4:0] note;
    reg note_on;
    reg [31:0] note_phase;
    wire [31:0] next_note_phase;
    
    // From 0 to 4
    reg [2:0] osc_choice;
    // 32 bit signed integers
    wire signed [31:0] osc_out, filter_out;
    
    // 37 bit to account for adding all keys (ceil(log2(24)) = 5)
    wire signed [36:0] osc_out_ext;
    reg signed [36:0] out_mix_sum;
    reg signed [31:0] out_mix;
    
    // From 0 to 3
    reg [1:0] filter_choice;

    reg [1:0] menu_choice;

    reg [2:0] volume;

	reg [2:0] next_volume, next_osc_choice;
    reg [1:0] next_filter_choice;
    wire [1:0] next_menu_choice;
    
    reg [7:0] out_history_index;
    reg [2:0] wait_history_index;

    /***************************************************************************
     * Sequential Logic *
     ***************************************************************************/
    
    // Sample clock posedge detection
    always @(posedge clk)
        if (en_previous_sample_clock)
            if (s_previous_sample_clock)
                previous_sample_clock <= sample_clock;
            else
                previous_sample_clock <= 0;
    
    // Note loading and iteration
    always @(posedge clk)
        if (en_note)
            case (s_note)
                2'd0: note    <= 5'd0;
                2'd1: note    <= evt[4:0];
                2'd2: note    <= note + 5'd1;
                default: note <= 5'd0;
            endcase
    
    // Output mixing
    always @(posedge clk)
        if (en_mix)
            if (s_mix)
                out_mix_sum <= out_mix_sum + (note_on ? osc_out_ext : 37'd0);
            else
                out_mix_sum <= 0;
    
    always @(posedge clk)
        if (en_mix_out)
            if (s_mix_out)
                out_mix <= out_mix_sum / 24;
            else
                out_mix <= 0;
    
    
    // Reading from memory to datapath registers
    always @(posedge clk)
        if (en_filter_choice)
            if (s_filter_choice)
                filter_choice <= ram_dout;
            else
                filter_choice <= 0;
    
    always @(posedge clk)
        if (en_osc_choice)
            if (s_osc_choice)
                osc_choice <= ram_dout;
            else
                osc_choice <= 0;
    
    always @(posedge clk)
        if (en_note_on)
            if (s_note_on)
                note_on <= ram_dout;
            else
                note_on <= 0;
    
    always @(posedge clk)
        if (en_note_phase)
            if (s_note_phase)
                note_phase <= ram_dout;
            else
                note_phase <= 0;
    
    always @(posedge clk)
        if (en_volume)
            if (s_volume)
                volume <= ram_dout;
            else
                volume <= 0;

    always @(posedge clk)
        if (en_menu_choice)
            if (s_menu_choice)
                menu_choice <= ram_dout;
            else
                menu_choice <= 0;
    
    // Output history
    always @(posedge clk)
        if (en_out_history_index)
            if (s_out_history_index)
                out_history_index <= (out_history_index == 8'd159) ? 8'd0 : (out_history_index + 8'd1);
            else
                out_history_index <= 0;
    
    always @(posedge clk)
        if (en_wait_history_index)
            if (s_wait_history_index)
                wait_history_index <= wait_history_index + 1;
            else
                wait_history_index <= 0;

    
    // Oscillator logic
    datapath_oscillator datapath_oscillator(
    .clk(clk),
    .note(note),
    .note_phase(note_phase),
    .osc_choice(osc_choice),
    .osc_rom_dout(osc_rom_dout),
    .en_osc_noise(en_osc_noise),
    .en_osc_out(en_osc_out),
    .s_osc_noise(s_osc_noise),
    .s_osc_out(s_osc_out),
    .next_note_phase(next_note_phase),
    .osc_rom_raddr(osc_rom_raddr),
    .osc_choice_is_noise(osc_choice_is_noise),
    .out(osc_out)
    );
    
    // Filter logic
    datapath_filter datapath_filter(
    .clk(clk),
    .en_filter(en_filter),
    .s_filter(s_filter),
    .in(out_mix),
    .filter_choice(filter_choice),
    .out(filter_out)
    );

    // Volume logic
    assign out = filter_out >>> (3'd4 - volume);
    
    /***************************************************************************
     * Combinational Logic *
     ***************************************************************************/
    
    // Sample clock posedge flag
    assign posedge_sample_clock = !previous_sample_clock && sample_clock;
    
    // Last note
    assign note_is_last = (note == 5'd23);
    
    // Memory access
    always @(*)
        case (s_ram_raddr)
            0: ram_raddr       = VOLUME_RAM_ADDRESS;
            1: ram_raddr       = FILTER_CHOICE_ADDRESS;
            2: ram_raddr       = OSC_CHOICE_ADDRESS;
            3: ram_raddr       = NOTE_ON_START_ADDRESS + {3'd0, note};
            4: ram_raddr       = NOTE_PHASE_START_ADDRESS + {3'd0, note};
            5: ram_raddr       = SETTINGS_MENU_ADDRESS;
            default: ram_raddr = 0;
        endcase
    
    always @(*)
        case (s_ram_waddr)
            0: ram_waddr       = VOLUME_RAM_ADDRESS;
            1: ram_waddr       = FILTER_CHOICE_ADDRESS;
            2: ram_waddr       = OSC_CHOICE_ADDRESS;
            3: ram_waddr       = NOTE_ON_START_ADDRESS + {3'd0, note};
            4: ram_waddr       = NOTE_PHASE_START_ADDRESS + {3'd0, note};
            5: ram_waddr       = SETTINGS_MENU_ADDRESS;
            6: ram_waddr       = OUT_HISTORY_START_ADDRESS + out_history_index;
            default: ram_waddr = 0;
        endcase
    
    always @(*)
        case (s_ram_din)
            0: ram_din       = 0;
            1: ram_din       = 1;
            2: ram_din       = next_volume;
            3: ram_din       = next_filter_choice;
            4: ram_din       = next_osc_choice;
            5: ram_din       = next_note_phase;
            6: ram_din       = next_menu_choice;
            7: ram_din       = out;
            default: ram_din = 0;
        endcase

    // LCD settings menu keys
    always @(*)
        if (event_increase) begin
            next_volume = (volume == 3'd4) ? 3'd0 : volume + 3'd1; 
            next_filter_choice = (filter_choice == 1'd1) ? 1'd0 : filter_choice + 1'd1;
            next_osc_choice = (osc_choice == 3'd4) ? 3'd0 : osc_choice + 3'd1;
        end
        else begin
            next_volume = (volume == 3'd0) ? 3'd4 : volume - 3'd1;
            next_filter_choice = (filter_choice == 1'd0) ? 1'd1 : filter_choice - 1'd1;
            next_osc_choice = (osc_choice == 3'd0) ? 3'd4 : osc_choice - 3'd1;
        end

    assign next_menu_choice = (menu_choice == 2'd2) ? 2'd0 : menu_choice + 2'd1;

    // Flags testing for keypress events
    assign event_key_press   = evt[7:5] == EVT_PRESS_KEY;
    assign event_key_release = evt[7:5] == EVT_RELEASE_KEY;
    assign event_increase    = evt[7:5] == EVT_INCREASE;
    assign event_decrease    = evt[7:5] == EVT_DECREASE;
    assign event_menu_change = evt[7:5] == EVT_CHANGE_MENU;

    // Flags for each menu state
    assign current_menu_volume = menu_choice == 2'h0;
    assign current_menu_filter = menu_choice == 2'h1;
    assign current_menu_osc    = menu_choice == 2'h2;
    
    // Audio mixing
    assign osc_out_ext = {osc_out[31], osc_out[31], osc_out[31], osc_out[31], osc_out[31], osc_out[31:0]};
    
    // Event logic
    assign clear_evt = s_clear_evt;
    
    // Output History
    assign should_write_out_history = (wait_history_index == 8'd0);

endmodule
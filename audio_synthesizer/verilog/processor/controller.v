module controller (input clk,
                   input reset,
                   input posedge_sample_clock,
                   input note_is_last,
                   input osc_choice_is_noise,
                   input event_key_press,
                   input event_key_release,
                   input event_increase,
                   input event_decrease,
                   input event_menu_change,
                   input current_menu_volume,
                   input current_menu_filter,
                   input current_menu_osc,
                   input should_write_out_history,
                   output reg en_previous_sample_clock,
                   output reg en_note,
                   output reg en_note_on,
                   output reg en_note_phase,
                   output reg en_note_duration,
                   output reg en_osc_choice,
                   output reg en_osc_noise,
                   output reg en_osc_out,
                   output reg en_filter_choice,
                   output reg en_filter,
                   output reg en_volume,
                   output reg en_mix,
                   output reg en_mix_out,
                   output reg en_menu_choice,
                   output reg en_out_history_index,
                   output reg en_wait_history_index,
                   output reg s_menu_choice,
                   output reg s_previous_sample_clock,
                   output reg [1:0] s_note,
                   output reg s_note_on,
                   output reg s_note_phase,
                   output reg s_note_duration,
                   output reg s_osc_choice,
                   output reg s_osc_noise,
                   output reg [1:0] s_osc_out,
                   output reg [2:0] s_ram_raddr,
                   output reg [2:0] s_ram_waddr,
                   output reg [2:0] s_ram_din,
                   output reg s_filter_choice,
                   output reg s_filter,
                   output reg s_clear_evt,
                   output reg s_volume,
                   output reg s_mix,
                   output reg s_mix_out,
                   output reg s_out_history_index,
                   output reg s_wait_history_index,
                   output reg en_ram_w);
    
    parameter INIT                              = 6'd0;
    parameter WAIT                              = 6'd1;
    parameter OSC_READ_CHOICE_0                 = 6'd2;
    parameter OSC_READ_CHOICE_1                 = 6'd3;
    parameter OSC_ADVANCE_PHASE                 = 6'd4;
    parameter OSC_LOOKUP                        = 6'd5;
    parameter OSC_NOISE_OUT_0                   = 6'd7;
    parameter OSC_NOISE_OUT_1                   = 6'd8;
    parameter FILTER_READ_CHOICE_0              = 6'd9;
    parameter FILTER_READ_CHOICE_1              = 6'd10;
    parameter FILTER                            = 6'd11;
    parameter EVT_KEY_PRESS_0                   = 6'd12;
    parameter EVT_KEY_PRESS_1                   = 6'd13;
    parameter EVT_KEY_PRESS_2                   = 6'd14;
    parameter EVT_KEY_PRESS_3                   = 6'd15;
    parameter EVT_KEY_RELEASE_0                 = 6'd16;
    parameter EVT_KEY_RELEASE_1                 = 6'd17;
    parameter NOTE_READ_START                   = 6'd18;
    parameter NOTE_READ_0                       = 6'd19;
    parameter NOTE_READ_1                       = 6'd20;
    parameter NOTE_READ_2                       = 6'd21;
    parameter NOTE_READ_3                       = 6'd22;
    parameter NOTE_WRITE_0                      = 6'd23;
    parameter NOTE_WRITE_1                      = 6'd24;
    parameter MIX                               = 6'd25;
    parameter MIX_OUT                           = 6'd26;
    parameter MENU_READ_VOLUME                  = 6'd27;
    parameter MENU_READ_FILTER_CHOICE           = 6'd28;
    parameter MENU_READ_OSC_CHOICE              = 6'd29;
    parameter MENU_READ_CURRENT_MENU            = 6'd30;
    parameter MENU_FINAL_READ                   = 6'd31;
    parameter MENU_UPDATE_CURRENT_MENU          = 6'd32;
    parameter MENU_DETERMINE_CHANGING_PARAMETER = 6'd33;
    parameter MENU_CHANGE_VOLUME                = 6'd34;
    parameter MENU_CHANGE_FILTER_CHOICE         = 6'd35;
    parameter MENU_CHANGE_OSC_CHOICE            = 6'd36;
    parameter MENU_CHANGE_CURRENT_MENU          = 6'd37;
    parameter READ_VOLUME_0                     = 6'd38;
    parameter READ_VOLUME_1                     = 6'd39;
    parameter WRITE_OUT_HISTORY                 = 6'd40;
    parameter WRITE_OUT_INCREMENT_WAIT          = 6'd41;
    parameter WRITE_OUT_INCREMENT_INDEX         = 6'd42;
    
    reg [5:0] state, next_state;
    
    always @(posedge clk)
        if (reset)
            state <= INIT;
        else
            state <= next_state;
    
    always @(*) begin
        en_previous_sample_clock = 0;
        en_note                  = 0;
        en_note_on               = 0;
        en_note_phase            = 0;
        en_note_duration         = 0;
        en_osc_choice            = 0;
        en_osc_noise             = 0;
        en_osc_out               = 0;
        en_menu_choice           = 0;
        en_filter_choice         = 0;
        en_filter                = 0;
        en_volume                = 0;
        en_mix                   = 0;
        en_mix_out               = 0;
        en_out_history_index     = 0;
        en_wait_history_index    = 0;
        
        s_previous_sample_clock = 0;
        s_note                  = 0;
        s_note_on               = 0;
        s_note_phase            = 0;
        s_note_duration         = 0;
        s_osc_choice            = 0;
        s_osc_noise             = 0;
        s_osc_out               = 0;
        s_menu_choice           = 0;
        s_ram_raddr             = 0;
        s_ram_waddr             = 0;
        s_ram_din               = 0;
        s_filter_choice         = 0;
        s_filter                = 0;
        s_clear_evt             = 0;
        s_volume                = 0;
        s_mix                   = 0;
        s_mix_out               = 0;
        s_out_history_index     = 0;
        s_wait_history_index    = 0;
        
        en_ram_w = 0;
        
        case (state)
            INIT: begin
                en_previous_sample_clock = 1;
                en_note                  = 1;
                en_note_on               = 1;
                en_note_phase            = 1;
                en_note_duration         = 1;
                en_osc_choice            = 1;
                en_osc_noise             = 1;
                en_osc_out               = 1;
                en_menu_choice           = 1;
                en_filter_choice         = 1;
                en_filter                = 1;
                en_volume                = 1;
                en_mix                   = 1;
                en_mix_out               = 1;
                en_out_history_index     = 1;
                en_wait_history_index    = 1;
                
                next_state = WAIT;
            end
            WAIT: begin
                en_previous_sample_clock = 1;
                s_previous_sample_clock  = 1;
                
                if (posedge_sample_clock)
                    next_state = OSC_READ_CHOICE_0;
                else if (event_key_press)
                    next_state = EVT_KEY_PRESS_0;
                else if (event_key_release)
                    next_state = EVT_KEY_RELEASE_0;
                else if (event_increase | event_decrease | event_menu_change)
                    next_state = MENU_READ_VOLUME;
                else
                    next_state = WAIT;
            end
            EVT_KEY_PRESS_0: begin
                s_clear_evt = 1; // clear on next clock
                
                en_note = 1; // load note on next clock
                s_note  = 1; // load note from evt
                
                next_state = EVT_KEY_PRESS_1;
            end
            EVT_KEY_PRESS_1: begin
                en_ram_w    = 1; // write to ram on next clock
                s_ram_waddr = 3; // write to note_on array
                s_ram_din   = 1;  // write value 1
                
                next_state = EVT_KEY_PRESS_2;
            end
            EVT_KEY_PRESS_2: begin
                en_ram_w    = 1; // write to ram on next clock
                s_ram_waddr = 4; // write to note_phase array
                s_ram_din   = 0;  // write value 0
                
                next_state = WAIT;
            end
            EVT_KEY_RELEASE_0: begin
                s_clear_evt = 1; // clear on next clock
                
                en_note = 1; // load note on next clock
                s_note  = 1; // load note from evt
                
                next_state = EVT_KEY_RELEASE_1;
            end
            EVT_KEY_RELEASE_1: begin
                en_ram_w    = 1; // write to ram on next clock
                s_ram_waddr = 3; // write to note_on array
                s_ram_din   = 0; // write value 0
                
                next_state = WAIT;
            end
            MENU_READ_VOLUME: begin
                s_ram_raddr = 0;
                next_state  = MENU_READ_FILTER_CHOICE;
            end
            MENU_READ_FILTER_CHOICE: begin
                en_volume   = 1;
                s_volume    = 1;
                s_ram_raddr = 1;
                next_state  = MENU_READ_OSC_CHOICE;
            end
            MENU_READ_OSC_CHOICE: begin
                en_filter_choice = 1;
                s_filter_choice  = 1;
                s_ram_raddr      = 2;
                next_state       = MENU_READ_CURRENT_MENU;
            end
            MENU_READ_CURRENT_MENU: begin
                en_osc_choice = 1;
                s_osc_choice  = 1;
                s_ram_raddr   = 5;
                next_state    = MENU_FINAL_READ;
            end
            MENU_FINAL_READ: begin
                en_menu_choice = 1;
                s_menu_choice  = 1;
                next_state     = MENU_DETERMINE_CHANGING_PARAMETER;
            end
            MENU_DETERMINE_CHANGING_PARAMETER: begin
                if (event_menu_change)
                    next_state = MENU_CHANGE_CURRENT_MENU;
                else if (current_menu_volume)
                    next_state = MENU_CHANGE_VOLUME;
                else if (current_menu_filter)
                    next_state = MENU_CHANGE_FILTER_CHOICE;
                else if (current_menu_osc)
                    next_state = MENU_CHANGE_OSC_CHOICE;
                else
                    next_state = WAIT;
            end
            MENU_CHANGE_VOLUME: begin
                s_clear_evt = 1;
                en_ram_w    = 1;
                s_ram_waddr = 0;
                s_ram_din   = 2;
                next_state  = WAIT;
            end
            MENU_CHANGE_FILTER_CHOICE: begin
                s_clear_evt = 1;
                en_ram_w    = 1;
                s_ram_waddr = 1;
                s_ram_din   = 3;
                next_state  = WAIT;
            end
            MENU_CHANGE_OSC_CHOICE: begin
                s_clear_evt = 1;
                en_ram_w    = 1;
                s_ram_waddr = 2;
                s_ram_din   = 4;
                next_state  = WAIT;
            end
            MENU_CHANGE_CURRENT_MENU: begin
                s_clear_evt = 1;
                en_ram_w    = 1;
                s_ram_waddr = 5;
                s_ram_din   = 6;
                next_state  = WAIT;
            end
            OSC_READ_CHOICE_0: begin
                s_ram_raddr = 2;
                next_state  = OSC_READ_CHOICE_1;
            end
            OSC_READ_CHOICE_1: begin
                en_osc_choice = 1;
                s_osc_choice  = 1;
                next_state    = NOTE_READ_START;
            end
            NOTE_READ_START: begin
                en_note = 1; // reset note on next clock
                s_note  = 0; // reset note iterator
                
                en_mix = 1; // reset audio mix on next clock
                s_mix  = 0; // reset audio mix
                
                next_state = NOTE_READ_0;
            end
            NOTE_READ_0: begin
                s_ram_raddr = 3; // read from note_on array
                
                next_state = NOTE_READ_1;
            end
            NOTE_READ_1: begin
                s_ram_raddr = 4; // read from note_phase array
                
                en_note_on = 1; // read note_on on this clock
                s_note_on  = 1; // read from ram din
                
                next_state = NOTE_READ_2;
            end
            NOTE_READ_2: begin
                en_note_phase = 1; // read note_phase on this clock
                s_note_phase  = 1; // read from ram din
                
                if (osc_choice_is_noise)
                    next_state = OSC_NOISE_OUT_0;
                else
                    next_state = OSC_LOOKUP;
            end
            OSC_LOOKUP: begin
                en_osc_out = 1;
                s_osc_out  = 1;
                
                next_state = MIX;
            end
            OSC_NOISE_OUT_0: begin
                en_osc_noise = 1;
                s_osc_noise  = 1;
                
                next_state = OSC_NOISE_OUT_1;
            end
            OSC_NOISE_OUT_1: begin
                en_osc_out = 1;
                s_osc_out  = 2;
                
                next_state = MIX;
            end
            MIX: begin
                en_mix = 1; // add to mix on next clock
                s_mix  = 1; // add to mix
                
                next_state = NOTE_WRITE_0;
            end
            NOTE_WRITE_0: begin
                en_ram_w    = 1; // write to ram on next clock
                s_ram_waddr = 4; // write to note_phase array
                s_ram_din   = 5; // write next_phase
                
                next_state = NOTE_WRITE_1;
            end
            NOTE_WRITE_1: begin
                en_note = 1; // increment note on next clock
                s_note  = 2; // increment note
                
                if (note_is_last)
                    next_state = MIX_OUT;
                else
                    next_state = NOTE_READ_0;
            end
            MIX_OUT: begin
                en_mix_out = 1;
                s_mix_out  = 1;
                
                next_state = FILTER_READ_CHOICE_0;
            end
            FILTER_READ_CHOICE_0: begin
                s_ram_raddr = 1;
                
                next_state = FILTER_READ_CHOICE_1;
            end
            FILTER_READ_CHOICE_1: begin
                en_filter_choice = 1;
                s_filter_choice  = 1;
                
                next_state = FILTER;
            end
            FILTER: begin
                en_filter = 1;
                s_filter  = 1;
                
                next_state = READ_VOLUME_0;
            end
            READ_VOLUME_0: begin
                s_ram_raddr = 0;

                next_state = READ_VOLUME_1;
            end
            READ_VOLUME_1: begin
                en_volume = 1;
                s_volume = 1;

                if (should_write_out_history)
                    next_state = WRITE_OUT_HISTORY;
                else
                    next_state = WRITE_OUT_INCREMENT_WAIT;
            end
            WRITE_OUT_HISTORY: begin
                en_ram_w = 1;
                s_ram_waddr = 6;
                s_ram_din = 7; // save history

                next_state = WRITE_OUT_INCREMENT_INDEX;
            end
            WRITE_OUT_INCREMENT_INDEX: begin
                en_out_history_index = 1; // increment index
                s_out_history_index = 1;

                next_state = WRITE_OUT_INCREMENT_WAIT;
            end
            WRITE_OUT_INCREMENT_WAIT: begin
                en_wait_history_index = 1;
                s_wait_history_index = 1;
                
                next_state = WAIT;
            end
            default: begin
                next_state = INIT;
            end
        endcase
    end
endmodule

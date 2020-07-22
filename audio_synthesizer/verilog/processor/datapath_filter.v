module datapath_filter (input clk,                     // 50 MHz clock
                        input en_filter,
                        input s_filter,
                        input signed [31:0] in,        // Input signal
                        input filter_choice,           // Whether filter is on or off
                        output reg signed [31:0] out); // Output signal after filtering
    
    /***************************************************************************
     * Parameter Declarations *
     ***************************************************************************/
    
    // Filter choices
    localparam FILTER_CHOICE_ON  = 0;
    localparam FILTER_CHOICE_OFF = 1;

    localparam LOGALPHA = 3;

    /***************************************************************************
     * Internal Wire and Register Declarations *
     ***************************************************************************/
    
    reg signed [32:0] filtered_out;
    
    /***************************************************************************
     * Sequential Logic *
     ***************************************************************************/
    
    always @(posedge clk)
        if (en_filter)
            if (s_filter)
                filtered_out <= (filtered_out + ({in[31], in} - filtered_out) >>> LOGALPHA) >> 1; 
            else
                filtered_out <= 0;
    
    /***************************************************************************
     * Combinational Logic *
     ***************************************************************************/

    always @(*)
        case (filter_choice)
            FILTER_CHOICE_ON:   out = filtered_out >> 1;
            FILTER_CHOICE_OFF:  out = in;
            default:            out = in;
        endcase
    
endmodule
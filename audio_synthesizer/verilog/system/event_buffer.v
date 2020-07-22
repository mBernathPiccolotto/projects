module event_buffer(input clk,
                    input reset,
                    input [7:0] keycode,
                    input key_is_press,
                    input key_en,
                    input increase,
                    input decrease,
                    input change_menu,
                    input clear,
                    output reg [7:0] evt);
        
    /***************************************************************************
     * Parameter Declarations *
     ***************************************************************************/

    // Event types
    localparam EVT_INVALID     = 3'h0;
    localparam EVT_PRESS_KEY   = 3'h1;
    localparam EVT_RELEASE_KEY = 3'h2;
    localparam EVT_INCREASE    = 3'h3;
    localparam EVT_DECREASE    = 3'h4;
    localparam EVT_CHANGE_MENU = 3'h5;
    
    /***************************************************************************
     * Internal Wire and Register Declarations *
     ***************************************************************************/
    
    reg [2:0] type;
    reg [4:0] key;
    reg evt_en;
    
    initial begin
        type   = EVT_INVALID;
        key    = 0;
        evt_en = 0;
        evt    = 0;
    end
    
    /***************************************************************************
     * Sequential Logic *
     ***************************************************************************/
    
    always @(posedge clk)
        if (clear | reset)
            evt <= 0;
        else if (evt_en)
            evt <= {type, key};
    
    /***************************************************************************
     * Combinational Logic *
     ***************************************************************************/
    
    always @(keycode)
        case (keycode)
            8'h15: key   = 5'd0; // Q
            8'h1E: key   = 5'd1; // 2
            8'h1D: key   = 5'd2; // W
            8'h26: key   = 5'd3; // 3
            8'h24: key   = 5'd4; // E
            8'h2D: key   = 5'd5; // R
            8'h2E: key   = 5'd6; // 5
            8'h2C: key   = 5'd7; // T
            8'h36: key   = 5'd8; // 6
            8'h35: key   = 5'd9; // Y
            8'h3D: key   = 5'd10; // 7
            8'h3C: key   = 5'd11; // U
            8'h1A: key   = 5'd12; // Z
            8'h1B: key   = 5'd13; // S
            8'h22: key   = 5'd14; // X
            8'h23: key   = 5'd15; // D
            8'h21: key   = 5'd16; // C
            8'h2A: key   = 5'd17; // V
            8'h34: key   = 5'd18; // G
            8'h32: key   = 5'd19; // B
            8'h33: key   = 5'd20; // H
            8'h31: key   = 5'd21; // N
            8'h3B: key   = 5'd22; // J
            8'h3A: key   = 5'd23; // M
            default: key = 5'd31; // invalid
        endcase
    
    always @(*)
        if (key_en & key_is_press) begin
            evt_en = 1;
            type   = EVT_PRESS_KEY;
        end
        else if (key_en && ~key_is_press) begin
            evt_en = 1;
            type   = EVT_RELEASE_KEY;
        end
        else if (increase) begin
            evt_en = 1;
            type   = EVT_INCREASE;
        end
        else if (decrease) begin
            evt_en = 1;
            type   = EVT_DECREASE;
        end
        else if (change_menu) begin
            evt_en = 1;
            type   = EVT_CHANGE_MENU;
        end
        else begin
            evt_en = 0;
            type   = EVT_INVALID;
        end
    
endmodule

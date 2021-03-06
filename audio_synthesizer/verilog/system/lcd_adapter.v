module lcd_adapter(input clk,
                   input reset,
                   input [4:0] addr,
                   input [31:0] ram_dout0,
                   input [31:0] ram_dout1,
                   input [7:0] text_rom_dout,
                   output [7:0] ram_raddr0,
                   output reg [7:0] ram_raddr1,
                   output [7:0] text_rom_raddr,
                   output reg [7:0] ascii);
    
    // Parameters
    localparam VOLUME_RAM_ADDRESS          = 8'd0;
    localparam FILTER_CHOICE_ADDRESS       = 8'd1;
    localparam OSC_CHOICE_ADDRESS          = 8'd2;
    localparam SETTINGS_MENU_ADDRESS       = 8'd3;
    localparam NOTE_ON_START_ADDRESS       = 8'd4;
    localparam NOTE_PHASE_START_ADDRESS    = NOTE_ON_START_ADDRESS + 8'd24;

    // Registers and wires
    wire row;
    wire [3:0] col;
    wire [1:0] menu;
    wire [7:0] dout1_to_ascii;
    reg [1:0] last_menu;
    reg [23:0] scroller_timer;
    reg last_scroller_msb;
    reg [5:0] index;


    // Sequential logic
    always @(posedge clk)
        last_menu <= menu;

    always @(posedge clk)
        if (reset | (last_menu != menu))
            index <= 0;
        else if ((last_scroller_msb == 1'b0) & (scroller_timer[23] == 1'b1))
            index <= index + 1;
        else
            index <= index;
    
    always @(posedge clk)
        if (reset | (last_menu != menu))
            last_scroller_msb = 0;
        else
            last_scroller_msb <= scroller_timer[23];
    
    always @(posedge clk)
        if (reset | (last_menu != menu))
            scroller_timer <= 0;
        else
            scroller_timer <= scroller_timer + 1;
    

    // Combinational logic
    assign row = addr[4];
    assign col = addr[3:0];
    
    assign ram_raddr0 = SETTINGS_MENU_ADDRESS;
    assign menu       = ram_dout0;
    
    assign text_rom_raddr = {menu, index + {2'b00, col}};
    
    always @(*)
        case (menu)
            2'h0: ram_raddr1 <= VOLUME_RAM_ADDRESS;
            2'h1: ram_raddr1 <= FILTER_CHOICE_ADDRESS;
            2'h2: ram_raddr1 <= OSC_CHOICE_ADDRESS;
            default ram_raddr1 <= 0;
        endcase
    
    always @(*)
        if (row == 1'b0) begin
            ascii <= text_rom_dout;
        end
        else begin
            case (col)
                4'h0: ascii <= "C";
                4'h1: ascii <= "u";
                4'h2: ascii <= "r";
                4'h3: ascii <= "r";
                4'h4: ascii <= "e";
                4'h5: ascii <= "n";
                4'h6: ascii <= "t";
                4'h7: ascii <= " ";
                4'h8: ascii <= "v";
                4'h9: ascii <= "a";
                4'hA: ascii <= "l";
                4'hB: ascii <= "u";
                4'hC: ascii <= "e";
                4'hD: ascii <= ":";
                4'hE: ascii <= " ";
                4'hF: ascii <= dout1_to_ascii;
            endcase
        end

	 assign dout1_to_ascii = "0" + ram_dout1;
    
endmodule

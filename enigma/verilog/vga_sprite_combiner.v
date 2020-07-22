/*
    vga_sprite_combiner: combines the engima machine pixels and the letters pixels
                         based on xvga and yvga, decided which letter to show
                         based on letter and outputs through color tot the VGA.
*/

module vga_sprite_combiner (input VGA_CLK,
                            input [4:0] letter,
                            input [7:0] xvga,
                            input [6:0] yvga,
                            output [2:0] color);
    
    wire [2:0] engima_sprite_color, letters_sprite_color;
    
    wire in_enigma_sprite = (xvga < 120) && (yvga < 120);
    reg  in_enigma_sprite_delayed;
    
    wire in_letters_sprite = (xvga >= 126) && (xvga < 154) && (yvga >= 42) && (yvga < 78);
    reg in_letters_sprite_delayed;
    
    always @(posedge VGA_CLK) begin
        in_enigma_sprite_delayed  <= in_enigma_sprite;
        in_letters_sprite_delayed <= in_letters_sprite;
    end
    
    vga_enigma_rom vga_enigma_rom(
        .clk  (VGA_CLK),
        .x    (xvga),
        .y    (yvga),
        .dout (engima_sprite_color)
    );
    
    vga_letters_rom vga_letters_rom(
        .clk  (VGA_CLK),
        .x    (xvga - 126 + letter * 28), // subtract margin from screen and add to get exact letter * 28 to get one of the letters
        .y    (yvga - 42), // subtract margin from screen
        .dout (letters_sprite_color)
    );
    
    assign color = in_enigma_sprite_delayed ? engima_sprite_color
                 : in_letters_sprite_delayed ? letters_sprite_color
                 : 3'h0;
    
endmodule

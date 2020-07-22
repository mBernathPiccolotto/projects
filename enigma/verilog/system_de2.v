module system_de2 (input CLOCK_50,
                   input [3:0] KEY,
                   input [17:0] SW,
                   output [17:0] LEDR,
                   inout PS2_CLK,
                   inout PS2_DAT,
                   output LCD_ON,
                   output LCD_BLON,
                   output LCD_RW,
                   output LCD_EN,
                   output LCD_RS,
                   inout [7:0] LCD_DATA,
                   input AUD_ADCDAT,
                   inout AUD_BCLK,
                   inout AUD_ADCLRCK,
                   inout AUD_DACLRCK,
                   inout I2C_SDAT,
                   output AUD_XCK,
                   output AUD_DACDAT,
                   output I2C_SCLK,
                   output VGA_CLK,
                   output VGA_HS,
                   output VGA_VS,
                   output VGA_BLANK,
                   output VGA_SYNC,
                   output [9:0] VGA_R,
                   output [9:0] VGA_G,
                   output [9:0] VGA_B);
    
    wire [7:0] ps2_key_data;
    wire ps2_key_en;
    wire [7:0] keycode;
    wire keycode_ready;
    wire ext;
    wire make;
    
    wire [7:0] ascii;
    
	wire debounced0, debounced1, debounced2;
    wire increase0, increase1, increase2;
    
    wire [4:0] befor;
    wire [4:0] after;
    wire [4:0] shift0;
    wire [4:0] shift1;
    wire [4:0] shift2;
    wire [2:0] type0;
    wire [2:0] type1;
    wire [2:0] type2;
    
    wire [4:0] history_raddr;
    wire [7:0] history_dout;
    
    wire [18:0] audio_rom_addr;
    wire [31:0] audio_rom_data;
    wire [31:0] audio_out;
    wire audio_out_allowed;
    
    wire [7:0] disp_data;
    wire [4:0] lcd_raddr;

    wire DLY_RST;
    
    wire [7:0] xvga;
    wire [6:0] yvga;
    wire [2:0] color;
    
    assign LEDR[17:16] = SW[17:16]; // sound on and history viewer
    assign LEDR[15:1]  = 0;         // blank LEDRs
    assign LEDR[0]     = SW[0];     // settings: shift or type
    
    assign LCD_ON   = 1'b1;
    assign LCD_BLON = 1'b1;
    
    PS2_Controller PS2 (
        .CLOCK_50         (CLOCK_50),
        .reset            (~KEY[0]),
        .PS2_CLK          (PS2_CLK),
        .PS2_DAT          (PS2_DAT),
        .received_data    (ps2_key_data),
        .received_data_en (ps2_key_en)
    );
    
    keycode_recognizer keycode_recognizer(
        .clk           (CLOCK_50),
        .reset_n       (KEY[0]),
        .ps2_key_en    (ps2_key_en),
        .ps2_key_data  (ps2_key_data),
        .keycode       (keycode),
        .ext           (ext),
        .make          (make),
        .keycode_ready (keycode_ready)
    );
    
    keycode_to_ascii keycode_to_ascii(
        .keycode (keycode),
        .ascii   (ascii)
    );
    
    debouncer debouncer0(
        .clk (CLOCK_50),
        .in  (~KEY[3]),
        .out (debounced0)
    );
    
    debouncer debouncer1(
        .clk (CLOCK_50),
        .in  (~KEY[2]),
        .out (debounced1)
    );
    
    debouncer debouncer2(
        .clk (CLOCK_50),
        .in  (~KEY[1]),
        .out (debounced2)
    );
    
    signal_shortener signal_shortener0(
        .clk (CLOCK_50),
        .in  (debounced0),
        .out (increase0)
    );
    
    signal_shortener signal_shortener1(
        .clk (CLOCK_50),
        .in  (debounced1),
        .out (increase1)
    );
    
    signal_shortener signal_shortener2(
        .clk (CLOCK_50),
        .in  (debounced2),
        .out (increase2)
    );
    
    system system(
        .clk                    (CLOCK_50),
        .reset                  (~KEY[0]),
        .key_ready              (keycode_ready),
        .make                   (make),
        .ext                    (ext),
        .key_input              (ascii),
        .befor                  (befor),
        .after                  (after),
        .shift0                 (shift0),
        .shift1                 (shift1),
        .shift2                 (shift2),
        .type0                  (type0),
        .type1                  (type1),
        .type2                  (type2),
        .increase_shift_or_type (SW[0]),
        .increase0              (increase0),
        .increase1              (increase1),
        .increase2              (increase2),
        .history_raddr          (history_raddr),
        .history_dout           (history_dout)
    );
    
    machine_to_LCD_rom machine_to_LCD_rom(
        .disp_or_hist(SW[16]),
        
        .befor  (befor),
        .after  (after),
        .shift0 (shift0),
        .shift1 (shift1),
        .shift2 (shift2),
        .type0  (type0),
        .type1  (type1),
        .type2  (type2),
        
        .history_raddr (history_raddr),
        .history_dout  (history_dout),
        
        .raddr (lcd_raddr),
        .dout  (disp_data)
    );
    
    Reset_Delay r0 (
        .iCLK   (CLOCK_50),
        .oRESET (DLY_RST)
    );
    
    LCD_Display u1(
        .iCLK_50MHZ (CLOCK_50),
        .iRST_N     (DLY_RST),
        .oMSG_INDEX (lcd_raddr),
        .iMSG_ASCII (disp_data),
        .DATA_BUS   (LCD_DATA),
        .LCD_RW     (LCD_RW),
        .LCD_E      (LCD_EN),
        .LCD_RS     (LCD_RS)
    );
	 
    assign audio_rom_addr = after; // one wavelength for each letter
    
    wavelengths_rom wavelengths_rom(
       .addr (audio_rom_addr),
       .dout (audio_rom_data)
    );
    
    square_wave_osc square_wave_osc(
       .clk             (CLOCK_50),
       .reset           (~KEY[0]),
       .sound_on        (SW[17]),
       .half_wavelength (audio_rom_data),
       .out             (audio_out)
    );
    
    Audio_Controller Audio_Controller(
		 .clk                     (CLOCK_50),
		 .reset                   (~KEY[0]),
		 .left_channel_audio_out  (audio_out),
		 .right_channel_audio_out (audio_out),
		 .write_audio_out         (audio_out_allowed),
		 .AUD_ADCDAT              (AUD_ADCDAT),
		 .AUD_BCLK                (AUD_BCLK),
		 .AUD_ADCLRCK             (AUD_ADCLRCK),
		 .AUD_DACLRCK             (AUD_DACLRCK),
		 .audio_out_allowed       (audio_out_allowed),
		 .AUD_XCK                 (AUD_XCK),
		 .AUD_DACDAT              (AUD_DACDAT)
    );
    
    avconf avc(
        .I2C_SCLK (I2C_SCLK),
        .I2C_SDAT (I2C_SDAT),
        .CLOCK_50 (CLOCK_50),
        .reset    (~KEY[0])
    );
    
    vga_sprite_combiner vga_sprite_combiner(
        .VGA_CLK (VGA_CLK),
        .letter  (after),
        .xvga    (xvga),
        .yvga    (yvga),
        .color   (color)
    );
    
    vga_xy_controller vga_xy_controller(
        .CLOCK_50  (CLOCK_50),
        .resetn    (KEY[0]),
        .color     (color),
        .x         (xvga),
        .y         (yvga),
        .VGA_R     (VGA_R),
        .VGA_G     (VGA_G),
        .VGA_B     (VGA_B),
        .VGA_HS    (VGA_HS),
        .VGA_VS    (VGA_VS),
        .VGA_BLANK (VGA_BLANK),
        .VGA_SYNC  (VGA_SYNC),
        .VGA_CLK   (VGA_CLK)
    );
    
endmodule

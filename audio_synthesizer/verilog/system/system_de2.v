module system_de2 (input CLOCK_50,
                   input [3:0] KEY,
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
    
    wire [18:0] audio_rom_addr;
    wire signed [31:0] audio_rom_data;
    wire signed [31:0] audio_out;
    wire audio_out_allowed;
    
    wire audio_clock;
    
    wire [7:0] ps2_key_data;
    wire ps2_key_en;
    wire [7:0] keycode;
    wire keycode_ready, ext, make;
    
    wire [7:0] evt;
    wire clear_evt;
    
    wire inc_debounced, dec_debounced, change_debounced;
    wire inc, dec, change;
    
    wire [31:0] key_freq;
    
    wire [7:0] lcd_out;
    wire [4:0] lcd_addr;
    
    wire DLY_RST;
    
    wire [31:0] ram_din;
    wire [31:0] ram_dout0;
    wire [31:0] ram_dout1;
    wire [31:0] ram_dout2;
    wire [31:0] ram_dout3;
    wire ram_wen;
    wire [7:0] ram_waddr;
    wire [7:0] ram_raddr0;
    wire [7:0] ram_raddr1;
    wire [7:0] ram_raddr2;
    wire [7:0] ram_raddr3;

    wire [7:0] text_rom_dout;
    wire [7:0] text_rom_raddr;

    wire [31:0] osc_rom_dout;
    wire [9:0] osc_rom_raddr;

    wire [7:0] xvga;
    wire [6:0] yvga;
    wire [2:0] colorvga;

    //  VGA adapter and controller
    vga_adapter vga_adapter(
        // .clk       (VGA_CLK),
        .x         (xvga),
        .y         (yvga),
        .ram_dout  (ram_dout3),
        .ram_raddr (ram_raddr3),
        .color     (colorvga)
    );
    
    vga_xy_controller vga_xy_controller(
        .CLOCK_50  (CLOCK_50),
        .resetn    (KEY[0]),
        .color     (colorvga),
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

    
    // LCD Adapter and Controller
    lcd_adapter lcd_adapter(
    .clk(CLOCK_50),
    .reset(~KEY[0]),
    .addr(lcd_addr),
    .ram_dout0(ram_dout1),
    .ram_dout1(ram_dout2),
    .text_rom_dout(text_rom_dout),
    .ram_raddr0(ram_raddr1),
    .ram_raddr1(ram_raddr2),
    .text_rom_raddr(text_rom_raddr),
    .ascii(lcd_out)
    );

    assign LCD_ON   = 1'b1;
    assign LCD_BLON = 1'b1;
    
    Reset_Delay r0 (
    .iCLK   (CLOCK_50),
    .oRESET (DLY_RST)
    );
    
    LCD_Display u1(
    .iCLK_50MHZ (CLOCK_50),
    .iRST_N     (DLY_RST),
    .oMSG_INDEX (lcd_addr),
    .iMSG_ASCII (lcd_out),
    .DATA_BUS   (LCD_DATA),
    .LCD_RW     (LCD_RW),
    .LCD_E      (LCD_EN),
    .LCD_RS     (LCD_RS)
    );
    
    // RAM and ROMs
    ram ram(
    .clk(CLOCK_50),
    .raddr0(ram_raddr0),
    .raddr1(ram_raddr1),
    .raddr2(ram_raddr2),
    .raddr3(ram_raddr3),
    .waddr(ram_waddr),
    .we(ram_wen),
    .din(ram_din),
    .dout0(ram_dout0),
    .dout1(ram_dout1),
    .dout2(ram_dout2),
    .dout3(ram_dout3)
    );
    
    text_rom text_rom(
    .clk(CLOCK_50),
    .raddr(text_rom_raddr),
    .dout(text_rom_dout)
    );

    osc_rom osc_rom(
    .clk(CLOCK_50),
    .raddr(osc_rom_raddr),
    .dout(osc_rom_dout)
    );
    
    // Debounce and shorten signal from keys
    debouncer debouncer_inc(
    .clk(CLOCK_50),
    .in(~KEY[3]),
    .out(inc_debounced)
    );
    
    debouncer debouncer_dec(
    .clk(CLOCK_50),
    .in(~KEY[2]),
    .out(dec_debounced)
    );
    
    debouncer debouncer_change(
    .clk(CLOCK_50),
    .in(~KEY[1]),
    .out(change_debounced)
    );
    
    signal_shortener shortener_inc(
    .clk(CLOCK_50),
    .in(inc_debounced),
    .out(inc)
    );
    
    signal_shortener shortener_dec(
    .clk(CLOCK_50),
    .in(dec_debounced),
    .out(dec)
    );
    
    signal_shortener shortener_change(
    .clk(CLOCK_50),
    .in(change_debounced),
    .out(change)
    );
    
    // Divide clock to get 48kHz for audio output
    audio_clocker audio_clocker(
    .clk(CLOCK_50),
    .reset(~KEY[0]),
    .audio_clock(audio_clock)
    );
    
    // Buffer for various key inputs
    event_buffer event_buffer(
    .clk(CLOCK_50),
    .reset(~KEY[0]),
    .keycode(keycode),
    .key_is_press(make),
    .key_en(keycode_ready),
    .increase(inc),
    .decrease(dec),
    .change_menu(change),
    .clear(clear_evt),
    .evt(evt)
    );
    
    // Connect processor and system modules
    processor processor(
    .clk(CLOCK_50),
    .reset(~KEY[0]),
    .sample_clock(audio_clock),
    .evt(evt),
    .ram_dout(ram_dout0),
    .osc_rom_dout(osc_rom_dout),
    .ram_raddr(ram_raddr0),
    .ram_waddr(ram_waddr),
    .ram_din(ram_din),
    .ram_wen(ram_wen),
    .osc_rom_raddr(osc_rom_raddr),
    .clear_evt(clear_evt),
    .out(audio_out)
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
    
endmodule

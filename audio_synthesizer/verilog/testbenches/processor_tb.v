`timescale 10 ns/10 ns

module processor_tb();
    
    reg clk;
    reg reset;
    reg sample_clock;
    
    reg [7:0] keycode;
    reg key_is_press;
    reg key_en;
    
    wire [7:0] evt;
    wire clear_evt;
    wire [31:0] audio_out;
    wire [4:0] state;

    wire [31:0] ram_din;
    wire [31:0] ram_dout0;
    wire ram_wen;
    wire [7:0] ram_waddr;
    wire [7:0] ram_raddr0;

    wire [31:0] osc_rom_dout;
    wire [9:0] osc_rom_raddr;

    ram ram(
    .clk(clk),
    .raddr0(ram_raddr0),
    .waddr(ram_waddr),
    .we(ram_wen),
    .din(ram_din),
    .dout0(ram_dout0)
    );

    osc_rom osc_rom(
    .clk(clk),
    .raddr(osc_rom_raddr),
    .dout(osc_rom_dout)
    );
    
    event_buffer event_buffer(
    .clk(clk),
    .reset(reset),
    .keycode(keycode),
    .key_is_press(key_is_press),
    .key_en(key_en),
    .increase(1'b0),
    .decrease(1'b0),
    .change_menu(1'b0),
    .clear(clear_evt),
    .evt(evt)
    );
    
    processor uut(
    .clk(clk),
    .reset(reset),
    .sample_clock(sample_clock),
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
    
    always #1 clk = ~clk;
    
    always #1000 sample_clock = ~sample_clock;
    
    initial begin
        clk = 0; sample_clock = 0; reset = 1;
        #10 reset = 0; keycode = 8'h15; key_is_press = 1; key_en = 1;
        #30 key_en = 0;
        #1000000;
    end
    
endmodule
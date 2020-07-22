`timescale 10 ns/10 ns

module datapath_oscillator_tb();
    reg clk;
    reg reset;
    wire signed [31:0] out;

    wire [31:0] osc_rom_dout;
    wire [9:0] osc_rom_raddr;

    reg [31:0] note_phase;
    wire [31:0] next_note_phase;
    
    reg [1:0] s_osc_out;

    osc_rom osc_rom(
    .clk(clk),
    .raddr(osc_rom_raddr),
    .dout(osc_rom_dout)
    );

    datapath_oscillator datapath_oscillator(
    .clk(clk),
    .note(5'd9), // 440 Hz
    .note_phase(note_phase),
    .osc_choice(0), // sine
    .osc_rom_dout(osc_rom_dout),
    .en_osc_noise(0),
    .en_osc_out(1),
    .s_osc_noise(0),
    .s_osc_out(s_osc_out),
    .next_note_phase(next_note_phase),
    .osc_rom_raddr(osc_rom_raddr),
    .out(out)
    );
    
    initial clk = 0;
    
    always #1 clk = ~clk;

    always @(posedge clk)
        note_phase <= next_note_phase;
    
    initial begin
        reset = 1; note_phase = 0; clk = 0; s_osc_out = 0;
        
        #2 reset = 0; s_osc_out = 1;
        #10000;
        
        $stop;
    end
    
endmodule
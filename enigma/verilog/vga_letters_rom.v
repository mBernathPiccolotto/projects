module vga_letters_rom(input clk,
                       input [10:0] x,
                       input [6:0] y,
                       output reg [2:0] dout);
    
    parameter IMAGE_FILE = "letters.mem";
    
    wire [15:0] addr = 728*y + x;
    
    reg [2:0] mem [0:26207];
    initial $readmemh(IMAGE_FILE, mem);
    
    always @(posedge clk)
        dout <= mem[addr];
    
endmodule

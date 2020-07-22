module vga_enigma_rom(input clk,
                      input [6:0] x,
                      input [6:0] y,
                      output reg [2:0] dout);
    
    parameter IMAGE_FILE = "enigma.mem";
    
    wire [14:0] addr = 120*y + x;
    
    reg [2:0] mem [0:14399];
    initial $readmemh(IMAGE_FILE, mem);
    
    always @(posedge clk)
        dout <= mem[addr];
    
endmodule

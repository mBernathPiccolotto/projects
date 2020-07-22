module text_rom (
    input clk,
    input [7:0] raddr,
    output reg [7:0] dout
    );

    reg [7:0] M [0:191];
    
    initial $readmemh("G:/My Drive/Logic Design Lab/Final Project/final_project/verilog/data/lcd_text_data.txt", M);

    always @(posedge clk)
        dout <= M[raddr];

endmodule

module osc_rom (
    input clk,
    input [9:0] raddr,
    output reg [31:0] dout
    );

    reg [31:0] M [0:1023];

    initial $readmemh("G:/My Drive/Logic Design Lab/Final Project/final_project/verilog/data/oscillator_lookup_table.txt", M);

    always @(posedge clk)
        dout <= M[raddr];

endmodule

module ram (input clk,
            input [7:0] raddr0,
            input [7:0] raddr1,
            input [7:0] raddr2,
            input [7:0] raddr3,
            input [7:0] waddr,
            input we,
            input [31:0] din,
            output reg [31:0] dout0,
            output reg [31:0] dout1,
            output reg [31:0] dout2,
            output reg [31:0] dout3);
    
    reg [31:0] M [0:255];

    // Initialization for testing
    genvar i;
    generate
    for (i = 0; i < 256; i = i + 1) begin : generate_ram_initializer
        initial M[i] = 0;
    end
    endgenerate
    
    always @(posedge clk)
    begin
        dout0 <= M[raddr0];
        dout1 <= M[raddr1];
        dout2 <= M[raddr2];
        dout3 <= M[raddr3];
    end
    
    always @(posedge clk)
        if (we)
            M[waddr] <= din;
    
endmodule

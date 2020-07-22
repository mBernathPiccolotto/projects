`timescale 10 ns/10 ns

module vga_adaptor_tb();
    reg clk;
    
    reg [7:0] x;
    reg [6:0] y;
    reg [31:0] ram_dout;
    wire [2:0] color;
    wire [7:0] ram_raddr;

    assign ram_dout = (ram_raddr == 4) ? 1 : 0;

    vga_adapter uut(
        .x(x),
        .y(y),
        .ram_dout(ram_dout),
        .ram_raddr(ram_raddr),
        .color(color)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (x == 160)
            x <= 0;
        else
            x <= x + 1;
    end

    always @(posedge clk) begin
        if (x == 160)
            if (y == 120)
                y <= 0;
            else
                y <= y + 1;
    end

    always @(*)
        if (ram_raddr == 4) // first key being pressed
            ram_dout = 1;
        else if (ram_raddr > 50) // sample history in ram
            ram_dout = (ram_dout - 50 - 30) * 10000000000;
        else
            ram_dout = 0; // else 0, default

    initial begin
        clk = 0; x = 0; y = 0;
        #20000;
    end

endmodule
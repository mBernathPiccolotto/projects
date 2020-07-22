module datapath_noise(
    input clk,
    input en_noise,
    input s_noise,
    output reg [31:0] out
    );

    always @(posedge clk)
        if (en_noise)
            if (s_noise)
                out <= {out[30:0], out[1] ^ out[5] ^ out[6] ^ out[31]};
            else
                out <= 32'd4190284019;

endmodule
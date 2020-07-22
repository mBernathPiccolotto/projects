module piano_graphics(input [6:0] x,                 // betwwen 0 and 76
                      input [5:0] y,                 // between 0 and 59
                      input is_key_playing,          // whether key in key_requested is playing
                      output reg [4:0] key_requested, // key to be checked
                      output reg [2:0] color);       // color of pixel (x, y)
    
    parameter BLACK = 3'h0;
    parameter RED   = 3'h4;
    parameter WHITE = 3'h7;
    
    wire is_top;
    
    assign is_top = y <= 39;
    
    always @(*)
        if ((x >= 0 & x <= 10 & ~is_top) | (x >= 0 & x <= 6)) begin
            key_requested = 5'd0;
            color = is_key_playing ? RED : WHITE;
        end
        else if (x >= 7 & x <= 15 & is_top) begin
            key_requested = 5'd1;
            color = is_key_playing ? RED : BLACK;
        end
        else if ((x >= 12 & x <= 21 & ~is_top) | (x >= 16 & x <= 17)) begin
            key_requested = 5'd2;
            color = is_key_playing ? RED : WHITE;
        end
        else if (x >= 18 & x <= 26 & is_top) begin
            key_requested = 5'd3;
            color = is_key_playing ? RED : BLACK;
        end
        else if ((x >= 23 & x <= 32 & ~is_top) | (x >= 27 & x <= 32)) begin
            key_requested = 5'd4;
            color = is_key_playing ? RED : WHITE;
        end
        else if ((x >= 34 & x <= 43 & ~is_top) | (x >= 34 & x <= 39)) begin
            key_requested = 5'd5;
            color = is_key_playing ? RED : WHITE;
        end
        else if (x >= 40 & x <= 48 & is_top) begin
            key_requested = 5'd6;
            color = is_key_playing ? RED : BLACK;
        end
        else if ((x >= 45 & x <= 54 & ~is_top) | (x >= 49 & x <= 50)) begin
            key_requested = 5'd7;
            color = is_key_playing ? RED : WHITE;
        end
        else if (x >= 51 & x <= 59 & is_top) begin
            key_requested = 5'd8;
            color = is_key_playing ? RED : BLACK;
        end
        else if ((x >= 56 & x <= 65 & ~is_top) | (x >= 60 & x <= 61)) begin
            key_requested = 5'd9;
            color = is_key_playing ? RED : WHITE;
        end
        else if (x >= 62 & x <= 70 & is_top) begin
            key_requested = 5'd10;
            color = is_key_playing ? RED : BLACK;
        end
        else if ((x >= 67 & x <= 76 & ~is_top) | (x >= 71 & x <= 76)) begin
            key_requested = 5'd11;
            color = is_key_playing ? RED : WHITE;
        end
        else begin
		    key_requested = 5'd0;
		    color = BLACK;
        end

endmodule

/*
	signal_shortener: shortens signal from in such that it is high only for
                      a clock and synchronized with clk.
*/
module signal_shortener(input clk,
                        input in,
                        output out);
    
    reg [1:0] shift_2;
    
    initial shift_2 = 2'b00;
    
    // shift_2 is a shift register that keeps
    // the last two values of in
    always @(posedge clk)
        shift_2 <= {in, shift_2[1]};
    
    // out is high during in posedge
    assign out = shift_2[1] && ~shift_2[0];
    
endmodule

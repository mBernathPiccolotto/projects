/*
    reflector: reflects characters, so A->Z, B->Y, ...,  Z->A, Y->B.
*/
module reflector(input [15:0] in,
                 output [15:0] out);
    
    assign out = 25 - in;
    
endmodule

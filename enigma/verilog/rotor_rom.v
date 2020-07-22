/*
    rotor_rom: 6-channel output ROM that stores the corresponding keys
               for each rotor type, for both forward and backward encoding.
 */
module rotor_rom (input [8:0] addr0,
                  input [8:0] addr1,
                  input [8:0] addr2,
                  input [8:0] addr3,
                  input [8:0] addr4,
                  input [8:0] addr5,
                  output [15:0] dout0,
                  output [15:0] dout1,
                  output [15:0] dout2,
                  output [15:0] dout3,
                  output [15:0] dout4,
                  output [15:0] dout5);
    
    reg [15:0] mem_array [259:0];
    
    initial $readmemh("rotor_types.txt", mem_array);
    
    assign dout0 = mem_array[addr0];
    assign dout1 = mem_array[addr1];
    assign dout2 = mem_array[addr2];
    assign dout3 = mem_array[addr3];
    assign dout4 = mem_array[addr4];
    assign dout5 = mem_array[addr5];
    
endmodule

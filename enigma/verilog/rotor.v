/*
	rotor: based on first_in, computes first_out as the forward encoding of
           shift "shift" of a rotor of type "type";
           based on second_in, computes second_out as the bnackward encoding of
           shift "shift" of a rotor of type "type";
		   uses addr's and din's to get corresponding ouputs from rotor_ram.
*/

module rotor (input [15:0] type,
              input [15:0] shift,
              input [15:0] first_in,
              output [15:0] first_out,
              input [15:0] second_in,
              output [15:0] second_out,
              output [8:0] first_addr,
              input [15:0] first_din,
              output [8:0] second_addr,
              input [15:0] second_din);
    
    assign first_addr = ((first_in + shift) % 16'd26) + 16'd52 * type;
    assign first_out  = first_din;
    
    assign second_addr = second_in + 16'd26 + (16'd52 * type);
    assign second_out  = (second_din + (16'd26 - shift)) % 16'd26;
    
endmodule

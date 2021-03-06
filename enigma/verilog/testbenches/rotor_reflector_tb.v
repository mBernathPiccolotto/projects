`timescale 1ns/1ns

/*
	rotor_reflector_tb: used to test rotor and reflectors together,
							  both forward encoding and backward.
*/

module rotor_reflector_tb ();
  reg [2:0] type;
  reg [4:0] shift;
  reg [15:0] first_in;
  wire [15:0] first_out, second_in, second_out;
  wire [8:0] addr0, addr1;
  wire [15:0] dout0, dout1;
  
  rotor_rom rotor_rom(
    .addr0(addr0),
    .addr1(addr1),
    .addr2(0),
    .addr3(0),
    .addr4(0),
    .addr5(0),
    .dout0(dout0),
    .dout1(dout1)
  );
	  
  rotor uut_rotor(
    .type({13'd0,type}), // padding to avoid overflows
    .shift({11'd0,shift}),
    .first_in(first_in),
    .first_out(first_out),
	 .first_addr(addr0),
    .first_din(dout0),
    .second_in(second_in),
    .second_out(second_out),
	 .second_addr(addr1),
    .second_din(dout1)
  );
  
  reflector uut_reflector(
    .in(first_out),
    .out(second_in)
  );

  initial begin
         type = 3;
         shift = 0; first_in = 3;
	  #10 shift = 1; first_in = 3;
	  #10 shift = 1; first_in = 19;
	  #10 shift = 25; first_in = 25;
     #10 shift = 25; first_in = 22;
     #10;

     $stop;
  end

endmodule
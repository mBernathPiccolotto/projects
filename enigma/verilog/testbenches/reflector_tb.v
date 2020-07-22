`timescale 1ns/1ns

/*
	reflector_tb: used to reflector.
*/

module reflector_tb ();
  reg [15:0]in;
  wire [15:0]out;
  
  reflector uut(
    .in(in),
    .out(out)
  );

  initial begin
         in = 0;
	 #10  in = 10;
	 #10  in = 25;
    #10;
	 
    $stop;
  end

endmodule
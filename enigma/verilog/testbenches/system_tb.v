`timescale 1ns/1ns

/*
	system_tb: used to test all the logic under system by peeking
				  intermediary variables using ModelSim, such as
				  history_keeper, enconding from before to after,
				  keyboard_filter.
*/

module system_tb ();
	reg clk;
	reg reset;
	
	reg key_ready;
	reg make;
	reg ext;
	reg [7:0] key_input;
	
	wire [4:0] befor;
	wire [4:0] after;
	
	wire [4:0] shift0;
	wire [4:0] shift1;
	wire [4:0] shift2;
	wire [2:0] type0;
	wire [2:0] type1;
	wire [2:0] type2;

	reg increase_shift_or_type, increase0, increase1, increase2;	
	
	reg [4:0] history_raddr;
   wire [7:0] history_dout;
	
	initial history_raddr = 0;
	
	system uut(
		.clk(clk),
		.reset(reset),
		.key_ready(key_ready),
		.make(make),
		.ext(ext),
		.key_input(key_input),
		.befor(befor),
		.after(after),
		.shift0(shift0),
		.shift1(shift1),
		.shift2(shift2),
		.type0(type0),
		.type1(type1),
		.type2(type2),
		.increase_shift_or_type(increase_shift_or_type),
		.increase0(increase0),
		.increase1(increase1),
		.increase2(increase2),
		.history_raddr(history_raddr),
      .history_dout(history_dout)
	);
  
	always #5 clk = ~clk;

	initial clk = 1;
	
	initial begin 
		increase_shift_or_type = 0;
		increase0 = 0;
		increase1 = 0;
		increase2 = 0;
	end

	initial begin
			reset = 1;
	 #10  reset = 0; key_ready = 0; ext = 0; make = 0;
	 #10  key_input = "A"; key_ready = 1;
	 #10 	key_ready = 0;
	 #10;
	 #10  key_input = "B"; key_ready = 1;
	 #10 	key_ready = 0;
	 #20  key_input = "C"; key_ready = 1;
	 #10 	key_ready = 0;
	 #30  key_input = "D"; key_ready = 1;
	 #10 	key_ready = 0;
	 #10  key_input = "G"; key_ready = 1;
	 #10  key_ready = 0;
	 #10;
	 #10; reset = 1;
	 #10; reset = 0; increase0 = 1; increase1 = 1;
	 #40; increase1 = 0;
	 #110; increase0 = 0;
	 #10  key_ready = 1; key_input = "A";
	 #10  key_ready = 0;
	 #10;
	 
	 $stop;
	end

endmodule
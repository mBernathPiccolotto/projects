module wavelengths_rom(
	input [4:0] addr,
	output [31:0] dout
	);

	reg [31:0] mem_array [25:0];
	
	initial $readmemh("audio_wavelengths.txt", mem_array);
	
	assign dout = mem_array[addr];
	
endmodule
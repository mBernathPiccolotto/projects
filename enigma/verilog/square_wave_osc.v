module square_wave_osc (
   input clk,
   input reset,
	input sound_on,
	input [19:0] half_wavelength,
   output [31:0] out);
   
   parameter AMPLITUDE = 32'd10_000_000;
	
   reg [19:0] count;
   reg phase;
   
   always @(posedge clk)
      if (reset) begin
         count <= 0;
         phase <= 0;
      end
      else if (count >= half_wavelength) begin
         count <= 0;
         phase <= ~phase;
      end
      else begin
         count <= count + 1;
      end
      
   assign out = (~sound_on) ? 0 : (phase ? AMPLITUDE : -AMPLITUDE);

endmodule

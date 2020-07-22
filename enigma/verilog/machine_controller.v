/*
    machine_controller: uses flipflops to capture inputted keys from key/key_ok,
                        store them at before, capture the encoding circuit's
                        output _after into after, and change the rotors (shift/type)
                        based on input.
*/
module machine_controller (input clk,
                           input reset,
                           input key_ok,
                           input [7:0] key,
                           output [4:0] _befor,          // combinational, depends solely on inputted keys
                           input [4:0] _after,           // combinational, received from rotors/reflector
                           output reg [4:0] befor,       // sequential, keeps only valid inputted keys
                           output reg [4:0] after,       // sequential, since _after changes when rotors rotate after entering a key
                           output reg save_history,      // used to indicate to history_keeper that a key has been received
                           output reg [4:0] shift0,      // rotor shifts
                           output reg [4:0] shift1,
                           output reg [4:0] shift2,
                           output reg [2:0] type0,       // rotor types
                           output reg [2:0] type1,
                           output reg [2:0] type2,
                           input increase_shift_or_type,
                           input increase0,
                           input increase1,
                           input increase2);
									
    reg [1:0] save_next_counter; // used to wait a few clocks to store after
	 wire save_next;
	 
	 assign save_next = save_next_counter == 2'b11;
    
    assign _befor = key - "A";
    
    initial begin
        befor             = 0;
        after             = 0;
        shift0            = 0;
        shift1            = 0;
        shift2            = 0;
        type0             = 0;
        type1             = 0;
        type2             = 0;
		  save_history      = 0;
        save_next_counter = 0;
    end
    
    always @(posedge clk) begin
        
        if (reset) begin
            
            befor             <= 0;
            after             <= 0;
            shift0            <= 0;
            shift1            <= 0;
            shift2            <= 0;
            type0             <= 0;
            type1             <= 0;
            type2             <= 0;
				save_history      <= 0;
            save_next_counter <= 0;
            
        end
        else begin
    
            if (save_next_counter == 2'b11) begin // store _after and rotate rotors
                after             <= _after;
                save_next_counter <= 0; // reset counter
					 save_history      <= 1; // send high to save history
                
                if (shift0 == 25 && shift1 == 25)
                    shift2 <= (shift2 == 25) ? 0 : (shift2 + 1);
                else
                    shift2 <= shift2;
                
                if (shift0 == 25)
                    shift1 <= (shift1 == 25) ? 0 : (shift1 + 1);
                else
                    shift1 <= shift1;
                
                shift0 <= (shift0 == 25) ? 0 : (shift0 + 1);
                
            end
				else if (save_next_counter != 2'b00) begin // save_next_counter has been set off but hasn't reached 3'b11
				
					save_next_counter <= save_next_counter + 1;
					
				end
				else begin // save_next_counter is 0, so we are not waiting to store _after
				
					save_history <= 0; // set save_history to low after a counter
				
					if (key_ok) begin // store _befor and start save_next_counter
						 
						 befor             <= _befor;
						 save_next_counter <= 2'b01;
						 
					end
					else begin

						 // test if we have a received a key to increase one of the rotor settings
						 
						 if (increase_shift_or_type == 0) begin // increase shift
							  
							  if (increase0)
									shift0 <= (shift0 == 25) ? 0 : (shift0 + 1);
							  
							  if (increase1)
									shift1 <= (shift1 == 25) ? 0 : (shift1 + 1);
							  
							  if (increase2)
									shift2 <= (shift2 == 25) ? 0 : (shift2 + 1);
							  
						 end
						 else begin // increase type
							  
							  if (increase0)
									type0 <= (type0 == 4) ? 0 : (type0 + 1);
							  
							  if (increase1)
									type1 <= (type1 == 4) ? 0 : (type1 + 1);
							  
							  if (increase2)
									type2 <= (type2 == 4) ? 0 : (type2 + 1);
							  
						 end     
					end
				end
        end
    end
endmodule

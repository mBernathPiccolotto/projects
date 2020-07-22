/*
    machine_to_LCD_rom: works similarly to a ROM and decides between the display or history
                        screens based on the inputted disp_or_hist, either outputting
                        the display built from the inputted befor,after,shifts,types
                        or forwarding the signal from the history rom.
*/
module machine_to_LCD_rom (input disp_or_hist,             // low for disp, high for hist
                           input [4:0] befor,
                           input [4:0] after,
                           input [4:0] shift0,
                           input [4:0] shift1,
                           input [4:0] shift2,
                           input [2:0] type0,
                           input [2:0] type1,
                           input [2:0] type2,
                           output reg [4:0] history_raddr,
                           input [7:0] history_dout,
                           input [4:0] raddr,
                           output reg [7:0] dout);
    
    always @(*)
        if (disp_or_hist == 0) begin
            history_raddr = 0; // not used when in "disp" screen
            
            case (raddr)
                // Rotor Shifts
                5'h00: dout = "S";
                5'h01: dout = "H";
                5'h02: dout = "I";
                5'h03: dout = "F";
                5'h04: dout = "T";
                
                5'h06: dout = (shift0 >= 20) ? "2" : (shift0 >= 10) ? "1" : "0";
                5'h07: dout = ((shift0 >= 20) ? (shift0 - 20) : (shift0 >= 10) ? (shift0 - 10) : shift0) + "0";
                5'h08: dout = (shift1 >= 20) ? "2" : (shift1 >= 10) ? "1" : "0";
                5'h09: dout = ((shift1 >= 20) ? (shift1 - 20) : (shift1 >= 10) ? (shift1 - 10) : shift1) + "0";
                5'h0A: dout = (shift2 >= 20) ? "2" : (shift2 >= 10) ? "1" : "0";
                5'h0B: dout = ((shift2 >= 20) ? (shift2 - 20) : (shift2 >= 10) ? (shift2 - 10) : shift2) + "0";
                
                // Rotor Types
                5'h10: dout = "T";
                5'h11: dout = "Y";
                5'h12: dout = "P";
                5'h13: dout = "E";
                
                5'h15: dout = type0 + "1";
                5'h16: dout = type1 + "1";
                5'h17: dout = type2 + "1";
                
                // Machine Input
                5'h0D: dout = "I";
                5'h0E: dout = "N";
                
                5'h0F: dout = "A" + befor;
                
                // Machine Output
                5'h1C: dout = "O";
                5'h1D: dout = "U";
                5'h1E: dout = "T";
                
                5'h1F: dout = "A" + after;
                
                // Blank space elsewhere
                default: dout = " ";
            endcase
        end
        else begin
            // just forward history memory
            history_raddr = raddr;
            dout          = history_dout;
        end
    
endmodule
    

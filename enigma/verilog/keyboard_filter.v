/*
    keyboard_filter: filters the input from keycode_recognizer and
                     key_code to ascii to only consider key releases
                     for keys between "A" and "Z".
*/
module keyboard_filter(input key_ready,
                       input make,
                       input ext,
                       input [7:0] key_input,
                       output key_ok,
                       output [7:0] key_output);
    
    parameter KEY_EMPTY = 8'h0;
	 
	 wire key_inside_range, key_release;
    
    assign key_inside_range = (ext == 0) && (key_input >= "A" && key_input <= "Z");
    
    assign key_release = (make == 0);
    
    assign key_ok = key_inside_range && key_release && key_ready;
    
    assign key_output = (key_inside_range && key_release) ? key_input : KEY_EMPTY;
    
endmodule

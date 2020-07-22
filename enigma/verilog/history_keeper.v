/*
    history_keeper: FSM of compound state (state, index, to_save) that
                    stores the user inputted character "befor" and the
                    resulting encoded "after" to a 2x16 RAM that is
                    then displayed to the user.
*/
module history_keeper (input clk,
                       input reset,
                       input save_history,
                       input [4:0] befor,
                       input [4:0] after,
                       output reg [4:0] waddr,
                       output reg we,
                       output reg [7:0] dout);
    
    parameter WAIT       = 2'h0; // wait for save_history to be high
    parameter SAVE       = 2'h1; // save "before" and "after" keys
    parameter CLEAR_NEXT = 2'h2; // clear space for next keys
    parameter CLEAR_ALL  = 2'h3; // clear the whole ram, after reset
    
    reg [1:0] state, next_state;
    reg [4:0] index, next_index;
    reg [4:0] to_save, next_to_save;
    
    wire [4:0] index_plus_1; // just a helper
    assign index_plus_1 = index + 1;
    
    always @(posedge clk)
        if (reset) begin
            state   <= CLEAR_ALL;
            index   <= 0;
            to_save <= 0;
        end
        else begin
            state   <= next_state;
            index   <= next_index;
            to_save <= next_to_save;
        end
    
    always @(*) begin
        waddr = index;
        we    = 1'h0;
        dout  = " ";
        
        case (state)
            WAIT: begin
                if (save_history) begin // received bit to save history, start saving
                    next_state   = SAVE;
                    next_index   = index;
                    next_to_save = befor;
                end
                else begin // remain waiting
                    next_state   = WAIT;
                    next_index   = index;
                    next_to_save = to_save;
                end
            end
                
            SAVE: begin
                we   = 1;
                dout = to_save + "A";
                
                if (index[4] == 0) begin// top row, save before
                    next_state   = SAVE;
                    next_index   = {1'b1, index[3:0]}; // change to bottom row
                    next_to_save = after;
                end
                else begin
                    next_state   = CLEAR_NEXT;
                    next_index   = {1'b0, index_plus_1[3:0]}; // change to next column and top row
                    next_to_save = 0;
                end
            end
                    
            CLEAR_NEXT: begin
                we   = 1;
                dout = " ";
                
                if (index[4] == 0) begin // clearing top row
                    next_state   = CLEAR_NEXT;
                    next_index   = {1'b1, index[3:0]}; // change to bottom row
                    next_to_save = 0;
                end
                else begin // clearing bottom row
                    next_state   = WAIT;
                    next_index   = {1'b0, index[3:0]}; // change to top row again
                    next_to_save = 0;
                end
            end
                    
            CLEAR_ALL: begin
                we   = 1;
                dout = " ";
                
                if (index == 5'h1f) begin // last index, stop clearing
                    next_state   = WAIT;
                    next_index   = 5'h0;
                    next_to_save = 0;
                end
                else begin // continue clearing
                    next_state   = CLEAR_ALL;
                    next_index   = index + 1;
                    next_to_save = 0;
                end
            end
        endcase
    end
endmodule

module system(input clk,
              input reset,
              input key_ready,
              input make,
              input ext,
              input [7:0] key_input,
              output [4:0] befor,
              output [4:0] after,
              output [4:0] shift0,
              output [4:0] shift1,
              output [4:0] shift2,
              output [2:0] type0,
              output [2:0] type1,
              output [2:0] type2,
              input increase_shift_or_type,
              input increase0,
              input increase1,
              input increase2,
              input [4:0] history_raddr,
              output [7:0] history_dout);
    
    wire key_ok;
    wire [7:0] key;
    wire [15:0] from0to1, from1to2, from2toR, fromRto2, from2to1, from1to0;
    wire [4:0] _befor, _after;
    
    wire [8:0] addr0, addr1, addr2, addr3, addr4, addr5;
    wire [15:0] dout0, dout1, dout2, dout3, dout4, dout5;
    
    wire save_history;
    wire [7:0] history_din;
    wire [4:0] history_waddr;
    wire history_we;
    
    keyboard_filter keyboard_filter(
        .key_ready(key_ready),
        .make(make),
        .ext(ext),
        .key_input(key_input),
        .key_ok(key_ok),
        .key_output(key)
    );
    
    machine_controller machine_controller(
        .clk(clk),
        .reset(reset),
        .key_ok(key_ok),
        .key(key),
        ._befor(_befor),
        ._after(_after),
        .befor(befor),
        .after(after),
        .save_history(save_history),
        .shift0(shift0),
        .shift1(shift1),
        .shift2(shift2),
        .type0(type0),
        .type1(type1),
        .type2(type2),
        .increase_shift_or_type(increase_shift_or_type),
        .increase0(increase0),
        .increase1(increase1),
        .increase2(increase2)
    );
    
    rotor_rom rotor_rom(
        .addr0(addr0),
        .addr1(addr1),
        .addr2(addr2),
        .addr3(addr3),
        .addr4(addr4),
        .addr5(addr5),
        .dout0(dout0),
        .dout1(dout1),
        .dout2(dout2),
        .dout3(dout3),
        .dout4(dout4),
        .dout5(dout5)
    );
    
    rotor rotor0(
        .type({13'd0,type0}), // padding to avoid overflows
        .shift({11'd0,shift0}),
        .first_in({11'd0,_befor}),
        .first_out(from0to1),
        .second_in(from1to0),
        .second_out(_after),
        .first_addr(addr0),
        .first_din(dout0),
        .second_addr(addr1),
        .second_din(dout1)
    );
    
    rotor rotor1(
        .type({13'd0,type1}),
        .shift({11'd0,shift1}),
        .first_in(from0to1),
        .first_out(from1to2),
        .second_in(from2to1),
        .second_out(from1to0),
        .first_addr(addr2),
        .first_din(dout2),
        .second_addr(addr3),
        .second_din(dout3)
    );
    
    rotor rotor2(
        .type({13'd0,type2}),
        .shift({11'd0,shift2}),
        .first_in(from1to2),
        .first_out(from2toR),
        .second_in(fromRto2),
        .second_out(from2to1),
        .first_addr(addr4),
        .first_din(dout4),
        .second_addr(addr5),
        .second_din(dout5)
    );
    
    reflector reflector(
        .in(from2toR),
        .out(fromRto2)
    );
    
    history_keeper history_keeper(
        .clk(clk),
        .reset(reset),
        .save_history(save_history),
        .befor(befor),
        .after(after),
        .dout(history_din),
        .waddr(history_waddr),
        .we(history_we)
    );
    
    history_ram history_ram(
        .clk(clk),
        .raddr(history_raddr),
        .dout(history_dout),
        .waddr(history_waddr),
        .we(history_we),
        .din(history_din)
    );
    
endmodule

`timescale 10 ns/10 ns

module datapath_noise_tb();
    reg clk;
    reg en_noise;
    reg s_noise;
    wire [31:0] out;
    
    integer f;
    
    datapath_noise uut(
    .clk(clk),
    .en_noise(en_noise),
    .s_noise(s_noise),
    .out(out)
    );
    
    initial clk = 0;
    
    always #5 clk = ~clk;
    
    always @(posedge clk) begin
        $fwrite(f, "%d\n", out);
    end
    
    initial begin
        f = $fopen("output.txt", "w");
        
        en_noise = 1; s_noise = 0;
        #10 s_noise = 1;
        #1000000;
        
        // $stop;
        $finish;
    end
    
endmodule
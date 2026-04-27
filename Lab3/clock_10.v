module clock_10(CLOCK_50,LEDR);

    // declaring input and output
    input CLOCK_50 ;
    output reg [9:0] LEDR;

    // registor for counter (22 bits)
    reg [21:0] counter_bits;

    // always block to trigger
    always @(posedge CLOCK_50) begin
    
         counter_bits <= counter_bits + 1;
        
        if (counter_bits == 22'b 1111111111111111111111) begin
            LEDR <= LEDR + 1;
        end
            
    end

endmodule


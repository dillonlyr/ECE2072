module clock_100(LEDR,CLOCK_50);

    // declaring inputs n outputs
    input CLOCK_50;
    output reg [9:0] LEDR;
    
    // register for counter
    reg [20:0] counter;
    
    // always block for 100Hz timer
    always @(posedge CLOCK_50) begin
    
        counter <= counter + 1'b 1;
        
        // enter block if milisecond reaches 100 
        if (counter == 19'b 1111010000100100000) begin
        
            // add 1 to seconds register for 1 tick
            LEDR <= LEDR + 1'b 1;
            
            // resets after clock ticks 100 times
            counter <= 19'b 0000000000000000000;
        end
        
    end

endmodule
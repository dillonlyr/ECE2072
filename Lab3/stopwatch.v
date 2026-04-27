module stopwatch (CLOCK_50,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

    // declaring input KEYs for reset and pause
    input [1:0] KEY;
    // input for 50Mhz clock
    input CLOCK_50;
    
    reg start;
    reg [9:0] reset;
    reg [9:0] verify;
    
    // registers for each time unit
    reg [18:0] clock_rise;
    reg [6:0] ms_counter;
    reg [6:0] sec_counter;
    reg [6:0] min_counter;
    
    // output initialisation for 7 seg (m:s:ms)
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    
    // always block for rising edge of 50MHz clock  
    always @(posedge CLOCK_50) begin
    
        // if value of pause is 1 activated from press and release of KEY[0]
        if (start == 1) begin
            // each time clock rises add one
            clock_rise <= clock_rise + 1'b 1;
        end
        
        if (reset > verify) begin
            ms_counter <= 7'b 0000000;
            sec_counter <= 7'b 0000000;
            min_counter <= 7'b 0000000;
            verify <= verify + 1'b 1;
        end
        
        if (clock_rise == 19'b 1111010000100100000) begin
            clock_rise <= 19'b 0000000000000000000;
            
            if (ms_counter < 7'b 1100011) begin //99
                // add one to miliseconds
                ms_counter <= ms_counter + 1'b 1;
            end
            
            else if (ms_counter > 7'b 1100010) begin //98
                // reset miliseconds
                ms_counter <= 7'b 0000000;
                
                if (sec_counter < 7'b 0111011) begin //59
                    // add one to seconds
                    sec_counter <= sec_counter + 1'b1;
                end
                
                else if (sec_counter > 7'b 0111010) begin //59
                    // reset seconds
                    sec_counter <= 7'b 0000000;
                    
                    if (min_counter < 7'b 0111011) begin //59
                        // add one to minutes
                        min_counter <= min_counter + 1'b1;
                    end
                    else if (min_counter > 7'b 0111010) begin //58
                        // reset minutes
                        min_counter <= 7'b 0000000;
                    end
                end
            end
        end
    end
    
    // always block for pause button
    always @(posedge KEY[1]) begin
        start <= start + 1'b 1;
    end
    
    // always block for reset button
    always @(posedge KEY[0]) begin
        reset <= reset + 1'b 1;
    end 
    
    
    // calling bcd and two_digit_bcd instance for bcd display
    two_digit_bcd_v2 ms_bcd (.input_num(ms_counter),.d1(HEX1),.d2(HEX0));
    two_digit_bcd_v2 sec_bcd(.input_num(sec_counter),.d1(HEX3),.d2(HEX2));
    two_digit_bcd_v2 min_bcd(.input_num(min_counter),.d1(HEX5),.d2(HEX4));


endmodule

module two_digit_bcd_v2(input_num,d1,d2);

    // declaring input output
    input [6:0] input_num;
    output [6:0] d1;
    output [6:0] d2;
    
    wire [6:0] d1_out;
    wire [6:0] d2_out;
    
    // to store value 10 
    wire [6:0] ten;
    assign ten = 7'b 0001010;
    
    divide_7bit bcd_divide(.denom(ten),.numer(input_num), .quotient(d1_out), .remain(d2_out));
    
	bcd digit1(.in(d1_out), .Hex(d1));
	bcd digit2(.in(d2_out), .Hex(d2));

endmodule





    
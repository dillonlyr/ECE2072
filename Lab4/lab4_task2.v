module lab4_task2(CLOCK_50, KEY, LEDR);

    // declaring I/O
	input CLOCK_50;
	input [1:0] KEY;
	output [9:0] LEDR;
	
	wire clock50;
	assign clock50 = CLOCK_50;
	
	wire load_key; 
	assign load_key = ~KEY[0];
	
	// for storing board output from game of life
	reg [7:0] jtag_write;
	assign  LEDR [9:2] = jtag_write;
	assign LEDR[0] = writeclock;
	assign LEDR[1] = gameclock;
	
	
	wire [63:0] board_output;
	wire [7:0] row0,row1,row2,row3,row4,row5,row6,row7;
	assign row7 = board_output [63:56];
	assign row6 = board_output [55:48];
	assign row5 = board_output [47:40];
	assign row4 = board_output [39:32];
	assign row3 = board_output [31:24];
	assign row2 = board_output [23:16];
	assign row1 = board_output [15:8];
	assign row0 = board_output [7:0];
	
	// initialising registers
	reg [23:0] three_hz;
	reg [20:0] twentyfour_hz;
	reg gameclock, writeclock;

	// always block for gameclock and writeclock
	always @(posedge CLOCK_50) begin    
	
	    three_hz <= three_hz + 1;
	    twentyfour_hz <= twentyfour_hz + 1;
	    
	    // if three hz counter reaches all 1, gameclock clocks once
	    if (three_hz == 24'b 111111111111111111111111) 
	        gameclock <= gameclock + 1;
        // if twenty four hz counter reachs all 1, writeclock clocks once
	    if (twentyfour_hz == 21'b 111111111111111111111)
	        writeclock <= writeclock + 1;
    end
	
	// A test Default state, you can find more in the lab doc
	wire [63:0] default_state;
	assign default_state = 64'd 147499484866150400;
	
	// JTAG MODULE
	JTAG_UART_MODULE jtag(
		.clk(clock50),
		.reset(zero),
		.write(writeclock),
		.readdata(),
		.writedata(jtag_write)
        );
	
	// GAME OF LIFE
	game_of_life game(
		.clk(gameclock),
		.load(load_key), 
		.data(default_state),
		.q(board_output)
		);  
		
	// parameter storing values
	parameter zero = 1'b 0;
	parameter one = 1'b 1;
	parameter two = 2'b 10;
	parameter three = 2'b 11;
	parameter four = 3'b 100;
	parameter five = 3'b 101;
	parameter six = 3'b 110;
	parameter seven = 3'b 111;
	
	// Seperate the game of life output into rows. The rows should update 8x faster than the game does
	reg [2:0] loop;
	always @(posedge writeclock) begin
	
	    
		if (loop==zero) begin
			jtag_write <= row0;
			loop <= loop + 1;
		end
		else if (loop==one) begin
			jtag_write <= row1;
			loop <= loop + 1;
		end
		else if (loop==two) begin
			jtag_write <= row2;
			loop <= loop + 1;
		end
		else if (loop==three) begin
			jtag_write <= row3;
			loop <= loop + 1;
		end
		else if (loop==four) begin
			jtag_write <= row4;
			loop <= loop + 1;
	    end
		else if (loop==five) begin
			jtag_write <= row5;
			loop <= loop + 1;
		end
		else if (loop==six) begin
			jtag_write <= row6;
			loop <= loop + 1;
		end
		else if (loop==seven) begin
			jtag_write <= row7;
			loop <= loop + 1;
	    end
		
	end

endmodule

module game_of_life(clk, load, data, q);

	// parameter storing values
	parameter zero = 1'b 0;
	parameter one = 1'b 1;
	parameter two = 2'b 10;
	parameter three = 2'b 11;
	parameter four = 3'b 100;
	parameter five = 3'b 101;
	parameter six = 3'b 110;
	parameter seven = 3'b 111;

	 // declaring I/O
	 input load;
	 input clk;
	 input [63:0] data;
	 output reg [63:0] q; 

    reg [63:0] q_next;
    reg [3:0] counter;

	initial begin
		q_next = 0;
		counter = 0;
	end
	
	// initiliaze Loop integers
	integer i,j;
    always @(*) begin 
    
        // Game of life code
	    for (i=0; i<64; i=i+1) begin
		 
				counter = zero;
                
            // 4 edges
            if (i==0)
                counter = q[63] + q[56] + q[57] + q[7] + q[1] + q[15] + q[8] + q[9];
            else if (i==7)
                counter = q[62] + q[63] + q[56] + q[6] + q[0] + q[14] + q[15] + q[8];
            else if (i==56)
                counter = q[55] + q[48] + q[49] + q[63] + q[57] + q[7] + q[0] + q[1];    
            else if (i==63)
                counter = q[54] + q[55] + q[48] + q[62] + q[56] + q[6] + q[7] + q[0];
                
            // top hori
            else if ((i==1)|(i==2)|(i==3)|(i==4)|(i==5)|(i==6)) 
                counter = q[i+55] + q[i+56] + q[i+57] + q[i-1] + q[i+1] + q[i+7] + q[i+8] + q[i+9];
                
            // left vert
            else if ((i==8)|(i==16)|(i==24)|(i==32)|(i==40)|(i==48))
                counter = q[i-1] + q[i-8] + q[i-7] + q[i+7] + q[i+1] + q[i+15] + q[i+8] + q[i+9];
                
            // right vert
            else if ((i==15)|(i==23)|(i==31)|(i==39)|(i==47)|(i==55))
                counter = q[i-9] + q[i-8] + q[i-15] + q[i-1] + q[i-7] + q[i+7] + q[i+8] + q[i+1];
                
            // bottom hori
            else if ((i==57)|(i==58)|(i==59)|(i==60)|(i==61)|(i==62))
               counter = q[i-9] + q[i-8] + q[i-7] + q[i-1] + q[i+1] + q[i-57] + q[i-56] + q[i-55];
                
            // not edges
            else 
                counter = q[i-9] + q[i-8] + q[i-7] + q[i-1] + q[i+1] + q[i+7] + q[i+8] + q[i+9];
                
            begin 
                case(counter)
                
                    zero : q_next[i] = 0;
                    one : q_next[i] = 0;
                    two : if (q[i]==1) q_next[i] = 1; else  q_next[i] = 0;
                    three : q_next[i] = 1;
                    four : q_next[i] = 0;
                    default : q_next[i] = 0;
                    
                endcase    
				end
			end
		end
    
    always @(posedge clk) begin
        if (load) q <= data;
        else q <= q_next;
    end
    
endmodule



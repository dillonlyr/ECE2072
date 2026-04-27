`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the individual 
    components used in the processor.
	 
Please enter your name and student ID:
Student Name:   Loo Yi Ren Dillon
Student ID  :   33455953
*/

module tick_FSM_tb;

    // TODO: Implement the logic of your testbench here
    // Add your code here to create I/O variables
	reg rst, clk, enable;
	wire [3:0] tick;
	
	// Instantiate the module that your are testing
	tick_FSM tick_counter_test(rst, clk, enable, tick);
	
	initial begin
		// Add your code here
		rst = 0;
		clk = 0;
		enable = 0;
	end
	
	always begin
		#10
		// increment your input variables
		clk = clk + 1;
	end
	
	always begin
		#160
		// increment your input variables
		enable = enable + 1;
	end
	
	always begin
		#400
		// increment your input variables
		rst = rst + 1;
	end
	
	// create and initialize your testbench statistics
	integer count, errors;
	
	initial begin
		// Add your code here
		count = 0;
		errors = 0;
	end
	
	always begin
		#9
		if (count == 500) begin
			#10 /* Display that the code is finished, and state how many errors occured*/;
			$display("Done with tick_FSM test with count %0d.", count);
			$display("There were %0d errors.", errors);
			// Stop the test bench
			$stop;
		end
		
		if (rst && tick != 0 && clk) begin
			errors = errors + 1;
		end
		
		#1
		// increment the test case count
		count = count + 1;
	end
    

endmodule
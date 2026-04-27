`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the individual 
    components used in the processor.
	 
Please enter your name and student ID:
Student Name:   Loo Yi Ren Dillon
Student ID  :   33455953
*/

module register_tb;

    // I/O variables:
	reg [15:0] in;
	wire [15:0] out;
	reg enable, clk, rst;
	
	// Instantiate the module:
	register_n test1(.r_in(in), .enable(enable), .clk(clk), .Q(out), .rst(rst));
	
	initial begin
		// assign 0 to all inputs
		in <= 0;
		enable <= 0;
		clk <= 0;
		rst <= 0;
	end
	
	always begin
		#10
		clk = clk + 1;
	end
	
	always begin
		#20
		in = in + 1;
	end
	
	always begin
		#200
		enable = enable + 1;
	end
	
	always begin
		#400
		rst = rst + 1;
	end
	
	// create and initialize your testbench statistics
	integer count, errors;
	
	initial begin
		// assign 0 to all variables
		count = 0;
		errors = 0;
	end
	
	always begin
		#9
		if (count == 800) begin
			#10 /* Display that the code is finished, and state how many errors occured*/;
			$display("Done with register test with test count %0d.", count);
			$display("There were %0d errors.", errors);
			// Stop the test bench
			$stop;
		end
		
		if (clk && enable && !rst && (out != in))
			errors = errors + 1;
		
		if (clk && rst && (out != 0))
			errors = errors + 1;
			
		
		#1
		// increment the test case count
		count = count + 1;
	end
    

endmodule
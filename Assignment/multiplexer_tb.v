`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the individual 
    components used in the processor.
	 
Please enter your name and student ID:
Student Name:   Loo Yi Ren Dillon
Student ID  :   33455953
*/

module multiplexer_tb;

	// TODO: Implement the logic of your testbench here
	// Add your code here to create I/O variables
	reg [15:0] SignExtDin, R0, R1, R2, R3, R4, R5, R6, R7, G;
	reg [3:0] sel;
	wire [15:0] bus;
	
	// Instantiate the module that your are testing
	multiplexer mux(SignExtDin, R0, R1, R2, R3, R4, R5, R6, R7, G, sel, bus);
	
	initial begin
		// set all inputs to 0
		SignExtDin = 0;
		R0 = 0;
		R1 = 0;
		R2 = 0;
		R3 = 0;
		R4 = 0;
		R5 = 0;
		R6 = 0;
		R7 = 0;
		G = 0;
		sel = 0;
	end
	
	always begin
		#10
		// increment input variable
		SignExtDin = SignExtDin + 1;
	end
	
	always begin
		#20
		// increment input variable
		R0 = R0 + 1;
	end
	
	always begin
		#30
		// increment input variable
		R1 = R1 + 1;
	end
	
	always begin
		#40
		// increment input variable
		R2 = R2 + 1;
	end
	
	always begin
		#50
		// increment input variable
		R3 = R3 + 1;
	end
	
	always begin
		#60
		// increment input variable
		R4 = R4 + 1;
	end
	
	always begin
		#70
		// increment input variable
		R5 = R5 + 1;
	end
	
	always begin
		#80
		// increment input variable
		R6 = R6 + 1;
	end
	
	always begin
		#90
		// increment input variable
		R7 = R7 + 1;
	end
	
	always begin
		#100
		// increment input variable
		G = G + 1;
	end
	
	always begin
		#10
		// increment input variable
		sel = sel + 1;
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
		if (count == 524288) begin
			#10 /* Display that the code is finished, and state how many errors occured*/;
			$display("Done with test.");
			$display("There were %0d errors.", errors);
			// Stop the test bench
			$stop;
		end
		
		if (sel == 0 && (bus != R0))
			errors = errors + 1;
		if (sel == 1 && (bus != R1))
			errors = errors + 1;
		if (sel == 2 && (bus != R2))
			errors = errors + 1;
		if (sel == 3 && (bus != R3))
			errors = errors + 1;	
		if (sel == 4 && (bus != R4))
			errors = errors + 1;	
		if (sel == 5 && (bus != R5))
			errors = errors + 1;	
		if (sel == 6 && (bus != R6))
			errors = errors + 1;	
		if (sel == 7 && (bus != R7))
			errors = errors + 1;	
		if (sel == 8 && (bus != SignExtDin))
			errors = errors + 1;
		if (sel == 9 && (bus != G))
			errors = errors + 1;	
			
		#1
		// increment the test case count
		count = count + 1;
	end
    

endmodule
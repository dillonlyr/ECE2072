`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the individual 
    components used in the processor.
	 
Please enter your name and student ID:
Student Name:   Loo Yi Ren Dillon
Student ID  :   33455953
*/

module components_tb;

	//////////////////////////////////////////////////////////////////////////////////////////////////////
	///  SIGN EXTENDER TESTBENCH																								///
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// I/O variables:
	reg [8:0] sign_in;
	wire [15:0] sign_out;
	
	// Instantiate the module:
	sign_extend test1(sign_in, sign_out);
	
	initial begin
		// assign 0 to all inputs
		sign_in = 0;
	end
	
	always begin
		#10
		sign_in = sign_in + 1;
	end
	
	// create and initialize testbench statistics
	integer signext_count, signext_errors;
	
	initial begin
		// assign 0 to all variables
		signext_count = 0;
		signext_errors = 0;
	end
	
	always begin
		#9
		if (signext_count == 512) begin
			#10 /* Display that the code is finished, and state how many errors occured*/;
			$display("Done with sign_extend test with test count %0d.", signext_count);
			$display("There were %0d errors.", signext_errors);
			// Stop the test bench
			$stop;
		end
		
		if (sign_in[8] != sign_out[15] | sign_in[8] != sign_out[14] | sign_in[8] != sign_out[13] | sign_in[8] != sign_out[12] | sign_in[8] != sign_out[11] | sign_in[8] != sign_out[11] |
		sign_in[8] != sign_out[10] | sign_in[8] != sign_out[9])
		    signext_errors = signext_errors + 1;
		
		#1
		// increment the test case count
		signext_count = signext_count + 1;
		
	end

	//////////////////////////////////////////////////////////////////////////////////////////////////////
	///  END																															///
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	
	
	
	
	
	
endmodule








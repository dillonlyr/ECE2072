// set the time scale
module ones_counting_testbench;
	// Add your code here to create I/O variables
	
	// Instantiate the module that your are testing
	
	initial begin
		// Add your code here
	end

	always begin
		#10
		// increment your input variables
	end

	// create and initialize your testbench statistics
	
	always begin
		#9
		if (/* Ending condition for the test bench*/) begin
			#10 /* Display that the code is finished, and state how many errors occured*/;
			// Stop the test bench
		end

		if (/*Condition to check if the module is outputting the right number*/) begin
			// Service the error
		end
		#1
		// increment the test case count
	end
endmodule

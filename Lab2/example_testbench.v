`timescale 1ns / 1ps

module example_testbench;

	reg [2:0] input1, input2;
	wire out1, out2, out3;
	
	comparison_module test1 (input1, input2, out1, out2, out3);
	
	initial begin
		input1 = 0;
		input2 = 0;
	end

	always begin
		#10
		input1 = input1 + 1;
	end

	always begin
		#80
		input2 = input2 + 1;
	end

	integer count, errors;
	initial begin
		count = 0;
		errors = 0;
	end
	
	always begin
		#9
		if (count == 64) begin
			$display("Done with test.");
			$display("There were %0d errors.", errors);
			$stop;
		end
		if (out1 != (input1 == input2) || out2 != (input1 > input2) || out3 != (input1 < input2)) begin
			$display("Error for input (%b, %b) at time %0t.", input1, input2, $time);
			errors = errors + 1;
		end
		#1
		count = count + 1;
	end
endmodule

`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the individual 
    components used in the processor.
	 
Please enter your name and student ID:
Student Name:   Loo Yi Ren Dillon
Student ID  :   33455953
*/

module ALU_tb;

	// I/O variables
	reg [15:0] input_a, input_b, test_op3, test_op0, test_op1, test_op2, wire_a, wire_b;
	wire [31:0] test_mult_hold;
	reg [2:0] alu_op0,alu_op1,alu_op2,alu_op3,alu_op4;
	wire [15:0] result_op0,result_op1,result_op2,result_op3,result_op4;
	
	// Instantiate the module that your are testing
	ALU test1(input_a, input_b, alu_op0, result_op0);
	ALU test2(input_a, input_b, alu_op1, result_op1);
	ALU test3(input_a, input_b, alu_op2, result_op2);
	ALU test4(input_a, input_b, alu_op3, result_op3);
	ALU test5(input_a, input_b, alu_op4, result_op4);
	
	mult MULTIPLICATION(.dataa(wire_a),.datab(wire_b),.result(test_mult_hold));
	
	initial begin
		// assign 0 to all inputs
		input_a = 0;
		input_b = 0;
		alu_op0 = 0;
		alu_op1 = 1;
		alu_op2 = 2;
		alu_op3 = 3;
		alu_op4 = 4;
	end   
	
	// increament for input_b
	always begin
		#10
		// input_b test until 6 bit since processor input max is 6 bit
		if (input_b == 16'b 1111111111111111) input_b = 16'b 0111111111111111;
		else	input_b = input_b + 1;
	end
	
	// increament for input_a
	always begin
		#327680
		input_a = input_a + 1;
	end
	
	// create and initialize your testbench statistics
	integer count, add_err, subt_err, mult_err, srl_err, sll_err;
	
	initial begin
		/* reseting stat values */
		count = 0;
		add_err = 0;
		subt_err = 0;
		mult_err = 0;
		srl_err = 0;
		sll_err = 0;
	end
	
	always @(*) begin
			
		#9
		wire_a = input_a;
		wire_b = input_b;	
		
		if (count==262144) begin
			#10 /* Display that the code is finished, and state how many errors occured*/;
			$display("Done with ALU test with test count %0d.", count);
			$display("There were %0d addition errors.", add_err);
			$display("There were %0d subtraction errors.", subt_err);
			$display("There were %0d multiplication errors.", mult_err);
			$display("There were %0d shift right errors.", srl_err);
			$display("There were %0d shift left errors.", sll_err);
			// Stop the test bench
			$stop;
		end
		
		test_op0 = input_a + input_b;
		if (input_a[15] == 0 && input_b[15] == 0 && test_op0[15]==1)
			test_op0 = 16'b 0111111111111111;
		else if (input_a[15] == 1 && input_b[15] == 1 && test_op0[15]==0)
			test_op0 = 16'b 1000000000000000;
		if (result_op0 != test_op0)
		    add_err = add_err + 1;
			 
		
		
		test_op1 = input_a - input_b;
		if (input_a[15] == 0 && input_b[15] == 1 && test_op1[15]==1)
			test_op1 = input_a[15] == 0 && input_b[15] == 0 ;
		else if (input_a[15] == 1 && input_b[15] == 0 && test_op1[15]==0)
			test_op1 = 16'b 1000000000000000;	
		if (result_op1 != test_op1)
		    subt_err = subt_err + 1;
			 
		
		if (input_a[15] == 0 && input_b[15] == 0) begin
			
			if (test_mult_hold[15:0] > 16'b 0111111111111111)
				test_op2 = 16'b 0111111111111111;
			else
				test_op2 = input_a * input_b;
		end		
		else if (input_a[15] == 1 && input_b[15] == 0) begin
			wire_a = ~wire_a + 1'b 1;
			
			if (test_mult_hold[15:0] > 16'b 0111111111111111)
				test_op2 = 16'b 1000000000000000;
			else
				test_op2 = wire_a * wire_b;
				test_op2 = ~test_op2 + 1'b 1;
		end
		else if (input_a[15] == 0 && input_b[15] == 1) begin
			wire_b = ~wire_b + 1'b 1;
			
			if (test_mult_hold[15:0] > (15'b 111111111111111)) begin
				test_op2 = 16'b 1000000000000000;
			end
			else begin
				
				test_op2 = wire_a * wire_b;
				test_op2 = ~test_op2 + 1'b 1;
			end
		end	
		else if (input_a[15] == 1 && input_b[15] == 1) begin
			wire_a = ~wire_a + 1'b 1;
			wire_b = ~wire_b + 1'b 1;
			
			if (test_mult_hold[15:0] > 16'b 0111111111111111)
				test_op2 = 16'b 0111111111111111;
			else
				test_op2 = wire_a * wire_b;
			 
		end
		if (result_op2 != test_op2)
		    mult_err = mult_err + 1;
			 
			 
		test_op3 = input_b >> 1;
		if (input_b[15] == 1) 
			test_op3[15] = 1;
		if (result_op3 != test_op3 )
		    srl_err = srl_err + 1;
		if (result_op4 != (input_b << 1) )
		    sll_err = sll_err + 1;
		#1
		// increment the test case count
		count = count + 1;
				
	end
    

endmodule
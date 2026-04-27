/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual components to be used in 
    the CPU.

Please enter your name and student ID:
Student Name:   Loo Yi Ren Dillon
Student ID  :   33455953
*/

module sign_extend(in, ext);
	/* 
	 * This module sign extends the 9-bit Din to a 16-bit output.
	 */
	 
	// I/O variables:
	input [8:0] in;
	output reg [15:0] ext;

	// Implementing sign extender logic:
	always @(*) begin
	
		// if LSB of in is 1(negative value), fill ext out with six 1's
		if (in[8]) begin
			ext [15:9] <= 7'b 1111111;
		end

		// else if LSB of in is 0(positive value), fill ext out with six 0's
		else if (!in[8]) begin
			ext [15:9] <= 7'b 0000000;
		end

		// assign rest of ext
		ext [8:0] <= in;
	end
	 
endmodule


module tick_FSM(rst, clk, enable, tick);
	/* 
	 * This module implements a tick FSM that will be used to
	 * control the actions of the control unit
	 */

	// I/O variables:
	input rst, clk, enable;
	output reg [3:0] tick;

	// parameters to store values
	parameter STATE1 = 4'b 0001;
	parameter STATE2 = 4'b 0010;
	parameter STATE3 = 4'b 0100;
	parameter STATE4 = 4'b 1000;
	
	// implementing tick FSM logic:
	always @(posedge clk) begin
		
		// store state 1 into tick during first run since tick is in state 0000.
		if (tick == 0) tick <= STATE1;
		
		// if reset 0
		if (!rst) begin  

			// if enable 1
			if (enable) begin 
				// case check current tick 
				case (tick) 
					STATE1: tick <= STATE2;
					STATE2: tick <= STATE3;
					STATE3: tick <= STATE4;
					STATE4: tick <= STATE1;
				endcase
			end
				
			// else if enable 0  
			else if (!enable) begin
				// do nothing if enable is off
			end
		end
	  
		// if reset 1
		else if (rst) begin
			// restore tick back to default state
			tick <= 0;
		end
	end
endmodule


module multiplexer(SignExtDin, R0, R1, R2, R3, R4, R5, R6, R7, G, sel, Bus);
	/* 
	 * This module takes 10 inputs and places the correct input onto the bus.
	 */	
	 
	// I/O variables:
	input [15:0] SignExtDin, R0, R1, R2, R3, R4, R5, R6, R7, G;
	input [3:0] sel;
	output reg [15:0] Bus;

	// parameters for storing values
	parameter ZERO =  4'd 0;
	parameter ONE =   4'd 1;
	parameter TWO =   4'd 2;
	parameter THREE = 4'd 3;
	parameter FOUR =  4'd 4;
	parameter FIVE =  4'd 5;
	parameter SIX =   4'd 6;
	parameter SEVEN = 4'd 7;
	parameter EIGHT = 4'd 8;
	parameter NINE =  4'd 9;
 
	// Implementing multiplexer logic:
	always @(*) begin
	
		// case statement to check for output
		case(sel)
			ZERO: Bus <= 	R0;	
			ONE: Bus <=   	R1;
			TWO: Bus <=    R2;
			THREE: Bus <=  R3;
			FOUR: Bus <=   R4;
			FIVE: Bus <=   R5;
			SIX: Bus <=    R6;
			SEVEN: Bus <=  R7;
			EIGHT: Bus <=  SignExtDin;
			NINE: Bus <=   G;
		endcase
	end
		
endmodule


module ALU(input_a, input_b, alu_op, result);
	/* 
	 * This module implements the arithmetic logic unit of the processor.
	 */
	 
	// I/O variables:
	input [15:0] input_a, input_b; 
	input [2:0] alu_op;
	wire [31:0] result_temp;
	reg [15:0] temp_a, temp_b;
	output reg [15:0] result;
	
	// Instantiating lpm_multiplier module
	mult MULT(.dataa(temp_a),.datab(temp_b),.result(result_temp));
	
	// parameters for storing values
	parameter ZERO =  4'd 0;
	parameter ONE =   4'd 1;
	parameter TWO =   4'd 2;
	parameter THREE = 4'd 3;
	parameter FOUR =  4'd 4;
		 
	// Implementing ALU Logic:
	always @(*) begin
	
		temp_a = input_a;
		temp_b = input_b;

		// case statement to check operation to perform
		case (alu_op) 

			/* alu_op addition*/
			ZERO: begin
				
				/* performing addition */
				result = input_a + input_b;
				
				if (input_a[15] == 0 && input_b[15] == 0 && result[15] == 1) 
					result = 16'b 0111111111111111;
				
				else if (input_a[15] == 1 && input_b[15] == 1 && result[15] == 0)
					result = 16'b 1000000000000000;												
			end
	
			/* alu_op subtraction*/
			ONE: begin	
			
				/* performing subtraction */
				result = input_a - input_b;
				
				if (input_a[15] == 0 && input_b[15] == 1 && result[15] == 1)
					result = input_a[15] == 0 && input_b[15] == 0 ;
					
				else if (input_a[15] == 1 && input_b[15] == 0 && result[15] == 0)
					result = 16'b 1000000000000000;	
			end	

			/* alu_op multiplication */
			TWO: begin

				/* if both input positive */
				if (input_a[15] == 0 && input_b[15] == 0) begin
					
					if (result_temp[15:0] > 16'b 0111111111111111)
						result = 16'b 0111111111111111;
					else
						result = input_a * input_b;
				end		
				
				/* if input a negative */
				else if (input_a[15] == 1 && input_b[15] == 0) begin
				
					temp_a = ~temp_a + 1'b 1;
					
					if (result_temp[15:0] > 16'b 0111111111111111)
						result = 16'b 1000000000000000;
					else
						result = temp_a * temp_b;
						result = ~result + 1'b 1;
				end
				
				/* if input a negative */
				else if (input_a[15] == 0 && input_b[15] == 1) begin
				
					temp_b = ~temp_b + 1'b 1;
					
					if (result_temp[15:0] > (15'b 111111111111111))
						result = 16'b 1000000000000000;
					else
						result = temp_a * temp_b;
						result = ~result + 1'b 1;
				end		
	
				/* if both input negative */
				else if (input_a[15] == 1 && input_b[15] == 1) begin
				
					temp_a = ~temp_a + 1'b 1;
					temp_b = ~temp_b + 1'b 1;
					
					if (result_temp[15:0] > 16'b 0111111111111111)
						result = 16'b 0111111111111111;
					else
						result = temp_a * temp_b;	
				end
			end
			  
			/* alu_op shift right */
			THREE: begin
			
				/* performing bit shift right */
				result = input_b >> 1;
				
				if (input_b[15] == 1) 
						result[15] = 1'b 1;
			end

			/* alu_op shift left */
			FOUR: begin 	 
				/* performing bit shit left */
				result = input_b << 1;
			end
			  
			endcase
	end
endmodule


module register_n(r_in, enable, clk, Q, rst);
	/* 
	 * This module implements registers that will be used in the processor.
	 */

	/* To set parameter N during instantiation, you can use:
		register_n #(.N(num_bits)) reg_IR(.....), 
		where num_bits is how many bits you want to set N to
		and "..." is your usual input/output signals
	 */
	
	// parameter N to be changed during module instantiation
	parameter N = 16;
	
	// I/O variables:
	input enable, clk, rst;
	input [N:0] r_in;
	output reg [N:0] Q;
    
	// Implementing register logic:
	always @(posedge clk) begin
	    
		// if reset off, enable on, store value of r_in input Q
		if(!rst) begin
		  if(enable) Q <= r_in;
		end
		
		// else if reset on, reset Q to store all 0's
		else begin
			Q <= 0;
		end
			
	end
	
endmodule
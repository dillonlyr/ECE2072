module lab2_task3 (W,LEDR,HEX0,HEX1);

    // declaring inputs
    input [8:0] SW;

    // declaring outputs
    output [4:0] LEDR;
    output [6:0] HEX0;
    output [6:0] HEX1;
    
    // declaring wires to connect rippler adder output to BCD
    wire [3:0] wire_num;
    wire [3:0] first_digit;
    wire [3:0] second_digit;

    // 4-bit ripple carry adder instance
    ripple_carry_adder instance1( .a(SW[7:4]), .b(SW[3:0]), .cin(SW[8]), .sum(wire_num), .cout(LEDR[0]) );
    
    // divider 
    two_digit_bcd display1(.input_num(wire_num), .hex1(first_digit), .hex0(second_digit));
    
    // first and second digit bcd
    bcd bcd1(.in(first_digit), .Hex(HEX1));
    bcd bcd2(.in(second_digit), .Hex(HEX0));
    
endmodule

endmodule


module two_digit_bcd(input_num,hex0,hex1);

    // declaring input output
    input [3:0] input_num;
    output [6:0] hex0;
    output [6:0] hex1;
    
    // to store value 10 
    wire [3:0] ten;
    assign ten = 4'b1010;
    
    bcd_divide bcd_divide_1(.denom(ten),.numer(input_num), .quotient(hex1), .remain(hex0));

endmodule

endmodule

module full_adder (a, b, cin, sum, cout);
	input a, b, cin;
	output sum, cout;
	
	assign sum = a ^ b ^ cin;
	assign cout = (a & b) | (cin & (a ^ b));
endmodule

module ripple_carry_adder (a, b, cin, sum, cout); 

	input [3:0] a;
	input [3:0] b;
	output [3:0] sum;
	
	input cin;
	output cout;
	
	// Defining a wire to hold carry outputs
	wire [2:0] carry_out; 
	wire [3:0] temp_sum;
	
	// full adder instance 1
	full_adder adder1( .a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(carry_out[0]) );
	
	// full adder instance 2
	full_adder adder2( .a(a[1]), .b(b[1]), .cin(carry_out[0]), .sum(sum[1]), .cout(carry_out[1]) );
	
	// full adder instance 3
	full_adder adder3( .a(a[2]), .b(b[2]), .cin(carry_out[1]), .sum(sum[2]), .cout(carry_out[2]) );
	
	// full adder instance 4
	full_adder adder4( .a(a[3]), .b(b[3]), .cin(carry_out[2]), .sum(sum[3]), .cout(cout) );
	
	
endmodule

// `timescale 1ns / 1ps
// module adder_testbench;
// 	initial begin
//         // ???
// 	end

// 	always begin
// 		# // ???
		
// 	end

// 	always begin
// 		# // ???
// 	end

// 	integer count, errors;
// 	initial begin
// 		count = 0;
// 		errors = 0;
// 	end
	
// 	always begin
// 		# ???
// 		if (count == /* ??? */) begin
// 			$display("Done with test.");
//           $display("There were %0d errors.", errors);
// 			$stop;
// 		end
// 		if (/* ??? */) begin
// 			$display("Error for input (%b, %b) at time %0t.", input1, input2, $time);
// 			errors = errors + 1;
// 		end
// 		# ???
// 		count = count + 1;
// 	end
// endmodule

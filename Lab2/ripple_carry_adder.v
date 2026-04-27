module ripple_carry_adder (a, b, cin, sum, cout); 

	input [3:0] a;
	input [3:0] b;
	output [3:0] sum;
	
	input cin;
	output cout;
	
	// Defining a wire to hold carry outputs
	wire [2:0] carry_out; 

	// full adder instance 1
	full_adder adder1( .a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(carry_out[0]) );
	
	// full adder instance 2
	full_adder adder2( .a(a[1]), .b(b[1]), .cin(carry_out[0]), .sum(sum[1]), .cout(carry_out[1]) );
	
	// full adder instance 3
	full_adder adder3( .a(a[2]), .b(b[2]), .cin(carry_out[1]), .sum(sum[2]), .cout(carry_out[2]) );
	
	// full adder instance 4
	full_adder adder4( .a(a[3]), .b(b[3]), .cin(carry_out[2]), .sum(sum[3]), .cout(cout) );
	
endmodule
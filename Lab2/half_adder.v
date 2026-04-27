module half_adder( a, b, sum, carry);
	input a, b;
	output sum, carry;
	
	assign sum = a ^ b; // sum is the XOR of the inputs
	assign carry = a & b; // carry is the AND of the inputs

endmodule
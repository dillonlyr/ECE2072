module lab2_task4 (/* Your IO */);
    // Your code here

    wallace_tree tree (.A(), .B(), .output_products());

endmodule



module wallace_tree (A, B, output_products);
    input [3:0] A;
    input [3:0] B;
    output [7:0] output_products;


    wire [3:0] C0, S0, C1, S1, C2, S2;

    // Adder modules
    // Stage 1
    half_adder HA_1 (.a(A[0] & B[1]), .b(A[1] & B[0]), .sum(S0[0]), .carry(C0[0]));
    full_adder FA_1 (.a(), .b(), .cin(), .sum(), .cout());
    full_adder FA_2 (.a(), .b(), .cin(), .sum(), .cout());
    half_adder HA_2 (.a(), .b(), .sum(), .carry());

    // Stage 2
    half_adder HA_3 (.a(), .b(), .sum(), .carry());
    full_adder FA_3 (.a(), .b(), .cin(), .sum(), .cout());
    full_adder FA_4 (.a(), .b(), .cin(), .sum(), .cout());
    full_adder FA_5 (.a(), .b(), .cin(), .sum(), .cout());

    // Stage 3
    half_adder HA_4 (.a(), .b(), .sum(), .carry());
    full_adder FA_6 (.a(), .b(), .cin(), .sum(), .cout());
    full_adder FA_7 (.a(), .b(), .cin(), .sum(), .cout());
    full_adder FA_8 (.a(), .b(), .cin(), .sum(), .cout());

    // Assign outputs
    assign output_products[?] = ?;



endmodule


module half_adder( a, b, sum, carry);
	input a, b;
	output sum, carry;
	
	assign sum = a ^ b; // sum is the XOR of the inputs
	assign carry = a & b; // carry is the AND of the inputs

endmodule
 
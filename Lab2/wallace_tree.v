module wallace_tree (A, B, output_products);

    // inputs and outputs
    input [3:0] A;
    input [3:0] B;
    output [7:0] output_products;

    // wires for cout and sum
    wire [3:0] C0, S0, C1, S1, C2, S2;

    // Adder modules
    // Stage 1
    half_adder HA_1 (.a(A[0] & B[1]), .b(A[1] & B[0]), .sum(S0[0]), .carry(C0[0]) );
    full_adder FA_1 (.a(A[0] & B[2]), .b(A[1] & B[1]), .cin(A[2] & B[0]), .sum(S0[1]), .cout(C0[1]) );
    full_adder FA_2 (.a(A[2] & B[1]), .b(A[1] & B[2]), .cin(A[0] & B[3]), .sum(S0[2]), .cout(C0[2]) );
    half_adder HA_2 (.a(A[2] & B[2]), .b(A[1] & B[3]), .sum(S0[3]), .carry(C0[3]) );

    // Stage 2
    half_adder HA_3 (.a(C0[0]), .b(S0[1]), .sum(S1[0]), .carry(C1[0]) );
    full_adder FA_3 (.a(S0[2]), .b(A[3] & B[0]), .cin(C0[1]), .sum(S1[1]), .cout(C1[1]) );
    full_adder FA_4 (.a(S0[3]), .b(A[3] & B[1]), .cin(C0[2]), .sum(S1[2]), .cout(C1[2]) );
    full_adder FA_5 (.a(A[2] & B[3]), .b(A[3] & B[2]), .cin(C0[3]), .sum(C1[3]), .cout(S1[3]) );

    // Stage 3
    half_adder HA_4 (.a(C1[0]), .b(S1[1]), .sum(S2[0]), .carry(C2[0]) );
    full_adder FA_6 (.a(S1[2]), .b(C1[1]), .cin(C2[0]), .sum(S2[1]), .cout(C2[1]) );
    full_adder FA_7 (.a(S1[3]), .b(C1[2]), .cin(C2[1]), .sum(S2[2]), .cout(C2[2]) );
    full_adder FA_8 (.a(A[3] & B[3]), .b(C1[3]), .cin(C2[2]), .sum(S2[3]), .cout(C2[3]) );

    // Assign outputs
    assign output_products[0] = A[0] & B[0];
    assign output_products[1] = S0[0];
    assign output_products[2] = S1[0];
    assign output_products[3] = S2[0];
    assign output_products[4] = S2[1];
    assign output_products[5] = S2[2];
    assign output_products[6] = S2[3];
    assign output_products[7] = C2[3];

endmodule
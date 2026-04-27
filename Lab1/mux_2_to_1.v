module mux_2_to_1_v(A,B,C,X);
    // declare inputs ...
	 input A, B, C;

    // declare outputs ...
    output X;
	 
    // implement your logic using assign statements ...
	  
	assign X = ~(~(A&C) & ~(B & ~(C & C)));
endmodule

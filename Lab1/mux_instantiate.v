module mux_instantiate(SW,LEDR); 
	// Define the inputs and outputs to our module
	input [3:0] SW;
	output [0:0]LEDR;


	// Create an instance of the verilog light module 
	mux_2_to_1_v mux1(.A(SW[2]), .B(SW[1]), .C(SW[0]), .X(LEDR[0]));
endmodule

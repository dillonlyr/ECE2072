module sequence_detector(SW, KEY, LEDR, LEDG);

    // declaring I/O
	input [1:0] SW; 
	input [0:0] KEY; // clock key
	
	output [8:0] LEDR; // LED output
	output [1:0] LEDG;
	wire Clock, Reset;
	
	// assigning when key KEY[0] is pressed as clock
	assign Clock = ~KEY[0];
	// assigning when switch SW[0] is pressed as reset
	assign Reset = ~SW[0];
	assign D = SW[1];
	
	// what other wires need to be defined here ...
    wire [8:0] y;
    wire [8:0] states;
    wire out;

	// instantiate flip flops for each state: 
	flipflop y0 ( .D(y[0]), .Clock(Clock), .Reset(), .Set(), .Q(states[0]) );
	flipflop y1 ( .D(y[1]), .Clock(Clock), .Reset(Reset), .Set(), .Q(states[1]) );
	flipflop y2 ( .D(y[2]), .Clock(Clock), .Reset(Reset), .Set(), .Q(states[2]) );
	flipflop y3 ( .D(y[3]), .Clock(Clock), .Reset(Reset), .Set(), .Q(states[3]) );
	flipflop y4 ( .D(y[4]), .Clock(Clock), .Reset(Reset), .Set(), .Q(states[4]) );
	flipflop y5 ( .D(y[5]), .Clock(Clock), .Reset(Reset), .Set(), .Q(states[5]) );
	flipflop y6 ( .D(y[6]), .Clock(Clock), .Reset(Reset), .Set(), .Q(states[6]) );		
	flipflop y7 ( .D(y[7]), .Clock(Clock), .Reset(Reset), .Set(), .Q(states[7]) );	
	flipflop y8 ( .D(y[8]), .Clock(Clock), .Reset(Reset), .Set(), .Q(states[8]) );

	// define next state logic for each flip flop:
	// for output 0
	assign y[0] = Reset;
	assign y[1] = ~D & (states[0] | states[5] | states[6] | states[7] | states[8]);
	assign y[2] = ~D & (states[1]);
    assign y[3] = ~D & (states[2]);
    assign y[4] = ~D & (states[3] | states[4]);
    // for output 1
    assign y[5] = D & (states[0] | states[1] | states[2] | states[3] | states[4]);
    assign y[6] = D & (states[5]);
    assign y[7] = D & (states[6]);
    assign y[8] = D & (states[7] | states[8]);
    // for LEDG output
    assign out = states[4] | states[8];
    
	// assign the state to LEDR[8:0]:
	assign LEDR[8:0] = states;

	// assign the output to LEDR[9]:
	assign LEDG[1] = out;

endmodule


module flipflop (D, Clock, Reset, Set, Q);

	input D, Clock, Reset, Set;
	output reg Q;
	
	// always block for +ve edge of clock
	always @(posedge Clock) begin
	
		if (Reset==1) // synchronous clear
			Q <= 1'b 0;
			
		else if (Set==1) // synchronous set
			Q <= 1'b 1;
			
		else
			Q <= D;
	end
	
endmodule






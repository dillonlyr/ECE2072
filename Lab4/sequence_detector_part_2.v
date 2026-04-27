module sequence_detector_part_2 (SW, KEY, LEDR, LEDG);

    // declaring I/O
	input [1:0] SW; 
	input [0:0] KEY; // clock key
	
	output [8:0] LEDR; // state LED
	output [1:0] LEDG; // output LED
	wire Clock, Reset;
	
	// assigning inputs to alter variables
	assign Clock = ~KEY[0];
	assign Reset = SW[0];
	assign w = SW[1];
	
	// define signals:
	reg [3:0] y_Q, y_D;	// y_Q represents current state, y_D represents next state

	// define state parameters:
	parameter A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011, E = 4'b0100, F = 4'b0101, G = 4'b0110, H = 4'b0111, I = 4'b1000;

	// TODO: implement the state table:
	always @(w,y_Q) begin 
		case (y_Q)
			A: 
				if (!w) y_D = B;
				else y_D = F;
			B:
			    if (!w) y_D = C;
			    else y_D = F;
		    C:
		        if (!w) y_D = D;
			    else y_D = F;
		    D: 
		        if (!w) y_D = E;
			    else y_D = F;
		    E:
		        if (!w) y_D = E;
			    else y_D = F;
		    F:
		        if (w) y_D = G;
			    else y_D = B;
		    G: 
		        if (w) y_D = H;    
			    else y_D = B;
		    H:
		        if (w) y_D = I;
			    else y_D = B;
		    I:
		        if (w) y_D = I;
			    else y_D = B;
			
			default: y_D = 4'b0000;
		endcase
	end

    // assigning outputs
	assign LEDG[1] = (y_Q == E) | (y_Q == I);
	assign LEDR[3:0] = y_Q;
	
	// update the current state on clock edges:
    always @(posedge Clock) begin
    
        if (Reset) y_Q <= 4'b 0000;
        else y_Q <= y_D;
        
    end
	
endmodule


module sequence_detector_part_3(SW, KEY, LEDR, LEDG);
    
    //inputs and outputs
    input [1:0] SW;
    input [0:0] KEY;
    output [8:0] LEDR;
    output [1:0] LEDG;
    
    //connections
    wire Clock, Reset, w;
    assign Clock = ~KEY[0];
    assign Reset = SW[0];
    assign w = SW[1];
    
    // stores currrent state of both shift registers
    wire [3:0] shiftreg_0;
    wire [3:0] shiftreg_1;
    
    // assinging LEDS to stored shift reg values and output
    assign LEDR[8:5] = shiftreg_0;
    assign LEDR[3:0] = shiftreg_1;
    assign LEDG[1] = shiftreg_0[3] | shiftreg_1[3];
    
    reg reg0_in;
    reg reg1_in;
    
    reg reset0;
    reg reset1;
    
    // shift reg instances
    lpm_shiftreg_balls sg0(.clock(Clock), .sclr(reset0|Reset), .shiftin(reg0_in), .sset(), .q(shiftreg_0));
    lpm_shiftreg_balls sg1(.clock(Clock), .sclr(reset1|Reset), .shiftin(reg1_in), .sset(), .q(shiftreg_1));
    
    initial begin
        reg0_in = 1;
        reg1_in = 0;
        reset0 = 0;
        reset1 = 1;
    end
    
    always @(w) begin
        
        if (!w) begin
            reset0 = 0;
            reset1 = 1;
            reg0_in = 1;
            reg1_in = 0;
        end
        
        else if (w) begin
            reset0 = 1;
            reset1 = 0;
            reg0_in = 0;
            reg1_in = 1;
        end
        
    end
    
endmodule

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module lpm_shiftreg_balls (
	clock,
	sclr,
	shiftin,
	sset,
	q);

	input	  clock;
	input	  sclr;
	input	  shiftin;
	input	  sset;
	output	[3:0]  q;

	wire [3:0] sub_wire0;
	wire [3:0] q = sub_wire0[3:0];

	lpm_shiftreg	LPM_SHIFTREG_component (
				.clock (clock),
				.sclr (sclr),
				.shiftin (shiftin),
				.sset (sset),
				.q (sub_wire0)
				// synopsys translate_off
				,
				.aclr (),
				.aset (),
				.data (),
				.enable (),
				.load (),
				.shiftout ()
				// synopsys translate_on
				);
	defparam
		LPM_SHIFTREG_component.lpm_direction = "LEFT",
		LPM_SHIFTREG_component.lpm_type = "LPM_SHIFTREG",
		LPM_SHIFTREG_component.lpm_width = 4;


endmodule
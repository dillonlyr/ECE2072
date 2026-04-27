module analysis (in1, in2, op , out, clk);

	input clk;
	
	//	for sign extend
	input [15:0] in1, in2;
	input [3:0] op;
	output reg [15:0] out;
	
	reg [3:0] clocked_op;
	reg [15:0] clocked_in1, clocked_in2;
	wire [15:0] clocked_out;
	
	always @(posedge clk) begin
	
		clocked_in1 <= in1;
		clocked_in2 <= in2;
		clocked_op <= op;
		
		out <= clocked_out;
	end
	
	
//	// for mux
//	input [15:0] in1, in2, in3, in4 , in5 ,in6, in7, in8, in9, in10;
//	reg [15:0] clocked_in1, clocked_in2, clocked_in3, clocked_in4, clocked_in5, clocked_in6, clocked_in7, clocked_in8, clocked_in9, clocked_in10, clocked_sel;
//	input [3:0] sel;
//	output reg [3:0] out;
//	wire [15:0] clocked_out;
//
//	always @(posedge clk) begin
//	
//		clocked_in1 <= in1;
//		clocked_in2 <= in2;
//		clocked_in3 <= in3;
//		clocked_in4 <= in4;
//		clocked_in5 <= in5;
//		clocked_in6 <= in6;
//		clocked_in7 <= in7;
//		clocked_in8 <= in8;
//		clocked_in9 <= in9;
//		clocked_in10 <= in10;
//		
//		clocked_sel <= sel;
//		
//		out <= clocked_out;
//	end
//		
//	
	// for tick 
//	input rst, enable;
//	output reg[3:0] out;
//	reg clocked_rst, clocked_enable;
//	wire [3:0] clocked_out;
//	
//	always @(posedge clk) begin
//		clocked_rst <= rst;
//		clocked_enable <= enable;
//		out <= clocked_out;
//	end


//	sign_extend a(.in(clocked_in), .ext(clocked_out));
//	
//	tick_FSM b(.rst(clocked_rst), .clk(clk), .enable(clocked_enable), .tick(clocked_out));
	
//	multiplexer c(.SignExtDin(in1),
//						.R0(clocked_in2),
//						.R1(clocked_in3),
//						.R2(clocked_in4),
//						.R3(clocked_in5),
//						.R4(clocked_in6),
//						.R5(clocked_in7),
//						.R6(clocked_in8),
//						.R7(clocked_in9),
//						.G(clocked_in10),
//						.sel(clocked_sel),
//						.Bus(clocked_out));
//	
	ALU d(.input_a(clocked_in1), .input_b(clocked_in2), .alu_op(clocked_op), .result(clocked_out));
//	
//	register_n e(.r_in(clocked_in), .enable(clocked_enable), .clk(clk), .Q(clocked_out), .rst(clocked_rst));

endmodule

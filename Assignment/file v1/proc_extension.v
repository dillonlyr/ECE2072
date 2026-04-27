/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual the CPU.

Please enter your name and student ID:
Student Name:   Loo Yi Ren Dillon
Student ID  :   33455953
*/

module proc_extension(LEDR, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	// I/O variables:
	input [1:0] KEY;
	input [9:0] SW;
	output [9:0] LEDR; 
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;


	// wires:
	wire clk, rst;
	wire [8:0] bus, led_disp;
	wire [15:0] display;
	wire [6:0] tick, digit1, digit2, digit3, digit4, digit5;
	reg sign;
	reg [15:0] disp;
	
	wire [15:0] ten, hundred, thousand, tenk, num4, num3, num2;
	assign ten = 4'd 10;
	assign hundred = 10'd 100;
	assign thousand = 10'd 1000;
	assign tenk = 16'd 10000;

	// wire connections:
	assign clk = ~KEY[0];
	assign rst = SW[9];
	assign bus = SW[8:0];
	assign LEDR[8:0] = led_disp;
	 
	always @(*)begin
		
		if (display[15] == 1) begin
			disp <= ~display + 1;
			sign <= 1;
		end
		
		else begin
			sign <= 0;
			disp <= display;
		end
		
		if (disp > 14'd 9999) disp <= 14'd 9999;
		
	end
	
	bcd_sign bcdsign1(.sign(sign), .hex(HEX4));
	
//	divide16_v2 divide0(.denom(tenk),
//								.numer(display),
//								.quotient(digit1),
//								.remain(num4));						
	
	divide16_v2 divide1(.denom(thousand),
								.numer(displ),
								.quotient(digit2),
								.remain(num3));
								
	divide16_v2 divide2(.denom(hundred),
								.numer(num3),
								.quotient(digit3),
								.remain(num2));
								
	divide16_v2 divide3(.denom(ten),
								.numer(num2),
								.quotient(digit4),
								.remain(digit5));
	
	/* bcd to 7-segment dispplay instances */
	bcd bcd5(.in(tick), .Hex(HEX5));
//	bcd bcd4(.in(digit1), .Hex(HEX4));
	bcd bcd3(.in(digit2), .Hex(HEX3));
	bcd bcd2(.in(digit3), .Hex(HEX2));
	bcd bcd1(.in(digit4), .Hex(HEX1));
	bcd bcd0(.in(digit5), .Hex(HEX0));
	
	/* extended processor instance */
	extended_proc testproc (.clk(clk), 
								.rst(rst), 
								.din(bus), 
								.enable(1),
								.bus(led_disp), 
								.tick_count(tick),
								.display(display));
								
endmodule


module bcd_sign(sign, hex);

	//I/O variables:
	input sign;
	output [6:0] hex; 
	
	assign hex[6] = ~sign;
	assign hex[5] = 1;
	assign hex[4] = 1;
	assign hex[3] = 1;
	assign hex[2] = 1;
	assign hex[1] = 1;
	assign hex[0] = 1;
	
endmodule

module extended_proc(clk, rst, enable, din, bus, tick_count, display);

	// I/O variables:
	input clk, rst, enable; 
	input [8:0] din;
	output [3:0] tick_count;
	output [15:0] bus;
	output [15:0] display;
	
	reg [3:0] bus_control; 
	reg [2:0] alu_op;

	// Wires:
	wire [15:0] alu_out;
	
	// register wires
	reg r0_in, r1_in, r2_in, r3_in, r4_in, r5_in, r6_in, r7_in, rG_in, rIR_in, rA_in, rH_in;
	wire [15:0] r0_val, r1_val, r2_val, r3_val, r4_val, r5_val, r6_val, r7_val, rIR_val, rG_val, rA_val, rH_val, sign_ext, bus_wire; 
		
	assign bus = bus_wire;
	assign display = rH_val;
	
	reg [2:0] Rx, Ry, opcode;

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/* REGISTERS																																		*/
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/* General Purpose resister instances
		instance name: R0, R1, R2, R3, R4, R5, R6, R7
		general use registers(16-bit).*/
	register_n #(.N(15)) reg_r0(.r_in(bus_wire), .enable(r0_in), .clk(clk), .Q(r0_val), .rst(rst));
	register_n #(.N(15)) reg_r1(.r_in(bus_wire), .enable(r1_in), .clk(clk), .Q(r1_val), .rst(rst));
	register_n #(.N(15)) reg_r2(.r_in(bus_wire), .enable(r2_in), .clk(clk), .Q(r2_val), .rst(rst));
	register_n #(.N(15)) reg_r3(.r_in(bus_wire), .enable(r3_in), .clk(clk), .Q(r3_val), .rst(rst));
	register_n #(.N(15)) reg_r4(.r_in(bus_wire), .enable(r4_in), .clk(clk), .Q(r4_val), .rst(rst));
	register_n #(.N(15)) reg_r5(.r_in(bus_wire), .enable(r5_in), .clk(clk), .Q(r5_val), .rst(rst));
	register_n #(.N(15)) reg_r6(.r_in(bus_wire), .enable(r6_in), .clk(clk), .Q(r6_val), .rst(rst));
	register_n #(.N(15)) reg_r7(.r_in(bus_wire), .enable(r7_in), .clk(clk), .Q(r7_val), .rst(rst));

	/* Intruction Register(IR) instance
		instance name: reg_IR
		used to store Data in value(9-bit).*/
	register_n #(.N(8)) reg_IR(.r_in(din), .enable(rIR_in), .clk(clk), .Q(rIR_val), .rst(rst));

	/* Register G instance
		instance name: reg_G
		used to store ALU outputvalue(16-bit).*/
	register_n #(.N(15)) reg_G(.r_in(alu_out), .enable(rG_in), .clk(clk), .Q(rG_val), .rst(rst));

	/* Register A instance
		instance name: reg_A
		used to store ALU input_a value(16-bit).*/
	register_n #(.N(15)) reg_A(.r_in(bus_wire), .enable(rA_in), .clk(clk), .Q(rA_val), .rst(rst));

	/* Register H instance
		instance name: reg_H
		used to store HEX5 output value(16-bit).*/
	register_n #(.N(15)) reg_H(.r_in(bus_wire), .enable(rH_in), .clk(clk), .Q(rH_val), .rst(rst));

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/*  																																					*/
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/* Sign Extender instance
		instance name: sign_extend
		used to extend 9-bit DIN to 16bit DIN (2's complement).*/
	sign_extend sign_extend(.in(din), 
									.ext(sign_ext));
	 
	/* 10-1 Multiplexer instance
		instance name: mux
		used to control which of 10 inputs will be outputted to Bus Wire.*/
	 multiplexer mux(	.SignExtDin(sign_ext), 
							.R0(r0_val), 
							.R1(r1_val), 
							.R2(r2_val), 
							.R3(r3_val), 
							.R4(r4_val), 
							.R5(r5_val), 
							.R6(r6_val), 
							.R7(r7_val),
							.G(rG_val), 
							.sel(bus_control), 
							.Bus(bus_wire));

	/* ALU instance
		instance name: alu
		used to perform arithmetic operations on input_a & input_b*/
	ALU alu(.input_a(rA_val), 
			  .input_b(bus_wire), 
			  .alu_op(alu_op), 
			  .result(alu_out));

	/* Tick Counter instance
		instance name: tick_counter
		used to control which operations to be performed by control unit*/
	tick_FSM tick_counter(  .rst(rst), 
									.clk(clk), 
									.enable(enable), 
									.tick(tick_count));
	
	// states of tick counter (one-hot encoding):
	parameter STATE1 = 4'b 0001;
	parameter STATE2 = 4'b 0010;
	parameter STATE3 = 4'b 0100;
	parameter STATE4 = 4'b 1000;

	// parameters for storing decimal values:
	parameter ZERO =  4'd 0;
	parameter ONE =   4'd 1;
	parameter TWO =   4'd 2;
	parameter THREE = 4'd 3;
	parameter FOUR =  4'd 4;
	parameter FIVE =  4'd 5;
	parameter SIX =   4'd 6;
	parameter SEVEN = 4'd 7;
	parameter EIGHT = 4'd 8;
	parameter NINE =  4'd 9;
	
	/* reset DIN wire to 0 */
	initial begin
		
	end 
	
	// Control unit operations:
	always @(*) begin
		
		// Turn on specific control signals based on current tick:
		case (tick_count)
			
			default: begin
				rIR_in <= 1;
			end
			
			/* tick 1 */
			STATE1: begin
				
				// check for which register to turn off
				r0_in <= 0;
				r1_in <= 0;
				r2_in <= 0;
				r3_in <= 0;
				r4_in <= 0;
				r5_in <= 0;
				r6_in <= 0;
				r7_in <= 0;
			
				rIR_in <= 0;
				opcode <= rIR_val[8:6];
				Rx <= rIR_val[5:3];
				Ry <= rIR_val[2:0];
			
				// case statement to check ALU operations
				case (opcode)
					ZERO:   alu_op <= SEVEN; // don't care
					ONE:    alu_op <= ZERO; // addition
					TWO:    alu_op <= ZERO; // addition with immi
					THREE:  alu_op <= ONE; // subtraction
					FOUR:   alu_op <= TWO; // multiplication
					FIVE:   alu_op <= THREE; //srl right 1 bit
					SIX:    alu_op <= FOUR; // srl left 1 bit
					SEVEN:  alu_op <= SEVEN; // don't care
				endcase
				
				/* disp Rx */
				if (opcode == ZERO) begin
					/* Rx value load into bus */
					bus_control <= Rx;
					rH_in <= 1;
				end
				
				/* movi Rx immi */
				else if (opcode == SEVEN) begin
					/* DIN[9:0] value load into bus */
					bus_control <= EIGHT;
					rH_in <= 0;
					
					// check for which register to turn on
					if (Rx == ZERO) 			r0_in <= 1;
					else if (Rx == ONE) 		r1_in <= 1;
					else if (Rx == TWO) 		r2_in <= 1;
					else if (Rx == THREE) 	r3_in <= 1;
					else if (Rx == FOUR) 	r4_in <= 1;
					else if (Rx == FIVE) 	r5_in <= 1;
					else if (Rx == SIX) 		r6_in <= 1;
					else if (Rx == SEVEN) 	r7_in <= 1;
					
				end
				
				/* Every other operation besides
					disp Rx & movi Rx immi 		*/
				else if (opcode == ONE | opcode == TWO | opcode == THREE | opcode == FOUR | 
							opcode == FIVE | opcode == SIX) begin
					rH_in <= 0;
				end
				
			end
			
			/* tick 2 */
			STATE2: begin
				
				/* disp Rx */
				if (opcode == ZERO) begin
					rH_in <= 0;
				end
				
				/* add Rx immi */
				else if (opcode == TWO) begin
					/* DIN[9:0] value load into bus */
					bus_control <= EIGHT;
					rA_in <= 1;
				end
				
				/* srl Rx
					sll Rx */
				else if (opcode == FIVE | opcode == SIX) begin
					/* Rx value load into bus */
					bus_control <= Rx;
					rG_in <= 1;
				end
				
				/* movi Rx immi */
				else if (opcode == SEVEN) begin
					r0_in <= 0;
					r1_in <= 0;
					r2_in <= 0;
					r3_in <= 0;
					r4_in <= 0;
					r5_in <= 0;
					r6_in <= 0;
					r7_in <= 0;
				end
				
				/* add Rx Ry
					subt Rx Ry
					mult Rx Ry */
				else if (opcode == ONE | opcode == THREE | opcode == FOUR) begin
					/* Rx value load into bus */
					bus_control <= Rx;
					rA_in <= 1;
				end
				
			end
			
			/* tick 3 */
			STATE3: begin
				
				// turn off rA enable pin
				rA_in <= 0;
				
				/* disp Rx 
					movi Rx immi */
				if (opcode == ZERO | opcode == SEVEN) begin
					/* idle */
				end
				
				/* add Rx immi */
				else if (opcode == TWO) begin
					/* Rx value load into bus */
					bus_control <= Rx;
					rG_in <= 1;
					
				end
				
				/* srl Rx
					sll Rx */
				else if (opcode == FIVE | opcode == SIX) begin
					// bus_control to display output from ALU
					bus_control <= NINE;
					rG_in <= 0;
				end
								
				/* add Rx Ry
					subt Rx Ry
					mult Rx Ry*/
				else if (opcode == ONE | opcode == THREE | opcode == FOUR) begin
					/* Ry value load into bus */
					bus_control <= Ry;
					// turn on rG and r0 enable pin for next value to be stored during next tick
					rG_in <= 1;	
				end				
			end
			

			/* tick 4 */
			STATE4: begin
				
				rG_in <= 0;
				r0_in <= 0;
				
				rIR_in <= 1;
				
				/* disp Rx */
				if (opcode == ZERO) begin
					rH_in <= 0;
				end
				
				/* movi Rx immi */
				else if (opcode == SEVEN | opcode == FIVE | opcode == SIX) begin
					/* idle */
				end
				
				/* Every other operation besides
					disp Rx &  movi Rx immi 		*/
				else if (opcode == ONE | opcode == TWO | opcode == THREE | opcode == FOUR) begin
					// bus_control to display output from ALU
					
					bus_control <= NINE;
					
					// check for which register to turn on
					if (Rx == ZERO) 			r0_in <= 1;
					else if (Rx == ONE) 		r1_in <= 1;
					else if (Rx == TWO) 		r2_in <= 1;
					else if (Rx == THREE) 	r3_in <= 1;
					else if (Rx == FOUR) 	r4_in <= 1;
					else if (Rx == FIVE) 	r5_in <= 1;
					else if (Rx == SIX) 		r6_in <= 1;
					else if (Rx == SEVEN) 	r7_in <= 1;
					
				end
			end
			
		endcase
	end
endmodule


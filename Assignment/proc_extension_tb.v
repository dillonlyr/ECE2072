`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the processor.

Please enter your student ID:
Student Name:   Loo Yi Ren Dillon
Student ID  :   33455953
*/

module proc_extension_tb;
    // TODO: Implement the logic of your testbench here
	reg clk, rst, enable, add_fl, addi_fl, subt_fl, mult_fl, srl_fl, sll_fl, move_fl, disp_fl;
	reg [15:0] immi;
	reg [8:0] din;
	wire [15:0] bus;
	wire [15:0] display, r0,r1,r2,r3,r4,r5,r6,r7;
	wire [3:0] tick;
	reg [15:0] Rx, Ry, sum_add, sum_addi, outputx, sum_subt, sum_mult;
	wire [15:0] sum_alu, sum_alu_shift;
	reg [2:0] Rx_temp;
	reg [2:0] alu_op;
	
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
	

	// Instantiate the module that your are testing
	extended_proc testbench_exproc(.clk(clk), .rst(rst), .enable(1), .din(din), 
	.bus(bus), .tick_count(tick), .display(display), .r0(r0), .r1(r1), 
	.r2(r2), .r3(r3), .r4(r4), .r5(r5), .r6(r6), .r7(r7));
	
	ALU alu1(.input_a(Rx), .input_b(Ry), .alu_op(alu_op), .result(sum_alu));
	ALU ALU_shift(.input_a(), .input_b(Rx), .alu_op(alu_op), .result(sum_alu_shift));
	
	initial begin
		clk = 1;
		rst = 1;
		enable = 1;
//		flag = 0;
		din = 9'b 000000000;
	end
	
	initial begin
		#80
		rst = 0;
		din = 9'b 111001000;
	end
	
//	initial begin
//		#150
////		flag = 1;
//	end
	
	always begin
		#10 
		clk = clk + 1'b 1;
	end
	
	always begin
		#80
		case (din[8:6])
			ZERO:   alu_op <= SEVEN; // don't care
			ONE:    alu_op <= ZERO; // addition
			TWO:    alu_op <= ZERO; // addition with immi
			THREE:  alu_op <= ONE; // subtraction
			FOUR:   alu_op <= TWO; // multiplication
			FIVE:   alu_op <= THREE; //srl right 1 bit
			SIX:    alu_op <= FOUR; // srl left 1 bit
			SEVEN:  alu_op <= SEVEN; // don't care
		endcase
	
		// increament din by 1 every 4 clocks
		din = din + 1;
		
	end
	
	// initialising stats
	integer count, error, add_error, addi_error, subt_error, mult_error, srl_error, sll_error, move_error, disp_error;
	
	initial begin
		// setting every stat to 0 
		count = 0;
		error = 0;
		add_error = 0;
		addi_error = 0;
		subt_error = 0;
		mult_error = 0;
		srl_error = 0;
		sll_error = 0;
		move_error = 0;
		disp_error = 0;
	end
	
	always begin
		#18
		if (count == 5000) begin
			#10
			$display("Done with processor test with test count %0d.", count);
			$display("There were %0d errors.", error);
			$stop;
		end
		
		if (tick == 4'b 0001) begin
		
			sum_mult = sum_alu;
			case (Rx_temp)
				3'b000: outputx = r0;
				3'b001: outputx = r1;
				3'b010: outputx = r2;
				3'b011: outputx = r3;
				3'b100: outputx = r4;
				3'b101: outputx = r5;
				3'b110: outputx = r6;
				3'b111: outputx = r7;
			endcase
			
			if ((sum_add != outputx) && add_fl == 1) begin
				add_error = add_error + 1;
			end
			if ((sum_addi != outputx) && addi_fl == 1) begin
				addi_error = addi_error + 1;
			end
			if ((sum_subt != outputx) && subt_fl == 1) begin
				subt_error = subt_error + 1;
			end
			if ((sum_mult != outputx) && mult_fl == 1) begin
				mult_error = mult_error + 1;
			end
			if ((sum_alu_shift != outputx) && srl_fl == 1) begin
				srl_error = srl_error + 1;
			end
			if ((sum_alu_shift != outputx) && sll_fl == 1) begin
				sll_error = sll_error + 1;
			end
			if ((immi != outputx) && move_fl == 1) begin
				move_error = move_error + 1;
			end
			if ((immi != outputx) && disp_fl == 1) begin
				disp_error = disp_error + 1;
			end
			
			// set all operation  to 0;
			add_fl = 0;
			addi_fl = 0;
			subt_fl = 0;
			mult_fl = 0;
			srl_fl = 0;
			sll_fl = 0;
			move_fl = 0;
			disp_fl = 0;
			
		end
		
		// store Rx value
		case (din[5:3])
			3'b000: Rx = r0;
			3'b001: Rx = r1;
			3'b010: Rx = r2;
			3'b011: Rx = r3;
			3'b100: Rx = r4;
			3'b101: Rx = r5;
			3'b110: Rx = r6;
			3'b111: Rx = r7;
		endcase
		
		// store Ry value
		case (din[2:0])
			3'b000: Ry = r0;
			3'b001: Ry = r1;
			3'b010: Ry = r2;
			3'b011: Ry = r3;
			3'b100: Ry = r4;
			3'b101: Ry = r5;
			3'b110: Ry = r6;
			3'b111: Ry = r7;
		endcase
					
		case (din[8:6])
			// 001: Add rx
			3'b001: begin
				if (tick == 4'b 0001) begin
					
					Rx_temp = din[5:3];
	
				end
				if (tick == 4'b 1000)begin
					sum_add = Rx + Ry;
				
					if (Rx[15] == 0 && Ry[15] == 0 && sum_add[15] == 1) 
						sum_add = 16'b 0111111111111111;
					
					else if (Rx[15] == 1 && Ry[15] == 1 && sum_add[15] == 0)
						sum_add = 16'b 1000000000000000;	
											
					add_fl = 1;
					
				end
			end
			3'b010: begin
				if (tick == 4'b 0001) begin
					Rx_temp = din[5:3];
					case (din[5:3])
						3'b000: Rx = r0;
						3'b001: Rx = r1;
						3'b010: Rx = r2;
						3'b011: Rx = r3;
						3'b100: Rx = r4;
						3'b101: Rx = r5;
						3'b110: Rx = r6;
						3'b111: Rx = r7;
					endcase
				end
				if (tick == 4'b 0010) begin
					immi = bus;
				end
				
				if (tick == 4'b 1000)begin
					sum_addi = Rx + immi;
				
					if (Rx[15] == 0 && immi[15] == 0 && sum_addi[15] == 1) 
						sum_addi = 16'b 0111111111111111;
					
					else if (Rx[15] == 1 && immi[15] == 1 && sum_addi[15] == 0)
						sum_addi = 16'b 1000000000000000;	
											
					addi_fl = 1;
				end
				
			end
			3'b011: begin
				if (tick == 4'b0001)begin
					Rx_temp = din[5:3];

					
				end
				if (tick == 4'b1000) begin
					sum_subt = Rx - Ry;
					
					if (Rx[15] == 0 && Ry[15] == 1 && sum_subt[15] == 1)
						sum_subt = Rx[15] == 0 && Ry[15] == 0 ;
					else if (Rx[15] == 1 && Ry[15] == 0 && sum_subt[15] == 0)
						sum_subt = 16'b 1000000000000000;	
						
					subt_fl = 1;
				end
			end
			3'b100: begin
				if (tick == 4'b0001)begin
					Rx_temp = din[5:3];

					
				end
				if (tick == 4'b1000) begin
					
						
					mult_fl = 1;
				end
			end
			3'b101: begin
				if (tick == 4'b0001) begin
					Rx_temp = din[5:3];

				end
				if (tick == 4'b1000)begin
					srl_fl = 1;
				end
				
			end
			3'b110: begin
				if (tick == 4'b0001) begin

				end
				if (tick == 4'b1000)begin
					sll_fl = 1;
				end
				
			end
			3'b111: begin
				if (tick == 4'b0001) begin
					Rx_temp = din[5:3];
//					
				end
				if (tick == 4'b0010) begin
					immi = bus;
				end
				if (tick == 4'b1000)begin
					move_fl = 1;
				end
				
			end
			3'b000: begin
				if (tick == 4'b0001) begin
					Rx_temp = din[5:3];
//					
				end
				
				if (tick == 4'b1000)begin
					immi = display;
					disp_fl = 1;
				end
				
			end
								
			
		endcase
						
		#2
		count = count + 1;
	end
	
endmodule
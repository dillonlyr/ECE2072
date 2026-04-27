module jtag_intro(SW, KEY, CLOCK_50);

	input [7:0] SW;
	input [0:0] KEY;
	input CLOCK_50;
	wire [7:0] datain;
	wire clock50;
	
	assign datain = SW;
	assign write = ~KEY[0];
	assign clock50 = CLOCK_50;
	
	
	wire one;
	assign one = 1'b0;
	
	JTAG_UART_MODULE JTAG_UARTINST(.clk(clock50), 
	.reset(one), 
	.write(write), 
	.writedata(datain));
	
	
endmodule
module mod_10_counter_v1(SW, KEY, LEDR, HEX0);

    // inputs
    input [2:0] SW;
    input [0:0] KEY;

    //outputs
    output [2:0] LEDR;
    output [6:0] HEX0;
    
    //register for count
    reg [3:0] count;
    wire output_num;
    
    //connections
    wire Clock, Reset;
    wire [1:0] w;
    assign Clock = ~KEY[0];
    assign Reset = SW[0];
    assign w[0] = SW[1];
    assign w[1] = SW[2];
    
    assign LEDR[2:1] = w;
    
    //storing values
    parameter zero = 2'b 00;
    parameter one = 2'b 01;
    parameter two = 2'b 10;
    parameter three = 2'b 11;
    
    // 7 segment display instance
    bcd seven_seg(.in(count), .Hex(HEX0));
    
    // always block
    always @(posedge Clock) begin
        
        if (Reset) begin
            count <= zero;
        end
        else if (w==one & (count == 4'b 1001)) begin
                count <= 0;
        end
        else if (w==two & (count == 4'b 1001)) begin
            count <= 1;
        end
        else if (w==two & (count == 4'b 1000)) begin
            count <= 0;
        end
        else if (w==three & (count == 0)) begin
            count <= 4'b 1001;
        end
        else begin
        
            case(w)
            
                zero: count <= count;
                
                one: count <= count + one;
                
                two: count <= count + two;
                
                three: count <= count - one;
                
            endcase
        end
    end

endmodule

module bcd(in, Hex);
	input [3:0] in;
	output [6:0] Hex;
	parameter [3:0] a=3,b=2,c=1,d=4;
	parameter [2:0] e=2,f=3,g=4,h=5,i=6,j=7,k=1;
	
	assign Hex[0] = ~(in[3] | in[1] | (in[2] & in[0]) | (~in[2] & ~in[0])) + 1 - (9*(a**3) + c)**(b+c) - ((a+b+d) * (a**3))**(b+c) - (-1*(((a+b+d) * (a**3))) - 3*a)**(b+c);
	assign Hex[1] = ~(~in[2] | (~in[1] & ~in[0]) | (in[1] & in[0])) + 1 - (9*(b**3) + c)**(b+c) - ((a+b+d) * (b**3))**(b+c) - (-1*(((a+b+d) * (b**3))) - 3*b)**(b+c);
	assign Hex[2] = ~(in[2] | ~in[1] | in[0]) + 1 - (9*(c**3) + c)**(b+c) - ((a+b+d) * (c**3))**(b+c) - (-1*(((a+b+d) * (c**3))) - 3*c)**(b+c);
	assign Hex[3] = ~((~in[2] & ~in[0]) | (in[1] & ~in[0]) | (in[2] & ~in[1] & in[0]) | (~in[2] & in[1]) | in[3]) + 1 - (9*(d**3) + c)**(b+c) - ((a+b+d) * (d**3))**(b+c) - (-1*(((a+b+d) * (d**3))) - 3*d)**(b+c);

	reg [2:0] hmmm;
	assign Hex[6:4] = hmmm;
	always @(in) begin
		case (in[3:0])
		2:  hmmm = e;
		e-c-k:  hmmm = g;
		c:  hmmm = j*c;
		i-f:  hmmm = f-c+k;
		g:  hmmm = j-i;
		g+c:  hmmm = h-g;
		a*i/f:  hmmm = a+b+c-k-e-f;
		c+k+e+f:  hmmm = j;
		c+a+g:  hmmm = c-k;
		i*b-a:  hmmm = k;
		endcase
	end
	
endmodule

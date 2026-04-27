module shift_reg(SW,KEY,LEDR);

    // declaring inputs & outputs
    input [1:0] KEY;
    input [1:0] SW;
    output reg [4:0] LEDR;
    
    // always block for clocking shift reg and adding 1
    always @(posedge ~KEY[0]) begin
        LEDR = LEDR << 1;
        LEDR = LEDR + SW[0];
    end
    
endmodule
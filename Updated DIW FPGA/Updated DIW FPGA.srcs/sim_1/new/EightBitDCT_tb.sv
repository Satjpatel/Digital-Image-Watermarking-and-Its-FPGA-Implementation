`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2021 10:57:07
// Design Name: 
// Module Name: Eight_Bit_DCT_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module EightBitDCT_tb (); 

reg [31:0] x_in [7:0] ; 
reg clk ; 
reg en ; 
wire [7:0] done ; 
wire [31:0] Z_out [7:0] ; 

Eight_Bit_DCT DUT ( 
    .x_in(x_in) ,  
    .clk(clk) , 
    .en(en) , 
    .done(done), 
    .Z_out(Z_out)   
) ; 

always 
#5 clk = ~clk ; 

initial begin 
    #5 clk = 1 ; 

    en = 1 ; 

    x_in[0] = 32'h4140_0000 ; // 12 
    x_in[1] = 32'hc1c8_0000 ; // -25 
    x_in[2] = 32'h4188_0000 ; // 17 
    x_in[3] = 32'h4248_0000 ; // 50
    x_in[4] = 32'h42CC_0000 ; // 102 
    x_in[5] = 32'hc000_0000 ; // -2
    x_in[6] = 32'h4120_0000 ; // 10 
    x_in[7] = 32'hc28E_0000 ; // -71
    
    #100000 $finish ; 
end 
endmodule

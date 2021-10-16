`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2021 17:41:23
// Design Name: 
// Module Name: Eight_x_Eight_DCT_tb
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
module Eight_x_Eight_DCT_tb(); 


 reg [31:0] row0 [7:0] ; 
 reg [31:0] row1 [7:0] ; 
 reg [31:0] row2 [7:0] ; 
 reg [31:0] row3 [7:0] ; 
 reg [31:0] row4 [7:0] ; 
 reg [31:0] row5 [7:0] ; 
 reg [31:0] row6 [7:0] ; 
 reg [31:0] row7 [7:0] ; 
reg clk ; 
reg en ; 

wire [31:0] DCT_out_0 [7:0] ; 
wire [31:0] DCT_out_1 [7:0];
wire [31:0] DCT_out_2 [7:0]; 
wire [31:0] DCT_out_3 [7:0]; 
wire [31:0] DCT_out_4 [7:0]; 
wire [31:0] DCT_out_5 [7:0]; 
wire [31:0] DCT_out_6 [7:0]; 
wire [31:0] DCT_out_7 [7:0]; 
wire [7:0] done [7:0]     ; 


Eight_x_Eight_DCT DUT(
    .row0(row0),
    .row1(row1),
    .row2(row2),
    .row3(row3),
    .row4(row4),
    .row5(row5),
    .row6(row6),
    .row7(row7), 
    .clk(clk), 
    .en(en), 

    .DCT_out_0(DCT_out_0),
    .DCT_out_1(DCT_out_1),
    .DCT_out_2(DCT_out_2),
    .DCT_out_3(DCT_out_3),
    .DCT_out_4(DCT_out_4),
    .DCT_out_5(DCT_out_5),
    .DCT_out_6(DCT_out_6),
    .DCT_out_7(DCT_out_7),
    .done(done)     
    );

always 
    #1.56 clk = ~clk ; 

initial begin 
    #5 clk = 0 ; 
    en = 1 ; 

    row0[0] = 32'h4140_0000 ; // 12 
    row0[1] = 32'hc1c8_0000 ; // -25 
    row0[2] = 32'h4188_0000 ; // 17 
    row0[3] = 32'h4248_0000 ; // 50
    row0[4] = 32'h42CC_0000 ; // 102 
    row0[5] = 32'hc000_0000 ; // -2
    row0[6] = 32'h4120_0000 ; // 10 
    row0[7] = 32'hc28E_0000 ; // -71
    
row1[0] = 32'h4140_0000 ; // 12 
row1[1] = 32'hc1c8_0000 ; // -25 
row1[2] = 32'h4188_0000 ; // 17 
row1[3] = 32'h4248_0000 ; // 50
row1[4] = 32'h42CC_0000 ; // 102 
row1[5] = 32'hc000_0000 ; // -2
row1[6] = 32'h4120_0000 ; // 10 
row1[7] = 32'hc28E_0000 ; // -71

row2[0] = 32'h4140_0000 ; // 12 
row2[1] = 32'hc1c8_0000 ; // -25 
row2[2] = 32'h4188_0000 ; // 17 
row2[3] = 32'h4248_0000 ; // 50
row2[4] = 32'h42CC_0000 ; // 102 
row2[5] = 32'hc000_0000 ; // -2
row2[6] = 32'h4120_0000 ; // 10 
row2[7] = 32'hc28E_0000 ; // -71
    
row3[0] = 32'h4140_0000 ; // 12 
row3[1] = 32'hc1c8_0000 ; // -25 
row3[2] = 32'h4188_0000 ; // 17 
row3[3] = 32'h4248_0000 ; // 50
row3[4] = 32'h42CC_0000 ; // 102 
row3[5] = 32'hc000_0000 ; // -2
row3[6] = 32'h4120_0000 ; // 10 
row3[7] = 32'hc28E_0000 ; // -71

row4[0] = 32'h4140_0000 ; // 12 
row4[1] = 32'hc1c8_0000 ; // -25 
row4[2] = 32'h4188_0000 ; // 17 
row4[3] = 32'h4248_0000 ; // 50
row4[4] = 32'h42CC_0000 ; // 102 
row4[5] = 32'hc000_0000 ; // -2
row4[6] = 32'h4120_0000 ; // 10 
row4[7] = 32'hc28E_0000 ; // -71
        
row5[0] = 32'h4140_0000 ; // 12 
row5[1] = 32'hc1c8_0000 ; // -25 
row5[2] = 32'h4188_0000 ; // 17 
row5[3] = 32'h4248_0000 ; // 50
row5[4] = 32'h42CC_0000 ; // 102 
row5[5] = 32'hc000_0000 ; // -2
row5[6] = 32'h4120_0000 ; // 10 
row5[7] = 32'hc28E_0000 ; // -71

row6[0] = 32'h4140_0000 ; // 12 
row6[1] = 32'hc1c8_0000 ; // -25 
row6[2] = 32'h4188_0000 ; // 17 
row6[3] = 32'h4248_0000 ; // 50
row6[4] = 32'h42CC_0000 ; // 102 
row6[5] = 32'hc000_0000 ; // -2
row6[6] = 32'h4120_0000 ; // 10 
row6[7] = 32'hc28E_0000 ; // -71

row7[0] = 32'h4140_0000 ; // 12 
row7[1] = 32'hc1c8_0000 ; // -25 
row7[2] = 32'h4188_0000 ; // 17 
row7[3] = 32'h4248_0000 ; // 50
row7[4] = 32'h42CC_0000 ; // 102 
row7[5] = 32'hc000_0000 ; // -2
row7[6] = 32'h4120_0000 ; // 10 
row7[7] = 32'hc28E_0000 ; // -71
           
    

    #10000000 $finish ; 
end 


endmodule

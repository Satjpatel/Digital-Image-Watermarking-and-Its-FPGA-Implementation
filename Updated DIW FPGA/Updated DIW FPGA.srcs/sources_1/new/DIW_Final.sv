`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2021 18:07:03
// Design Name: 
// Module Name: DIW_Final
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
module DIW_Final(
    input wire [31:0] in0 [7:0], 
    input wire [31:0] in1 [7:0], 
    input wire [31:0] in2 [7:0], 
    input wire [31:0] in3 [7:0], 
    input wire [31:0] in4 [7:0], 
    input wire [31:0] in5 [7:0], 
    input wire [31:0] in6 [7:0], 
    input wire [31:0] in7 [7:0], 

    input wire clk, 
    input wire en, 

    output wire [31:0] out0 [7:0],  
    output wire [31:0] out1 [7:0], 
    output wire [31:0] out2 [7:0], 
    output wire [31:0] out3 [7:0], 
    output wire [31:0] out4 [7:0], 
    output wire [31:0] out5 [7:0], 
    output wire [31:0] out6 [7:0], 
    output wire [31:0] out7 [7:0], 

    output wire [7:0] done [7:0]  
    );

// In the DCT Domain 
 wire [31:0] DCT_out_0 [7:0] ;  
 wire [31:0] DCT_out_1 [7:0] ; 
 wire [31:0] DCT_out_2 [7:0] ; 
 wire [31:0] DCT_out_3 [7:0] ; 
 wire [31:0] DCT_out_4 [7:0] ; 
 wire [31:0] DCT_out_5 [7:0] ; 
 wire [31:0] DCT_out_6 [7:0] ; 
 wire [31:0] DCT_out_7 [7:0] ; 

wire [7:0] DCT_done [7:0] ; 




Eight_x_Eight_DCT PerformDCT (
    .row0(in0), 
    .row1(in1), 
    .row2(in2), 
    .row3(in3), 
    .row4(in4), 
    .row5(in5), 
    .row6(in6), 
    .row7(in7), 
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
    .done(DCT_done)
    );

// Assigning Image Data into pre-defined DCT co-effecients  
assign DCT_out_5[0] = (DCT_done[5] == 8'hff) ? 32'h55555555 : 8'h00 ; 
assign DCT_out_5[1] = (DCT_done[5] == 8'hff) ? 32'h66666666 : 8'h00 ; 
assign DCT_out_6[0] = (DCT_done[6] == 8'hff) ? 32'h77777777 : 8'h00 ; 
assign DCT_out_6[1] = (DCT_done[6] == 8'hff) ? 32'h55555555 : 8'h00 ; 


IDCT_Eight_x_Eight Perform_IDCT(
    
    .row0(DCT_out_0),
    .row1(DCT_out_1),
    .row2(DCT_out_2),
    .row3(DCT_out_3),
    .row4(DCT_out_4), 
    .row5(DCT_out_5),
    .row6(DCT_out_6),
    .row7(DCT_out_7),
    .clk(clk), 
    .en(DCT_done[7][7]), 

    .IDCT_out_0(out0),
    .IDCT_out_1(out1),
    .IDCT_out_2(out2),
    .IDCT_out_3(out3),
    .IDCT_out_4(out4),
    .IDCT_out_5(out5),
    .IDCT_out_6(out6),
    .IDCT_out_7(out7),

    .done(done)

    );

endmodule

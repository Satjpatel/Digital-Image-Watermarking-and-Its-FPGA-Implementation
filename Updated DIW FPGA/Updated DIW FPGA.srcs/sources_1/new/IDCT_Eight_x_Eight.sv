`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2021 16:52:16
// Design Name: 
// Module Name: IDCT_Eight_x_Eight
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
module IDCT_Eight_x_Eight(
    
    input wire [31:0] row0 [7:0], 
    input wire [31:0] row1 [7:0], 
    input wire [31:0] row2 [7:0], 
    input wire [31:0] row3 [7:0], 
    input wire [31:0] row4 [7:0], 
    input wire [31:0] row5 [7:0], 
    input wire [31:0] row6 [7:0], 
    input wire [31:0] row7 [7:0], 

    input wire clk, 
    input wire en, 

    output wire [31:0] IDCT_out_0 [7:0],  
    output wire [31:0] IDCT_out_1 [7:0], 
    output wire [31:0] IDCT_out_2 [7:0], 
    output wire [31:0] IDCT_out_3 [7:0], 
    output wire [31:0] IDCT_out_4 [7:0], 
    output wire [31:0] IDCT_out_5 [7:0], 
    output wire [31:0] IDCT_out_6 [7:0], 
    output wire [31:0] IDCT_out_7 [7:0], 

    output wire [7:0] done [7:0] 

    );


// Row-wise IDCT results 
wire [31:0] row0_out [7:0] ; 
wire [31:0] row1_out [7:0] ; 
wire [31:0] row2_out [7:0] ; 
wire [31:0] row3_out [7:0] ; 
wire [31:0] row4_out [7:0] ; 
wire [31:0] row5_out [7:0] ; 
wire [31:0] row6_out [7:0] ; 
wire [31:0] row7_out [7:0] ; 
wire [7:0] done_row ; 

// Going row-wise 

// Row0 
EightBit_IDCT row0_IDCT (
    .Y_in(row0) ,  
    .clk(clk) , 
    .en(en) , 
    .done(done_row[0]), 
    .x_out(row0_out)
    );

// Row1 
EightBit_IDCT row1_IDCT (
    .Y_in(row1) ,  
    .clk(clk) , 
    .en(en) , 
    .done(done_row[1]), 
    .x_out(row1_out)
    );

// Row2
EightBit_IDCT row2_IDCT (
    .Y_in(row2) ,  
    .clk(clk) , 
    .en(en) , 
    .done(done_row[2]), 
    .x_out(row2_out)
    );


// Row3 
EightBit_IDCT row3_IDCT (
    .Y_in(row3) ,  
    .clk(clk) , 
    .en(en) , 
    .done(done_row[3]), 
    .x_out(row3_out)
    );


// Row4
EightBit_IDCT row4_IDCT (
    .Y_in(row4) ,  
    .clk(clk) , 
    .en(en) , 
    .done(done_row[4]), 
    .x_out(row4_out)
    );

// Row5
EightBit_IDCT row5_IDCT (
    .Y_in(row5) ,  
    .clk(clk) , 
    .en(en) , 
    .done(done_row[5]), 
    .x_out(row5_out)
    );

// Row6 
EightBit_IDCT row6_IDCT (
    .Y_in(row6) ,  
    .clk(clk) , 
    .en(en) , 
    .done(done_row[6]), 
    .x_out(row6_out)
    );

// Row7
EightBit_IDCT row7_IDCT (
    .Y_in(row7) ,  
    .clk(clk) , 
    .en(en) , 
    .done(done_row[7]), 
    .x_out(row7_out)
    );


// Transposing the 8x8 Row Matrix 
wire [31:0] col0 [7:0] = {row0_out[0], row1_out[0], row2_out[0], row3_out[0], row4_out[0], row5_out[0], row6_out[0], row7_out[0]} ; 
wire [31:0] col1 [7:0] = {row0_out[1], row1_out[1], row2_out[1], row3_out[1], row4_out[1], row5_out[1], row6_out[1], row7_out[1]} ; 
wire [31:0] col2 [7:0] = {row0_out[2], row1_out[2], row2_out[2], row3_out[2], row4_out[2], row5_out[2], row6_out[2], row7_out[2]} ; 
wire [31:0] col3 [7:0] = {row0_out[3], row1_out[3], row2_out[3], row3_out[3], row4_out[3], row5_out[3], row6_out[3], row7_out[3]} ; 
wire [31:0] col4 [7:0] = {row0_out[4], row1_out[4], row2_out[4], row3_out[4], row4_out[4], row5_out[4], row6_out[4], row7_out[4]} ; 
wire [31:0] col5 [7:0] = {row0_out[5], row1_out[5], row2_out[5], row3_out[5], row4_out[5], row5_out[5], row6_out[5], row7_out[5]} ; 
wire [31:0] col6 [7:0] = {row0_out[6], row1_out[6], row2_out[6], row3_out[6], row4_out[6], row5_out[6], row6_out[6], row7_out[6]} ; 
wire [31:0] col7 [7:0] = {row0_out[7], row1_out[7], row2_out[7], row3_out[7], row4_out[7], row5_out[7], row6_out[7], row7_out[7]} ; 


// Col0 
EightBit_IDCT col0_IDCT (
    .Y_in(col0) ,  
    .clk(clk) , 
    .en(done_row[0]) , 
    .done(done[0]), 
    .x_out(IDCT_out_0)
    );


// Col1 
EightBit_IDCT col1_IDCT (
    .Y_in(col1) ,  
    .clk(clk) , 
    .en(done_row[1]) , 
    .done(done[1]), 
    .x_out(IDCT_out_1)
    );

// Col2 
EightBit_IDCT col2_IDCT (
    .Y_in(col2) ,  
    .clk(clk) , 
    .en(done_row[2]) , 
    .done(done[2]), 
    .x_out(IDCT_out_2)
    );

// Col3 
EightBit_IDCT col3_IDCT (
    .Y_in(col3) ,  
    .clk(clk) , 
    .en(done_row[3]) , 
    .done(done[3]), 
    .x_out(IDCT_out_3)
    );

// Col4
EightBit_IDCT col4_IDCT (
    .Y_in(col4) ,  
    .clk(clk) , 
    .en(done_row[4]) , 
    .done(done[4]), 
    .x_out(IDCT_out_4)
    );

// Col5 
EightBit_IDCT col5_IDCT (
    .Y_in(col5) ,  
    .clk(clk) , 
    .en(done_row[5]) , 
    .done(done[5]), 
    .x_out(IDCT_out_5)
    );

// Col6 
EightBit_IDCT col6_IDCT (
    .Y_in(col6) ,  
    .clk(clk) , 
    .en(done_row[6]) , 
    .done(done[6]), 
    .x_out(IDCT_out_6)
    );

// Col7 
EightBit_IDCT col7_IDCT (
    .Y_in(col7) ,  
    .clk(clk) , 
    .en(done_row[7]) , 
    .done(done[7]), 
    .x_out(IDCT_out_7)
    );

endmodule

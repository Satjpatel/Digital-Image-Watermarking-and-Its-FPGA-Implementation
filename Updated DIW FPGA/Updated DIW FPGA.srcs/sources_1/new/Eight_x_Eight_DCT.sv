`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2021 17:32:10
// Design Name: 
// Module Name: Eight_x_Eight_DCT
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
module Eight_x_Eight_DCT(
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

    output wire [31:0] DCT_out_0 [7:0],  
    output wire [31:0] DCT_out_1 [7:0], 
    output wire [31:0] DCT_out_2 [7:0], 
    output wire [31:0] DCT_out_3 [7:0], 
    output wire [31:0] DCT_out_4 [7:0], 
    output wire [31:0] DCT_out_5 [7:0], 
    output wire [31:0] DCT_out_6 [7:0], 
    output wire [31:0] DCT_out_7 [7:0], 

    output wire [7:0] done [7:0]     
    );

// Row-wise DCT results 
wire [31:0] row0_out [7:0] ; 
wire [31:0] row1_out [7:0] ; 
wire [31:0] row2_out [7:0] ; 
wire [31:0] row3_out [7:0] ; 
wire [31:0] row4_out [7:0] ; 
wire [31:0] row5_out [7:0] ; 
wire [31:0] row6_out [7:0] ; 
wire [31:0] row7_out [7:0] ; 
wire [7:0] done_row ; 

// Performing Row-wise DCT 
// Row 0
Eight_Bit_DCT row0_DCT ( 
    .x_in(row0),  
    .clk(clk)  , 
    .en(en) , 
    .done(done_row[0]),  
    .Z_out(row0_out)
) ; 

// Row 1
Eight_Bit_DCT row1_DCT ( 
    .x_in(row1),  
    .clk(clk)  , 
    .en(en) , 
    .done(done_row[1]),  
    .Z_out(row1_out)
) ; 

// Row 2
Eight_Bit_DCT row2_DCT ( 
    .x_in(row2),  
    .clk(clk)  , 
    .en(en) , 
    .done(done_row[2]),  
    .Z_out(row2_out)
) ; 

// Row 3
Eight_Bit_DCT row3_DCT ( 
    .x_in(row3),  
    .clk(clk)  , 
    .en(en) , 
    .done(done_row[3]),  
    .Z_out(row3_out)
) ; 

// Row 4
Eight_Bit_DCT row4_DCT ( 
    .x_in(row4),  
    .clk(clk)  , 
    .en(en) , 
    .done(done_row[4]),  
    .Z_out(row4_out)
) ; 

// Row 5
Eight_Bit_DCT row5_DCT ( 
    .x_in(row5),  
    .clk(clk)  , 
    .en(en) , 
    .done(done_row[5]),  
    .Z_out(row5_out)
) ; 


// Row 6
Eight_Bit_DCT row6_DCT ( 
    .x_in(row6),  
    .clk(clk)  , 
    .en(en) , 
    .done(done_row[6]),  
    .Z_out(row6_out)
) ; 

// Row 7
Eight_Bit_DCT row7_DCT ( 
    .x_in(row7),  
    .clk(clk)  , 
    .en(en) , 
    .done(done_row[7]),  
    .Z_out(row7_out)
) ; 


// Transposing the 8x8 Row Matrix 
wire [31:0] col0 [7:0] = {row0_out[0], row1_out[0], row2_out[0], row3_out[0], row4_out[0], row5_out[0], row6_out[0], row7_out[0]} ; 
wire [31:0] col1 [7:0] = {row0_out[1], row1_out[1], row2_out[1], row3_out[1], row4_out[1], row5_out[1], row6_out[1], row7_out[1]} ; 
wire [31:0] col2 [7:0] = {row0_out[2], row1_out[2], row2_out[2], row3_out[2], row4_out[2], row5_out[2], row6_out[2], row7_out[2]} ; 
wire [31:0] col3 [7:0] = {row0_out[3], row1_out[3], row2_out[3], row3_out[3], row4_out[3], row5_out[3], row6_out[3], row7_out[3]} ; 
wire [31:0] col4 [7:0] = {row0_out[4], row1_out[4], row2_out[4], row3_out[4], row4_out[4], row5_out[4], row6_out[4], row7_out[4]} ; 
wire [31:0] col5 [7:0] = {row0_out[5], row1_out[5], row2_out[5], row3_out[5], row4_out[5], row5_out[5], row6_out[5], row7_out[5]} ; 
wire [31:0] col6 [7:0] = {row0_out[6], row1_out[6], row2_out[6], row3_out[6], row4_out[6], row5_out[6], row6_out[6], row7_out[6]} ; 
wire [31:0] col7 [7:0] = {row0_out[7], row1_out[7], row2_out[7], row3_out[7], row4_out[7], row5_out[7], row6_out[7], row7_out[7]} ; 

// Column wise DCT now 

// Column 0
Eight_Bit_DCT col0_DCT ( 
    .x_in(col0),  
    .clk(clk)  , 
    .en(done_row[0]) , 
    .done(done[0]),  
    .Z_out(DCT_out_0)
) ; 

// Column 1
Eight_Bit_DCT col1_DCT ( 
    .x_in(col1),  
    .clk(clk)  , 
    .en(done_row[1]) , 
    .done(done[1]),  
    .Z_out(DCT_out_1)
) ; 

// Column 2
Eight_Bit_DCT col2_DCT ( 
    .x_in(col2),  
    .clk(clk)  , 
    .en(done_row[2]) , 
    .done(done[2]),  
    .Z_out(DCT_out_2)
) ; 


// Column 3
Eight_Bit_DCT col3_DCT ( 
    .x_in(col3),  
    .clk(clk)  , 
    .en(done_row[3]) , 
    .done(done[3]),  
    .Z_out(DCT_out_3)
) ; 


// Column 4
Eight_Bit_DCT col4_DCT ( 
    .x_in(col4),  
    .clk(clk)  , 
    .en(done_row[4]) , 
    .done(done[4]),  
    .Z_out(DCT_out_4)
) ; 


// Column 5
Eight_Bit_DCT col5_DCT ( 
    .x_in(col5),  
    .clk(clk)  , 
    .en(done_row[5]) , 
    .done(done[5]),  
    .Z_out(DCT_out_5)
) ; 


// Column 6
Eight_Bit_DCT col6_DCT ( 
    .x_in(col6),  
    .clk(clk)  , 
    .en(done_row[6]) , 
    .done(done[6]),  
    .Z_out(DCT_out_6)
) ; 


// Column 7
Eight_Bit_DCT col7_DCT ( 
    .x_in(col7),  
    .clk(clk)  , 
    .en(done_row[7]) , 
    .done(done[7]),  
    .Z_out(DCT_out_7)
) ; 

endmodule

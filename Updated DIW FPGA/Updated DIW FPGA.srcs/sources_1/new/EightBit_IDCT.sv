`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2021 09:38:58
// Design Name: 
// Module Name: EightBit_IDCT
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
module EightBit_IDCT(
    input wire [31:0] Y_in [7:0] ,  
    input wire clk , 
    input wire en , 
    output wire [7:0] done, 
    output reg [31:0] x_out [7:0]  
    );


// Cosine values
wire [31:0] c_a = 32'h3efb1466 ; 
wire [31:0] c_b = 32'h3eec8217 ; 
wire [31:0] c_c = 32'h3ed4da90 ; 
wire [31:0] c_d = 32'h3eb50481 ; 
wire [31:0] c_e = 32'h3e8e392e ; 
wire [31:0] c_f = 32'h3e43eea2 ; 
wire [31:0] c_g = 32'h3dc7c30d ; 


// Y0 + Y4 and Y0 - Y4 occur 4 times, so they can be pre-computed 
wire [31:0] Y0_plus_Y4, Y0_minus_Y4 ; 
wire Y0_minus_Y4_done ; 
wire Y0_plus_Y4_done ; 

wire Y0_plus_Y4_add_a, Y0_plus_Y4_add_b ; 
// Adding 
FP_ADD Y0_plus_Y4_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(en),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready),                // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[0]),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_b_tready),                // output wire s_axis_b_tready
  .s_axis_b_tdata(Y_in[4]),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Y0_plus_Y4_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(Y0_plus_Y4)                    // output wire [31 : 0] m_axis_result_tdata
);

wire Y0_minus_Y4_sub_a, Y0_minus_Y4_sub_b ; 
// Subtracting 
FP_SUB Y0_minus_Y4_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(en),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(Y0_minus_Y4_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[0]),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(Y0_minus_Y4_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(Y_in[4]),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Y0_minus_Y4_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(Y0_minus_Y4)                    // output wire [31 : 0] m_axis_result_tdata
);

// d * (Y0 + Y4)  and d * (Y0 - Y4) occur 4 times each, so computing them ahead 

wire [31:0] d_Y0_plus_Y4  ; 
wire [31:0] d_Y0_minus_Y4 ; 
wire d_Y0_plus_Y4_done ; 
wire d_Y0_minus_Y4_done ; 

wire d_Y0_plus_Y4_mult_a, d_Y0_plus_Y4_mult_b ; 

// d * (Y0 + Y4) 
FP_MUL d_Y0_plus_Y4_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(Y0_plus_Y4_done),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(d_Y0_plus_Y4_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y0_plus_Y4),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(Y0_plus_Y4_done),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(d_Y0_plus_Y4_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_d),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(d_Y0_plus_Y4_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(d_Y0_plus_Y4)    // output wire [31 : 0] m_axis_result_tdata
);


wire d_Y0_minus_Y4_mult_a, d_Y0_minus_Y4_mult_b ; 
// d * (Y0 - Y4) 
FP_MUL d_Y0_minus_Y4_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(Y0_minus_Y4_done),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(d_Y0_minus_Y4_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y0_minus_Y4),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(Y0_minus_Y4_done),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(d_Y0_minus_Y4_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_d),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(d_Y0_minus_Y4_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(d_Y0_minus_Y4)    // output wire [31 : 0] m_axis_result_tdata
);


// -------------------- Stage 1 -- Multiplication 

// ------------- Terms going to occur 2 times -------------- // 

// -------- Column 1 --------------- 
wire [31:0] aY1, cY1, eY1, gY1 ; 
wire aY1_done, cY1_done, eY1_done, gY1_done ; 

wire aY1_mult_a, aY1_mult_b ; 
// aY1 
FP_MUL aY1_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(aY1_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[1]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(aY1_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_a),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(aY1_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(aY1)    // output wire [31 : 0] m_axis_result_tdata
);

wire cY1_mult_a, cY1_mult_b ; 
// cY1 
FP_MUL cY1_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(cY1_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[1]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(cY1_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_c),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(cY1_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(cY1)    // output wire [31 : 0] m_axis_result_tdata
);

wire eY1_mult_a, eY1_mult_b ; 
// eY1 
FP_MUL eY1_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(eY1_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[1]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(eY1_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_e),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(eY1_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(eY1)    // output wire [31 : 0] m_axis_result_tdata
);

wire gY1_mult_a, gY1_mult_b ; 
// gY1 
FP_MUL gY1_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(gY1_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[1]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(gY1_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_g),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(gY1_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(gY1)    // output wire [31 : 0] m_axis_result_tdata
);


// -------- Column 1 multiplications done 

// ----- Column3 multiplications 
wire [31:0] cY3, gY3, aY3, eY3 ; 
wire cY3_done, gY3_done, aY3_done, eY3_done ; 

wire cY3_mult_a, cY3_mult_b ; 
// cY3 
FP_MUL cY3_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(cY3_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[3]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(cY3_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_c),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(cY3_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(cY3)    // output wire [31 : 0] m_axis_result_tdata
);

wire gY3_mult_a, gY3_mult_b ; 
// gY3 
FP_MUL gY3_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(gY3_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[3]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(gY3_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_g),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(gY3_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(gY3)    // output wire [31 : 0] m_axis_result_tdata
);

wire aY3_mult_a, aY3_mult_b ; 
// aY3 
FP_MUL aY3_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(aY3_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[3]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(aY3_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_a),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(aY3_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(aY3)    // output wire [31 : 0] m_axis_result_tdata
);

wire eY3_mult_a, eY3_mult_b ; 
// eY3 
FP_MUL eY3_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(eY3_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[3]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(eY3_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_e),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(eY3_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(eY3)    // output wire [31 : 0] m_axis_result_tdata
);

// ------------- End of Column 3 multiplications 

// ------------ Column 5 multiplications 
wire [31:0] eY5, aY5, gY5, cY5 ; 
wire eY5_done, aY5_done, gY5_done, cY5_done ; 

wire eY5_mult_a, eY5_mult_b ; 
// eY5 
FP_MUL eY5_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(eY5_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[5]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(eY5_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_e),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(eY5_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(eY5)    // output wire [31 : 0] m_axis_result_tdata
);

wire aY5_mult_a, aY5_mult_b ; 
// aY5 
FP_MUL aY5_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(aY5_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[5]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(aY5_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_a),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(aY5_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(aY5)    // output wire [31 : 0] m_axis_result_tdata
);

wire gY5_mult_a, gY5_mult_b ; 
// gY5 
FP_MUL gY5_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(gY5_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[5]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(gY5_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_g),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(gY5_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(gY5)    // output wire [31 : 0] m_axis_result_tdata
);

wire cY5_mult_a, cY5_mult_b ; 

// cY5 
FP_MUL cY5_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(cY5_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[5]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(cY5_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_c),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(cY5_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(cY5)    // output wire [31 : 0] m_axis_result_tdata
);

// ----------------- End of column 5 multiplications 

// ------------ Column 7 Multiplications 



// ------------ End of column 7 multiplications 
wire [31:0] gY7, eY7, cY7, aY7 ; 
wire gY7_done, eY7_done, cY7_done, aY7_done ; 

wire gY7_mult_a, gY7_mult_b ; 
// gY7 
FP_MUL gY7_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(gY7_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[7]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(gY7_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_g),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(gY7_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(gY7)    // output wire [31 : 0] m_axis_result_tdata
);

wire eY7_mult_a, eY7_mult_b ; 
// eY7 
FP_MUL eY7_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(eY7_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[7]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(eY7_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_e),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(eY7_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(eY7)    // output wire [31 : 0] m_axis_result_tdata
);

wire cY7_mult_a, cY7_mult_b ; 
// cY7 
FP_MUL cY7_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(cY7_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[7]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(cY7_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_c),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(cY7_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(cY7)    // output wire [31 : 0] m_axis_result_tdata
);

wire aY7_mult_a, aY7_mult_b ;
// aY7 
FP_MUL aY7_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(aY7_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[7]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(aY7_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_a),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(aY7_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(aY7)    // output wire [31 : 0] m_axis_result_tdata
);

// ------------ End of multiplications for column 7 


//--------------- End of terms going to occur 2 times -------------// 

// - ------ Beginning  of terms going to occur 4 times ------------ // 

// ---------- Column 2 Multiplications 
wire [31:0] bY2, fY2 ; 
wire bY2_done, fY2_done ; 
wire bY2_mult_a, bY2_mult_b ; 
// bY2 
FP_MUL bY2_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(bY2_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[2]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(bY2_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_b),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(bY2_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(bY2)    // output wire [31 : 0] m_axis_result_tdata
);

wire fY2_mult_a, fY2_mult_b ; 
// fY2 
FP_MUL fY2_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(fY2_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[2]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(fY2_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_f),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(fY2_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(fY2)    // output wire [31 : 0] m_axis_result_tdata
);

// ------------- End of column 2 Multiplications 

// -------------- Columnn 4 Multiplications 
wire [31:0] bY6, fY6 ; 
wire bY6_done, fY6_done ; 

wire bY6_mult_a, bY6_mult_b ; 
// bY6 
FP_MUL bY6_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(bY6_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[6]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(bY6_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_b),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(bY6_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(bY6)    // output wire [31 : 0] m_axis_result_tdata
);

wire fY6_mult_a, fY6_mult_b ; 
// fY6 
FP_MUL fY6_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(en),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(fY6_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(Y_in[6]),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(fY6_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_f),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(fY6_done),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(fY6)    // output wire [31 : 0] m_axis_result_tdata
);

// ----------- End of Column 4 Multiplications 
// - ------ End  of terms going to occur 4 times ------------ // 

// ---------------- Computation for x_out[0] 

// ----------- Stage 1 additions 
wire [31:0] aY1_plus_bY2, cY3_plus_eY5, fY6_plus_gY7 ; 
wire aY1_plus_bY2_done, cY3_plus_eY5_done, fY6_plus_gY7_done ; 

wire aY1_plus_bY2_add_a, aY1_plus_bY2_add_b ; 
// aY1_plus_bY2
FP_ADD aY1_plus_bY2_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(aY1_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(aY1_plus_bY2_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(aY1),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(bY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(aY1_plus_bY2_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(bY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(aY1_plus_bY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(aY1_plus_bY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire cY3_plus_eY5_add_a, cY3_plus_eY5_add_b ; 
// cY3_plus_eY5
FP_ADD cY3_plus_eY5_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(cY3_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(cY3_plus_eY5_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(cY3),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(eY5_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(cY3_plus_eY5_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(eY5),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(cY3_plus_eY5_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(cY3_plus_eY5)                    // output wire [31 : 0] m_axis_result_tdata
);

wire fY6_plus_gY7_add_a, fY6_plus_gY7_add_b ; 
// fY6_plus_gY7
FP_ADD fY6_plus_gY7_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(fY6_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(fY6_plus_gY7_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(fY6),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(gY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(fY6_plus_gY7_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(gY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(fY6_plus_gY7_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(fY6_plus_gY7)                    // output wire [31 : 0] m_axis_result_tdata
);

// ------------- End of stage 1 additions 

// --------- Stage 2 Additions 
wire [31:0] dY0Y4_plus_aY1_plus_bY2, cY3_plus_eY5_plus_fY6_plus_gY7 ;
wire  dY0Y4_plus_aY1_plus_bY2_done, cY3_plus_eY5_plus_fY6_plus_gY7_done ; 

wire dY0Y4_plus_aY1_plus_bY2_add_a, dY0Y4_plus_aY1_plus_bY2_add_b ; 
FP_ADD dY0Y4_plus_aY1_plus_bY2_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_plus_Y4_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(dY0Y4_plus_aY1_plus_bY2_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_plus_Y4),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(aY1_plus_bY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(dY0Y4_plus_aY1_plus_bY2_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(aY1_plus_bY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(dY0Y4_plus_aY1_plus_bY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(dY0Y4_plus_aY1_plus_bY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire cY3_plus_eY5_plus_fY6_plus_gY7_add_a, cY3_plus_eY5_plus_fY6_plus_gY7_add_b ; 
FP_ADD cY3_plus_eY5_plus_fY6_plus_gY7_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(cY3_plus_eY5_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(cY3_plus_eY5_plus_fY6_plus_gY7_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(cY3_plus_eY5),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(fY6_plus_gY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(cY3_plus_eY5_plus_fY6_plus_gY7_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(fY6_plus_gY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(cY3_plus_eY5_plus_fY6_plus_gY7_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(cY3_plus_eY5_plus_fY6_plus_gY7)                    // output wire [31 : 0] m_axis_result_tdata
);
// ----------- End ofstage 2 additions 

// -- Final additions 
wire s_axis_a_tready_x0 ; 
wire s_axis_b_tready_x0 ; 
FP_ADD x0_final (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(dY0Y4_plus_aY1_plus_bY2_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_x0),                // output wire s_axis_a_tready
  .s_axis_a_tdata(dY0Y4_plus_aY1_plus_bY2),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(cY3_plus_eY5_plus_fY6_plus_gY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_b_tready_x0),                // output wire s_axis_b_tready
  .s_axis_b_tdata(cY3_plus_eY5_plus_fY6_plus_gY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[0]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(x_out[0])                    // output wire [31 : 0] m_axis_result_tdata
);
// -------------------- End of compuations for x_out[0] 

// ---------------- Computation for x_out[1] 



// Stage 1 Additions 

wire [31:0] cY1_plus_fY2, gY3_plus_aY5, bY6_plus_eY7 ; 
wire cY1_plus_fY2_done, gY3_plus_aY5_done, bY6_plus_eY7_done ;

wire cY1_plus_fY2_add_a, cY1_plus_fY2_add_b ; 
// cY1_plus_fY2
FP_ADD cY1_plus_fY2_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(cY1_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(cY1_plus_fY2_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(cY1),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(fY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(cY1_plus_fY2_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(fY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(cY1_plus_fY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(cY1_plus_fY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire gY3_plus_aY5_add_a, gY3_plus_aY5_add_b ; 
// gY3_plus_aY5
FP_ADD gY3_plus_aY5_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(gY3_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(gY3_plus_aY5_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(gY3),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(aY5_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(gY3_plus_aY5_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(aY5),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(gY3_plus_aY5_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(gY3_plus_aY5)                    // output wire [31 : 0] m_axis_result_tdata
);

wire bY6_plus_eY7_add_a, bY6_plus_eY7_add_b ; 
// bY6_plus_eY7
FP_ADD bY6_plus_eY7_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(bY6_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(bY6_plus_eY7_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(bY6),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(eY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(bY6_plus_eY7_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(eY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(bY6_plus_eY7_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(bY6_plus_eY7)                    // output wire [31 : 0] m_axis_result_tdata
);

// ---------------- Stage 2 Computations 

wire [31:0] d_Y0_minus_Y4_plus_cY1_plus_fY2, gY3_plus_aY5_plus_bY6_plus_eY7 ; 
wire d_Y0_minus_Y4_plus_cY1_plus_fY2_done , gY3_plus_aY5_plus_bY6_plus_eY7_done ; 

wire d_Y0_minus_Y4_plus_cY1_plus_fY2_add_a, d_Y0_minus_Y4_plus_cY1_plus_fY2_add_b ; 
// d_Y0_minus_Y4_plus_cY1_plus_fY2 
FP_ADD d_Y0_minus_Y4_plus_cY1_plus_fY2_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_minus_Y4_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(d_Y0_minus_Y4_plus_cY1_plus_fY2_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_minus_Y4),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(cY1_plus_fY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(d_Y0_minus_Y4_plus_cY1_plus_fY2_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(cY1_plus_fY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(d_Y0_minus_Y4_plus_cY1_plus_fY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(d_Y0_minus_Y4_plus_cY1_plus_fY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire gY3_plus_aY5_plus_bY6_plus_eY7_add_a, gY3_plus_aY5_plus_bY6_plus_eY7_add_b ; 
// gY3_plus_aY5_plus_bY6_plus_eY7
FP_ADD gY3_plus_aY5_plus_bY6_plus_eY7_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(gY3_plus_aY5_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(gY3_plus_aY5_plus_bY6_plus_eY7_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(gY3_plus_aY5),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(bY6_plus_eY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(gY3_plus_aY5_plus_bY6_plus_eY7_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(bY6_plus_eY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(gY3_plus_aY5_plus_bY6_plus_eY7_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(gY3_plus_aY5_plus_bY6_plus_eY7)                    // output wire [31 : 0] m_axis_result_tdata
);

// Final subtraction for x_out[1] 

wire s_axis_a_tready_x1 ; 
wire s_axis_b_tready_x1 ; 
FP_ADD x1_final (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_minus_Y4_plus_cY1_plus_fY2_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_x1),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_minus_Y4_plus_cY1_plus_fY2),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(gY3_plus_aY5_plus_bY6_plus_eY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_b_tready_x1),                // output wire s_axis_b_tready
  .s_axis_b_tdata(gY3_plus_aY5_plus_bY6_plus_eY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[1]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(x_out[1])                    // output wire [31 : 0] m_axis_result_tdata
);
 
// ------------- End of compuation for x_out[1] 

// ------------ Computation for x_out[2] 
// Stage 1 Additions/Subtractions 

wire [31:0] eY1_minus_fY2, aY3_minus_gY5, bY6_plus_cY7 ; 
wire eY1_minus_fY2_done, aY3_minus_gY5_done, bY6_plus_cY7_done ; 

wire eY1_minus_fY2_sub_a, eY1_minus_fY2_sub_b ; 
// eY1_minus_fY2_sub
FP_SUB eY1_minus_fY2_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(eY1_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(eY1_minus_fY2_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(eY1),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(fY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(eY1_minus_fY2_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(fY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(eY1_minus_fY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(eY1_minus_fY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire aY3_minus_gY5_sub_a, aY3_minus_gY5_sub_b ; 
// aY3_minus_gY5
FP_SUB aY3_minus_gY5_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(aY3_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(aY3_minus_gY5_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(aY3),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(gY5_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(aY3_minus_gY5_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(gY5),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(aY3_minus_gY5_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(aY3_minus_gY5)                    // output wire [31 : 0] m_axis_result_tdata
);

wire bY6_plus_cY7_add_a, bY6_plus_cY7_add_b ; 
// bY6_plus_cY7_add
FP_ADD bY6_plus_cY7_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(bY6_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(bY6_plus_cY7_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(bY6),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(cY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(bY6_plus_cY7_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(cY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(bY6_plus_cY7_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(bY6_plus_cY7)                    // output wire [31 : 0] m_axis_result_tdata
);


// Stage 2  
wire [31:0] d_Y0_minus_Y4_plus_eY1_minus_fY2, bY6_plus_cY7_minus_aY3_minus_gY5; 
wire d_Y0_minus_Y4_plus_eY1_minus_fY2_done, bY6_plus_cY7_minus_aY3_minus_gY5_done ; 

wire d_Y0_minus_Y4_plus_eY1_minus_fY2_add_a, d_Y0_minus_Y4_plus_eY1_minus_fY2_add_b ; 
// d_Y0_minus_Y4_plus_eY1_minus_fY2
FP_ADD d_Y0_minus_Y4_plus_eY1_minus_fY2_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_minus_Y4_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(d_Y0_minus_Y4_plus_eY1_minus_fY2_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_minus_Y4),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(eY1_minus_fY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(d_Y0_minus_Y4_plus_eY1_minus_fY2_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(eY1_minus_fY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(d_Y0_minus_Y4_plus_eY1_minus_fY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(d_Y0_minus_Y4_plus_eY1_minus_fY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire bY6_plus_cY7_minus_aY3_minus_gY5_sub_a, bY6_plus_cY7_minus_aY3_minus_gY5_sub_b ; 
// bY6_plus_cY7_minus_aY3_minus_gY5
FP_SUB bY6_plus_cY7_minus_aY3_minus_gY5_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(bY6_plus_cY7_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(bY6_plus_cY7_minus_aY3_minus_gY5_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(bY6_plus_cY7),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(aY3_minus_gY5_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(bY6_plus_cY7_minus_aY3_minus_gY5_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(aY3_minus_gY5),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(bY6_plus_cY7_minus_aY3_minus_gY5_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(bY6_plus_cY7_minus_aY3_minus_gY5)                    // output wire [31 : 0] m_axis_result_tdata
);

wire s_axis_a_tready_x2 ; 
wire s_axis_b_tready_x2 ; 
// Final Addition for x_out[2] 
FP_ADD x2_final (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_minus_Y4_plus_eY1_minus_fY2_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_x2),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_minus_Y4_plus_eY1_minus_fY2),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(bY6_plus_cY7_minus_aY3_minus_gY5_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_b_tready_x2),                // output wire s_axis_b_tready
  .s_axis_b_tdata(bY6_plus_cY7_minus_aY3_minus_gY5),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[2]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(x_out[2])                    // output wire [31 : 0] m_axis_result_tdata
);

// ------------ End of computation for x_out[2]


// ------------------ Computation for x_out[3] 
// Stage 1 Addition 

wire [31:0] gY1_minus_bY2, eY3_minus_cY5, fY6_plus_aY7 ; 
wire gY1_minus_bY2_done, eY3_minus_cY5_done, fY6_plus_aY7_done ; 

wire gY1_minus_bY2_sub_a, gY1_minus_bY2_sub_b ; 
// gY1_minus_bY2
FP_SUB gY1_minus_bY2_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(gY1_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(gY1_minus_bY2_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(gY1),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(bY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(gY1_minus_bY2_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(bY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(gY1_minus_bY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(gY1_minus_bY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire eY3_minus_cY5_sub_a, eY3_minus_cY5_sub_b ; 
// eY3_minus_cY5
FP_SUB eY3_minus_cY5_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(eY3_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(eY3_minus_cY5_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(eY3),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(cY5_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(eY3_minus_cY5_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(cY5),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(eY3_minus_cY5_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(eY3_minus_cY5)                    // output wire [31 : 0] m_axis_result_tdata
);

wire fY6_plus_aY7_add_a, fY6_plus_aY7_add_b ; 
// fY6_plus_aY7
FP_ADD fY6_plus_aY7_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(fY6_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(fY6_plus_aY7_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(fY6),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(aY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(fY6_plus_aY7_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(aY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(fY6_plus_aY7_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(fY6_plus_aY7)                    // output wire [31 : 0] m_axis_result_tdata
);

// Stage 2  
wire [31:0] d_Y0_plus_Y4_plus_gY1_minus_bY2, eY3_minus_cY5_plus_fY6_plus_aY7 ; 
wire d_Y0_plus_Y4_plus_gY1_minus_bY2_done, eY3_minus_cY5_plus_fY6_plus_aY7_done ; 

wire d_Y0_plus_Y4_plus_gY1_minus_bY2_add_a, d_Y0_plus_Y4_plus_gY1_minus_bY2_add_b ; 
// d_Y0_plus_Y4_plus_gY1_minus_bY2 add 
FP_ADD d_Y0_plus_Y4_plus_gY1_minus_bY2_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_plus_Y4_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(d_Y0_plus_Y4_plus_gY1_minus_bY2_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_plus_Y4),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(gY1_minus_bY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(d_Y0_plus_Y4_plus_gY1_minus_bY2_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(gY1_minus_bY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(d_Y0_plus_Y4_plus_gY1_minus_bY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(d_Y0_plus_Y4_plus_gY1_minus_bY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire eY3_minus_cY5_plus_fY6_plus_aY7_add_a, eY3_minus_cY5_plus_fY6_plus_aY7_add_b ; 
// eY3_minus_cY5_plus_fY6_plus_aY7 add 
FP_ADD eY3_minus_cY5_plus_fY6_plus_aY7_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(eY3_minus_cY5_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(eY3_minus_cY5_plus_fY6_plus_aY7_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(eY3_minus_cY5),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(fY6_plus_aY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(eY3_minus_cY5_plus_fY6_plus_aY7_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(fY6_plus_aY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(eY3_minus_cY5_plus_fY6_plus_aY7_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(eY3_minus_cY5_plus_fY6_plus_aY7)                    // output wire [31 : 0] m_axis_result_tdata
);

wire s_axis_a_tready_x3 ; 
wire s_axis_b_tready_x3 ; 
// Final addition fort x_out[3] 
FP_SUB x3_final (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_plus_Y4_plus_gY1_minus_bY2_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_x3),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_plus_Y4_plus_gY1_minus_bY2),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(eY3_minus_cY5_plus_fY6_plus_aY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_b_tready_x3),                // output wire s_axis_b_tready
  .s_axis_b_tdata(eY3_minus_cY5_plus_fY6_plus_aY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[3]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(x_out[3])                    // output wire [31 : 0] m_axis_result_tdata
);
// -------------- End of computation for x_out[3]

// ---------------- Computation for x_out[4] 
// Stage 1 
wire [31:0] gY1_plus_bY2, fY6_minus_aY7 ; 
wire gY1_plus_bY2_done, fY6_minus_aY7_done ; 
wire gY1_plus_bY2_add_a, gY1_plus_bY2_add_b ; 
// gY1_plus_bY2_add
FP_ADD gY1_plus_bY2_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(gY1_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(gY1_plus_bY2_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(gY1),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(bY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(gY1_plus_bY2_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(bY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(gY1_plus_bY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(gY1_plus_bY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire fY6_minus_aY7_sub_a, fY6_minus_aY7_sub_b ; 
// fY6_minus_aY7
FP_SUB fY6_minus_aY7_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(fY6_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(fY6_minus_aY7_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(fY6),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(aY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(fY6_minus_aY7_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(aY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(fY6_minus_aY7_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(fY6_minus_aY7)                    // output wire [31 : 0] m_axis_result_tdata
);


// Stage 2 
wire [31:0] d_Y0_plus_Y4_minus_gY1_plus_bY2, eY3_minus_cY5_minus_fY6_minus_aY7 ; 
wire d_Y0_plus_Y4_minus_gY1_plus_bY2_done, eY3_minus_cY5_minus_fY6_minus_aY7_done ; 

wire d_Y0_plus_Y4_minus_gY1_plus_bY2_sub_a, d_Y0_plus_Y4_minus_gY1_plus_bY2_sub_b ; 
// d_Y0_plus_Y4_minus_gY1_plus_bY2
FP_SUB d_Y0_plus_Y4_minus_gY1_plus_bY2_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_plus_Y4_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(d_Y0_plus_Y4_minus_gY1_plus_bY2_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_plus_Y4),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(gY1_plus_bY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(d_Y0_plus_Y4_minus_gY1_plus_bY2_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(gY1_plus_bY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(d_Y0_plus_Y4_minus_gY1_plus_bY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(d_Y0_plus_Y4_minus_gY1_plus_bY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire eY3_minus_cY5_minus_fY6_minus_aY7_sub_a, eY3_minus_cY5_minus_fY6_minus_aY7_sub_b ; 
// eY3_minus_cY5_minus_fY6_minus_aY7
FP_SUB eY3_minus_cY5_minus_fY6_minus_aY7_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(eY3_minus_cY5_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(eY3_minus_cY5_minus_fY6_minus_aY7_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(eY3_minus_cY5),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(fY6_minus_aY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(eY3_minus_cY5_minus_fY6_minus_aY7_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(fY6_minus_aY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(eY3_minus_cY5_minus_fY6_minus_aY7_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(eY3_minus_cY5_minus_fY6_minus_aY7)                    // output wire [31 : 0] m_axis_result_tdata
);

wire s_axis_a_tready_x4 ; 
wire s_axis_b_tready_x4 ; 
// ------ Final calculation for x_out[4] 
FP_ADD x4_final (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_plus_Y4_minus_gY1_plus_bY2_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_x4),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_plus_Y4_minus_gY1_plus_bY2),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(eY3_minus_cY5_minus_fY6_minus_aY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_b_tready_x4),                // output wire s_axis_b_tready
  .s_axis_b_tdata(eY3_minus_cY5_minus_fY6_minus_aY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[4]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(x_out[4])                    // output wire [31 : 0] m_axis_result_tdata
);
// ------------------ End of computation for x_out[4]

// ------------ Computation for x_out[5] 
// Stage 1 Calculation 
wire [31:0] eY1_plus_fY2, bY6_minus_cY7 ; 
wire eY1_plus_fY2_done , bY6_minus_cY7_done ;  

wire eY1_plus_fY2_add_a, eY1_plus_fY2_add_b ; 
FP_ADD eY1_plus_fY2_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(eY1_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(eY1_plus_fY2_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(eY1),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(fY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(eY1_plus_fY2_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(fY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(eY1_plus_fY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(eY1_plus_fY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire bY6_minus_cY7_sub_a, bY6_minus_cY7_sub_b ; 
FP_SUB bY6_minus_cY7_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(bY6_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(bY6_minus_cY7_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(bY6),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(cY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(bY6_minus_cY7_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(cY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(bY6_minus_cY7_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(bY6_minus_cY7)                    // output wire [31 : 0] m_axis_result_tdata
);

// Stage 2 Calculation 
wire [31:0] d_Y0_minus_Y4_minus_eY1_plus_fY2, aY3_minus_gY5_plus_bY6_minus_cY7 ; 
wire d_Y0_minus_Y4_minus_eY1_plus_fY2_done, aY3_minus_gY5_plus_bY6_minus_cY7_done ; 

wire d_Y0_minus_Y4_minus_eY1_plus_fY2_add_a, d_Y0_minus_Y4_minus_eY1_plus_fY2_add_b ; 
// d_Y0_minus_Y4_minus_eY1_plus_fY2 add 
FP_ADD d_Y0_minus_Y4_minus_eY1_plus_fY2_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_minus_Y4_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(d_Y0_minus_Y4_minus_eY1_plus_fY2_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_minus_Y4),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(eY1_plus_fY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(d_Y0_minus_Y4_minus_eY1_plus_fY2_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(eY1_plus_fY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(d_Y0_minus_Y4_minus_eY1_plus_fY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(d_Y0_minus_Y4_minus_eY1_plus_fY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire aY3_minus_gY5_plus_bY6_minus_cY7_sub_a, aY3_minus_gY5_plus_bY6_minus_cY7_sub_b ; 
// aY3_minus_gY5_plus_bY6_minus_cY7 sub 
FP_SUB aY3_minus_gY5_plus_bY6_minus_cY7_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(aY3_minus_gY5_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(aY3_minus_gY5_plus_bY6_minus_cY7_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(aY3_minus_gY5),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(bY6_minus_cY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(aY3_minus_gY5_plus_bY6_minus_cY7_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(bY6_minus_cY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(aY3_minus_gY5_plus_bY6_minus_cY7_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(aY3_minus_gY5_plus_bY6_minus_cY7)                    // output wire [31 : 0] m_axis_result_tdata
);

wire s_axis_a_tready_x5 ; 
wire s_axis_b_tready_x5 ; 
// Final computation 
FP_ADD x5_final( 
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_minus_Y4_minus_eY1_plus_fY2_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_x5),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_minus_Y4_minus_eY1_plus_fY2),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(aY3_minus_gY5_plus_bY6_minus_cY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_b_tready_x5),                // output wire s_axis_b_tready
  .s_axis_b_tdata(aY3_minus_gY5_plus_bY6_minus_cY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[5]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(x_out[5])                    // output wire [31 : 0] m_axis_result_tdata
);

// ---------------End of computation for x_out[5] 

// ---------------- Computation for x_out[6]
// Stage 1 -- Addition 
wire [31:0] cY1_minus_fY2, bY6_minus_eY7 ; 
wire cY1_minus_fY2_done, bY6_minus_eY7_done ; 
wire cY1_minus_fY2_sub_a, cY1_minus_fY2_sub_b ; 
FP_SUB cY1_minus_fY2_sub( 
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(cY1_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(cY1_minus_fY2_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(cY1),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(fY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(cY1_minus_fY2_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(fY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(cY1_minus_fY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(cY1_minus_fY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire bY6_minus_eY7_sub_a, bY6_minus_eY7_sub_b ; 
FP_SUB bY6_minus_eY7_sub ( 
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(bY6_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(bY6_minus_eY7_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(bY6),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(eY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(bY6_minus_eY7_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(eY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(bY6_minus_eY7_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(bY6_minus_eY7)                    // output wire [31 : 0] m_axis_result_tdata
);

// Stage 2 
wire [31:0] d_Y0_minus_Y4_minus_cY1_minus_fY2, gY3_plus_aY5_minus_bY6_minus_eY7 ; 
wire d_Y0_minus_Y4_minus_cY1_minus_fY2_done, gY3_plus_aY5_minus_bY6_minus_eY7_done ; 

wire d_Y0_minus_Y4_minus_cY1_minus_fY2_sub_a, d_Y0_minus_Y4_minus_cY1_minus_fY2_sub_b ; 

FP_SUB d_Y0_minus_Y4_minus_cY1_minus_fY2_sub ( 
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_minus_Y4_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(d_Y0_minus_Y4_minus_cY1_minus_fY2_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_minus_Y4),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(cY1_minus_fY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(d_Y0_minus_Y4_minus_cY1_minus_fY2_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(cY1_minus_fY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(d_Y0_minus_Y4_minus_cY1_minus_fY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(d_Y0_minus_Y4_minus_cY1_minus_fY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire gY3_plus_aY5_minus_bY6_minus_eY7_sub_a, gY3_plus_aY5_minus_bY6_minus_eY7_sub_b ; 
FP_SUB gY3_plus_aY5_minus_bY6_minus_eY7_sub ( 
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(gY3_plus_aY5_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(gY3_plus_aY5_minus_bY6_minus_eY7_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(gY3_plus_aY5),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(bY6_minus_eY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(gY3_plus_aY5_minus_bY6_minus_eY7_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(bY6_minus_eY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(gY3_plus_aY5_minus_bY6_minus_eY7_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(gY3_plus_aY5_minus_bY6_minus_eY7)                    // output wire [31 : 0] m_axis_result_tdata
);

wire s_axis_a_tready_x6 ; 
wire s_axis_b_tready_x6 ; 
// Final Computation 
FP_ADD x6_final ( 
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_minus_Y4_minus_cY1_minus_fY2_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_x6),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_minus_Y4_minus_cY1_minus_fY2),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(gY3_plus_aY5_minus_bY6_minus_eY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_b_tready_x6),                // output wire s_axis_b_tready
  .s_axis_b_tdata(gY3_plus_aY5_minus_bY6_minus_eY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[6]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(x_out[6])                    // output wire [31 : 0] m_axis_result_tdata
);

// ----------------End Computation for x_out[6]


// ---------------- Computation for x_out[7]
// Stage 1 -- Addition 
wire [31:0] aY1_minus_bY2, fY6_minus_gY7 ; 
wire aY1_minus_bY2_done, fY6_minus_gY7_done ; 

wire aY1_minus_bY2_sub_a, aY1_minus_bY2_sub_b ; 
FP_SUB aY1_minus_bY2_sub ( 
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(aY1_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(aY1_minus_bY2_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(aY1),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(bY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(aY1_minus_bY2_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(bY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(aY1_minus_bY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(aY1_minus_bY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire fY6_minus_gY7_sub_a, fY6_minus_gY7_sub_b ;
FP_SUB fY6_minus_gY7_sub ( 
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(fY6_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(fY6_minus_gY7_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(fY6),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(gY7_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(fY6_minus_gY7_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(gY7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(fY6_minus_gY7_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(fY6_minus_gY7)                    // output wire [31 : 0] m_axis_result_tdata
);

// Stage 2 
wire [31:0] d_Y0_plus_Y4_minus_aY1_minus_bY2, fY6_minus_gY7_minus_cY3_plus_eY5 ; 
wire d_Y0_plus_Y4_minus_aY1_minus_bY2_done, fY6_minus_gY7_minus_cY3_plus_eY5_done ; 
wire d_Y0_plus_Y4_minus_aY1_minus_bY2_sub_a, d_Y0_plus_Y4_minus_aY1_minus_bY2_sub_b ; 

FP_SUB d_Y0_plus_Y4_minus_aY1_minus_bY2_sub ( 
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_plus_Y4_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(d_Y0_plus_Y4_minus_aY1_minus_bY2_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_plus_Y4),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(aY1_minus_bY2_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(d_Y0_plus_Y4_minus_aY1_minus_bY2_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(aY1_minus_bY2),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(d_Y0_plus_Y4_minus_aY1_minus_bY2_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(d_Y0_plus_Y4_minus_aY1_minus_bY2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire fY6_minus_gY7_minus_cY3_plus_eY5_sub_a, fY6_minus_gY7_minus_cY3_plus_eY5_sub_b ; 
FP_SUB fY6_minus_gY7_minus_cY3_plus_eY5_sub ( 
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(fY6_minus_gY7_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(fY6_minus_gY7_minus_cY3_plus_eY5_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(fY6_minus_gY7),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(cY3_plus_eY5_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(fY6_minus_gY7_minus_cY3_plus_eY5_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(cY3_plus_eY5),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(fY6_minus_gY7_minus_cY3_plus_eY5_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(fY6_minus_gY7_minus_cY3_plus_eY5)                    // output wire [31 : 0] m_axis_result_tdata
);

// Final Computation for x7 
wire s_axis_a_tready_x7 ; 
wire s_axis_b_tready_x7 ; 
FP_ADD x7_final ( 
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(d_Y0_plus_Y4_minus_aY1_minus_bY2_done),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_x7),                // output wire s_axis_a_tready
  .s_axis_a_tdata(d_Y0_plus_Y4_minus_aY1_minus_bY2),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(fY6_minus_gY7_minus_cY3_plus_eY5_done),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_b_tready_x7),                // output wire s_axis_b_tready
  .s_axis_b_tdata(fY6_minus_gY7_minus_cY3_plus_eY5),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[7]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(x_out[7])                    // output wire [31 : 0] m_axis_result_tdata
);
// ----------------End Computation for x_out[7]

endmodule
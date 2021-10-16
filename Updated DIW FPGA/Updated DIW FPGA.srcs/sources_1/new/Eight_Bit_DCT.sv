module Eight_Bit_DCT ( 
    input wire [31:0] x_in [7:0] ,  
    input wire clk , 
    input wire en , 
    output wire [7:0] done, 
    output reg [31:0] Z_out [7:0]   
) ; 

// Cosine values
wire [31:0] c_a = 32'h3efb1466 ; 
wire [31:0] c_b = 32'h3eec8217 ; 
wire [31:0] c_c = 32'h3ed4da90 ; 
wire [31:0] c_d = 32'h3eb50481 ; 
wire [31:0] c_e = 32'h3e8e392e ; 
wire [31:0] c_f = 32'h3e43eea2 ; 
wire [31:0] c_g = 32'h3dc7c30d ; 


// Stage 1: Generating X_i for intermediate states 

wire [31:0] X0, X1, X2, X3, X4, X5, X6, X7 ; 
wire [7:0] stage_1_done ; 

wire X0_Adder_new_a, X0_Adder_new_b ; 
// X0 Calculation 
FP_ADD X0_Adder_new (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(en),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(X0_Adder_new_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(x_in[0]),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(X0_Adder_new_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(x_in[7]),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(stage_1_done[0]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(X0)                    // output wire [31 : 0] m_axis_result_tdata
);

wire X2_Adder_a, X2_Adder_b ; 
// X2 Calculation 
FP_ADD X2_Adder (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(en),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(X2_Adder_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(x_in[1]),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(X2_Adder_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(x_in[6]),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(stage_1_done[2]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(X2)                    // output wire [31 : 0] m_axis_result_tdata
);

wire X4_Adder_a, X4_Adder_b ; 
// X4 Calculation 
FP_ADD X4_Adder (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(en),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(X4_Adder_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(x_in[2]),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(X4_Adder_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(x_in[5]),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(stage_1_done[4]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(X4)                    // output wire [31 : 0] m_axis_result_tdata
);

wire X6_Adder_a, X6_Adder_b ; 
// X6 Calculation 
FP_ADD X6_Adder (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(en),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(X6_Adder_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(x_in[3]),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(X6_Adder_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(x_in[4]),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(stage_1_done[6]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(X6)                    // output wire [31 : 0] m_axis_result_tdata
);

wire X1_Subtractor_a, X1_Subtractor_b ; 
// X1 Calculation
FP_SUB X1_Subtractor (
  .aclk(clk),                                   // input wire aclk
  .s_axis_a_tvalid(en),                         // input wire s_axis_a_tvalid
  .s_axis_a_tready(X1_Subtractor_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(x_in[0]),                     // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),                         // input wire s_axis_b_tvalid
  .s_axis_b_tready(X1_Subtractor_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(x_in[7]),                     // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(stage_1_done[1]),       // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(X1)                      // output wire [31 : 0] m_axis_result_tdata
);

wire X3_Subtractor_a, X3_Subtractor_b ; 
// X3 Calculation
FP_SUB X3_Subtractor (
  .aclk(clk),                                   // input wire aclk
  .s_axis_a_tvalid(en),                         // input wire s_axis_a_tvalid
  .s_axis_a_tready(X3_Subtractor_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(x_in[1]),                     // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),                         // input wire s_axis_b_tvalid
  .s_axis_b_tready(X3_Subtractor_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(x_in[6]),                     // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(stage_1_done[3]),       // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(X3)                      // output wire [31 : 0] m_axis_result_tdata
);


wire X5_Subtractor_a, X5_Subtractor_b ; 
// X5 Calculation
FP_SUB X5_Subtractor (
  .aclk(clk),                                   // input wire aclk
  .s_axis_a_tvalid(en),                         // input wire s_axis_a_tvalid
  .s_axis_a_tready(X5_Subtractor_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(x_in[2]),                     // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),                         // input wire s_axis_b_tvalid
  .s_axis_b_tready(X5_Subtractor_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(x_in[5]),                     // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(stage_1_done[5]),       // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(X5)                      // output wire [31 : 0] m_axis_result_tdata
);

wire X7_Subtractor_a, X7_Subtractor_b ; 
// X7 Calculation
FP_SUB X7_Subtractor (
  .aclk(clk),                                   // input wire aclk
  .s_axis_a_tvalid(en),                         // input wire s_axis_a_tvalid
  .s_axis_a_tready(X7_Subtractor_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(x_in[3]),                     // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(en),                         // input wire s_axis_b_tvalid
  .s_axis_b_tready(X7_Subtractor_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(x_in[4]),                     // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(stage_1_done[7]),       // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(X7)                      // output wire [31 : 0] m_axis_result_tdata
);

// ----------------- End of Stage 1 ----------------------------- // 



// ---------------- Calculation for Even Part ------------------ // 

// ------------ Stage 2 ------------------// 
wire [31:0] X0_plus_X6, X0_minus_X6 ; 
wire [31:0] X2_plus_X4, X2_minus_X4 ; 
wire [3:0] even_stage2_done ; 

// Butterfly for X0 and X6 
wire X0_Adder_X6_a, X0_Adder_X6_b ; 
FP_ADD X0_Adder_X6 (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(stage_1_done[0]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(X0_Adder_X6_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(X0),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[6]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(X0_Adder_X6_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(X6),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(even_stage2_done[0]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(X0_plus_X6)                    // output wire [31 : 0] m_axis_result_tdata
);

wire X0_sub_X6_a, X0_sub_X6_b ; 
FP_SUB X0_sub_X6 (
  .aclk(clk),                                   // input wire aclk
  .s_axis_a_tvalid(stage_1_done[0]),                         // input wire s_axis_a_tvalid
  .s_axis_a_tready(X0_sub_X6_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X0),                     // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[6]),                         // input wire s_axis_b_tvalid
  .s_axis_b_tready(X0_sub_X6_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(X6),                     // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(even_stage2_done[1]),       // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(X0_minus_X6)                      // output wire [31 : 0] m_axis_result_tdata
);

// Butterfly for X2 and X4 
wire X2_Adder_X4_a, X2_Adder_X4_b ; 
FP_ADD X2_Adder_X4 (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(stage_1_done[2]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(X2_Adder_X4_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(X2),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[4]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(X2_Adder_X4_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(X4),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(even_stage2_done[2]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(X2_plus_X4)                    // output wire [31 : 0] m_axis_result_tdata
);

wire X2_sub_X4_a, X2_sub_X4_b ; 
FP_SUB X2_sub_X4 (
  .aclk(clk),                                   // input wire aclk
  .s_axis_a_tvalid(stage_1_done[2]),                         // input wire s_axis_a_tvalid
  .s_axis_a_tready(X2_sub_X4_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X2),                     // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[4]),                         // input wire s_axis_b_tvalid
  .s_axis_b_tready(X2_sub_X4_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(X4),                     // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(even_stage2_done[3]),       // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(X2_minus_X4)                      // output wire [31 : 0] m_axis_result_tdata
);

// Addition of X2_plus_X6 with X2_plus_X4 
wire [31:0] X0_plus_X6_plus_X2_plus_X4 ; 
wire bada_add_done ; 
wire X0_plus_X6_plus_X2_plus_X4_adder_a, X0_plus_X6_plus_X2_plus_X4_adder_b ; 
FP_ADD X0_plus_X6_plus_X2_plus_X4_adder (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(even_stage2_done[0]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(X0_plus_X6_plus_X2_plus_X4_adder_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(X0_plus_X6),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(even_stage2_done[2]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(X0_plus_X6_plus_X2_plus_X4_adder_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(X2_plus_X4),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(bada_add_done),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(X0_plus_X6_plus_X2_plus_X4)                    // output wire [31 : 0] m_axis_result_tdata
);



// Subtraction of X2_plus_X6 with X2_plus_X4 
wire [31:0] X0_plus_X6_minus_X2_plus_X4 ; 
wire bada_sub_done ; 
wire X0_plus_X6_minus_X2_plus_X4_sub_a, X0_plus_X6_minus_X2_plus_X4_sub_b ; 
FP_SUB X0_plus_X6_minus_X2_plus_X4_sub (
  .aclk(clk),                                   // input wire aclk
  .s_axis_a_tvalid(even_stage2_done[0]),                         // input wire s_axis_a_tvalid
  .s_axis_a_tready(X0_plus_X6_minus_X2_plus_X4_sub_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X0_plus_X6),                     // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(even_stage2_done[2]),                         // input wire s_axis_b_tvalid
  .s_axis_b_tready(X0_plus_X6_minus_X2_plus_X4_sub_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(X2_plus_X4),                     // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(bada_sub_done),       // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(X0_plus_X6_minus_X2_plus_X4)                      // output wire [31 : 0] m_axis_result_tdata
);

 
// Stage 3 ------ Multiplication with b, d, f 
wire [31:0] f_X0_minus_X6, b_X0_minus_X6 ; 
wire [31:0] f_X2_minus_X4, b_X2_minus_X4 ; 
wire [3:0] even_stage_3_done ; 

wire f_X0_minus_X6_mult_a, f_X0_minus_X6_mult_b ; 

FP_MUL f_X0_minus_X6_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(even_stage2_done[1]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(f_X0_minus_X6_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X0_minus_X6),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(even_stage2_done[1]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(f_X0_minus_X6_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_f),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(even_stage_3_done[0]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(f_X0_minus_X6)    // output wire [31 : 0] m_axis_result_tdata
);

wire b_X0_minus_X6_mult_a, b_X0_minus_X6_mult_b ; 

FP_MUL b_X0_minus_X6_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(even_stage2_done[1]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(b_X0_minus_X6_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X0_minus_X6),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(even_stage2_done[1]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(b_X0_minus_X6_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_b),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(even_stage_3_done[1]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(b_X0_minus_X6)    // output wire [31 : 0] m_axis_result_tdata
);

wire f_X2_minus_X4_mult_a, f_X2_minus_X4_mult_b ; 

FP_MUL f_X2_minus_X4_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(even_stage2_done[3]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(f_X2_minus_X4_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X2_minus_X4),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(even_stage2_done[3]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(f_X2_minus_X4_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_f),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(even_stage_3_done[2]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(f_X2_minus_X4)    // output wire [31 : 0] m_axis_result_tdata
);


wire b_X2_minus_X4_mult_a, b_X2_minus_X4_mult_b ; 
FP_MUL b_X2_minus_X4_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(even_stage2_done[3]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(b_X2_minus_X4_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X2_minus_X4),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(even_stage2_done[3]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(b_X2_minus_X4_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_b),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(even_stage_3_done[3]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(b_X2_minus_X4)    // output wire [31 : 0] m_axis_result_tdata
);


// Stage 4 ---- Final stage 
wire d_X0_plus_X6_plus_X2_plus_X4_a, d_X0_plus_X6_plus_X2_plus_X4_b ; 
// Final Computation for Z_out[0] 
FP_MUL d_X0_plus_X6_plus_X2_plus_X4 (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(bada_add_done),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(d_X0_plus_X6_plus_X2_plus_X4_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X0_plus_X6_plus_X2_plus_X4),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(bada_add_done),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(d_X0_plus_X6_plus_X2_plus_X4_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_d),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[0]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(Z_out[0])    // output wire [31 : 0] m_axis_result_tdata
);


wire d_X0_plus_X6_minus_X2_plus_X4_a, d_X0_plus_X6_minus_X2_plus_X4_b ; 
// Final Computation for Z_out[4] 
FP_MUL d_X0_plus_X6_minus_X2_plus_X4 (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(bada_sub_done),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(d_X0_plus_X6_minus_X2_plus_X4_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X0_plus_X6_minus_X2_plus_X4),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(bada_sub_done),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(d_X0_plus_X6_minus_X2_plus_X4_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_d),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[4]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(Z_out[4])    // output wire [31 : 0] m_axis_result_tdata
);

// Final computation for Z_out[2] 
wire Z_2_a, Z_2_b ; 
FP_ADD Z_2 (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(even_stage_3_done[1]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(Z_2_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(b_X0_minus_X6),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(even_stage_3_done[2]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(Z_2_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(f_X2_minus_X4),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[2]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(Z_out[2])                    // output wire [31 : 0] m_axis_result_tdata
);

// Final computation for Z_out[6] 
wire Z_6_a, Z_6_b ; 
FP_SUB Z_6 (
  .aclk(clk),                                   // input wire aclk
  .s_axis_a_tvalid(even_stage_3_done[0]),                         // input wire s_axis_a_tvalid
  .s_axis_a_tready(Z_6_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(f_X0_minus_X6),                     // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(even_stage_3_done[3]),                         // input wire s_axis_b_tvalid
  .s_axis_b_tready(Z_6_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(b_X2_minus_X4),                     // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[6]),       // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(Z_out[6])                      // output wire [31 : 0] m_axis_result_tdata
);

 
 
// ----------- End of Calculation for Even Part ------------ // 


// ----------- Calculation for Odd Part ------------ // 
// Calculation for Z1 

// Stage 2: Multiplications 
wire [3:0] Z1_stage2_done ;  
wire [31:0] a_X1, c_X3, e_X5, g_X7 ; 

wire a_X1_mult_a, a_X1_mult_b ; 

FP_MUL a_X1_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[1]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(a_X1_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X1),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[1]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(a_X1_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_a),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z1_stage2_done[0]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(a_X1)    // output wire [31 : 0] m_axis_result_tdata
);

wire c_X3_mult_a, c_X3_mult_b ; 
FP_MUL c_X3_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[3]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(c_X3_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X3),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[3]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(c_X3_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_c),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z1_stage2_done[1]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(c_X3)    // output wire [31 : 0] m_axis_result_tdata
);

wire e_X5_mult_a, e_X5_mult_b ; 
FP_MUL e_X5_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[5]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(e_X5_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X5),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[5]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(e_X5_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_e),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z1_stage2_done[2]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(e_X5)    // output wire [31 : 0] m_axis_result_tdata
);

wire g_X7_mult_a, g_X7_mult_b ; 
FP_MUL g_X7_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[7]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(g_X7_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X7),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[7]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(g_X7_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_g),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z1_stage2_done[3]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(g_X7)    // output wire [31 : 0] m_axis_result_tdata
);

// Stage 3: Addition of 2 terms 
wire [31:0] aX1_plus_cX3, eX5_plus_gX7 ; 
wire [1:0] Z1_stage3_done ; 

wire aX1_plus_cX3_add_a, aX1_plus_cX3_add_b ; 
FP_ADD aX1_plus_cX3_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(Z1_stage2_done[0]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(aX1_plus_cX3_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(a_X1),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(Z1_stage2_done[0]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(aX1_plus_cX3_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(c_X3),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z1_stage3_done[0]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(aX1_plus_cX3)                    // output wire [31 : 0] m_axis_result_tdata
);

wire eX5_plus_gX7_add_a, eX5_plus_gX7_add_b ; 
FP_ADD eX5_plus_gX7_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(Z1_stage2_done[2]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(eX5_plus_gX7_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(e_X5),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(Z1_stage2_done[3]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(eX5_plus_gX7_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(g_X7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z1_stage3_done[1]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(eX5_plus_gX7)                    // output wire [31 : 0] m_axis_result_tdata
);

wire s_axis_a_tready_a, s_axis_a_tready_b ; 
// Final addition for Z1 
FP_ADD Z1_final_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(Z1_stage3_done[0]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(aX1_plus_cX3),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(Z1_stage3_done[1]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_a_tready_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(eX5_plus_gX7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[1]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(Z_out[1])                    // output wire [31 : 0] m_axis_result_tdata
);
// - End of calculation for Z1 


// Calculation for Z3 

// Stage 2: Multiplications 
wire [3:0] Z3_stage2_done ;  
wire [31:0] c_X1, g_X3, a_X5, e_X7 ; 

wire c_X1_mult_a, c_X1_mult_b ; 
FP_MUL c_X1_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[1]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(c_X1_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X1),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[1]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(c_X1_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_c),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z3_stage2_done[0]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(c_X1)    // output wire [31 : 0] m_axis_result_tdata
);

wire g_X3_mult_a, g_X3_mult_b ; 
FP_MUL g_X3_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[3]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(g_X3_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X3),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[3]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(g_X3_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_g),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z3_stage2_done[1]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(g_X3)    // output wire [31 : 0] m_axis_result_tdata
);

wire a_X5_mult_a, a_X5_mult_b ; 
FP_MUL a_X5_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[5]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(a_X5_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X5),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[5]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(a_X5_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_a),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z3_stage2_done[2]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(a_X5)    // output wire [31 : 0] m_axis_result_tdata
);

wire e_X7_mult_a, e_X7_mult_b ; 
FP_MUL e_X7_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[7]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(e_X7_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X7),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[7]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(e_X7_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_e),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z3_stage2_done[3]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(e_X7)    // output wire [31 : 0] m_axis_result_tdata
);

// Stage 3: subtraction of 2 terms 
wire [31:0] cX1_minus_gX3, aX5_plus_eX7 ; 
wire [1:0] Z3_stage3_done ; 

wire cX1_minus_gX3_minus_a, cX1_minus_gX3_minus_b ; 
FP_SUB cX1_minus_gX3_minus (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(Z3_stage2_done[0]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(cX1_minus_gX3_minus_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(c_X1),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(Z3_stage2_done[0]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(cX1_minus_gX3_minus_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(g_X3),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z3_stage3_done[0]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(cX1_minus_gX3)                    // output wire [31 : 0] m_axis_result_tdata
);

wire aX5_plus_eX7_add_a, aX5_plus_eX7_add_b ; 
FP_ADD aX5_plus_eX7_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(Z3_stage2_done[2]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(aX5_plus_eX7_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(a_X5),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(Z3_stage2_done[3]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(aX5_plus_eX7_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(e_X7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z3_stage3_done[1]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(aX5_plus_eX7)                    // output wire [31 : 0] m_axis_result_tdata
);

wire Z3_final_sub_a, Z3_final_sub_b ; 
// Final subtraction for Z3 
FP_SUB Z3_final_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(Z3_stage3_done[0]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(Z3_final_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(cX1_minus_gX3),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(Z3_stage3_done[1]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(Z3_final_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(aX5_plus_eX7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[3]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(Z_out[3])                    // output wire [31 : 0] m_axis_result_tdata
);
// End of Calculation for Z3 

// ---------------------------  Calculation for Z5 

// Stage 2: Multiplications 
wire [3:0] Z5_stage2_done ;  
wire [31:0] e_X1, a_X3, g_X5, c_X7 ; 

wire e_X1_mult_a, e_X1_mult_b ; 
FP_MUL e_X1_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[1]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(e_X1_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X1),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[1]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(e_X1_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_e),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z5_stage2_done[0]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(e_X1)    // output wire [31 : 0] m_axis_result_tdata
);

wire a_X3_mult_a, a_X3_mult_b ; 
FP_MUL a_X3_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[3]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(a_X3_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X3),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[3]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(a_X3_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_a),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z5_stage2_done[1]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(a_X3)    // output wire [31 : 0] m_axis_result_tdata
);

wire g_X5_mult_a, g_X5_mult_b ; 
FP_MUL g_X5_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[5]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(g_X5_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X5),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[5]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(g_X5_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_g),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z5_stage2_done[2]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(g_X5)    // output wire [31 : 0] m_axis_result_tdata
);

wire c_X7_mult_a, c_X7_mult_b ; 
FP_MUL c_X7_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[7]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(c_X7_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X7),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[7]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(c_X7_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_c),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z5_stage2_done[3]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(c_X7)    // output wire [31 : 0] m_axis_result_tdata
);

// Stage 3: subtraction of 2 terms 
wire [31:0] eX1_minus_aX3, gX5_plus_cX7 ; 
wire [1:0] Z5_stage3_done ; 

wire eX1_minus_aX3_sub_a, eX1_minus_aX3_sub_b ; 
FP_SUB eX1_minus_aX3_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(Z5_stage2_done[0]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(eX1_minus_aX3_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(e_X1),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(Z5_stage2_done[0]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(eX1_minus_aX3_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(a_X3),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z5_stage3_done[0]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(eX1_minus_aX3)                    // output wire [31 : 0] m_axis_result_tdata
);

wire gX5_plus_cX7_add_a, gX5_plus_cX7_add_b ; 
FP_ADD gX5_plus_cX7_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(Z5_stage2_done[2]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(gX5_plus_cX7_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(g_X5),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(Z5_stage2_done[3]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(gX5_plus_cX7_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(c_X7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z5_stage3_done[1]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(gX5_plus_cX7)                    // output wire [31 : 0] m_axis_result_tdata
);

// Final addition for Z5 
wire Z5_final_add_a, Z5_final_add_b ; 
FP_ADD Z5_final_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(Z5_stage3_done[0]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(Z5_final_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(eX1_minus_aX3),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(Z5_stage3_done[1]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(Z5_final_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(gX5_plus_cX7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[5]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(Z_out[5])                    // output wire [31 : 0] m_axis_result_tdata
);
// End of Calculation for Z5 

// ---------------- Calculation for Z7 
// Stage 2: Multiplications 
wire [3:0] Z7_stage2_done ;  
wire [31:0] g_X1, e_X3, c_X5, a_X7 ; 

wire g_X1_mult_a, g_X1_mult_b ; 
FP_MUL g_X1_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[1]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(g_X1_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X1),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[1]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(g_X1_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_g),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z7_stage2_done[0]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(g_X1)    // output wire [31 : 0] m_axis_result_tdata
);

wire e_X3_mult_a, e_X3_mult_b ; 
FP_MUL e_X3_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[3]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(e_X3_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X3),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[3]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(e_X3_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_e),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z7_stage2_done[1]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(e_X3)    // output wire [31 : 0] m_axis_result_tdata
);

wire c_X5_mult_a, c_X5_mult_b ; 
FP_MUL c_X5_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[5]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(c_X5_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X5),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[5]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(c_X5_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_c),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z7_stage2_done[2]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(c_X5)    // output wire [31 : 0] m_axis_result_tdata
);

wire a_X7_mult_a, a_X7_mult_b ; 
FP_MUL a_X7_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(stage_1_done[7]),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(a_X7_mult_a),            // output wire s_axis_a_tready
  .s_axis_a_tdata(X7),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(stage_1_done[7]),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(a_X7_mult_b),            // output wire s_axis_b_tready
  .s_axis_b_tdata(c_a),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z7_stage2_done[3]),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(a_X7)    // output wire [31 : 0] m_axis_result_tdata
);

// Stage 3: subtraction of 2 terms 
wire [31:0] gX1_minus_eX3, cX5_minus_aX7 ; 
wire [1:0] Z7_stage3_done ; 

wire gX1_minus_eX3_sub_a, gX1_minus_eX3_sub_b ;
FP_SUB gX1_minus_eX3_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(Z7_stage2_done[0]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(gX1_minus_eX3_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(g_X1),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(Z7_stage2_done[0]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(gX1_minus_eX3_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(e_X3),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z7_stage3_done[0]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(gX1_minus_eX3)                    // output wire [31 : 0] m_axis_result_tdata
);

wire cX5_minus_aX7_sub_a, cX5_minus_aX7_sub_b ; 
FP_SUB cX5_minus_aX7_sub (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(Z7_stage2_done[2]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(cX5_minus_aX7_sub_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(c_X5),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(Z7_stage2_done[3]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(cX5_minus_aX7_sub_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(a_X7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(Z7_stage3_done[1]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(cX5_minus_aX7)                    // output wire [31 : 0] m_axis_result_tdata
);

wire Z7_final_add_a, Z7_final_add_b ; 
// Final addition for Z7 
FP_ADD Z7_final_add (
  .aclk(clk),                                       // input wire aclk
  .s_axis_a_tvalid(Z7_stage3_done[0]),                             // input wire s_axis_a_tvalid
  .s_axis_a_tready(Z7_final_add_a),                // output wire s_axis_a_tready
  .s_axis_a_tdata(gX1_minus_eX3),                         // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(Z7_stage3_done[1]),                             // input wire s_axis_b_tvalid
  .s_axis_b_tready(Z7_final_add_b),                // output wire s_axis_b_tready
  .s_axis_b_tdata(cX5_minus_aX7),                         // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(done[7]),      // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),      // input wire m_axis_result_tready
  .m_axis_result_tdata(Z_out[7])                    // output wire [31 : 0] m_axis_result_tdata
);


// ------------------ End of Calculation for Z7 

// ----------- End of Calculation for Odd Part ------------ // 

endmodule 
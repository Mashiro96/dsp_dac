// #########################################
//# 0.18-inputs ISI and MS Loop Combination #
//# 1.1st-order for ISI Loop                #
//# 2.2nd-order for MS Loop                 #
//# 3.With ISI Bypass Function              #
//# 4.With MIS Bypass Function              #
//# 5.With Partial-Sort operation           #
//#             Version 1.5                 #
// #########################################

module ISI_MS_18_V1p5(clk, rstn, V, ISI_SEL, MIS_SEL,
					  SVout, STout);

//--------------------------------------------------
// clk:      input clock;
// rstn:     rest signal, 0 enable;
// V:        input selected number;
// SVout:    Output SV Vector;
// STout:    Output ST Vector;
// TS17~TS0: Debug ports;
//---------------------------------------------------
// ISI_SEL: ISI bypass enable, "1" enable bypass;
// MIS_SEL: MIS bypass enable, "1" enable bypass;
//---------------------------------------------------
// MIS_SEL=0, ISI_SEL=0: ISI enable, MIS enable,
//						 Dither_Gen  enable,
//						 Decp_Gen    enable,
//						 Tran_Det    enable,
//						 HILF6_1st   enable,
//						 HMLF6_2nd   enable,
//						 VQ6_V1p3    enable,
//					     Dig_Sel	 enable;
// MIS_SEL=0, ISI_SEL=1: ISI bypass, MIS enable;
//						 Dither_Gen  disable,
//						 Decp_Gen    disable,
//						 Tran_Det    disable,
//						 HILF6_1st   disable,
//						 HMLF6_2nd   enable,
//						 VQ6_V1p3    enable,
//					     Dig_Sel	 enable;
// MIS_SEL=1, ISI_SEL=0: ISI bypass, MIS bypass;
//						 Dither_Gen  disable,
//						 Decp_Gen    disable,
//						 Tran_Det    disable,
//						 HILF6_1st   disable,
//						 HMLF6_2nd   disable,
//						 VQ6_V1p3    disable,
//					     Dig_Sel	 disable;
// MIS_SEL=1, ISI_SEL=1: ISI bypass, MIS bypass;
//						 Dither_Gen  disable,
//						 Decp_Gen    disable,
//						 Tran_Det    disable,
//						 HILF6_1st   disable,
//						 HMLF6_2nd   disable,
//						 VQ6_V1p3    disable,
//					     Dig_Sel	 disable;
//---------------------------------------------------

input clk, rstn, ISI_SEL, MIS_SEL;
input signed [5:0] V;
output [17:0] SVout;
output [17:0] STout;
//output signed [7:0] TS17,TS16,TS15,TS14,TS13,TS12,TS11,TS10,TS9,TS8,TS7,TS6,TS5,TS4,TS3,TS2,TS1,TS0;

wire [17:0] SV;
wire [17:0] SVD,SVDB;
wire [17:0] ST;
wire [6:0]  SFM [17:0];
wire [3:0]  SFI [17:0];
wire [6:0]  SMX;
wire signed [7:0] SY1 [17:0];
wire signed [7:0] SY2 [17:0];
wire signed [7:0] SX1 [17:0];
wire signed [7:0] SX2 [17:0];
wire signed [7:0] SCM [17:0];
wire signed [7:0] SY  [17:0];
wire [4:0] SQ  [17:0]; //VQ output adress
wire signed [1:0] dither; //dither sequence
wire [3:0] Gama; //Transition selection number
wire [3:0] Beta; //Ones selection number
reg signed [5:0] Vinput;

assign SVDB=~SVD;

always @(posedge clk or negedge rstn)
	if(rstn==0)begin
		Vinput<=0;
	end
	else begin
		Vinput<=V;
	end

// Dither Sequence Generator
Dither_Gen18 Dither_Gen18(.clk(clk), .rstn(rstn),
					      .dither(dither));

// De-couple Sequence Generator
Decp_Gen18 Decp_Gen18(.clk(clk), .rstn(rstn), .dither(dither), .V(Vinput),
				      .Gama(Gama), .Beta(Beta));

// HMLF Operation
HMLF18_2nd_V1p5 HMLF18_2nd(.clk(clk), .rstn(rstn), .SV(SV),.SD(SVD),
						   .SFM17(SFM[17]), .SFM16(SFM[16]), .SFM15(SFM[15]), .SFM14(SFM[14]), .SFM13(SFM[13]),
						   .SFM12(SFM[12]), .SFM11(SFM[11]), .SFM10(SFM[10]), .SFM9(SFM[9]),
						   .SFM8(SFM[8]),   .SFM7(SFM[7]),   .SFM6(SFM[6]),   .SFM5(SFM[5]),   .SFM4(SFM[4]),
						   .SFM3(SFM[3]),   .SFM2(SFM[2]),   .SFM1(SFM[1]),   .SFM0(SFM[0]));

// Transition Operation
Tran_Det18 Tran_Det18(.clk(clk), .rstn(rstn), .SV(SVD), //这个SV的传输需要非常的注意，必须是SV的一个delay周期
				      .ST(ST));

// HILF Operation
HILF18_1st HILF18_1st(.clk(clk), .rstn(rstn), .ST(ST),
				      .SFI17(SFI[17]), .SFI16(SFI[16]), .SFI15(SFI[15]), .SFI14(SFI[14]), .SFI13(SFI[13]),
					  .SFI12(SFI[12]), .SFI11(SFI[11]), .SFI10(SFI[10]), .SFI9(SFI[9]),
				      .SFI8(SFI[8]),   .SFI7(SFI[7]),   .SFI6(SFI[6]),   .SFI5(SFI[5]),   .SFI4(SFI[4]),
					  .SFI3(SFI[3]),   .SFI2(SFI[2]),   .SFI1(SFI[1]),   .SFI0(SFI[0]));

// MAX Operation
MAX18 MAX18(.a17(SFM[17]), .a16(SFM[16]), .a15(SFM[15]), .a14(SFM[14]), .a13(SFM[13]),
			.a12(SFM[12]), .a11(SFM[11]), .a10(SFM[10]), .a9(SFM[9]),   
			.a8(SFM[8]),   .a7(SFM[7]),   .a6(SFM[6]),   .a5(SFM[5]),   .a4(SFM[4]),
			.a3(SFM[3]),   .a2(SFM[2]),   .a1(SFM[1]),   .a0(SFM[0]),
			.b(SMX));
			
// VQ Operation
VQ18_V1p5 VQ18_V1p5(.a17(SY[17]), .a16(SY[16]), .a15(SY[15]), .a14(SY[14]), .a13(SY[13]),
					.a12(SY[12]), .a11(SY[11]), .a10(SY[10]), .a9(SY[9]),
					.a8(SY[8]),   .a7(SY[7]),   .a6(SY[6]),   .a5(SY[5]),   .a4(SY[4]),
					.a3(SY[3]),   .a2(SY[2]),   .a1(SY[1]),   .a0(SY[0]),
					.b17(SQ[17]), .b16(SQ[16]), .b15(SQ[15]), .b14(SQ[14]), .b13(SQ[13]),
					.b12(SQ[12]), .b11(SQ[11]), .b10(SQ[10]), .b9(SQ[9]),
					.b8(SQ[8]),   .b7(SQ[7]),   .b6(SQ[6]),   .b5(SQ[5]),   .b4(SQ[4]),
					.b3(SQ[3]),   .b2(SQ[2]),   .b1(SQ[1]),   .b0(SQ[0]));

// Digital Selection Operation
Dig_Sel18 Dig_Sel18(.Gama({1'b0,Gama}), .Beta({1'b0,Beta}), .ISI_SEL(ISI_SEL), .MIS_SEL(MIS_SEL), .V(Vinput),
				    .SQ17(SQ[17]), .SQ16(SQ[16]), .SQ15(SQ[15]), .SQ14(SQ[14]), .SQ13(SQ[13]),
					.SQ12(SQ[12]), .SQ11(SQ[11]), .SQ10(SQ[10]), .SQ9(SQ[9]), 
				    .SQ8(SQ[8]), .SQ7(SQ[7]), .SQ6(SQ[6]), .SQ5(SQ[5]), .SQ4(SQ[4]),
					.SQ3(SQ[3]), .SQ2(SQ[2]), .SQ1(SQ[1]), .SQ0(SQ[0]),
				    .SV(SV));

// SY1 Node
assign SY1[17]=SFM[17]+SMX-SFI[17]+7'b0110010; //SY1=SFM+SMX-SFI+50
assign SY1[16]=SFM[16]+SMX-SFI[16]+7'b0110010;
assign SY1[15]=SFM[15]+SMX-SFI[15]+7'b0110010;
assign SY1[14]=SFM[14]+SMX-SFI[14]+7'b0110010;
assign SY1[13]=SFM[13]+SMX-SFI[13]+7'b0110010;
assign SY1[12]=SFM[12]+SMX-SFI[12]+7'b0110010;
assign SY1[11]=SFM[11]+SMX-SFI[11]+7'b0110010;
assign SY1[10]=SFM[10]+SMX-SFI[10]+7'b0110010;
assign SY1[9] =SFM[9] +SMX-SFI[9] +7'b0110010;
assign SY1[8] =SFM[8] +SMX-SFI[8] +7'b0110010;
assign SY1[7] =SFM[7] +SMX-SFI[7] +7'b0110010;
assign SY1[6] =SFM[6] +SMX-SFI[6] +7'b0110010;
assign SY1[5] =SFM[5] +SMX-SFI[5] +7'b0110010;
assign SY1[4] =SFM[4] +SMX-SFI[4] +7'b0110010;
assign SY1[3] =SFM[3] +SMX-SFI[3] +7'b0110010;
assign SY1[2] =SFM[2] +SMX-SFI[2] +7'b0110010;
assign SY1[1] =SFM[1] +SMX-SFI[1] +7'b0110010;
assign SY1[0] =SFM[0] +SMX-SFI[0] +7'b0110010;

// SY2 Node
assign SY2[17]=SFM[17]+SFI[17]; //SY2=SFM+SFI
assign SY2[16]=SFM[16]+SFI[16];
assign SY2[15]=SFM[15]+SFI[15];
assign SY2[14]=SFM[14]+SFI[14];
assign SY2[13]=SFM[13]+SFI[13];
assign SY2[12]=SFM[12]+SFI[12];
assign SY2[11]=SFM[11]+SFI[11];
assign SY2[10]=SFM[10]+SFI[10];
assign SY2[9] =SFM[9] +SFI[9];
assign SY2[8] =SFM[8] +SFI[8];
assign SY2[7] =SFM[7] +SFI[7];
assign SY2[6] =SFM[6] +SFI[6];
assign SY2[5] =SFM[5] +SFI[5];
assign SY2[4] =SFM[4] +SFI[4];
assign SY2[3] =SFM[3] +SFI[3];
assign SY2[2] =SFM[2] +SFI[2];
assign SY2[1] =SFM[1] +SFI[1];
assign SY2[0] =SFM[0] +SFI[0];

// SX1 Node
assign SX1[17]=SVDB[17] ? SY1[17]:0;
assign SX1[16]=SVDB[16] ? SY1[16]:0;
assign SX1[15]=SVDB[15] ? SY1[15]:0;
assign SX1[14]=SVDB[14] ? SY1[14]:0;
assign SX1[13]=SVDB[13] ? SY1[13]:0;
assign SX1[12]=SVDB[12] ? SY1[12]:0;
assign SX1[11]=SVDB[11] ? SY1[11]:0;
assign SX1[10]=SVDB[10] ? SY1[10]:0;
assign SX1[9] =SVDB[9]  ? SY1[9] :0;
assign SX1[8] =SVDB[8]  ? SY1[8] :0;
assign SX1[7] =SVDB[7]  ? SY1[7] :0;
assign SX1[6] =SVDB[6]  ? SY1[6] :0;
assign SX1[5] =SVDB[5]  ? SY1[5] :0;
assign SX1[4] =SVDB[4]  ? SY1[4] :0;
assign SX1[3] =SVDB[3]  ? SY1[3] :0;
assign SX1[2] =SVDB[2]  ? SY1[2] :0;
assign SX1[1] =SVDB[1]  ? SY1[1] :0;
assign SX1[0] =SVDB[0]  ? SY1[0] :0;

// SX2 Node
assign SX2[17]=SVD[17] ? SY2[17]:0;
assign SX2[16]=SVD[16] ? SY2[16]:0;
assign SX2[15]=SVD[15] ? SY2[15]:0;
assign SX2[14]=SVD[14] ? SY2[14]:0;
assign SX2[13]=SVD[13] ? SY2[13]:0;
assign SX2[12]=SVD[12] ? SY2[12]:0;
assign SX2[11]=SVD[11] ? SY2[11]:0;
assign SX2[10]=SVD[10] ? SY2[10]:0;
assign SX2[9] =SVD[9]  ? SY2[9] :0;
assign SX2[8] =SVD[8]  ? SY2[8] :0;
assign SX2[7] =SVD[7]  ? SY2[7] :0;
assign SX2[6] =SVD[6]  ? SY2[6] :0;
assign SX2[5] =SVD[5]  ? SY2[5] :0;
assign SX2[4] =SVD[4]  ? SY2[4] :0;
assign SX2[3] =SVD[3]  ? SY2[3] :0;
assign SX2[2] =SVD[2]  ? SY2[2] :0;
assign SX2[1] =SVD[1]  ? SY2[1] :0;
assign SX2[0] =SVD[0]  ? SY2[0] :0;

// SCM Node
assign SCM[17]=SX1[17]-SX2[17];
assign SCM[16]=SX1[16]-SX2[16];
assign SCM[15]=SX1[15]-SX2[15];
assign SCM[14]=SX1[14]-SX2[14];
assign SCM[13]=SX1[13]-SX2[13];
assign SCM[12]=SX1[12]-SX2[12];
assign SCM[11]=SX1[11]-SX2[11];
assign SCM[10]=SX1[10]-SX2[10];
assign SCM[9] =SX1[9] -SX2[9];
assign SCM[8] =SX1[8] -SX2[8];
assign SCM[7] =SX1[7] -SX2[7];
assign SCM[6] =SX1[6] -SX2[6];
assign SCM[5] =SX1[5] -SX2[5];
assign SCM[4] =SX1[4] -SX2[4];
assign SCM[3] =SX1[3] -SX2[3];
assign SCM[2] =SX1[2] -SX2[2];
assign SCM[1] =SX1[1] -SX2[1];
assign SCM[0] =SX1[0] -SX2[0];

// SY Node and MUX operation
assign SY[17]=ISI_SEL ? {1'b0,SFM[17]} : SCM[17];
assign SY[16]=ISI_SEL ? {1'b0,SFM[16]} : SCM[16];
assign SY[15]=ISI_SEL ? {1'b0,SFM[15]} : SCM[15];
assign SY[14]=ISI_SEL ? {1'b0,SFM[14]} : SCM[14];
assign SY[13]=ISI_SEL ? {1'b0,SFM[13]} : SCM[13];
assign SY[12]=ISI_SEL ? {1'b0,SFM[12]} : SCM[12];
assign SY[11]=ISI_SEL ? {1'b0,SFM[11]} : SCM[11];
assign SY[10]=ISI_SEL ? {1'b0,SFM[10]} : SCM[10];
assign SY[9] =ISI_SEL ? {1'b0,SFM[9]}  : SCM[9];
assign SY[8] =ISI_SEL ? {1'b0,SFM[8]}  : SCM[8];
assign SY[7] =ISI_SEL ? {1'b0,SFM[7]}  : SCM[7];
assign SY[6] =ISI_SEL ? {1'b0,SFM[6]}  : SCM[6];
assign SY[5] =ISI_SEL ? {1'b0,SFM[5]}  : SCM[5];
assign SY[4] =ISI_SEL ? {1'b0,SFM[4]}  : SCM[4];
assign SY[3] =ISI_SEL ? {1'b0,SFM[3]}  : SCM[3];
assign SY[2] =ISI_SEL ? {1'b0,SFM[2]}  : SCM[2];
assign SY[1] =ISI_SEL ? {1'b0,SFM[1]}  : SCM[1];
assign SY[0] =ISI_SEL ? {1'b0,SFM[0]}  : SCM[0];

// Output
assign SVout=SV;
assign STout=ST;

// Debug Ports
/*assign TS17={4'b0000,Gama};
assign TS16={4'b0000,Beta};
assign TS15=SFM[15];
assign TS14=SFM[14];
assign TS13=SFM[13];
assign TS12=SFM[12];
assign TS11=SFM[11];
assign TS10=SFM[10];
assign TS9 =SFM[9];
assign TS8 =SFM[8];
assign TS7 =SFM[7];
assign TS6 =SFM[6];
assign TS5 =SFM[5];
assign TS4 =SFM[4];
assign TS3 =SFM[3];
assign TS2 =SFM[2];
assign TS1 =SFM[1];
assign TS0 =SFM[0];*/

endmodule
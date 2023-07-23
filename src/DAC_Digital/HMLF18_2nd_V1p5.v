//###################################
// 18-inputs MIS Shaping Loop Filter
// Order: 2nd-order
// Version 1.5
//###################################

module HMLF18_2nd_V1p5(clk, rstn, SV, SD,
					   SFM17,SFM16,SFM15,SFM14,SFM13,SFM12,SFM11,SFM10,
				       SFM9,SFM8,SFM7,SFM6,SFM5,SFM4,SFM3,SFM2,SFM1,SFM0);

//-----------------------------------
// SV: Input SV Vector;
// SD: Output Delayed SV;
// SFM17-SFM0: Filter Output Vector;
// clk: input clock;
// rstn: rest signal, 0 enable rest;
//-----------------------------------

input [17:0] SV;
input clk, rstn;
output [6:0] SFM17,SFM16,SFM15,SFM14,SFM13,SFM12,SFM11,SFM10,SFM9,SFM8,SFM7,SFM6,SFM5,SFM4,SFM3,SFM2,SFM1,SFM0;
output [17:0] SD;

reg  signed [6:0] SVD  [17:0];
reg  signed [6:0] SMD1 [17:0];
wire signed [6:0] SE1  [17:0];
wire signed [6:0] SU1;
wire signed [6:0] SM1  [17:0];
reg  signed [6:0] SMD2 [17:0];
wire signed [6:0] SE2  [17:0];
wire signed [6:0] SU2;
wire signed [6:0] SM2  [17:0];

// MIN Operation
MIN18_HMLF_V1p5 MIN18_1(.a17(SE1[17]), .a16(SE1[16]), .a15(SE1[15]), .a14(SE1[14]), .a13(SE1[13]),
						.a12(SE1[12]), .a11(SE1[11]), .a10(SE1[10]), .a9(SE1[9]),
						.a8(SE1[8]),   .a7(SE1[7]),   .a6(SE1[6]),   .a5(SE1[5]),  .a4(SE1[4]),
						.a3(SE1[3]),   .a2(SE1[2]),   .a1(SE1[1]),   .a0(SE1[0]),  .b(SU1));
MIN18_HMLF_V1p5 MIN18_2(.a17(SE2[17]), .a16(SE2[16]), .a15(SE2[15]), .a14(SE2[14]), .a13(SE2[13]),
						.a12(SE2[12]), .a11(SE2[11]), .a10(SE2[10]), .a9(SE2[9]),
						.a8(SE2[8]),   .a7(SE2[7]),   .a6(SE2[6]),   .a5(SE2[5]),   .a4(SE2[4]),
						.a3(SE2[3]),   .a2(SE2[2]),   .a1(SE2[1]),   .a0(SE2[0]),   .b(SU2));

// 移位的功能
always @(posedge clk or negedge rstn)
	if(rstn==0)begin
		SVD[17]<=0;
		SVD[16]<=0;
		SVD[15]<=0;
		SVD[14]<=0;
		SVD[13]<=0;
		SVD[12]<=0;
		SVD[11]<=0;
		SVD[10]<=0;
		SVD[9]<=0;
		SVD[8]<=0;
		SVD[7]<=0;
		SVD[6]<=0;
		SVD[5]<=0;
		SVD[4]<=0;
		SVD[3]<=0;
		SVD[2]<=0;
		SVD[1]<=0;
		SVD[0]<=0;
		
		SMD1[17]<=0;
		SMD1[16]<=0;
		SMD1[15]<=0;
		SMD1[14]<=0;
		SMD1[13]<=0;
		SMD1[12]<=0;
		SMD1[11]<=0;
		SMD1[10]<=0;
		SMD1[9]<=0;
		SMD1[8]<=0;
		SMD1[7]<=0;
		SMD1[6]<=0;
		SMD1[5]<=0;
		SMD1[4]<=0;
		SMD1[3]<=0;
		SMD1[2]<=0;
		SMD1[1]<=0;
		SMD1[0]<=0;
		
		SMD2[17]<=0;
		SMD2[16]<=0;
		SMD2[15]<=0;
		SMD2[14]<=0;
		SMD2[13]<=0;
		SMD2[12]<=0;
		SMD2[11]<=0;
		SMD2[10]<=0;
		SMD2[9]<=0;
		SMD2[8]<=0;
		SMD2[7]<=0;
		SMD2[6]<=0;
		SMD2[5]<=0;
		SMD2[4]<=0;
		SMD2[3]<=0;
		SMD2[2]<=0;
		SMD2[1]<=0;
		SMD2[0]<=0;
	end
	else begin
		SVD[17]<={6'b0,SV[17]};
		SVD[16]<={6'b0,SV[16]};
		SVD[15]<={6'b0,SV[15]};
		SVD[14]<={6'b0,SV[14]};
		SVD[13]<={6'b0,SV[13]};
		SVD[12]<={6'b0,SV[12]};
		SVD[11]<={6'b0,SV[11]};
		SVD[10]<={6'b0,SV[10]};
		SVD[9]<={6'b0,SV[9]};
		SVD[8]<={6'b0,SV[8]};
		SVD[7]<={6'b0,SV[7]};
		SVD[6]<={6'b0,SV[6]};
		SVD[5]<={6'b0,SV[5]};
		SVD[4]<={6'b0,SV[4]};
		SVD[3]<={6'b0,SV[3]};
		SVD[2]<={6'b0,SV[2]};
		SVD[1]<={6'b0,SV[1]};
		SVD[0]<={6'b0,SV[0]};
		
		SMD1[17]<=SM1[17];
		SMD1[16]<=SM1[16];
		SMD1[15]<=SM1[15];
		SMD1[14]<=SM1[14];
		SMD1[13]<=SM1[13];
		SMD1[12]<=SM1[12];
		SMD1[11]<=SM1[11];
		SMD1[10]<=SM1[10];
		SMD1[9]<=SM1[9];
		SMD1[8]<=SM1[8];
		SMD1[7]<=SM1[7];
		SMD1[6]<=SM1[6];
		SMD1[5]<=SM1[5];
		SMD1[4]<=SM1[4];
		SMD1[3]<=SM1[3];
		SMD1[2]<=SM1[2];
		SMD1[1]<=SM1[1];
		SMD1[0]<=SM1[0];
		
		SMD2[17]<=SM2[17];
		SMD2[16]<=SM2[16];
		SMD2[15]<=SM2[15];
		SMD2[14]<=SM2[14];
		SMD2[13]<=SM2[13];
		SMD2[12]<=SM2[12];
		SMD2[11]<=SM2[11];
		SMD2[10]<=SM2[10];
		SMD2[9]<=SM2[9];
		SMD2[8]<=SM2[8];
		SMD2[7]<=SM2[7];
		SMD2[6]<=SM2[6];
		SMD2[5]<=SM2[5];
		SMD2[4]<=SM2[4];
		SMD2[3]<=SM2[3];
		SMD2[2]<=SM2[2];
		SMD2[1]<=SM2[1];
		SMD2[0]<=SM2[0];
	end

// SE Node
assign SE1[17]=-SVD[17]+SMD1[17];
assign SE1[16]=-SVD[16]+SMD1[16];
assign SE1[15]=-SVD[15]+SMD1[15];
assign SE1[14]=-SVD[14]+SMD1[14];
assign SE1[13]=-SVD[13]+SMD1[13];
assign SE1[12]=-SVD[12]+SMD1[12];
assign SE1[11]=-SVD[11]+SMD1[11];
assign SE1[10]=-SVD[10]+SMD1[10];
assign SE1[9] =-SVD[9] +SMD1[9];
assign SE1[8] =-SVD[8] +SMD1[8];
assign SE1[7] =-SVD[7] +SMD1[7];
assign SE1[6] =-SVD[6] +SMD1[6];
assign SE1[5] =-SVD[5] +SMD1[5];
assign SE1[4] =-SVD[4] +SMD1[4];
assign SE1[3] =-SVD[3] +SMD1[3];
assign SE1[2] =-SVD[2] +SMD1[2];
assign SE1[1] =-SVD[1] +SMD1[1];
assign SE1[0] =-SVD[0] +SMD1[0];

assign SE2[17]=-SVD[17]+SM1[17]+SMD2[17];
assign SE2[16]=-SVD[16]+SM1[16]+SMD2[16];
assign SE2[15]=-SVD[15]+SM1[15]+SMD2[15];
assign SE2[14]=-SVD[14]+SM1[14]+SMD2[14];
assign SE2[13]=-SVD[13]+SM1[13]+SMD2[13];
assign SE2[12]=-SVD[12]+SM1[12]+SMD2[12];
assign SE2[11]=-SVD[11]+SM1[11]+SMD2[11];
assign SE2[10]=-SVD[10]+SM1[10]+SMD2[10];
assign SE2[9] =-SVD[9] +SM1[9] +SMD2[9];
assign SE2[8] =-SVD[8] +SM1[8] +SMD2[8];
assign SE2[7] =-SVD[7] +SM1[7] +SMD2[7];
assign SE2[6] =-SVD[6] +SM1[6] +SMD2[6];
assign SE2[5] =-SVD[5] +SM1[5] +SMD2[5];
assign SE2[4] =-SVD[4] +SM1[4] +SMD2[4];
assign SE2[3] =-SVD[3] +SM1[3] +SMD2[3];
assign SE2[2] =-SVD[2] +SM1[2] +SMD2[2];
assign SE2[1] =-SVD[1] +SM1[1] +SMD2[1];
assign SE2[0] =-SVD[0] +SM1[0] +SMD2[0];

// SM Node
assign SM1[17]=SE1[17]-SU1;
assign SM1[16]=SE1[16]-SU1;
assign SM1[15]=SE1[15]-SU1;
assign SM1[14]=SE1[14]-SU1;
assign SM1[13]=SE1[13]-SU1;
assign SM1[12]=SE1[12]-SU1;
assign SM1[11]=SE1[11]-SU1;
assign SM1[10]=SE1[10]-SU1;
assign SM1[9] =SE1[9] -SU1;
assign SM1[8] =SE1[8] -SU1;
assign SM1[7] =SE1[7] -SU1;
assign SM1[6] =SE1[6] -SU1;
assign SM1[5] =SE1[5] -SU1;
assign SM1[4] =SE1[4] -SU1;
assign SM1[3] =SE1[3] -SU1;
assign SM1[2] =SE1[2] -SU1;
assign SM1[1] =SE1[1] -SU1;
assign SM1[0] =SE1[0] -SU1;

assign SM2[17]=SE2[17]-SU2;
assign SM2[16]=SE2[16]-SU2;
assign SM2[15]=SE2[15]-SU2;
assign SM2[14]=SE2[14]-SU2;
assign SM2[13]=SE2[13]-SU2;
assign SM2[12]=SE2[12]-SU2;
assign SM2[11]=SE2[11]-SU2;
assign SM2[10]=SE2[10]-SU2;
assign SM2[9] =SE2[9] -SU2;
assign SM2[8] =SE2[8] -SU2;
assign SM2[7] =SE2[7] -SU2;
assign SM2[6] =SE2[6] -SU2;
assign SM2[5] =SE2[5] -SU2;
assign SM2[4] =SE2[4] -SU2;
assign SM2[3] =SE2[3] -SU2;
assign SM2[2] =SE2[2] -SU2;
assign SM2[1] =SE2[1] -SU2;
assign SM2[0] =SE2[0] -SU2;

// Output
assign SFM17 = SM2[17][5:0]+SM1[17][5:0];
assign SFM16 = SM2[16][5:0]+SM1[16][5:0];
assign SFM15 = SM2[15][5:0]+SM1[15][5:0];
assign SFM14 = SM2[14][5:0]+SM1[14][5:0];
assign SFM13 = SM2[13][5:0]+SM1[13][5:0];
assign SFM12 = SM2[12][5:0]+SM1[12][5:0];
assign SFM11 = SM2[11][5:0]+SM1[11][5:0];
assign SFM10 = SM2[10][5:0]+SM1[10][5:0];
assign SFM9  = SM2[9][5:0] +SM1[9][5:0];
assign SFM8  = SM2[8][5:0] +SM1[8][5:0];
assign SFM7  = SM2[7][5:0] +SM1[7][5:0];
assign SFM6  = SM2[6][5:0] +SM1[6][5:0];
assign SFM5  = SM2[5][5:0] +SM1[5][5:0];
assign SFM4  = SM2[4][5:0] +SM1[4][5:0];
assign SFM3  = SM2[3][5:0] +SM1[3][5:0];
assign SFM2  = SM2[2][5:0] +SM1[2][5:0];
assign SFM1  = SM2[1][5:0] +SM1[1][5:0];
assign SFM0  = SM2[0][5:0] +SM1[0][5:0];

assign SD[17] = SVD[17][0];
assign SD[16] = SVD[16][0];
assign SD[15] = SVD[15][0];
assign SD[14] = SVD[14][0];
assign SD[13] = SVD[13][0];
assign SD[12] = SVD[12][0];
assign SD[11] = SVD[11][0];
assign SD[10] = SVD[10][0];
assign SD[9]  = SVD[9][0];
assign SD[8]  = SVD[8][0];
assign SD[7]  = SVD[7][0];
assign SD[6]  = SVD[6][0];
assign SD[5]  = SVD[5][0];
assign SD[4]  = SVD[4][0];
assign SD[3]  = SVD[3][0];
assign SD[2]  = SVD[2][0];
assign SD[1]  = SVD[1][0];
assign SD[0]  = SVD[0][0];

endmodule
//##################################
// 6-inputs MIS Shaping Loop Filter
// Order: 2nd-order
// Version 1.6
//##################################

module HMLF6_2nd(clk, clk_en, rstn, SV, SD,
				 SFM5,SFM4,SFM3,SFM2,SFM1,SFM0);

//----------------------------------
// SV: Input SV Vector;
// SD: Output Delayed SV;
// SFM5-SFM0: Filter Output Vector;
// clk: input clock;
// rstn: rest signal, 0 enable;
//----------------------------------

input [5:0] SV;
input clk, clk_en, rstn;
output [5:0] SFM5,SFM4,SFM3,SFM2,SFM1,SFM0;
output [5:0] SD;

reg  signed [5:0] SVD  [5:0];
reg  signed [5:0] SMD1 [5:0];
wire signed [5:0] SE1  [5:0];
wire signed [5:0] SU1;
wire signed [5:0] SM1  [5:0];
reg  signed [5:0] SMD2 [5:0];
wire signed [5:0] SE2  [5:0];
wire signed [5:0] SU2;
wire signed [5:0] SM2  [5:0];

// MIN Operation
MIN6_HMLF MIN6_1(.a5(SE1[5]), .a4(SE1[4]), .a3(SE1[3]), .a2(SE1[2]), .a1(SE1[1]), .a0(SE1[0]),
			     .b(SU1));
MIN6_HMLF MIN6_2(.a5(SE2[5]), .a4(SE2[4]), .a3(SE2[3]), .a2(SE2[2]), .a1(SE2[1]), .a0(SE2[0]),
			     .b(SU2));

// 移位的功能
always @(posedge clk or negedge rstn) begin
	if(rstn==0)begin
		SVD[5]<=0;
		SVD[4]<=0;
		SVD[3]<=0;
		SVD[2]<=0;
		SVD[1]<=0;
		SVD[0]<=0;
		
		SMD1[5]<=0;
		SMD1[4]<=0;
		SMD1[3]<=0;
		SMD1[2]<=0;
		SMD1[1]<=0;
		SMD1[0]<=0;
		
		SMD2[5]<=0;
		SMD2[4]<=0;
		SMD2[3]<=0;
		SMD2[2]<=0;
		SMD2[1]<=0;
		SMD2[0]<=0;
	end
	else if(clk_en)begin
		SVD[5]<={5'b0,SV[5]};
		SVD[4]<={5'b0,SV[4]};
		SVD[3]<={5'b0,SV[3]};
		SVD[2]<={5'b0,SV[2]};
		SVD[1]<={5'b0,SV[1]};
		SVD[0]<={5'b0,SV[0]};
		
		SMD1[5]<=SM1[5];
		SMD1[4]<=SM1[4];
		SMD1[3]<=SM1[3];
		SMD1[2]<=SM1[2];
		SMD1[1]<=SM1[1];
		SMD1[0]<=SM1[0];
		
		SMD2[5]<=SM2[5];
		SMD2[4]<=SM2[4];
		SMD2[3]<=SM2[3];
		SMD2[2]<=SM2[2];
		SMD2[1]<=SM2[1];
		SMD2[0]<=SM2[0];
	end
	else begin
		SVD[5]<=SVD[5];
		SVD[4]<=SVD[4];
		SVD[3]<=SVD[3];
		SVD[2]<=SVD[2];
		SVD[1]<=SVD[1];
		SVD[0]<=SVD[0];
		
		SMD1[5]<=SMD1[5];
		SMD1[4]<=SMD1[4];
		SMD1[3]<=SMD1[3];
		SMD1[2]<=SMD1[2];
		SMD1[1]<=SMD1[1];
		SMD1[0]<=SMD1[0];
		
		SMD2[5]<=SMD2[5];
		SMD2[4]<=SMD2[4];
		SMD2[3]<=SMD2[3];
		SMD2[2]<=SMD2[2];
		SMD2[1]<=SMD2[1];
		SMD2[0]<=SMD2[0];
	end
end

// SE Node
assign SE1[5]=-SVD[5]+SMD1[5];
assign SE1[4]=-SVD[4]+SMD1[4];
assign SE1[3]=-SVD[3]+SMD1[3];
assign SE1[2]=-SVD[2]+SMD1[2];
assign SE1[1]=-SVD[1]+SMD1[1];
assign SE1[0]=-SVD[0]+SMD1[0];

assign SE2[5]=-SVD[5]+SM1[5]+SMD2[5];
assign SE2[4]=-SVD[4]+SM1[4]+SMD2[4];
assign SE2[3]=-SVD[3]+SM1[3]+SMD2[3];
assign SE2[2]=-SVD[2]+SM1[2]+SMD2[2];
assign SE2[1]=-SVD[1]+SM1[1]+SMD2[1];
assign SE2[0]=-SVD[0]+SM1[0]+SMD2[0];

// SM Node
assign SM1[5]=SE1[5]-SU1;
assign SM1[4]=SE1[4]-SU1;
assign SM1[3]=SE1[3]-SU1;
assign SM1[2]=SE1[2]-SU1;
assign SM1[1]=SE1[1]-SU1;
assign SM1[0]=SE1[0]-SU1;

assign SM2[5]=SE2[5]-SU2;
assign SM2[4]=SE2[4]-SU2;
assign SM2[3]=SE2[3]-SU2;
assign SM2[2]=SE2[2]-SU2;
assign SM2[1]=SE2[1]-SU2;
assign SM2[0]=SE2[0]-SU2;

// Output
assign SFM5 = SM2[5][4:0]+SM1[5][4:0];
assign SFM4 = SM2[4][4:0]+SM1[4][4:0];
assign SFM3 = SM2[3][4:0]+SM1[3][4:0];
assign SFM2 = SM2[2][4:0]+SM1[2][4:0];
assign SFM1 = SM2[1][4:0]+SM1[1][4:0];
assign SFM0 = SM2[0][4:0]+SM1[0][4:0];

assign SD[5] = SVD[5][0];
assign SD[4] = SVD[4][0];
assign SD[3] = SVD[3][0];
assign SD[2] = SVD[2][0];
assign SD[1] = SVD[1][0];
assign SD[0] = SVD[0][0];

endmodule
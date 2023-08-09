//###################################
// 18-inputs ISI Shaping Loop Filter
// Order: 1st-order
// Version 1.6
//###################################

module HILF18_1st(ST, clk, clk_en, rstn,
				  SFI17,SFI16,SFI15,SFI14,SFI13,SFI12,SFI11,SFI10,
				  SFI9,SFI8,SFI7,SFI6,SFI5,SFI4,SFI3,SFI2,SFI1,SFI0);

//---------------------------------
// ST: Up Transition Vector;
// clk: input clock;
// rstn: rest signal, 0 enable rest;
//---------------------------------

input [17:0] ST;
input clk, clk_en, rstn;
output [3:0] SFI17,SFI16,SFI15,SFI14,SFI13,SFI12,SFI11,SFI10,SFI9,SFI8,SFI7,SFI6,SFI5,SFI4,SFI3,SFI2,SFI1,SFI0;

wire [3:0] FI  [17:0];
reg  [3:0] FID [17:0];
wire [3:0] SR  [17:0];
wire [3:0] SU;

// MIN Operation
MIN18_HILF MIN18(.a17(SR[17]), .a16(SR[16]), .a15(SR[15]), .a14(SR[14]), .a13(SR[13]),
				 .a12(SR[12]), .a11(SR[11]), .a10(SR[10]), .a9(SR[9]),
				 .a8(SR[8]),   .a7(SR[7]),   .a6(SR[6]),   .a5(SR[5]),   .a4(SR[4]),
				 .a3(SR[3]),   .a2(SR[2]),   .a1(SR[1]),   .a0(SR[0]),
				 .b(SU));

// 移位功能
always @(posedge clk or negedge rstn) begin
	if(rstn==0)begin
		FID[17]<=0;
		FID[16]<=0;
		FID[15]<=0;
		FID[14]<=0;
		FID[13]<=0;
		FID[12]<=0;
		FID[11]<=0;
		FID[10]<=0;
		FID[9]<=0;
		FID[8]<=0;
		FID[7]<=0;
		FID[6]<=0;
		FID[5]<=0;
		FID[4]<=0;
		FID[3]<=0;
		FID[2]<=0;
		FID[1]<=0;
		FID[0]<=0;
	end
	else if(clk_en)begin
		FID[17]<=FI[17];
		FID[16]<=FI[16];
		FID[15]<=FI[15];
		FID[14]<=FI[14];
		FID[13]<=FI[13];
		FID[12]<=FI[12];
		FID[11]<=FI[11];
		FID[10]<=FI[10];
		FID[9]<=FI[9];
		FID[8]<=FI[8];
		FID[7]<=FI[7];
		FID[6]<=FI[6];
		FID[5]<=FI[5];
		FID[4]<=FI[4];
		FID[3]<=FI[3];
		FID[2]<=FI[2];
		FID[1]<=FI[1];
		FID[0]<=FI[0];
	end
	else begin
		FID[17]<=FID[17];
		FID[16]<=FID[16];
		FID[15]<=FID[15];
		FID[14]<=FID[14];
		FID[13]<=FID[13];
		FID[12]<=FID[12];
		FID[11]<=FID[11];
		FID[10]<=FID[10];
		FID[9]<=FID[9];
		FID[8]<=FID[8];
		FID[7]<=FID[7];
		FID[6]<=FID[6];
		FID[5]<=FID[5];
		FID[4]<=FID[4];
		FID[3]<=FID[3];
		FID[2]<=FID[2];
		FID[1]<=FID[1];
		FID[0]<=FID[0];
	end
end

// SR Node
assign SR[17]={3'b0,ST[17]}+FID[17];
assign SR[16]={3'b0,ST[16]}+FID[16];
assign SR[15]={3'b0,ST[15]}+FID[15];
assign SR[14]={3'b0,ST[14]}+FID[14];
assign SR[13]={3'b0,ST[13]}+FID[13];
assign SR[12]={3'b0,ST[12]}+FID[12];
assign SR[11]={3'b0,ST[11]}+FID[11];
assign SR[10]={3'b0,ST[10]}+FID[10];
assign SR[9] ={3'b0,ST[9]} +FID[9];
assign SR[8] ={3'b0,ST[8]} +FID[8];
assign SR[7] ={3'b0,ST[7]} +FID[7];
assign SR[6] ={3'b0,ST[6]} +FID[6];
assign SR[5] ={3'b0,ST[5]} +FID[5];
assign SR[4] ={3'b0,ST[4]} +FID[4];
assign SR[3] ={3'b0,ST[3]} +FID[3];
assign SR[2] ={3'b0,ST[2]} +FID[2];
assign SR[1] ={3'b0,ST[1]} +FID[1];
assign SR[0] ={3'b0,ST[0]} +FID[0];

// FI Node
assign FI[17]=SR[17]-SU;
assign FI[16]=SR[16]-SU;
assign FI[15]=SR[15]-SU;
assign FI[14]=SR[14]-SU;
assign FI[13]=SR[13]-SU;
assign FI[12]=SR[12]-SU;
assign FI[11]=SR[11]-SU;
assign FI[10]=SR[10]-SU;
assign FI[9] =SR[9] -SU;
assign FI[8] =SR[8] -SU;
assign FI[7] =SR[7] -SU;
assign FI[6] =SR[6] -SU;
assign FI[5] =SR[5] -SU;
assign FI[4] =SR[4] -SU;
assign FI[3] =SR[3] -SU;
assign FI[2] =SR[2] -SU;
assign FI[1] =SR[1] -SU;
assign FI[0] =SR[0] -SU;

// Output
assign SFI17=FI[17];
assign SFI16=FI[16];
assign SFI15=FI[15];
assign SFI14=FI[14];
assign SFI13=FI[13];
assign SFI12=FI[12];
assign SFI11=FI[11];
assign SFI10=FI[10];
assign SFI9 =FI[9];
assign SFI8 =FI[8];
assign SFI7 =FI[7];
assign SFI6 =FI[6];
assign SFI5 =FI[5];
assign SFI4 =FI[4];
assign SFI3 =FI[3];
assign SFI2 =FI[2];
assign SFI1 =FI[1];
assign SFI0 =FI[0];

/*assign SFI15=SR[15];
assign SFI14=SR[14];
assign SFI13=SR[13];
assign SFI12=SR[12];
assign SFI11=SR[11];
assign SFI10=SR[10];
assign SFI9=SR[9];
assign SFI8=SR[8];
assign SFI7=SR[7];
assign SFI6=SR[6];
assign SFI5=SR[5];
assign SFI4=SR[4];
assign SFI3=SR[3];
assign SFI2=SR[2];
assign SFI1=SR[1];
assign SFI0=SR[0];*/

endmodule
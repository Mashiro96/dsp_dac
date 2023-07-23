//-----------------------------------
// 6-inputs ISI Shaping Loop Filter
// Order: 1st-order
// Version 1.6
//-----------------------------------

module HILF6_1st(ST, clk, rstn,
				 SFI5,SFI4,SFI3,SFI2,SFI1,SFI0);

//----------------------------------
// ST: Up Transition Vector;
// clk: input clock;
// rstn: rest signal, 0 enable rest;
//----------------------------------

input [5:0] ST;
input clk, rstn;
output [3:0] SFI5,SFI4,SFI3,SFI2,SFI1,SFI0;

wire [3:0] FI  [5:0];
reg  [3:0] FID [5:0];
wire [3:0] SR  [5:0];
wire [3:0] SU;

// MIN Operation
MIN6_HILF MIN6(.a5(SR[5]), .a4(SR[4]), .a3(SR[3]), .a2(SR[2]), .a1(SR[1]), .a0(SR[0]),
			   .b(SU));

// 移位功能
always @(posedge clk or negedge rstn)
	if(rstn==0)begin
		FID[5]<=0;
		FID[4]<=0;
		FID[3]<=0;
		FID[2]<=0;
		FID[1]<=0;
		FID[0]<=0;
	end
	else begin
		FID[5]<=FI[5];
		FID[4]<=FI[4];
		FID[3]<=FI[3];
		FID[2]<=FI[2];
		FID[1]<=FI[1];
		FID[0]<=FI[0];
	end

// SR Node
assign SR[5]={3'b0,ST[5]}+FID[5];
assign SR[4]={3'b0,ST[4]}+FID[4];
assign SR[3]={3'b0,ST[3]}+FID[3];
assign SR[2]={3'b0,ST[2]}+FID[2];
assign SR[1]={3'b0,ST[1]}+FID[1];
assign SR[0]={3'b0,ST[0]}+FID[0];

// FI Node
assign FI[5]=SR[5]-SU;
assign FI[4]=SR[4]-SU;
assign FI[3]=SR[3]-SU;
assign FI[2]=SR[2]-SU;
assign FI[1]=SR[1]-SU;
assign FI[0]=SR[0]-SU;

// Output
assign SFI5=FI[5];
assign SFI4=FI[4];
assign SFI3=FI[3];
assign SFI2=FI[2];
assign SFI1=FI[1];
assign SFI0=FI[0];

/*
assign SFI5=SR[5];
assign SFI4=SR[4];
assign SFI3=SR[3];
assign SFI2=SR[2];
assign SFI1=SR[1];
assign SFI0=SR[0];*/

endmodule
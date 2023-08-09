// ########################################
//# 0.6-inputs ISI and MS Loop Combination #
//# 1.1st-order for ISI Loop               #
//# 2.2nd-order for MS Loop                #
//# 3.With ISI Shaping Bypass Function     #
//# 4.With MIS Shaping Bypass Function     #
//#            Version 1.5                 #
// ########################################

module ISI_MS_6_V1p5(clk, clk_en, rstn, V, ISI_SEL, MIS_SEL,
					 SVout, STout);

//---------------------------------------------------
// clk:     input clock;
// rstn:    rest signal, 0 enable;
// V:       input selected number;
// SVout:   Output SV Vector;
// STout:   Output ST Vector;
// TS5~TS0: Debug ports;
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

input clk, clk_en, rstn, ISI_SEL, MIS_SEL;
input signed [3:0] V;//Input elements number
output [5:0] SVout;  //Outoput SV vector
output [5:0] STout;  //Outoput ST vector
//output signed [7:0] TS5,TS4,TS3,TS2,TS1,TS0;

wire [5:0] SV;
wire [5:0] SVD,SVDB;
wire [5:0] ST;
wire [5:0] SFM [5:0];
wire [3:0] SFI [5:0];
wire [5:0] SMX;
wire signed [7:0] SY1 [5:0];
wire signed [7:0] SY2 [5:0];
wire signed [7:0] SX1 [5:0];
wire signed [7:0] SX2 [5:0];
wire signed [7:0] SCM [5:0];
wire signed [7:0] SY  [5:0];
wire [2:0] SQ  [5:0]; // VQ output adress
wire signed [1:0] dither; // dither sequence
wire [1:0] Gama; //Transition selection number
wire [1:0] Beta; //Ones selection number
reg signed [3:0] Vinput;

assign SVDB=~SVD;

always @(posedge clk or negedge rstn) begin
	if(rstn==0)begin
		Vinput<=0;
	end
	else if(clk_en) begin
		Vinput<=V;
	end
	else begin
		Vinput<=Vinput;
	end
end

// Dither Sequence Generator OK
Dither_Gen6 Dither_Gen6(.clk(clk), .clk_en(clk_en), .rstn(rstn),
					    .dither(dither));

// De-couple Sequence Generator OK
Decp_Gen6 Decp_Gen6(.clk(clk), .clk_en(clk_en), .rstn(rstn), .dither(dither), .V(Vinput),
				    .Gama(Gama), .Beta(Beta));

// HMLF Operation OK
HMLF6_2nd HMLF6_2nd(.clk(clk), .clk_en(clk_en), .rstn(rstn), .SV(SV),
				    .SD(SVD),
				    .SFM5(SFM[5]), .SFM4(SFM[4]), .SFM3(SFM[3]), .SFM2(SFM[2]), .SFM1(SFM[1]), .SFM0(SFM[0]));

// Transition Operation OK
Tran_Det6 Tran_Det6(.clk(clk), .clk_en(clk_en), .rstn(rstn), .SV(SVD), //这个SV的传输需要非常的注意，必须是SV的一个delay周期
				    .ST(ST));

// HILF Operation OK
HILF6_1st HILF6_1st(.clk(clk), .clk_en(clk_en), .rstn(rstn), .ST(ST),
				    .SFI5(SFI[5]), .SFI4(SFI[4]), .SFI3(SFI[3]), .SFI2(SFI[2]), .SFI1(SFI[1]), .SFI0(SFI[0]));

// MAX Operation OK
MAX6 MAX6(.a5(SFM[5]), .a4(SFM[4]), .a3(SFM[3]), .a2(SFM[2]), .a1(SFM[1]), .a0(SFM[0]),
		  .b(SMX));
			
// VQ Operation 
VQ6_V1p5 VQ6_V1p5(.a5(SY[5]), .a4(SY[4]), .a3(SY[3]), .a2(SY[2]), .a1(SY[1]), .a0(SY[0]),
				  .b5(SQ[5]), .b4(SQ[4]), .b3(SQ[3]), .b2(SQ[2]), .b1(SQ[1]), .b0(SQ[0]));

// Digital Selection Operation
Dig_Sel6 Dig_Sel6(.Gama({1'b0,Gama}), .Beta({1'b0,Beta}), .ISI_SEL(ISI_SEL), .V(Vinput), .MIS_SEL(MIS_SEL),
				  .SQ5(SQ[5]), .SQ4(SQ[4]), .SQ3(SQ[3]), .SQ2(SQ[2]), .SQ1(SQ[1]), .SQ0(SQ[0]),
				  .SV(SV));

// SY1 Node
assign SY1[5]=SFM[5]+SMX-SFI[5]+6'b110010; //SY1=SFM+SMX-SFI+50
assign SY1[4]=SFM[4]+SMX-SFI[4]+6'b110010;
assign SY1[3]=SFM[3]+SMX-SFI[3]+6'b110010;
assign SY1[2]=SFM[2]+SMX-SFI[2]+6'b110010;
assign SY1[1]=SFM[1]+SMX-SFI[1]+6'b110010;
assign SY1[0]=SFM[0]+SMX-SFI[0]+6'b110010;

// SY2 Node
assign SY2[5]=SFM[5]+SFI[5]; //SY2=SFM+SFI
assign SY2[4]=SFM[4]+SFI[4];
assign SY2[3]=SFM[3]+SFI[3];
assign SY2[2]=SFM[2]+SFI[2];
assign SY2[1]=SFM[1]+SFI[1];
assign SY2[0]=SFM[0]+SFI[0];

// SX1 Node
assign SX1[5]=SVDB[5] ? SY1[5] : 0;
assign SX1[4]=SVDB[4] ? SY1[4] : 0;
assign SX1[3]=SVDB[3] ? SY1[3] : 0;
assign SX1[2]=SVDB[2] ? SY1[2] : 0;
assign SX1[1]=SVDB[1] ? SY1[1] : 0;
assign SX1[0]=SVDB[0] ? SY1[0] : 0;

// SX2 Node
assign SX2[5]=SVD[5] ? SY2[5] : 0;
assign SX2[4]=SVD[4] ? SY2[4] : 0;
assign SX2[3]=SVD[3] ? SY2[3] : 0;
assign SX2[2]=SVD[2] ? SY2[2] : 0;
assign SX2[1]=SVD[1] ? SY2[1] : 0;
assign SX2[0]=SVD[0] ? SY2[0] : 0;

// SCM Node
assign SCM[5]=SX1[5]-SX2[5];
assign SCM[4]=SX1[4]-SX2[4];
assign SCM[3]=SX1[3]-SX2[3];
assign SCM[2]=SX1[2]-SX2[2];
assign SCM[1]=SX1[1]-SX2[1];
assign SCM[0]=SX1[0]-SX2[0];

// SY Node and MUX operation
assign SY[5]=ISI_SEL ? {2'b00,SFM[5]} : SCM[5];
assign SY[4]=ISI_SEL ? {2'b00,SFM[4]} : SCM[4];
assign SY[3]=ISI_SEL ? {2'b00,SFM[3]} : SCM[3];
assign SY[2]=ISI_SEL ? {2'b00,SFM[2]} : SCM[2];
assign SY[1]=ISI_SEL ? {2'b00,SFM[1]} : SCM[1];
assign SY[0]=ISI_SEL ? {2'b00,SFM[0]} : SCM[0];

// Output
assign SVout=SV;
assign STout=ST;

// Debug Ports
/*assign TS5=SFM[5];
assign TS4=SFM[4];
assign TS3=SFM[3];
assign TS2=SFM[2];
assign TS1=SFM[1];
assign TS0=SFM[0];*/

endmodule
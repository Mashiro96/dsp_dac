//#############################
// 6-inputs Digital Selector
// Version 1.1
//#############################

module Dig_Sel6(V,Gama,Beta,SV,ISI_SEL,MIS_SEL,
			    SQ5,SQ4,SQ3,SQ2,SQ1,SQ0);

//---------------------------------
// V: number of selected element;
// ISI_SEL: ISI bypass enable;
// MIS_SEL: MIS bypass enable;
// SQ6-SQ0: Sorted Vector;
// Gama: Zeros Selected Number;
// Beta: Ones Selected Number;
//---------------------------------

input  signed [3:0] V;
input  ISI_SEL,MIS_SEL;
input  [2:0] SQ5,SQ4,SQ3,SQ2,SQ1,SQ0;
input  [2:0] Gama;
input  [2:0] Beta;
output [5:0] SV;

wire [5:0] ad5,ad4,ad3,ad2,ad1,ad0;
wire [5:0] SEN_norm,SEN,SEN_bypass;
wire [5:0] SGama;
wire [5:0] SBeta;
wire [2:0] RawData;

// EN Operation
decode3_6_Gama decode3_6_Gama0(.s(Gama), .DataOut(SGama));
decode3_6_Beta decode3_6_Beta0(.s(Beta), .DataOut(SBeta));
assign SEN_norm=SGama|SBeta;

// ISI bypass enable
assign RawData=V[2:0];
decode3_6_Gama decode3_6_Gama1(.s(RawData), .DataOut(SEN_bypass));
assign SEN=ISI_SEL ? SEN_bypass:SEN_norm;

// Select Operation
decode3_6_Norm decoder5 (.s(SQ5), .en(SEN[5]), .DataOut(ad5));
decode3_6_Norm decoder4 (.s(SQ4), .en(SEN[4]), .DataOut(ad4));
decode3_6_Norm decoder3 (.s(SQ3), .en(SEN[3]), .DataOut(ad3));
decode3_6_Norm decoder2 (.s(SQ2), .en(SEN[2]), .DataOut(ad2));
decode3_6_Norm decoder1 (.s(SQ1), .en(SEN[1]), .DataOut(ad1));
decode3_6_Norm decoder0 (.s(SQ0), .en(SEN[0]), .DataOut(ad0));

// Output
assign SV[5]=MIS_SEL ? SEN_bypass[5]:ad5[5] || ad4[5] || ad3[5] || ad2[5] || ad1[5] || ad0[5];
assign SV[4]=MIS_SEL ? SEN_bypass[4]:ad5[4] || ad4[4] || ad3[4] || ad2[4] || ad1[4] || ad0[4];
assign SV[3]=MIS_SEL ? SEN_bypass[3]:ad5[3] || ad4[3] || ad3[3] || ad2[3] || ad1[3] || ad0[3];
assign SV[2]=MIS_SEL ? SEN_bypass[2]:ad5[2] || ad4[2] || ad3[2] || ad2[2] || ad1[2] || ad0[2];
assign SV[1]=MIS_SEL ? SEN_bypass[1]:ad5[1] || ad4[1] || ad3[1] || ad2[1] || ad1[1] || ad0[1];
assign SV[0]=MIS_SEL ? SEN_bypass[0]:ad5[0] || ad4[0] || ad3[0] || ad2[0] || ad1[0] || ad0[0];

endmodule
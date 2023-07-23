//#############################
// 18-inputs Digital Selector
// Version 1.1
//#############################

module Dig_Sel18(Gama,Beta,SV,V,ISI_SEL,MIS_SEL,
			     SQ17,SQ16,SQ15,SQ14,SQ13,SQ12,SQ11,SQ10,
			     SQ9,SQ8,SQ7,SQ6,SQ5,SQ4,SQ3,SQ2,SQ1,SQ0);

//--------------------------------
// V: number of selected element;
// ISI_SEL: ISI bypass enable;
// MIS_SEL: MIS bypass enable;
// SQ17-SQ0: Sorted Vector;
// Gama: Zeros Selected Number;
// Beta: Ones Selected Number;
//--------------------------------

input  ISI_SEL,MIS_SEL;
input signed [5:0] V;
input  [4:0] SQ17,SQ16,SQ15,SQ14,SQ13,SQ12,SQ11,SQ10,SQ9,SQ8,SQ7,SQ6,SQ5,SQ4,SQ3,SQ2,SQ1,SQ0;
input  [4:0] Gama;
input  [4:0] Beta;
output [17:0] SV;

wire [17:0] ad17,ad16,ad15,ad14,ad13,ad12,ad11,ad10,ad9,ad8,ad7,ad6,ad5,ad4,ad3,ad2,ad1,ad0;
wire [17:0] SEN_norm,SEN,SEN_bypass;
wire [17:0] SGama;
wire [17:0] SBeta;
wire [4:0] RawData;

// EN Operation
decode5_18_Gama decode5_18_Gama0(.s(Gama), .DataOut(SGama));
decode5_18_Beta decode5_18_Beta0(.s(Beta), .DataOut(SBeta));
assign SEN_norm=SGama|SBeta;

// ISI bypass enable
assign RawData=V[4:0];
decode5_18_Gama decode5_18_Gama1(.s(RawData), .DataOut(SEN_bypass));
assign SEN=ISI_SEL ? SEN_bypass:SEN_norm;

// Select Operation
decode5_18_Norm decoder17(.s(SQ17), .en(SEN[17]), .DataOut(ad17));
decode5_18_Norm decoder16(.s(SQ16), .en(SEN[16]), .DataOut(ad16));
decode5_18_Norm decoder15(.s(SQ15), .en(SEN[15]), .DataOut(ad15));
decode5_18_Norm decoder14(.s(SQ14), .en(SEN[14]), .DataOut(ad14));
decode5_18_Norm decoder13(.s(SQ13), .en(SEN[13]), .DataOut(ad13));
decode5_18_Norm decoder12(.s(SQ12), .en(SEN[12]), .DataOut(ad12));
decode5_18_Norm decoder11(.s(SQ11), .en(SEN[11]), .DataOut(ad11));
decode5_18_Norm decoder10(.s(SQ10), .en(SEN[10]), .DataOut(ad10));
decode5_18_Norm decoder9 (.s(SQ9),  .en(SEN[9]),  .DataOut(ad9));
decode5_18_Norm decoder8 (.s(SQ8),  .en(SEN[8]),  .DataOut(ad8));
decode5_18_Norm decoder7 (.s(SQ7),  .en(SEN[7]),  .DataOut(ad7));
decode5_18_Norm decoder6 (.s(SQ6),  .en(SEN[6]),  .DataOut(ad6));
decode5_18_Norm decoder5 (.s(SQ5),  .en(SEN[5]),  .DataOut(ad5));
decode5_18_Norm decoder4 (.s(SQ4),  .en(SEN[4]),  .DataOut(ad4));
decode5_18_Norm decoder3 (.s(SQ3),  .en(SEN[3]),  .DataOut(ad3));
decode5_18_Norm decoder2 (.s(SQ2),  .en(SEN[2]),  .DataOut(ad2));
decode5_18_Norm decoder1 (.s(SQ1),  .en(SEN[1]),  .DataOut(ad1));
decode5_18_Norm decoder0 (.s(SQ0),  .en(SEN[0]),  .DataOut(ad0));

// Output
assign SV[17]=MIS_SEL? SEN_bypass[17]:ad17[17]||ad16[17]||ad15[17]||ad14[17]||ad13[17]||ad12[17]||ad11[17]||ad10[17]||ad9[17]||ad8[17]||ad7[17]||ad6[17]||ad5[17]||ad4[17]||ad3[17]||ad2[17]||ad1[17]||ad0[17];
assign SV[16]=MIS_SEL? SEN_bypass[16]:ad17[16]||ad16[16]||ad15[16]||ad14[16]||ad13[16]||ad12[16]||ad11[16]||ad10[16]||ad9[16]||ad8[16]||ad7[16]||ad6[16]||ad5[16]||ad4[16]||ad3[16]||ad2[16]||ad1[16]||ad0[16];
assign SV[15]=MIS_SEL? SEN_bypass[15]:ad17[15]||ad16[15]||ad15[15]||ad14[15]||ad13[15]||ad12[15]||ad11[15]||ad10[15]||ad9[15]||ad8[15]||ad7[15]||ad6[15]||ad5[15]||ad4[15]||ad3[15]||ad2[15]||ad1[15]||ad0[15];
assign SV[14]=MIS_SEL? SEN_bypass[14]:ad17[14]||ad16[14]||ad15[14]||ad14[14]||ad13[14]||ad12[14]||ad11[14]||ad10[14]||ad9[14]||ad8[14]||ad7[14]||ad6[14]||ad5[14]||ad4[14]||ad3[14]||ad2[14]||ad1[14]||ad0[14];
assign SV[13]=MIS_SEL? SEN_bypass[13]:ad17[13]||ad16[13]||ad15[13]||ad14[13]||ad13[13]||ad12[13]||ad11[13]||ad10[13]||ad9[13]||ad8[13]||ad7[13]||ad6[13]||ad5[13]||ad4[13]||ad3[13]||ad2[13]||ad1[13]||ad0[13];
assign SV[12]=MIS_SEL? SEN_bypass[12]:ad17[12]||ad16[12]||ad15[12]||ad14[12]||ad13[12]||ad12[12]||ad11[12]||ad10[12]||ad9[12]||ad8[12]||ad7[12]||ad6[12]||ad5[12]||ad4[12]||ad3[12]||ad2[12]||ad1[12]||ad0[12];
assign SV[11]=MIS_SEL? SEN_bypass[11]:ad17[11]||ad16[11]||ad15[11]||ad14[11]||ad13[11]||ad12[11]||ad11[11]||ad10[11]||ad9[11]||ad8[11]||ad7[11]||ad6[11]||ad5[11]||ad4[11]||ad3[11]||ad2[11]||ad1[11]||ad0[11];
assign SV[10]=MIS_SEL? SEN_bypass[10]:ad17[10]||ad16[10]||ad15[10]||ad14[10]||ad13[10]||ad12[10]||ad11[10]||ad10[10]||ad9[10]||ad8[10]||ad7[10]||ad6[10]||ad5[10]||ad4[10]||ad3[10]||ad2[10]||ad1[10]||ad0[10];
assign SV[9]=MIS_SEL? SEN_bypass[9]:ad17[9] ||ad16[9] ||ad15[9] ||ad14[9] ||ad13[9] ||ad12[9] ||ad11[9] ||ad10[9] ||ad9[9] ||ad8[9] ||ad7[9] ||ad6[9] ||ad5[9] ||ad4[9] ||ad3[9] ||ad2[9] ||ad1[9] ||ad0[9];
assign SV[8]=MIS_SEL? SEN_bypass[8]:ad17[8] ||ad16[8] ||ad15[8] ||ad14[8] ||ad13[8] ||ad12[8] ||ad11[8] ||ad10[8] ||ad9[8] ||ad8[8] ||ad7[8] ||ad6[8] ||ad5[8] ||ad4[8] ||ad3[8] ||ad2[8] ||ad1[8] ||ad0[8];
assign SV[7]=MIS_SEL? SEN_bypass[7]:ad17[7] ||ad16[7] ||ad15[7] ||ad14[7] ||ad13[7] ||ad12[7] ||ad11[7] ||ad10[7] ||ad9[7] ||ad8[7] ||ad7[7] ||ad6[7] ||ad5[7] ||ad4[7] ||ad3[7] ||ad2[7] ||ad1[7] ||ad0[7];
assign SV[6]=MIS_SEL? SEN_bypass[6]:ad17[6] ||ad16[6] ||ad15[6] ||ad14[6] ||ad13[6] ||ad12[6] ||ad11[6] ||ad10[6] ||ad9[6] ||ad8[6] ||ad7[6] ||ad6[6] ||ad5[6] ||ad4[6] ||ad3[6] ||ad2[6] ||ad1[6] ||ad0[6];
assign SV[5]=MIS_SEL? SEN_bypass[5]:ad17[5] ||ad16[5] ||ad15[5] ||ad14[5] ||ad13[5] ||ad12[5] ||ad11[5] ||ad10[5] ||ad9[5] ||ad8[5] ||ad7[5] ||ad6[5] ||ad5[5] ||ad4[5] ||ad3[5] ||ad2[5] ||ad1[5] ||ad0[5];
assign SV[4]=MIS_SEL? SEN_bypass[4]:ad17[4] ||ad16[4] ||ad15[4] ||ad14[4] ||ad13[4] ||ad12[4] ||ad11[4] ||ad10[4] ||ad9[4] ||ad8[4] ||ad7[4] ||ad6[4] ||ad5[4] ||ad4[4] ||ad3[4] ||ad2[4] ||ad1[4] ||ad0[4];
assign SV[3]=MIS_SEL? SEN_bypass[3]:ad17[3] ||ad16[3] ||ad15[3] ||ad14[3] ||ad13[3] ||ad12[3] ||ad11[3] ||ad10[3] ||ad9[3] ||ad8[3] ||ad7[3] ||ad6[3] ||ad5[3] ||ad4[3] ||ad3[3] ||ad2[3] ||ad1[3] ||ad0[3];
assign SV[2]=MIS_SEL? SEN_bypass[2]:ad17[2] ||ad16[2] ||ad15[2] ||ad14[2] ||ad13[2] ||ad12[2] ||ad11[2] ||ad10[2] ||ad9[2] ||ad8[2] ||ad7[2] ||ad6[2] ||ad5[2] ||ad4[2] ||ad3[2] ||ad2[2] ||ad1[2] ||ad0[2];
assign SV[1]=MIS_SEL? SEN_bypass[1]:ad17[1] ||ad16[1] ||ad15[1] ||ad14[1] ||ad13[1] ||ad12[1] ||ad11[1] ||ad10[1] ||ad9[1] ||ad8[1] ||ad7[1] ||ad6[1] ||ad5[1] ||ad4[1] ||ad3[1] ||ad2[1] ||ad1[1] ||ad0[1];
assign SV[0]=MIS_SEL? SEN_bypass[0]:ad17[0] ||ad16[0] ||ad15[0] ||ad14[0] ||ad13[0] ||ad12[0] ||ad11[0] ||ad10[0] ||ad9[0] ||ad8[0] ||ad7[0] ||ad6[0] ||ad5[0] ||ad4[0] ||ad3[0] ||ad2[0] ||ad1[0] ||ad0[0];

endmodule
// ###############################
//# 0.ISI and MS Loop Combination #
//# 1.1st-order for ISI Loop      #
//# 2.2nd-order for MS Loop       #
//# 3.With ISI Bypass Function    #
//# 4.With MS Bypass Function     #
//# 5.18-inputs ISI_MS operation  #
//# 6.6-inputs ISI_MS operation   #
//# 7.With Segmentation operation #
//#         Version 1.5           #
//#      Update: 2023/7/05        #
// ###############################

module ISI_MS_V1p5(clk, clk_en, rstn, VB, VC, ISI_SEL, MIS_SEL,
				   SVBout, STBout, SVCout, STCout);

//--------------------------------------------------
// clk:     input clock;
// rstn:    rest signal, 0 enable;
// VB:      input selected B number;
// VC:      input selected C number;
// SVBout:  Output SVB Vector;
// SVCout:  Output SVC Vector;
// STBout:  Output STB Vector;
// STCout:  Output STC Vector;
// Debug：  Output debug ports;
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
input signed [5:0] VB;
input signed [3:0] VC;
output [17:0] SVBout;
output [5:0]  SVCout;
output [17:0] STBout;
output [5:0]  STCout;

// ISI_MS_18 Operaiton
ISI_MS_18_V1p5 ISI_MS_18_V1p5(.clk(clk), .clk_en(clk_en), .rstn(rstn), .V(VB),  .ISI_SEL(ISI_SEL), .MIS_SEL(MIS_SEL),
							  .SVout(SVBout), .STout(STBout));

// ISI_MS_6 Operation
ISI_MS_6_V1p5 ISI_MS_6_V1p5(.clk(clk), .clk_en(clk_en), .rstn(rstn), .V(VC), .ISI_SEL(ISI_SEL), .MIS_SEL(MIS_SEL),
							.SVout(SVCout), .STout(STCout));

endmodule
// ###############################
//#        Main Function          #
//# 0.ISI and MS Loop Combination #
//# 1.1st-order for ISI Loop      #
//# 2.2nd-order for MS Loop       #
//# 3.With ISI Bypass Function    #
//# 4.With MS Bypass Function     #
//# 5.18-inputs ISI_MS operation  #
//# 6.6-inputs ISI_MS operation   #
//# 7.With Segmentation operation #
//#         Version 1.0           #
//#      Update: 2023/7/18        #
// ###############################

module Audio_DAC_Dig_V1p0(
	clock,
    div8_0_en,
    div8_0_neg_en,
    div8_2_en,
    div8_4_en,
    div8_8_en,
    div8_8_neg_en,
    div8_16_en,
    div8_32_en,
    div8_32_neg_en,
    div8_64_en,
    div8_64_neg_en,
    div8_128_en,
	div_cnt,
	rstn, 
	ISI_SEL, 
	MIS_SEL, 
	Data_in,
	SVBout, 
	STBout, 
	SVCout, 
	STCout);

//--------------------------------------------------
// ### Input ports:
// clock:   input clock, 49.152MHz;
// rstn:    rest signal, 0 enable;
// ISI_SEL: ISI bypass enable, "0" enable bypass;
// MIS_SEL: MIS bypass enable, "0" enable bypass;
//
// ### Output ports:
// SVBout:  Output SVB Vector;
// SVCout:  Output SVC Vector;
// STBout:  Output STB Vector;
// STCout:  Output STC Vector;
//---------------------------------------------------


input clock, rstn, ISI_SEL, MIS_SEL;
input div8_0_en;   // 49.152 Mhz / 8    = 6.144 Mhz
input div8_2_en;   // 49.152 Mhz / 16   = 3.072 Mhz
input div8_4_en;   // 49.152 Mhz / 32   = 1.536 Mhz
input div8_8_en;   // 49.152 Mhz / 64   = 768   khz
input div8_16_en;  // 49.152 Mhz / 128  = 384   khz
input div8_32_en;  // 49.152 Mhz / 256  = 192   khz
input div8_64_en;  // 49.152 Mhz / 512  = 96    khz
input div8_128_en; // 49.152 Mhz / 1024 = 48    khz
input div8_0_neg_en;
input div8_8_neg_en;
input div8_32_neg_en;
input div8_64_neg_en;
input [9:0] div_cnt;
input signed [23:0] Data_in;
output [17:0] SVBout;
output [5:0]  SVCout;
output [17:0] STBout;
output [5:0]  STCout;

//IFIR_top_V1p3
wire signed [23:0] Data_out1;
wire signed [23:0] Data_out2;
wire signed [23:0] Data_out3;
wire signed [23:0] Data_out4;
IFIR_top_V1p3 IFIR_top(.clock (clock),
					   .rstn (rstn),
					   .div8_0_en (div8_0_en),
    				   .div8_0_neg_en (div8_0_neg_en),
					   .div8_2_en (div8_2_en),
					   .div8_4_en (div8_4_en),
					   .div8_8_en (div8_8_en),
					   .div8_8_neg_en (div8_8_neg_en),
					   .div8_16_en (div8_16_en),
					   .div8_32_en (div8_32_en),
					   .div8_32_neg_en (div8_32_neg_en),
					   .div8_64_en (div8_64_en),
					   .div8_64_neg_en (div8_64_neg_en),
					   .div8_128_en (div8_128_en),
					   .div_cnt (div_cnt),
					   .Data_in (Data_in),
					   .Data_out1 (Data_out1),
					   .Data_out2 (Data_out2),
					   .Data_out3 (Data_out3),
					   .Data_out4 (Data_out4));
					   
//SDM_V1p4
wire signed [4:0] DataOut; 
SDM_V1p4 SDM(.DataIn (Data_out4),
			 .clk_en (div8_0_en),
			 .DataOut (DataOut),
			 .clock (clock),
			 .rstn (rstn));

//Segmentation_V1p4
wire signed [5:0] B;
wire signed [3:0] C;
Segmentation_V1p4 Segmentation(.clock (clock),
							   .clk_en (div8_0_en),
							   .rstn (rstn),
							   .A (DataOut),
							   .B (B),
							   .C (C));
							 
//ISI_MS_V1p5
ISI_MS_V1p5 ISI_MS(.clk (clock),
				   .clk_en (div8_0_en),
				   .rstn (rstn),
				   .VB (B),
				   .VC (C),
				   .ISI_SEL (ISI_SEL),
				   .MIS_SEL (MIS_SEL),
				   .SVBout (SVBout),
				   .STBout (STBout),
				   .SVCout (SVCout),
				   .STCout (STCout));
				   
endmodule
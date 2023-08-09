//------------------------------------------------
// Full Parellel implementation for IFIR top
// With CSD Multiplier
// Version 1.3
//------------------------------------------------

module IFIR_top_V1p3(clock,rstn,div8_0_en,div8_0_neg_en,div8_2_en,div8_4_en,div8_8_en,div8_8_neg_en,
					 div8_16_en,div8_32_en,div8_32_neg_en,div8_64_en,div8_64_neg_en,div8_128_en,
					 div_cnt,Data_in,Data_out1,Data_out2,Data_out3,Data_out4);

input clock; // the SDM clock frequency
input div8_0_en,div8_2_en,div8_4_en,div8_8_en,div8_16_en,div8_32_en,div8_64_en,div8_128_en;
input div8_0_neg_en,div8_8_neg_en,div8_32_neg_en,div8_64_neg_en;
input [9:0] div_cnt;
input rstn;
input  signed [23:0] Data_in; 
output signed [23:0] Data_out1; // the output of Filter_1st_stage
output signed [23:0] Data_out2; // the output of Filter_2nd_stage
output signed [23:0] Data_out3; // the output of Filter_3rd_stage
output signed [23:0] Data_out4; // the output of Filter_4th_stage

//IFIR_1st_stage_V1p3
IFIR_1st_stage_V1p3 IFIR1(.Data_in (Data_in),
						  .Data_out (Data_out1),
						  .clock_in (div8_128_en),
						  .clock_div2 (div_cnt[8]),
						  .clock_up (div8_64_neg_en),
						  .clock (clock),
						  .rstn (rstn));

//IFIR_2nd_stage_V1p3
IFIR_2nd_stage_V1p3 IFIR2(.Data_in (Data_out1),
						  .Data_out (Data_out2),
						  .clock_in (div8_64_en),
						  .clock_div2 (div_cnt[7]),
						  .clock_up (div8_32_neg_en),
						  .clock (clock),
						  .rstn (rstn));

//IFIR_3rd_stage_V1p3
IFIR_3rd_stage_V1p3 IFIR3(.Data_in (Data_out2),
						  .Data_out (Data_out3),
						  .clock_in (div8_32_en),
						  .clock_div4 (div_cnt[6]),
						  .clock_div2 (div_cnt[5]),
						  .clock_up (div8_8_en),
						  .neg_en(div8_8_neg_en),
						  .clock(clock),
						  .rstn (rstn));

//IFIR_4th_stage_V1p3
IFIR_4th_stage_V1p3 IFIR4(.Data_in (Data_out3),
						  .Data_out (Data_out4),
						  .clock_in (div8_8_en),
						  .clock_div8 (div_cnt[4]),
						  .clock_div4 (div_cnt[3]),
						  .clock_div2 (div_cnt[2]),
						  .clock_up (clock),
						  .neg_en (div8_0_neg_en),
						  .rstn (rstn));

endmodule
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

module Audio_DAC_Dig_V1p0(clock, rstn, rclk, ISI_SEL, MIS_SEL, Data_in,
						  SVBout, STBout, SVCout, STCout);

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
output rclk;
input signed [23:0] Data_in;
output [17:0] SVBout;
output [5:0]  SVCout;
output [17:0] STBout;
output [5:0]  STCout;
wire rclk;

//###clock divider###
//Clock div2
reg clk_div2_r;
wire clock_div2;
always @(posedge clock or negedge rstn)begin
	if(rstn==0)begin
		clk_div2_r<='b0;
	end
	else begin
		clk_div2_r<=~clk_div2_r;
	end
end
assign clock_div2=clk_div2_r;

//CLock div4
reg clk_div4_r;
wire clock_div4;
always @(posedge clock_div2 or negedge rstn)begin
	if(rstn==0)begin
		clk_div4_r<='b0;
	end
	else begin
		clk_div4_r<=~clk_div4_r;
	end
end
assign clock_div4=clk_div4_r;

//Clock div8: 6.144MHz
reg clk_div8_r;
wire clock_div8; // the Filter_4th_stage frequency
always @(posedge clock_div4 or negedge rstn)begin
	if(rstn==0)begin
		clk_div8_r<='b0;
	end
	else begin
		clk_div8_r<=~clk_div8_r;
	end
end
assign clock_div8=clk_div8_r;

//IFIR_top_V1p3
wire signed [23:0] Data_out1;
wire signed [23:0] Data_out2;
wire signed [23:0] Data_out3;
wire signed [23:0] Data_out4;
IFIR_top_V1p3 IFIR_top(.clock (clock_div8),
					   .rstn (rstn),
					   .rclk (rclk),
					   .Data_in (Data_in),
					   .Data_out1 (Data_out1),
					   .Data_out2 (Data_out2),
					   .Data_out3 (Data_out3),
					   .Data_out4 (Data_out4));
					   
//SDM_V1p4
wire signed [4:0] DataOut; 
SDM_V1p4 SDM(.DataIn (Data_out4),
			 .DataOut (DataOut),
			 .clock (clock_div8),
			 .rstn (rstn));

//Segmentation_V1p4
wire signed [5:0] B;
wire signed [3:0] C;
Segmentation_V1p4 Segmentation(.clock (clock_div8),
							   .rstn (rstn),
							   .A (DataOut),
							   .B (B),
							   .C (C));
							 
//ISI_MS_V1p5
ISI_MS_V1p5 ISI_MS(.clk (clock_div8),
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
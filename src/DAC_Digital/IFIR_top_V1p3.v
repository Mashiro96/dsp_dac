//------------------------------------------------
// Full Parellel implementation for IFIR top
// With CSD Multiplier
// Version 1.3
//------------------------------------------------

module IFIR_top_V1p3(clock,rstn,rclk,Data_in,Data_out1,
					 Data_out2,Data_out3,Data_out4);

input clock; // the SDM clock frequency
input rstn;
output rclk; // output clock for read
input  signed [23:0] Data_in; 
output signed [23:0] Data_out1; // the output of Filter_1st_stage
output signed [23:0] Data_out2; // the output of Filter_2nd_stage
output signed [23:0] Data_out3; // the output of Filter_3rd_stage
output signed [23:0] Data_out4; // the output of Filter_4th_stage
wire rclk;

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

//Clock div4
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

//Clock div8
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

//Clock div16
reg clk_div16_r;
wire clock_div16;
always @(posedge clock_div8 or negedge rstn)begin
	if(rstn==0)begin
		clk_div16_r<='b0;
	end
	else begin
		clk_div16_r<=~clk_div16_r;
	end
end
assign clock_div16=clk_div16_r;

//Clock div32
reg clk_div32_r;
wire clock_div32; // the Filter_3rd_stage frequency
always @(posedge clock_div16 or negedge rstn)begin
	if(rstn==0)begin
		clk_div32_r<='b0;
	end
	else begin
		clk_div32_r<=~clk_div32_r;
	end
end
assign clock_div32=clk_div32_r;

//Clock div64
reg clk_div64_r;
wire clock_div64; // the Filter_2nd_stage frequency
always @(posedge clock_div32 or negedge rstn)begin
	if(rstn==0)begin
		clk_div64_r<='b0;
	end
	else begin
		clk_div64_r<=~clk_div64_r;
	end
end
assign clock_div64=clk_div64_r;
assign rclk=clk_div64_r;

//Clock div128
reg clk_div128_r;
wire clock_div128; // the Filter_1st_stage frequency
always @(posedge clock_div64 or negedge rstn)begin
	if(rstn==0)begin
		clk_div128_r<='b0;
	end
	else begin
		clk_div128_r<=~clk_div128_r;
	end
end
assign clock_div128=clk_div128_r;

//IFIR_1st_stage_V1p3
IFIR_1st_stage_V1p3 IFIR1(.Data_in (Data_in),
						  .Data_out (Data_out1),
						  .clock_in (clock_div128),
						  .clock_up (clock_div64),
						  .rstn (rstn));

//IFIR_2nd_stage_V1p3
IFIR_2nd_stage_V1p3 IFIR2(.Data_in (Data_out1),
						  .Data_out (Data_out2),
						  .clock_in (clock_div64),
						  .clock_up (clock_div32),
						  .rstn (rstn));

//IFIR_3rd_stage_V1p3
IFIR_3rd_stage_V1p3 IFIR3(.Data_in (Data_out2),
						  .Data_out (Data_out3),
						  .clock_in (clock_div32),
						  .clock_div2 (clock_div16),
						  .clock_up (clock_div8),
						  .rstn (rstn));

//IFIR_4th_stage_V1p3
IFIR_4th_stage_V1p3 IFIR4(.Data_in (Data_out3),
						  .Data_out (Data_out4),
						  .clock_in (clock_div8),
						  .clock_div4 (clock_div4),
						  .clock_div2 (clock_div2),
						  .clock_up (clock),
						  .rstn (rstn));

endmodule
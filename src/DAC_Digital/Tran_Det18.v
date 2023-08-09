//---------------------------------
// 18-inputs Transition Detector
// Version 1.6
//---------------------------------

module Tran_Det18(SV, ST, clk, clk_en, rstn);

//----------------------------------
// SV: Input SV Vector;
// ST: Output Transition Vector;
// clk: input clock;
// rstn: rest signal, 0 enable rest;
//----------------------------------

input [17:0] SV;
input clk, clk_en, rstn;
output [17:0] ST;

wire [17:0] ms2;
wire [17:0] ms1;
reg  [17:0] ms0;

// 移位的功能
always @(posedge clk or negedge rstn) begin
	if(rstn==0)begin
		ms0<=18'b0;
	end
	else if(clk_en)begin
		ms0<=SV;
	end
	else begin
		ms0<=ms0;
	end
end
// Output
assign ms1 = ~ms0;
assign ST = ms1 & SV;

endmodule
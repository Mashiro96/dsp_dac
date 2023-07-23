//---------------------------------
// 6-inputs Transition Detector
// Version 1.6
//---------------------------------

module Tran_Det6(SV, ST, clk, rstn);

//--------------------------------
// SV: Input SV Vector
// ST: Output Transition Vector
// clk: input clock
// rstn: rest signal, 0 enable
//--------------------------------

input [5:0] SV;
input clk, rstn;
output [5:0] ST;

wire [5:0] ms2;
wire [5:0] ms1;
reg  [5:0] ms0;

// 移位的功能
always @(posedge clk or negedge rstn)
	if(rstn==0)begin
		ms0<=6'b0;
	end
	else begin
		ms0<=SV;
	end

// Output
assign ms1 = ~ms0;
assign ST = ms1 & SV;

endmodule
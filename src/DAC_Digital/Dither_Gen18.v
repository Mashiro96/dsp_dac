//#######################################
// 18-inputs Dither Sequence Generator
// Version 1.6
//#######################################

module Dither_Gen18(clk, clk_en, rstn, dither);

//-----------------------------------
// clk: input clock;
// rstn: rest signal, 0 enable;
// dither: Output dither sequence;
//-----------------------------------

input clk, clk_en, rstn;
output signed [1:0] dither;

wire SEL;
wire A;
wire B;
wire C;

reg D0;
reg D10,D11,D12,D13;
reg D2;
reg D30,D31,D32,D33,D34,D35,D36,D37,D38,D39,D310,D311,D312;

// Delay的功能
always @(posedge clk or negedge rstn) begin
	if(rstn==0)begin
		D0 <=1;
		D10<=0;
		D11<=0;
		D12<=0;
		D13<=0;
		D2 <=0;
		D30<=0;
		D31<=0;
		D32<=0;
		D33<=0;
		D34<=0;
		D35<=0;
		D36<=0;
		D37<=0;
		D38<=0;
		D39<=0;
		D310<=0;
		D311<=0;
		D312<=0;
	end
	else if(clk_en)begin
		D0 <=SEL;
		D10<=A;
		D11<=D10;
		D12<=D11;
		D13<=D12;
		D2 <=B;
		D30<=C;
		D31<=D30;
		D32<=D31;
		D33<=D32;
		D34<=D33;
		D35<=D34;
		D36<=D35;
		D37<=D36;
		D38<=D37;
		D39<=D38;
		D310<=D39;
		D311<=D310;
		D312<=D311;
	end
	else begin
		D0 <=D0;
		D10<=D10;
		D11<=D11;
		D12<=D12;
		D13<=D13;
		D2 <=D2;
		D30<=D30;
		D31<=D31;
		D32<=D32;
		D33<=D33;
		D34<=D34;
		D35<=D35;
		D36<=D36;
		D37<=D37;
		D38<=D38;
		D39<=D39;
		D310<=D310;
		D311<=D311;
		D312<=D312;
	end
end
// A Node
assign A=D0^SEL;
// B  Node 
assign B=D13^SEL;
// C Node
assign C=D2^SEL;
assign SEL=D312;

// Output
assign dither=SEL ? 2'b11:2'b01;

endmodule
//#######################################
// 6-inputs Decouple Sequence Generator
// 1st-order
// Version 1.6
//#######################################

module Decp_Gen6(clk, clk_en, rstn, dither, V, Gama, Beta);

//-----------------------------------
// clk: input clock;
// rstn: rest signal, 0 enable rest;
// dither: Input dither sequence;
// V: Input selected element number;
// Gama: Input selected zeros number;
// Beta: Input selected ones number;
//-----------------------------------

input clk, clk_en, rstn;
input signed [1:0] dither;
input signed [3:0] V; //V<=4
output [1:0] Gama; //0,1,2
output [1:0] Beta; //1,2,3

wire signed [1:0] LO;
wire signed [1:0] LF;
wire signed [2:0] LD;
wire signed [1:0] LQ;
wire signed [3:0] Vdiff;
wire Sel;
wire signed [2:0] K;
wire signed [3:0] KA;
wire signed [2:0] L=3'b010;
reg  signed [1:0] LFD;
reg  signed [1:0] LOD;
reg  signed [3:0] VD; // V Delay

// Delay的功能
always @(posedge clk or negedge rstn) begin
	if(rstn==0)begin
		VD <=4'b0;
		LFD<=2'b0;
		LOD<=2'b0;
	end
	else if(clk_en)begin
		VD <=V;
		LFD<=LF;
		LOD<=LO;
	end
	else begin
		VD <=VD;
		LFD<=LFD;
		LOD<=LOD;
	end
end

// Sel Node
assign Vdiff=V-VD;
assign Sel=Vdiff[0]^L[0];

// LO Node
assign LO=Sel ? LQ:0;

// LF Node
assign LF=LFD-LOD;

// LD Node
assign LD=dither+LF;

// LQ Node
assign LQ=LD[2] ? 2'b11:2'b01;

// K Node
assign K=LO+L;

// KA Node
assign KA=K+V-VD;

// Output
assign Gama = KA[2:1];
assign Beta = V[2:0]-{1'b0,Gama};

endmodule
// ###########################################
//# Verilog code for Segmentation Version 1.4 #
//# A: Inputs 5bits;                          #
//# B: output 4bits;                          #
//# C: output 2bits;                          #
//# With output offset for B and C            #
//# Change for noise cancellation             #
// ###########################################

module Segmentation_V1p4(clock,rstn,A,B,C);

input clock,rstn;
input  signed [4:0] A; // input  signal
output signed [5:0] B; // output signal
output signed [3:0] C; // output signal

reg  signed [4:0] SD;
reg  signed [4:0] ED; 
reg  signed [4:0] AD;
wire signed [4:0] E; //input signal
wire signed [4:0] S; //feedback quantization signal
wire signed [3:0] BW; //wire for B output
wire signed [4:0] CW; //wire for C output
wire signed [1:0] C1;

//Node E
assign E=A-{BW,1'b0};

//Node S
assign S=ED+SD;

//Node SD
always @(posedge clock or negedge rstn)begin //first integrator
	if(rstn==0)begin
		SD<=0;
		ED<=0;
		AD<=0;
	end
	else begin
		SD<=S;
		ED<=E;
		AD<=A;
	end
end

//Node B and Trunctor
assign BW=S[4:1];

//Node C
assign CW={BW,1'b0}-AD;
assign C1=CW[1:0];

//Output Ports with offset
assign B=BW+9;
assign C=C1+3;

endmodule
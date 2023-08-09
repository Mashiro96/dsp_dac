//###############################
//# Verilog code for simple SDM #
//# 1.OSR=128                   #
//# 2.Output=5bit               #
//# 3.3rd-order CIFF            #
//# 4.With CSD Multiplier       #
//# Version 1.4                 #
//###############################

module SDM_V1p4(DataOut,DataIn,clock,clk_en,rstn);

parameter signed a1_csd=24'b000001000100010000010001;
parameter signed a2_csd=24'b010010000000001000000010;
parameter signed a3_csd=24'b000000010001000001000100;
parameter signed g_csd =24'b000000000000000000000001;

input clock,clk_en,rstn;
input signed [23:0] DataIn;
output signed [4:0] DataOut;

reg signed [23:0] Xout1;
reg signed [23:0] Xout2;
reg signed [23:0] Xout3; 

wire signed [23:0] D1; //Input signal
wire signed [4:0]  Df; //quantization feedback signal
wire signed [23:0] Xin1;
wire signed [23:0] Xin2;
wire signed [23:0] Xin3;
wire signed [23:0] Xreg1;
wire signed [34:0] Xreg2;
wire signed [23:0] Xreg3;
wire signed [34:0] S1_1;
wire signed [34:0] S1_2;
wire signed [34:0] S2_1; 
wire signed [34:0] S3;
wire signed [34:0] S4;
wire signed [34:0] Sout; //output of adder

//Input Part
assign D1=DataIn;
assign Xin1=D1-{Df,{19{1'b0}}};
assign Df=DataOut;

//Filter Loop Part
assign Xreg1=Xout1;
CSD_mult_SDM mult1(.CSD_in (g_csd),
				   .Data_in (Xout3),
			       .Data_out (Xreg2));
				   
assign Xreg3=Xreg2[34:11];
assign Xin2=Xreg1-Xreg3;
assign Xin3=Xout2;

always @(posedge clock or negedge rstn)begin //first integrator
	if(rstn==0)begin
		Xout1<=0;
	end
	else if(clk_en)begin
		Xout1<=Xout1+Xin1;
	end
	else begin
		Xout1<=Xout1;
	end
end

always @(posedge clock or negedge rstn)begin //second integrator
	if(rstn==0)begin
		Xout2<=0;
	end
	else if(clk_en)begin
		Xout2<=Xout2+Xin2;
	end
	else begin
		Xout2<=Xout2;
	end
end

always @(posedge clock or negedge rstn)begin //third integrator
	if(rstn==0)begin
		Xout3<=0;
	end
	else if(clk_en)begin
		Xout3<=Xout3+Xin3;
	end
	else begin
		Xout3<=Xout3;
	end
end

//Adder and Quantizer Feedback Part
//*Pay attention to adding operation，especially the word length*//

// assign S1_1=a1*Xout1;
CSD_mult_SDM mult2(.CSD_in (a1_csd),
			       .Data_in (Xout1),
			       .Data_out (S1_1));
			   
assign S1_2={Xout1,{11{1'b0}}};
// assign S2_1=a2*Xout2;
CSD_mult_SDM mult3(.CSD_in (a2_csd),
			       .Data_in (Xout2),
			       .Data_out (S2_1));
			   
// assign S3=a3*Xout3;
CSD_mult_SDM mult4(.CSD_in (a3_csd),
			       .Data_in (Xout3),
			       .Data_out (S3));
			   
assign S4={DataIn,{11{1'b0}}};
assign Sout=S1_1+S1_2+S2_1+S3+S4;
assign DataOut=Sout[34:30]; //Quantizing operation

endmodule
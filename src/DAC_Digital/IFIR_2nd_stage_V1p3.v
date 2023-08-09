//------------------------------------------------
//Full Parellel implementation for IFIR_2nd_stage
// With CSD Multiplier
// Version 1.3
//-------------------------------------------------

module IFIR_2nd_stage_V1p3(Data_out,Data_in,clock_in,clock_div2,clock_up,clock,rstn);

// Signed CSD coefficients
parameter signed b1=28'b0000000000000000000001000001;
parameter signed b2=28'b0000000000000001000001000001;
parameter signed b3=28'b0000000000000001000001000000;
parameter signed b4=28'b0000000000100001000001000100;
parameter signed b5=28'b0000000010000001000000100001;
parameter signed b6=28'b0000000000000000010000000001;
parameter signed b7=28'b0000010010000000000001001000;
parameter signed b8=28'b0001001000000010000000000100;

input clock_in,clock_div2,clock_up,rstn;
input clock;
input signed [23:0] Data_in; 
output reg signed [23:0] Data_out;
reg signed [23:0] s[0:7];

wire signed [37:0] Data_a0;
wire signed [37:0] Data_a1;
wire signed [37:0] csdout[0:15];
integer	k;

//并行实现乘累加			   
CSD_mult mutl0(.CSD_in(b1),
			   .Data_in(Data_in),
			   .Data_out(csdout[0]));
CSD_mult mutl1(.CSD_in(b2),
			   .Data_in(Data_in),
			   .Data_out(csdout[1]));
CSD_mult mutl2(.CSD_in(b3),
			   .Data_in(s[1]),
			   .Data_out(csdout[2]));
CSD_mult mutl3(.CSD_in(b4),
			   .Data_in(s[1]),
			   .Data_out(csdout[3]));
CSD_mult mutl4(.CSD_in(b5),
			   .Data_in(s[2]),
			   .Data_out(csdout[4]));
CSD_mult mutl5(.CSD_in(b6),
			   .Data_in(s[2]),
			   .Data_out(csdout[5]));
CSD_mult mutl6(.CSD_in(b7),
			   .Data_in(s[3]),
			   .Data_out(csdout[6]));
CSD_mult mutl7(.CSD_in(b8),
			   .Data_in(s[3]),
			   .Data_out(csdout[7]));
CSD_mult mutl8(.CSD_in(b8),
			   .Data_in(s[4]),
			   .Data_out(csdout[8]));
CSD_mult mutl9(.CSD_in(b7),
			   .Data_in(s[4]),
			   .Data_out(csdout[9]));
CSD_mult mutl10(.CSD_in(b6),
			   .Data_in(s[5]),
			   .Data_out(csdout[10]));
CSD_mult mutl11(.CSD_in(b5),
			   .Data_in(s[5]),
			   .Data_out(csdout[11]));
CSD_mult mutl12(.CSD_in(b4),
			   .Data_in(s[6]),
			   .Data_out(csdout[12]));
CSD_mult mutl13(.CSD_in(b3),
			   .Data_in(s[6]),
			   .Data_out(csdout[13]));
CSD_mult mutl14(.CSD_in(b2),
			   .Data_in(s[7]),
			   .Data_out(csdout[14]));
CSD_mult mutl15(.CSD_in(b1),
			   .Data_in(s[7]),
			   .Data_out(csdout[15]));
			   
assign Data_a0=csdout[0]+csdout[2]+csdout[4]+csdout[6]+
			   csdout[8]+csdout[10]+csdout[12]+csdout[14];
assign Data_a1=csdout[1]+csdout[3]+csdout[5]+csdout[7]+
			   csdout[9]+csdout[11]+csdout[13]+csdout[15];

//MUX实现上采样
always @(posedge clock or negedge rstn)
	if(rstn==0)begin
		Data_out=0;
	end
	else if(!clock_div2 && clock_up)begin
		Data_out=Data_a1[35:12];
	end
	else if(clock_div2 && clock_up)begin
		Data_out=Data_a0[35:12];
	end
	else begin
		Data_out=Data_out;
	end

//完成移位的功能
always @(posedge clock or negedge rstn)
	if(rstn==0)begin
		for(k=0;k<=7;k=k+1)
			s[k]<=0;
	end
	else if(clock_in)begin
		s[1]<=Data_in;
		for(k=2;k<=7;k=k+1)
			s[k]<=s[k-1];
	end
	else begin
		for(k=0;k<=7;k=k+1)
			s[k]<=s[k];
	end

endmodule
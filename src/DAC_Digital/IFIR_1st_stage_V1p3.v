//-------------------------------------------------
// Full Parellel implementation for IFIR_1st_stage
// With CSD Multiplier
// Version 1.3
//-------------------------------------------------

module IFIR_1st_stage_V1p3(Data_out,Data_in,clock_in,clock_up,rstn);

// signed CSD coefficients
parameter signed b1 =28'b0000000000000000000000100000;
parameter signed b2 =28'b0000000000000000000001000001;
parameter signed b3 =28'b0000000000000000001000001000;
parameter signed b4 =28'b0000000000000000010000000000;
parameter signed b5 =28'b0000000000000010000001000100;
parameter signed b6 =28'b0000000000000001000100010001;
parameter signed b7 =28'b0000000000001000000000001000;
parameter signed b8 =28'b0000000000010010000000010010;
parameter signed b9 =28'b0000000000100000100010000100;
parameter signed b10=28'b0000000001000010000100000010; 
parameter signed b11=28'b0000001000010010000000000010;
parameter signed b12=28'b0000010001000000010000010010;
parameter signed b13=28'b0001000000000000000000000000;

input clock_in,clock_up,rstn;
input signed [23:0] Data_in;
output reg signed [23:0] Data_out;
reg signed [23:0] s[0:23];

wire signed [37:0] Data_a1;
wire signed [37:0] Data_a0;
wire signed [37:0] csdout[23:0];
integer	k;
			  
// CSD multiplier operaiton
CSD_mult mult0(.CSD_in (b1),
			   .Data_in (Data_in),
			   .Data_out (csdout[0]));
CSD_mult mult1(.CSD_in (b1),
			   .Data_in (s[23]),
			   .Data_out (csdout[1]));
CSD_mult mult2(.CSD_in (b2),
			   .Data_in (s[1]),
			   .Data_out (csdout[2]));
CSD_mult mult3(.CSD_in (b2),
			   .Data_in (s[22]),
			   .Data_out (csdout[3]));
CSD_mult mult4(.CSD_in (b3),
			   .Data_in (s[2]),
			   .Data_out (csdout[4]));
CSD_mult mult5(.CSD_in (b3),
			   .Data_in (s[21]),
			   .Data_out (csdout[5]));
CSD_mult mult6(.CSD_in (b4),
			   .Data_in (s[3]),
			   .Data_out (csdout[6]));
CSD_mult mult7(.CSD_in (b4),
			   .Data_in (s[20]),
			   .Data_out (csdout[7]));
CSD_mult mult8(.CSD_in (b5),
			   .Data_in (s[4]),
			   .Data_out (csdout[8]));
CSD_mult mult9(.CSD_in (b5),
			   .Data_in (s[19]),
			   .Data_out (csdout[9]));
CSD_mult mult10(.CSD_in (b6),
			    .Data_in (s[5]),
				.Data_out (csdout[10]));
CSD_mult mult11(.CSD_in (b6),
				.Data_in (s[18]),
				.Data_out (csdout[11]));
CSD_mult mult12(.CSD_in (b7),
				.Data_in (s[6]),
				.Data_out (csdout[12]));
CSD_mult mult13(.CSD_in (b7),
				.Data_in (s[17]),
				.Data_out (csdout[13]));
CSD_mult mult14(.CSD_in (b8),
				.Data_in (s[7]),
				.Data_out (csdout[14]));
CSD_mult mult15(.CSD_in (b8),
				.Data_in (s[16]),
				.Data_out (csdout[15]));
CSD_mult mult16(.CSD_in (b9),
				.Data_in (s[8]),
				.Data_out (csdout[16]));
CSD_mult mult17(.CSD_in (b9),
				.Data_in (s[15]),
				.Data_out (csdout[17]));
CSD_mult mult18(.CSD_in (b10),
				.Data_in (s[9]),
				.Data_out (csdout[18]));
CSD_mult mult19(.CSD_in (b10),
				.Data_in (s[14]),
				.Data_out (csdout[19]));
CSD_mult mult20(.CSD_in (b11),
				.Data_in (s[10]),
				.Data_out (csdout[20]));
CSD_mult mult21(.CSD_in (b11),
				.Data_in (s[13]),
				.Data_out (csdout[21]));
CSD_mult mult22(.CSD_in (b12),
				.Data_in (s[11]),
				.Data_out (csdout[22]));
CSD_mult mult23(.CSD_in (b12),
				.Data_in (s[12]),
				.Data_out (csdout[23]));

assign Data_a0=csdout[0]+csdout[1]+csdout[2]+
			   csdout[3]+csdout[4]+csdout[5]+
			   csdout[6]+csdout[7]+csdout[8]+
			   csdout[9]+csdout[10]+csdout[11]+
			   csdout[12]+csdout[13]+csdout[14]+
			   csdout[15]+csdout[16]+csdout[17]+
			   csdout[18]+csdout[19]+csdout[20]+
			   csdout[21]+csdout[22]+csdout[23];

CSD_mult mult24(.CSD_in (b13),
				.Data_in (s[11]),
				.Data_out (Data_a1));

//MUX实现上采样
always @(negedge clock_up or negedge rstn)
	if(rstn==0)begin
		Data_out=0;
	end
	else if(clock_in==0 & rstn==1)begin
		Data_out=Data_a1[35:12];
	end
	else if(clock_in==1 & rstn==1)begin
		Data_out=Data_a0[35:12];
	end
	else begin
		Data_out=0;
	end

//完成移位的功能
always @(posedge clock_in or negedge rstn)
	if(rstn==0)begin
		for(k=0;k<=23;k=k+1)
			s[k]<=0;
	end
	else begin
		s[1]<=Data_in;
		for(k=2;k<=23;k=k+1)
			s[k]<=s[k-1];
	end

endmodule
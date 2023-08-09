//------------------------------------------------
//Full Parellel implementation for IFIR_3rd_stage
// With CSD Multiplier
// Version 1.3
//-------------------------------------------------

module IFIR_4th_stage_V1p3(Data_out,Data_in,clock_in,clock_div8,clock_div4,clock_div2,clock_up,neg_en,rstn);

// Signed CSD coefficients
parameter signed b1=28'b0000000000000000000010000100;
parameter signed b2=28'b0000000000000000001000010000;
parameter signed b3=28'b0000000000000000001000100001;
parameter signed b4=28'b0000000000000000100001000010;
parameter signed b5=28'b0000000000000000100001000010;
parameter signed b6=28'b0000000000000000001000010010;
parameter signed b7=28'b0000000000000000000100010010;
parameter signed b8=28'b0000000000000001000100100000;
parameter signed b9=28'b0000000000000100010000000000;
parameter signed b10=28'b0000000000010000000100001000;
parameter signed b11=28'b0000000001001000000100000000;
parameter signed b12=28'b0000000001000000010010000100;
parameter signed b13=28'b0000000001000100010000001000;
parameter signed b14=28'b0000000100100000000100100010;
parameter signed b15=28'b0000000100100001000100010010;
parameter signed b16=28'b0000000100001000001000100000;

input clock_in,clock_div8,clock_div4,clock_div2,clock_up,neg_en,rstn;
input signed [23:0] Data_in; 
output reg signed [23:0] Data_out;
reg signed [23:0] s[0:3];

wire signed [37:0] Data_a0;
wire signed [37:0] Data_a1;
wire signed [37:0] Data_a2;
wire signed [37:0] Data_a3;
wire signed [37:0] Data_a4;
wire signed [37:0] Data_a5;
wire signed [37:0] Data_a6;
wire signed [37:0] Data_a7;
wire signed [37:0] csdout[30:0];
integer	k;
wire [2:0] up_count;

//并行实现乘累加
// a0 adding result
CSD_mult mult00(.CSD_in(b1),
			   .Data_in(Data_in),
			   .Data_out(csdout[0]));
CSD_mult mult01(.CSD_in(b9),
			   .Data_in(s[1]),
			   .Data_out(csdout[8]));
CSD_mult mult02(.CSD_in(b15),
			   .Data_in(s[2]),
			   .Data_out(csdout[16]));
CSD_mult mult03(.CSD_in(b7),
			   .Data_in(s[3]),
			   .Data_out(csdout[24]));
assign Data_a0=csdout[0]+csdout[8]+csdout[16]+csdout[24];

// a1 adding result
CSD_mult mult10(.CSD_in(b2),
			   .Data_in(Data_in),
			   .Data_out(csdout[1]));
CSD_mult mult11(.CSD_in(b10),
			   .Data_in(s[1]),
			   .Data_out(csdout[9]));
CSD_mult mult12(.CSD_in(b14),
			   .Data_in(s[2]),
			   .Data_out(csdout[17]));
CSD_mult mult13(.CSD_in(b6),
			   .Data_in(s[3]),
			   .Data_out(csdout[25]));
assign Data_a1=csdout[1]+csdout[9]+csdout[17]+csdout[25];

// a2 adding result
CSD_mult mult20(.CSD_in(b3),
			   .Data_in(Data_in),
			   .Data_out(csdout[2]));
CSD_mult mult21(.CSD_in(b11),
			   .Data_in(s[1]),
			   .Data_out(csdout[10]));
CSD_mult mult22(.CSD_in(b13),
			   .Data_in(s[2]),
			   .Data_out(csdout[18]));
CSD_mult mult23(.CSD_in(b5),
			   .Data_in(s[3]),
			   .Data_out(csdout[26]));
assign Data_a2=csdout[2]+csdout[10]+csdout[18]+csdout[26];

// a3 adding result
CSD_mult mult30(.CSD_in(b4),
			   .Data_in(Data_in),
			   .Data_out(csdout[3]));
CSD_mult mult31(.CSD_in(b12),
			   .Data_in(s[1]),
			   .Data_out(csdout[11]));
CSD_mult mult32(.CSD_in(b12),
			   .Data_in(s[2]),
			   .Data_out(csdout[19]));
CSD_mult mult33(.CSD_in(b4),
			   .Data_in(s[3]),
			   .Data_out(csdout[27]));
assign Data_a3=csdout[3]+csdout[11]+csdout[19]+csdout[27];

// a4 adding result
CSD_mult mult40(.CSD_in(b5),
			   .Data_in(Data_in),
			   .Data_out(csdout[4]));
CSD_mult mult41(.CSD_in(b13),
			   .Data_in(s[1]),
			   .Data_out(csdout[12]));
CSD_mult mult42(.CSD_in(b11),
			   .Data_in(s[2]),
			   .Data_out(csdout[20]));
CSD_mult mult43(.CSD_in(b3),
			   .Data_in(s[3]),
			   .Data_out(csdout[28]));
assign Data_a4=csdout[4]+csdout[12]+csdout[20]+csdout[28];

// a5 adding result
CSD_mult mult50(.CSD_in(b6),
			   .Data_in(Data_in),
			   .Data_out(csdout[5]));
CSD_mult mult51(.CSD_in(b14),
			   .Data_in(s[1]),
			   .Data_out(csdout[13]));
CSD_mult mult52(.CSD_in(b10),
			   .Data_in(s[2]),
			   .Data_out(csdout[21]));
CSD_mult mult53(.CSD_in(b2),
			   .Data_in(s[3]),
			   .Data_out(csdout[29]));
assign Data_a5=csdout[5]+csdout[13]+csdout[21]+csdout[29];

// a6 adding result
CSD_mult mult60(.CSD_in(b7),
			   .Data_in(Data_in),
			   .Data_out(csdout[6]));
CSD_mult mult61(.CSD_in(b15),
			   .Data_in(s[1]),
			   .Data_out(csdout[14]));
CSD_mult mult62(.CSD_in(b9),
			   .Data_in(s[2]),
			   .Data_out(csdout[22]));
CSD_mult mult63(.CSD_in(b1),
			   .Data_in(s[3]),
			   .Data_out(csdout[30]));
assign Data_a6=csdout[6]+csdout[14]+csdout[22]+csdout[30] ;

// a7 adding result
CSD_mult mult70(.CSD_in(b8),
			   .Data_in(Data_in),
			   .Data_out(csdout[7]));
CSD_mult mult71(.CSD_in(b16),
			   .Data_in(s[1]),
			   .Data_out(csdout[15]));
CSD_mult mult72(.CSD_in(b8),
			   .Data_in(s[2]),
			   .Data_out(csdout[23]));
assign Data_a7=csdout[7]+csdout[15]+csdout[23];


//MUX实现上采样
assign up_count={clock_div8,clock_div4,clock_div2};
always @(posedge clock_up or negedge rstn)
	if(rstn==0)begin
		Data_out<=0;
	end
	else if (neg_en) begin
		case(up_count)
			3'b000: Data_out<=Data_a7[33:10];
			3'b001: Data_out<=Data_a6[33:10];
			3'b010: Data_out<=Data_a5[33:10];
			3'b011: Data_out<=Data_a4[33:10];
			3'b100: Data_out<=Data_a3[33:10];
			3'b101: Data_out<=Data_a2[33:10];
			3'b110: Data_out<=Data_a1[33:10];
			3'b111: Data_out<=Data_a0[33:10];
			default: Data_out<=Data_a0[33:10];
		endcase
	end
	else begin
		Data_out <= Data_out;
	end

//完成移位的功能
always @(posedge clock_up or negedge rstn) begin
	if(rstn==0)begin
		for(k=0;k<=3;k=k+1)
			s[k]<=0;
	end
	else if(clock_in)begin
		s[1]<=Data_in;
		for(k=2;k<=3;k=k+1)
			s[k]<=s[k-1];
	end
	else begin
		for(k=0;k<=3;k=k+1)
			s[k]<=s[k];
	end
end

endmodule
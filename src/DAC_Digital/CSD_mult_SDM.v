//#######################
// CDS multiplier block
//#######################

module CSD_mult_SDM(CSD_in,Data_in,Data_out);

input [23:0] CSD_in;
input signed [23:0] Data_in;
output signed [34:0] Data_out;
reg signed  [34:0] Data_sum[11:0]; //部分积之和的reg
wire signed [33:0] partial_prod[11:0]; //部分积的net

//部分积的sum给到输出
assign Data_out=Data_sum[11];

//先进行移位
assign partial_prod[0]=Data_in; //输入信号赋值扩展
assign partial_prod[1]=partial_prod[0]<<1;
assign partial_prod[2]=partial_prod[0]<<2;
assign partial_prod[3]=partial_prod[0]<<3;
assign partial_prod[4]=partial_prod[0]<<4;
assign partial_prod[5]=partial_prod[0]<<5;
assign partial_prod[6]=partial_prod[0]<<6;
assign partial_prod[7]=partial_prod[0]<<7;
assign partial_prod[8]=partial_prod[0]<<8;
assign partial_prod[9]=partial_prod[0]<<9;
assign partial_prod[10]=partial_prod[0]<<10;
assign partial_prod[11]=partial_prod[0]<<11;


//根据CSD_in做加减法
always @(*)begin
	case(CSD_in[1:0])
		2'b00: Data_sum[0]=0;
		2'b01: Data_sum[0]=partial_prod[0];
		2'b10: Data_sum[0]=0-partial_prod[0];
		default: Data_sum[0]=0;
	endcase
end

always @(*)begin
	case(CSD_in[3:2])
		2'b00: Data_sum[1]=Data_sum[0];
		2'b01: Data_sum[1]=Data_sum[0]+partial_prod[1];
		2'b10: Data_sum[1]=Data_sum[0]-partial_prod[1];
		default: Data_sum[1]=0;
	endcase
end

always @(*)begin
	case(CSD_in[5:4])
		2'b00: Data_sum[2]=Data_sum[1];
		2'b01: Data_sum[2]=Data_sum[1]+partial_prod[2];
		2'b10: Data_sum[2]=Data_sum[1]-partial_prod[2];
		default: Data_sum[2]=0;
	endcase
end

always @(*)begin
	case(CSD_in[7:6])
		2'b00: Data_sum[3]=Data_sum[2];
		2'b01: Data_sum[3]=Data_sum[2]+partial_prod[3];
		2'b10: Data_sum[3]=Data_sum[2]-partial_prod[3];
		default: Data_sum[3]=0;
	endcase
end

always @(*)begin
	case(CSD_in[9:8])
		2'b00: Data_sum[4]=Data_sum[3];
		2'b01: Data_sum[4]=Data_sum[3]+partial_prod[4];
		2'b10: Data_sum[4]=Data_sum[3]-partial_prod[4];
		default: Data_sum[4]=0;
	endcase
end

always @(*)begin
	case(CSD_in[11:10])
		2'b00: Data_sum[5]=Data_sum[4];
		2'b01: Data_sum[5]=Data_sum[4]+partial_prod[5];
		2'b10: Data_sum[5]=Data_sum[4]-partial_prod[5];
		default: Data_sum[5]=0;
	endcase
end

always @(*)begin
	case(CSD_in[13:12])
		2'b00: Data_sum[6]=Data_sum[5];
		2'b01: Data_sum[6]=Data_sum[5]+partial_prod[6];
		2'b10: Data_sum[6]=Data_sum[5]-partial_prod[6];
		default: Data_sum[6]=0;
	endcase
end

always @(*)begin
	case(CSD_in[15:14])
		2'b00: Data_sum[7]=Data_sum[6];
		2'b01: Data_sum[7]=Data_sum[6]+partial_prod[7];
		2'b10: Data_sum[7]=Data_sum[6]-partial_prod[7];
		default: Data_sum[7]=0;
	endcase
end

always @(*)begin
	case(CSD_in[17:16])
		2'b00: Data_sum[8]=Data_sum[7];
		2'b01: Data_sum[8]=Data_sum[7]+partial_prod[8];
		2'b10: Data_sum[8]=Data_sum[7]-partial_prod[8];
		default: Data_sum[8]=0;
	endcase
end

always @(*)begin
	case(CSD_in[19:18])
		2'b00: Data_sum[9]=Data_sum[8];
		2'b01: Data_sum[9]=Data_sum[8]+partial_prod[9];
		2'b10: Data_sum[9]=Data_sum[8]-partial_prod[9];
		default: Data_sum[9]=0;
	endcase
end

always @(*)begin
	case(CSD_in[21:20])
		2'b00: Data_sum[10]=Data_sum[9];
		2'b01: Data_sum[10]=Data_sum[9]+partial_prod[10];
		2'b10: Data_sum[10]=Data_sum[9]-partial_prod[10];
		default: Data_sum[10]=0;
	endcase
end

always @(*)begin
	case(CSD_in[23:22])
		2'b00: Data_sum[11]=Data_sum[10];
		2'b01: Data_sum[11]=Data_sum[10]+partial_prod[11];
		2'b10: Data_sum[11]=Data_sum[10]-partial_prod[11];
		default: Data_sum[11]=0;
	endcase
end

endmodule



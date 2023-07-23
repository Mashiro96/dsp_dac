//################################
// Decoder for Gama Number
// 6-inputs element
// Version 1.5                  
//################################

module decode3_6_Gama(s,DataOut);

//---------------------------
// s: Input deecimal adress;
// DataOut: Output data;
//---------------------------

input  [2:0] s;
output reg [5:0] DataOut;

always@(s)begin
	case(s)
		3'b000: DataOut=6'b000000;
		3'b001: DataOut=6'b100000;
		3'b010: DataOut=6'b110000;
		3'b011: DataOut=6'b111000;
		3'b100: DataOut=6'b111100;
		3'b101: DataOut=6'b111110;
		3'b110: DataOut=6'b111111;
		default: DataOut=6'b000000;
	endcase
end
endmodule
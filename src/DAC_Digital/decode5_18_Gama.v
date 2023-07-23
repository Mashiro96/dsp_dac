//################################
// Decoder for Gama Number
// 18-inputs element
// Version 1.5                  
//################################

module decode5_18_Gama(s,DataOut);

//---------------------------
// s: Input deecimal adress;
// DataOut: Output data;
//---------------------------

input [4:0] s;
output reg [17:0] DataOut;

always@(s)begin
	case(s)
		5'b00000: DataOut=18'b000000000000000000;
		5'b00001: DataOut=18'b100000000000000000;
		5'b00010: DataOut=18'b110000000000000000;
		5'b00011: DataOut=18'b111000000000000000;
		5'b00100: DataOut=18'b111100000000000000;
		5'b00101: DataOut=18'b111110000000000000;
		5'b00110: DataOut=18'b111111000000000000;
		5'b00111: DataOut=18'b111111100000000000;
		5'b01000: DataOut=18'b111111110000000000; 
		5'b01001: DataOut=18'b111111111000000000;
		5'b01010: DataOut=18'b111111111100000000;
		5'b01011: DataOut=18'b111111111110000000;
		5'b01100: DataOut=18'b111111111111000000;
		5'b01101: DataOut=18'b111111111111100000;
		5'b01110: DataOut=18'b111111111111110000;
		5'b01111: DataOut=18'b111111111111111000;
		5'b10000: DataOut=18'b111111111111111100;
		5'b10001: DataOut=18'b111111111111111110;
		5'b10010: DataOut=18'b111111111111111111;
		default:  DataOut=18'b000000000000000000;
	endcase
end
endmodule
//################################
// Decoder for Digital Selector
// 18-inputs element
// Version 1.5                  
//################################

module decode5_18_Norm(s,en,DataOut);

//---------------------------
// s: Input deecimal adress;
// en: Input enable;
// DataOut: Output data;
//---------------------------

input en;
input [4:0] s;
output reg [17:0] DataOut;

always@(en or s)begin
	if(en==0)
		DataOut=18'b000000000000000000;
	else
		case(s)
			5'b00000: DataOut=18'b000000000000000001;
			5'b00001: DataOut=18'b000000000000000010;
			5'b00010: DataOut=18'b000000000000000100;
			5'b00011: DataOut=18'b000000000000001000;
			5'b00100: DataOut=18'b000000000000010000;
			5'b00101: DataOut=18'b000000000000100000;
			5'b00110: DataOut=18'b000000000001000000;
			5'b00111: DataOut=18'b000000000010000000;
			5'b01000: DataOut=18'b000000000100000000;
			5'b01001: DataOut=18'b000000001000000000;
			5'b01010: DataOut=18'b000000010000000000;
			5'b01011: DataOut=18'b000000100000000000;
			5'b01100: DataOut=18'b000001000000000000;
			5'b01101: DataOut=18'b000010000000000000;
			5'b01110: DataOut=18'b000100000000000000;
			5'b01111: DataOut=18'b001000000000000000;
			5'b10000: DataOut=18'b010000000000000000;
			5'b10001: DataOut=18'b100000000000000000;
			default:  DataOut=18'b000000000000000000;
		endcase
end

endmodule
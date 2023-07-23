//################################
// Decoder for Beta Number
// 18-inputs element
// Version 1.5                  
//################################

module decode5_18_Beta(s,DataOut);

//---------------------------
// s: Input deecimal adress;
// DataOut: Output data;
//---------------------------

input [4:0] s;
output reg [17:0] DataOut;

always@(s)begin
	case(s)
		5'b00000: DataOut=18'b000000000000000000;
		5'b00001: DataOut=18'b000000000000000001;
		5'b00010: DataOut=18'b000000000000000011;
		5'b00011: DataOut=18'b000000000000000111;
		5'b00100: DataOut=18'b000000000000001111;
		5'b00101: DataOut=18'b000000000000011111;
		5'b00110: DataOut=18'b000000000000111111;
		5'b00111: DataOut=18'b000000000001111111;
		5'b01000: DataOut=18'b000000000011111111; 
		5'b01001: DataOut=18'b000000000111111111;
		5'b01010: DataOut=18'b000000001111111111;
		5'b01011: DataOut=18'b000000011111111111;
		5'b01100: DataOut=18'b000000111111111111;
		5'b01101: DataOut=18'b000001111111111111;
		5'b01110: DataOut=18'b000011111111111111;
		5'b01111: DataOut=18'b000111111111111111;
		5'b10000: DataOut=18'b001111111111111111;
		5'b10001: DataOut=18'b011111111111111111;
		5'b10010: DataOut=18'b111111111111111111;
		default:  DataOut=18'b000000000000000000;
	endcase
end
endmodule
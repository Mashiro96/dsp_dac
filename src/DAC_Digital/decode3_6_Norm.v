//################################
// Decoder for Digital Selector
// 6-inputs element
// Version 1.5                  
//################################

module decode3_6_Norm(s,en,DataOut);

//---------------------------
// s: Input deecimal adress;
// en: Input enable;
// DataOut: Output data;
//---------------------------

input en;
input  [2:0] s;
output reg [5:0] DataOut;

always@(en or s)begin
	if(en==0)
		DataOut=6'b000000;
	else
		case(s)
			3'b000: DataOut=6'b000001;
			3'b001: DataOut=6'b000010;
			3'b010: DataOut=6'b000100;
			3'b011: DataOut=6'b001000;
			3'b100: DataOut=6'b010000;
			3'b101: DataOut=6'b100000;
			default: DataOut=6'b000000;
		endcase
end
endmodule
//----------------------------
// 2 input comparator for VQ6
// Version 1.0
//----------------------------

module comp2_VQ6(In1,In0,
				 Out1,Out0,
				 Adi1,Adi0,
				 Ado1,Ado0);

//-------------------------
// In0: input binary code;
// In1: input binary code;
// Out1 is the max value;
// Out0 is the min value;
//-------------------------

input signed [7:0] In0,In1; // Input data
input  [2:0] Adi0,Adi1; //Element Input address
output signed [7:0] Out0,Out1; // Ouput data
output [2:0] Ado0,Ado1; //Ouptut address

assign Out1= (In1>=In0) ? In1:In0;
assign Out0= (In1>=In0) ? In0:In1;
assign Ado1= (In1>=In0) ? Adi1:Adi0;
assign Ado0= (In1>=In0) ? Adi0:Adi1;

endmodule
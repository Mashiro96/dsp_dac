//---------------------------
// 2 input comparator for MIN
// Version 1.1
//---------------------------

module comp2_MIN_HILF(In1,In0,Out);

//-------------------------
// In0: input binary code;
// In1: input binary code;
// Out: is the min value;
//-------------------------

input [3:0] In0,In1; // Input data
output [3:0] Out; // Ouput data

assign Out= (In1>=In0) ? In0:In1;

endmodule
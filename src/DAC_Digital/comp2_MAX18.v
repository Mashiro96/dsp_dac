//---------------------------
// 2 input comparator for MAX
// Version 1.0
//---------------------------

module comp2_MAX18(In1,In0,Out);

//---------------------------------
// In0: input binary code;
// In1: input binary code;
// Out: is the max value;
//---------------------------------

input  [6:0] In0,In1; // Input data
output [6:0] Out;    // Ouput data

assign Out= (In1>=In0) ? In1:In0;

endmodule
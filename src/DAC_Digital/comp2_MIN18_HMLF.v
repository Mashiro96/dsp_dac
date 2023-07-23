//-----------------------------------
// 2 input MIN comparator for HMLF18
// Version 1.1
//-----------------------------------

module comp2_MIN18_HMLF(In1,In0,Out);

//---------------------------
// In0: input binary code;
// In1: input binary code;
// Out: is the min value;
//---------------------------

input signed  [6:0] In0,In1; // Input data
output signed [6:0] Out;    // Ouput data

assign Out=(In1>=In0) ? In0:In1;

endmodule
//---------------------------------
// MIN Operation 6-elements 
// Version 1.1
//---------------------------------

module MIN6_HILF(a5,a4,a3,a2,a1,a0,
				  b);

//--------------------------------
// a5-a0 : Input unsorted Vector;
// b     : Output min operation;
//--------------------------------

input wire [3:0] a5,a4,a3,a2,a1,a0;
output wire [3:0] b;

wire [3:0] ma2 [2:0];
wire [3:0] ma3;
wire [3:0] ma4;

// Depth=1
comp2_MIN_HILF comp2_N10(.In1(a5), .In0(a4), .Out(ma2[2])); //(5,4)
comp2_MIN_HILF comp2_N11(.In1(a3), .In0(a2), .Out(ma2[1])); //(3,2)
comp2_MIN_HILF comp2_N12(.In1(a1), .In0(a0), .Out(ma2[0])); //(1,0)

// Depth=2
comp2_MIN_HILF comp2_N20(.In1(ma2[2]), .In0(ma2[1]), .Out(ma3));

// Depth=3
comp2_MIN_HILF comp2_N30(.In1(ma3), .In0(ma2[0]), .Out(ma4));

// Output
assign b=ma4;

endmodule
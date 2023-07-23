//---------------------------------
// MIN Operation 18-elements 
// Version 1.5
//---------------------------------

module MIN18_HMLF_V1p5(a17,a16,a15,a14,a13,a12,a11,a10,
					   a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,b);

//--------------------------------
// a17-a0: Input unsorted Vector;
// b     : Output min operation;
//--------------------------------

input wire signed [6:0] a17,a16,a15,a14,a13,a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0;
output wire signed [6:0] b;

wire signed [6:0] ma2 [8:0];
wire signed [6:0] ma3 [3:0];
wire signed [6:0] ma4 [1:0];
wire signed [6:0] ma5;
wire signed [6:0] ma6;

// Depth=1
comp2_MIN18_HMLF comp2_N10(.In1(a17), .In0(a16), .Out(ma2[8])); //(17,16)
comp2_MIN18_HMLF comp2_N11(.In1(a15), .In0(a14), .Out(ma2[7])); //(15,14)
comp2_MIN18_HMLF comp2_N12(.In1(a13), .In0(a12), .Out(ma2[6])); //(13,12)
comp2_MIN18_HMLF comp2_N13(.In1(a11), .In0(a10), .Out(ma2[5])); //(11,10)
comp2_MIN18_HMLF comp2_N14(.In1(a9),  .In0(a8),  .Out(ma2[4])); //(9, 8)
comp2_MIN18_HMLF comp2_N15(.In1(a7),  .In0(a6),  .Out(ma2[3])); //(7, 6)
comp2_MIN18_HMLF comp2_N16(.In1(a5),  .In0(a4),  .Out(ma2[2])); //(5, 4)
comp2_MIN18_HMLF comp2_N17(.In1(a3),  .In0(a2),  .Out(ma2[1])); //(3, 2)
comp2_MIN18_HMLF comp2_N18(.In1(a1),  .In0(a0),  .Out(ma2[0])); //(1, 0)

// Depth=2
comp2_MIN18_HMLF comp2_N20(.In1(ma2[8]), .In0(ma2[7]),  .Out(ma3[3]));  //(8,7)
comp2_MIN18_HMLF comp2_N21(.In1(ma2[6]), .In0(ma2[5]),  .Out(ma3[2]));  //(6,5)
comp2_MIN18_HMLF comp2_N22(.In1(ma2[4]), .In0(ma2[3]),  .Out(ma3[1]));  //(4,3)
comp2_MIN18_HMLF comp2_N23(.In1(ma2[2]), .In0(ma2[1]),  .Out(ma3[0]));  //(2,1)

// Depth=3
comp2_MIN18_HMLF comp2_N30(.In1(ma3[3]), .In0(ma3[2]), .Out(ma4[1])); //(3,2)
comp2_MIN18_HMLF comp2_N31(.In1(ma3[1]), .In0(ma3[0]), .Out(ma4[0])); //(1,0)

// Depth=4
comp2_MIN18_HMLF comp2_N40(.In1(ma4[1]), .In0(ma4[0]), .Out(ma5)); //(1,0)

// Depth=5
comp2_MIN18_HMLF comp2_N50(.In1(ma5), .In0(ma2[0]), .Out(ma6));

// Output
assign b = ma6;

endmodule
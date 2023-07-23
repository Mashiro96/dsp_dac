//---------------------------------
// Vector Quantizer 6-elements 
// Version 1.5
//---------------------------------

module VQ6_V1p5(a5,a4,a3,a2,a1,a0,
				b5,b4,b3,b2,b1,b0);

//--------------------------------------------
// a5-a0: Input unsorted Vector;
// b5-b0: Output address Vector;
// ad5-ad0: Address Vector;
// 这个code的线宽需要修改，先用以前的线宽！！
//-------------------------------------------

input wire  [7:0] a5,a4,a3,a2,a1,a0; // the input data
output wire [2:0] b5,b4,b3,b2,b1,b0; // the output address

wire [2:0] ad5=5,ad4=4,ad3=3,ad2=2,ad1=1,ad0=0;

wire [7:0] ma2 [5:0];
wire [7:0] ma3 [5:0];
wire [7:0] ma4 [5:0];
wire [7:0] ma5 [5:0];
wire [7:0] ma6 [5:0];

wire [2:0] mad2 [5:0];
wire [2:0] mad3 [5:0];
wire [2:0] mad4 [5:0];
wire [2:0] mad5 [5:0];
wire [2:0] mad6 [5:0];

// Depth=1
comp2_VQ6 comp2_N10(.In1(a4), .In0(a2),  .Adi1(ad4), .Adi0(ad2),   .Out1(ma2[4]), .Out0(ma2[2]),  .Ado1(mad2[4]), .Ado0(mad2[2]));  //(4,2)
comp2_VQ6 comp2_N11(.In1(a5), .In0(a0),  .Adi1(ad5), .Adi0(ad0),   .Out1(ma2[5]), .Out0(ma2[0]),  .Ado1(mad2[5]), .Ado0(mad2[0]));  //(5,0)
comp2_VQ6 comp2_N12(.In1(a3), .In0(a1),  .Adi1(ad3), .Adi0(ad1),   .Out1(ma2[3]), .Out0(ma2[1]),  .Ado1(mad2[3]), .Ado0(mad2[1]));  //(3,1)

// Depth=2
comp2_VQ6 comp2_N20(.In1(ma2[4]), .In0(ma2[3]),  .Adi1(mad2[4]), .Adi0(mad2[3]),   .Out1(ma3[4]), .Out0(ma3[3]),  .Ado1(mad3[4]), .Ado0(mad3[3]));  //(4,3)
comp2_VQ6 comp2_N21(.In1(ma2[2]), .In0(ma2[1]),  .Adi1(mad2[2]), .Adi0(mad2[1]),   .Out1(ma3[2]), .Out0(ma3[1]),  .Ado1(mad3[2]), .Ado0(mad3[1]));  //(2,1)
assign ma3[5]=ma2[5];  assign mad3[5]=mad2[5]; //(5)
assign ma3[0]=ma2[0];  assign mad3[0]=mad2[0]; //(0)

// Depth=3
comp2_VQ6 comp2_N30(.In1(ma3[5]), .In0(ma3[2]), .Adi1(mad3[5]), .Adi0(mad3[2]),  .Out1(ma4[5]), .Out0(ma4[2]), .Ado1(mad4[5]), .Ado0(mad4[2])); //(5,2)
comp2_VQ6 comp2_N31(.In1(ma3[3]), .In0(ma3[0]), .Adi1(mad3[3]), .Adi0(mad3[0]),  .Out1(ma4[3]), .Out0(ma4[0]), .Ado1(mad4[3]), .Ado0(mad4[0])); //(3,0)
assign ma4[4]=ma3[4];  assign mad4[4]=mad3[4]; //(4)
assign ma4[1]=ma3[1];  assign mad4[1]=mad3[1]; //(1)

// Depth=4
comp2_VQ6 comp2_N40(.In1(ma4[5]), .In0(ma4[4]),  .Adi1(mad4[5]), .Adi0(mad4[4]),   .Out1(ma5[5]), .Out0(ma5[4]),  .Ado1(mad5[5]), .Ado0(mad5[4]));  //(5,4)
comp2_VQ6 comp2_N41(.In1(ma4[3]), .In0(ma4[2]),  .Adi1(mad4[3]), .Adi0(mad4[2]),   .Out1(ma5[3]), .Out0(ma5[2]),  .Ado1(mad5[3]), .Ado0(mad5[2]));  //(3,2)
comp2_VQ6 comp2_N42(.In1(ma4[1]), .In0(ma4[0]),  .Adi1(mad4[1]), .Adi0(mad4[0]),   .Out1(ma5[1]), .Out0(ma5[0]),  .Ado1(mad5[1]), .Ado0(mad5[0]));  //(1,0)

// Depth=5
comp2_VQ6 comp2_N50(.In1(ma5[4]), .In0(ma5[3]),  .Adi1(mad5[4]), .Adi0(mad5[3]),   .Out1(ma6[4]), .Out0(ma6[3]),  .Ado1(mad6[4]), .Ado0(mad6[3]));  //(4,3)
comp2_VQ6 comp2_N51(.In1(ma5[2]), .In0(ma5[1]),  .Adi1(mad5[2]), .Adi0(mad5[1]),   .Out1(ma6[2]), .Out0(ma6[1]),  .Ado1(mad6[2]), .Ado0(mad6[1]));  //(2,1)
assign ma6[5]=ma5[5];    assign mad6[5]=mad5[5]; //(5)
assign ma6[0]=ma5[0];    assign mad6[0]=mad5[0]; //(0)

// Output address
assign b5=mad6[5];
assign b4=mad6[4];
assign b3=mad6[3];
assign b2=mad6[2];
assign b1=mad6[1];
assign b0=mad6[0];

endmodule
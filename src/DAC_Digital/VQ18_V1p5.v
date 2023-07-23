//---------------------------------
// Vector Quantizer 18-elements
// 1.With partial sort operation
// Version 1.5
//---------------------------------

module VQ18_V1p5(a17,a16,a15,a14,a13,a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,
				b17,b16,b15,b14,b13,b12,b11,b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0);

//--------------------------------
// a17-a0: Input unsorted Vector
// b17-b0: Output address Vector
// ad17-ad0: Address Vector
//--------------------------------

input wire signed [7:0] a17,a16,a15,a14,a13,a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0;
output wire [4:0] b17,b16,b15,b14,b13,b12,b11,b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0;

wire [4:0] ad17=17,ad16=16,ad15=15,ad14=14,ad13=13,ad12=12,ad11=11,ad10=10,ad9=9;
wire [4:0] ad8=8,ad7=7,ad6=6,ad5=5,ad4=4,ad3=3,ad2=2,ad1=1,ad0=0;

wire signed [7:0] ma2 [17:0];
wire signed [7:0] ma3 [17:0];
wire signed [7:0] ma4 [17:0];
wire signed [7:0] ma5 [17:0];
wire signed [7:0] ma6 [17:0];
wire signed [7:0] ma7 [17:0];
wire signed [7:0] ma8 [17:0];
wire signed [7:0] ma9 [17:0];
wire signed [7:0] ma10 [17:0];
wire signed [7:0] ma11 [17:0];
wire signed [7:0] ma12 [17:0];

wire [4:0] mad2 [17:0];
wire [4:0] mad3 [17:0];
wire [4:0] mad4 [17:0];
wire [4:0] mad5 [17:0];
wire [4:0] mad6 [17:0];
wire [4:0] mad7 [17:0];
wire [4:0] mad8 [17:0];
wire [4:0] mad9 [17:0];
wire [4:0] mad10 [17:0];
wire [4:0] mad11 [17:0];
wire [4:0] mad12 [17:0];

// Depth=1
comp2_VQ18 comp2_N10(.In1(a16), .In0(a7),  .Adi1(ad16), .Adi0(ad7),   .Out1(ma2[16]), .Out0(ma2[7]),  .Ado1(mad2[16]), .Ado0(mad2[7]));  //(16,7)
comp2_VQ18 comp2_N11(.In1(a17), .In0(a11), .Adi1(ad17), .Adi0(ad11),  .Out1(ma2[17]), .Out0(ma2[11]), .Ado1(mad2[17]), .Ado0(mad2[11])); //(17,11)
comp2_VQ18 comp2_N12(.In1(a9),  .In0(a4),  .Adi1(ad9),  .Adi0(ad4),   .Out1(ma2[9]),  .Out0(ma2[4]),  .Ado1(mad2[9]),  .Ado0(mad2[4]));  //(9, 4)
comp2_VQ18 comp2_N13(.In1(a14), .In0(a12), .Adi1(ad14), .Adi0(ad12),  .Out1(ma2[14]), .Out0(ma2[12]), .Ado1(mad2[14]), .Ado0(mad2[12])); //(14,12)
comp2_VQ18 comp2_N14(.In1(a5),  .In0(a3),  .Adi1(ad5),  .Adi0(ad3),   .Out1(ma2[5]),  .Out0(ma2[3]),  .Ado1(mad2[5]),  .Ado0(mad2[3]));  //(5, 3)
comp2_VQ18 comp2_N15(.In1(a15), .In0(a2),  .Adi1(ad15), .Adi0(ad2),   .Out1(ma2[15]), .Out0(ma2[2]),  .Ado1(mad2[15]), .Ado0(mad2[2]));  //(15,2)
comp2_VQ18 comp2_N16(.In1(a13), .In0(a8),  .Adi1(ad13), .Adi0(ad8),   .Out1(ma2[13]), .Out0(ma2[8]),  .Ado1(mad2[13]), .Ado0(mad2[8]));  //(13,8)
comp2_VQ18 comp2_N17(.In1(a6),  .In0(a0),  .Adi1(ad6),  .Adi0(ad0),   .Out1(ma2[6]),  .Out0(ma2[0]),  .Ado1(mad2[6]),  .Ado0(mad2[0]));  //(6, 0)
comp2_VQ18 comp2_N18(.In1(a10), .In0(a1),  .Adi1(ad10), .Adi0(ad1),   .Out1(ma2[10]), .Out0(ma2[1]),  .Ado1(mad2[10]), .Ado0(mad2[1]));  //(10,1)

// Depth=2
comp2_VQ18 comp2_N20(.In1(ma2[17]), .In0(ma2[5]),  .Adi1(mad2[17]), .Adi0(mad2[5]),   .Out1(ma3[17]), .Out0(ma3[5]),  .Ado1(mad3[17]), .Ado0(mad3[5]));  //(17,5)
comp2_VQ18 comp2_N21(.In1(ma2[14]), .In0(ma2[6]),  .Adi1(mad2[14]), .Adi0(mad2[6]),   .Out1(ma3[14]), .Out0(ma3[6]),  .Ado1(mad3[14]), .Ado0(mad3[6]));  //(14,6)
comp2_VQ18 comp2_N22(.In1(ma2[16]), .In0(ma2[13]), .Adi1(mad2[16]), .Adi0(mad2[13]),  .Out1(ma3[16]), .Out0(ma3[13]), .Ado1(mad3[16]), .Ado0(mad3[13])); //(16,13)
comp2_VQ18 comp2_N23(.In1(ma2[10]), .In0(ma2[9]),  .Adi1(mad2[10]), .Adi0(mad2[9]),   .Out1(ma3[10]), .Out0(ma3[9]),  .Ado1(mad3[10]), .Ado0(mad3[9]));  //(10,9)
comp2_VQ18 comp2_N24(.In1(ma2[8]),  .In0(ma2[7]),  .Adi1(mad2[8]),  .Adi0(mad2[7]),   .Out1(ma3[8]),  .Out0(ma3[7]),  .Ado1(mad3[8]),  .Ado0(mad3[7]));  //(8, 7)
comp2_VQ18 comp2_N25(.In1(ma2[4]),  .In0(ma2[1]),  .Adi1(mad2[4]),  .Adi0(mad2[1]),   .Out1(ma3[4]),  .Out0(ma3[1]),  .Ado1(mad3[4]),  .Ado0(mad3[1]));  //(4, 1)
comp2_VQ18 comp2_N26(.In1(ma2[11]), .In0(ma2[3]),  .Adi1(mad2[11]), .Adi0(mad2[3]),   .Out1(ma3[11]), .Out0(ma3[3]),  .Ado1(mad3[11]), .Ado0(mad3[3]));  //(11,3)
comp2_VQ18 comp2_N27(.In1(ma2[12]), .In0(ma2[0]),  .Adi1(mad2[12]), .Adi0(mad2[0]),   .Out1(ma3[12]), .Out0(ma3[0]),  .Ado1(mad3[12]), .Ado0(mad3[0]));  //(12,0)
assign ma3[15]=ma2[15];  assign mad3[15]=mad2[15]; //(15)
assign ma3[2]=ma2[2];  assign mad3[2]=mad2[2]; //(2)

// Depth=3
comp2_VQ18 comp2_N30(.In1(ma3[15]), .In0(ma3[10]), .Adi1(mad3[15]), .Adi0(mad3[10]),  .Out1(ma4[15]), .Out0(ma4[10]), .Ado1(mad4[15]), .Ado0(mad4[10])); //(15,10)
comp2_VQ18 comp2_N31(.In1(ma3[9]),  .In0(ma3[6]),  .Adi1(mad3[9]),  .Adi0(mad3[6]),   .Out1(ma4[9]),  .Out0(ma4[6]),  .Ado1(mad4[9]),  .Ado0(mad4[6])); //(9,6)
comp2_VQ18 comp2_N32(.In1(ma3[16]), .In0(ma3[4]),  .Adi1(mad3[16]), .Adi0(mad3[4]),   .Out1(ma4[16]), .Out0(ma4[4]),  .Ado1(mad4[16]), .Ado0(mad4[4])); //(16,4)
comp2_VQ18 comp2_N33(.In1(ma3[11]), .In0(ma3[8]),  .Adi1(mad3[11]), .Adi0(mad3[8]),   .Out1(ma4[11]), .Out0(ma4[8]),  .Ado1(mad4[11]), .Ado0(mad4[8])); //(11,8)
comp2_VQ18 comp2_N34(.In1(ma3[7]),  .In0(ma3[2]),  .Adi1(mad3[7]),  .Adi0(mad3[2]),   .Out1(ma4[7]),  .Out0(ma4[2]),  .Ado1(mad4[7]),  .Ado0(mad4[2])); //(7, 2)
comp2_VQ18 comp2_N35(.In1(ma3[13]), .In0(ma3[1]),  .Adi1(mad3[13]), .Adi0(mad3[1]),   .Out1(ma4[13]), .Out0(ma4[1]),  .Ado1(mad4[13]), .Ado0(mad4[1])); //(13,1)
assign ma4[17]=ma3[17];  assign mad4[17]=mad3[17]; //(17)
assign ma4[14]=ma3[14];  assign mad4[14]=mad3[14]; //(14)
assign ma4[12]=ma3[12];  assign mad4[12]=mad3[12]; //(12)
assign ma4[5] =ma3[5];   assign mad4[5] =mad3[5];  //(5)
assign ma4[3] =ma3[3];   assign mad4[3] =mad3[3];  //(3)
assign ma4[0] =ma3[0];   assign mad4[0] =mad3[0];  //(0)

// Depth=4
comp2_VQ18 comp2_N40(.In1(ma4[10]), .In0(ma4[8]),  .Adi1(mad4[10]), .Adi0(mad4[8]),   .Out1(ma5[10]), .Out0(ma5[8]),  .Ado1(mad5[10]), .Ado0(mad5[8]));  //(10,8)
comp2_VQ18 comp2_N41(.In1(ma4[13]), .In0(ma4[5]),  .Adi1(mad4[13]), .Adi0(mad4[5]),   .Out1(ma5[13]), .Out0(ma5[5]),  .Ado1(mad5[13]), .Ado0(mad5[5]));  //(13,5)
comp2_VQ18 comp2_N42(.In1(ma4[17]), .In0(ma4[16]), .Adi1(mad4[17]), .Adi0(mad4[16]),  .Out1(ma5[17]), .Out0(ma5[16]), .Ado1(mad5[17]), .Ado0(mad5[16])); //(17,16)
comp2_VQ18 comp2_N43(.In1(ma4[15]), .In0(ma4[14]), .Adi1(mad4[15]), .Adi0(mad4[14]),  .Out1(ma5[15]), .Out0(ma5[14]), .Ado1(mad5[15]), .Ado0(mad5[14])); //(15,14)
comp2_VQ18 comp2_N44(.In1(ma4[9]),  .In0(ma4[7]),  .Adi1(mad4[9]),  .Adi0(mad4[7]),   .Out1(ma5[9]),  .Out0(ma5[7]),  .Ado1(mad5[9]),  .Ado0(mad5[7]));  //(9, 7)
comp2_VQ18 comp2_N45(.In1(ma4[3]),  .In0(ma4[2]),  .Adi1(mad4[3]),  .Adi0(mad4[2]),   .Out1(ma5[3]),  .Out0(ma5[2]),  .Ado1(mad5[3]),  .Ado0(mad5[2]));  //(3, 2)
comp2_VQ18 comp2_N46(.In1(ma4[1]),  .In0(ma4[0]),  .Adi1(mad4[1]),  .Adi0(mad4[0]),   .Out1(ma5[1]),  .Out0(ma5[0]),  .Ado1(mad5[1]),  .Ado0(mad5[0]));  //(1, 0)
comp2_VQ18 comp2_N47(.In1(ma4[12]), .In0(ma4[4]),  .Adi1(mad4[12]), .Adi0(mad4[4]),   .Out1(ma5[12]), .Out0(ma5[4]),  .Ado1(mad5[12]), .Ado0(mad5[4]));  //(12,4)
assign ma5[11]=ma4[11];  assign mad5[11]=mad4[11]; //(11)
assign ma5[6] =ma4[6];   assign mad5[6] =mad4[6];  //(6)

// Depth=5
comp2_VQ18 comp2_N50(.In1(ma5[16]), .In0(ma5[6]),  .Adi1(mad5[16]), .Adi0(mad5[6]),   .Out1(ma6[16]), .Out0(ma6[6]),  .Ado1(mad6[16]), .Ado0(mad6[6]));  //(16,6)
comp2_VQ18 comp2_N51(.In1(ma5[17]), .In0(ma5[15]), .Adi1(mad5[17]), .Adi0(mad5[15]),  .Out1(ma6[17]), .Out0(ma6[15]), .Ado1(mad6[17]), .Ado0(mad6[15])); //(17,15)
comp2_VQ18 comp2_N52(.In1(ma5[14]), .In0(ma5[13]), .Adi1(mad5[14]), .Adi0(mad5[13]),  .Out1(ma6[14]), .Out0(ma6[13]), .Ado1(mad6[14]), .Ado0(mad6[13])); //(14,13)
comp2_VQ18 comp2_N53(.In1(ma5[12]), .In0(ma5[10]), .Adi1(mad5[12]), .Adi0(mad5[10]),  .Out1(ma6[12]), .Out0(ma6[10]), .Ado1(mad6[12]), .Ado0(mad6[10])); //(12,10)
comp2_VQ18 comp2_N54(.In1(ma5[7]),  .In0(ma5[5]),  .Adi1(mad5[7]),  .Adi0(mad5[5]),   .Out1(ma6[7]),  .Out0(ma6[5]),  .Ado1(mad6[7]),  .Ado0(mad6[5]));  //(7, 5)
comp2_VQ18 comp2_N55(.In1(ma5[4]),  .In0(ma5[3]),  .Adi1(mad5[4]),  .Adi0(mad5[3]),   .Out1(ma6[4]),  .Out0(ma6[3]),  .Ado1(mad6[4]),  .Ado0(mad6[3]));  //(4, 3)
comp2_VQ18 comp2_N56(.In1(ma5[2]),  .In0(ma5[0]),  .Adi1(mad5[2]),  .Adi0(mad5[0]),   .Out1(ma6[2]),  .Out0(ma6[0]),  .Ado1(mad6[2]),  .Ado0(mad6[0]));  //(2, 0)
comp2_VQ18 comp2_N57(.In1(ma5[11]), .In0(ma5[1]),  .Adi1(mad5[11]), .Adi0(mad5[1]),   .Out1(ma6[11]), .Out0(ma6[1]),  .Ado1(mad6[11]), .Ado0(mad6[1]));  //(11,1)
assign ma6[9]=ma5[9];    assign mad6[9]=mad5[9]; //(9)
assign ma6[8]=ma5[8];    assign mad6[8]=mad5[8]; //(8)

// Depth=6
comp2_VQ18 comp2_N60(.In1(ma6[13]), .In0(ma6[7]),  .Adi1(mad6[13]), .Adi0(mad6[7]),    .Out1(ma7[13]), .Out0(ma7[7]),  .Ado1(mad7[13]), .Ado0(mad7[7]));  //(13,7)
comp2_VQ18 comp2_N61(.In1(ma6[12]), .In0(ma6[11]), .Adi1(mad6[12]), .Adi0(mad6[11]),   .Out1(ma7[12]), .Out0(ma7[11]), .Ado1(mad7[12]), .Ado0(mad7[11])); //(12,11)
comp2_VQ18 comp2_N62(.In1(ma6[6]),  .In0(ma6[5]),  .Adi1(mad6[6]),  .Adi0(mad6[5]),    .Out1(ma7[6]),  .Out0(ma7[5]),  .Ado1(mad7[6]),  .Ado0(mad7[5]));  //(6,5)
comp2_VQ18 comp2_N63(.In1(ma6[16]), .In0(ma6[9]),  .Adi1(mad6[16]), .Adi0(mad6[9]),    .Out1(ma7[16]), .Out0(ma7[9]),  .Ado1(mad7[16]), .Ado0(mad7[9]));  //(16,9)
comp2_VQ18 comp2_N64(.In1(ma6[8]),  .In0(ma6[1]),  .Adi1(mad6[8]),  .Adi0(mad6[1]),    .Out1(ma7[8]),  .Out0(ma7[1]),  .Ado1(mad7[8]),  .Ado0(mad7[1]));  //(8, 1)
comp2_VQ18 comp2_N65(.In1(ma6[10]), .In0(ma6[4]),  .Adi1(mad6[10]), .Adi0(mad6[4]),    .Out1(ma7[10]), .Out0(ma7[4]),  .Ado1(mad7[10]), .Ado0(mad7[4]));  //(10,4)
assign ma7[17]=ma6[17];  assign mad7[17]=mad6[17]; //(17)
assign ma7[15]=ma6[15];  assign mad7[15]=mad6[15]; //(15)
assign ma7[14]=ma6[14];  assign mad7[14]=mad6[14]; //(14)
assign ma7[3]=ma6[3];    assign mad7[3]=mad6[3];   //(3)
assign ma7[2]=ma6[2];    assign mad7[2]=mad6[2];   //(2)
assign ma7[0]=ma6[0];    assign mad7[0]=mad6[0];   //(0)

// Depth=7
comp2_VQ18 comp2_N70(.In1(ma7[13]), .In0(ma7[10]), .Adi1(mad7[13]), .Adi0(mad7[10]),   .Out1(ma8[13]), .Out0(ma8[10]), .Ado1(mad8[13]), .Ado0(mad8[10])); //(13,10)
comp2_VQ18 comp2_N71(.In1(ma7[7]),  .In0(ma7[4]),  .Adi1(mad7[7]),  .Adi0(mad7[4]),    .Out1(ma8[7]),  .Out0(ma8[4]),  .Ado1(mad8[7]),  .Ado0(mad8[4]));  //(7,4)
comp2_VQ18 comp2_N72(.In1(ma7[15]), .In0(ma7[12]), .Adi1(mad7[15]), .Adi0(mad7[12]),   .Out1(ma8[15]), .Out0(ma8[12]), .Ado1(mad8[15]), .Ado0(mad8[12])); //(15,12)
comp2_VQ18 comp2_N73(.In1(ma7[5]),  .In0(ma7[2]),  .Adi1(mad7[5]),  .Adi0(mad7[2]),    .Out1(ma8[5]),  .Out0(ma8[2]),  .Ado1(mad8[5]),  .Ado0(mad8[2]));  //(5,2)
comp2_VQ18 comp2_N74(.In1(ma7[16]), .In0(ma7[14]), .Adi1(mad7[16]), .Adi0(mad7[14]),   .Out1(ma8[16]), .Out0(ma8[14]), .Ado1(mad8[16]), .Ado0(mad8[14])); //(16,14)
comp2_VQ18 comp2_N75(.In1(ma7[11]), .In0(ma7[9]),  .Adi1(mad7[11]), .Adi0(mad7[9]),    .Out1(ma8[11]), .Out0(ma8[9]),  .Ado1(mad8[11]), .Ado0(mad8[9]));  //(11,9)
comp2_VQ18 comp2_N76(.In1(ma7[8]),  .In0(ma7[6]),  .Adi1(mad7[8]),  .Adi0(mad7[6]),    .Out1(ma8[8]),  .Out0(ma8[6]),  .Ado1(mad8[8]),  .Ado0(mad8[6]));  //(8,6)
comp2_VQ18 comp2_N77(.In1(ma7[3]),  .In0(ma7[1]),  .Adi1(mad7[3]),  .Adi0(mad7[1]),    .Out1(ma8[3]),  .Out0(ma8[1]),  .Ado1(mad8[3]),  .Ado0(mad8[1]));  //(3,1)
assign ma8[17]=ma7[17];  assign mad8[17]=mad7[17]; //(17)
assign ma8[0]=ma7[0];    assign mad8[0]=mad7[0]; //(0)

// Depth=8
comp2_VQ18 comp2_N80(.In1(ma8[14]), .In0(ma8[12]), .Adi1(mad8[14]), .Adi0(mad8[12]),   .Out1(ma9[14]), .Out0(ma9[12]), .Ado1(mad9[14]), .Ado0(mad9[12])); //(14,12)
comp2_VQ18 comp2_N81(.In1(ma8[10]), .In0(ma8[8]),  .Adi1(mad8[10]), .Adi0(mad8[8]),    .Out1(ma9[10]), .Out0(ma9[8]),  .Ado1(mad9[10]), .Ado0(mad9[8]));  //(10,8)
comp2_VQ18 comp2_N82(.In1(ma8[5]),  .In0(ma8[3]),  .Adi1(mad8[5]),  .Adi0(mad8[3]),    .Out1(ma9[5]),  .Out0(ma9[3]),  .Ado1(mad9[5]),  .Ado0(mad9[3]));  //(5,3)
comp2_VQ18 comp2_N83(.In1(ma8[16]), .In0(ma8[15]), .Adi1(mad8[16]), .Adi0(mad8[15]),   .Out1(ma9[16]), .Out0(ma9[15]), .Ado1(mad9[16]), .Ado0(mad9[15])); //(16,15)
comp2_VQ18 comp2_N84(.In1(ma8[13]), .In0(ma8[11]), .Adi1(mad8[13]), .Adi0(mad8[11]),   .Out1(ma9[13]), .Out0(ma9[11]), .Ado1(mad9[13]), .Ado0(mad9[11])); //(13,11)
comp2_VQ18 comp2_N85(.In1(ma8[9]),  .In0(ma8[7]),  .Adi1(mad8[9]),  .Adi0(mad8[7]),    .Out1(ma9[9]),  .Out0(ma9[7]),  .Ado1(mad9[9]),  .Ado0(mad9[7]));  //(9,7)
comp2_VQ18 comp2_N86(.In1(ma8[6]),  .In0(ma8[4]),  .Adi1(mad8[6]),  .Adi0(mad8[4]),    .Out1(ma9[6]),  .Out0(ma9[4]),  .Ado1(mad9[6]),  .Ado0(mad9[4]));  //(6,4)
comp2_VQ18 comp2_N87(.In1(ma8[2]),  .In0(ma8[1]),  .Adi1(mad8[2]),  .Adi0(mad8[1]),    .Out1(ma9[2]),  .Out0(ma9[1]),  .Ado1(mad9[2]),  .Ado0(mad9[1]));  //(2,1)
assign ma9[17]=ma8[17];  assign mad9[17]=mad8[17]; //(17)
assign ma9[0] =ma8[0];   assign mad9[0] =mad8[0]; //(0)

// Depth=9
comp2_VQ18 comp2_N90(.In1(ma9[12]), .In0(ma9[9]),  .Adi1(mad9[12]), .Adi0(mad9[9]),   .Out1(ma10[12]), .Out0(ma10[9]),  .Ado1(mad10[12]), .Ado0(mad10[9]));  //(12,9)
comp2_VQ18 comp2_N91(.In1(ma9[8]),  .In0(ma9[5]),  .Adi1(mad9[8]),  .Adi0(mad9[5]),   .Out1(ma10[8]),  .Out0(ma10[5]),  .Ado1(mad10[8]),  .Ado0(mad10[5]));  //(8,5)
comp2_VQ18 comp2_N92(.In1(ma9[15]), .In0(ma9[14]), .Adi1(mad9[15]), .Adi0(mad9[14]),  .Out1(ma10[15]), .Out0(ma10[14]), .Ado1(mad10[15]), .Ado0(mad10[14])); //(15,14)
comp2_VQ18 comp2_N93(.In1(ma9[11]), .In0(ma9[10]), .Adi1(mad9[11]), .Adi0(mad9[10]),  .Out1(ma10[11]), .Out0(ma10[10]), .Ado1(mad10[11]), .Ado0(mad10[10])); //(11,10)
comp2_VQ18 comp2_N94(.In1(ma9[7]),  .In0(ma9[6]),  .Adi1(mad9[7]),  .Adi0(mad9[6]),   .Out1(ma10[7]),  .Out0(ma10[6]),  .Ado1(mad10[7]),  .Ado0(mad10[6]));  //(7,6)
comp2_VQ18 comp2_N95(.In1(ma9[3]),  .In0(ma9[2]),  .Adi1(mad9[3]),  .Adi0(mad9[2]),   .Out1(ma10[3]),  .Out0(ma10[2]),  .Ado1(mad10[3]),  .Ado0(mad10[2]));  //(3,2)
assign ma10[17]=ma9[17];  assign mad10[17]=mad9[17]; //(17)
assign ma10[16]=ma9[16];  assign mad10[16]=mad9[16]; //(16)
assign ma10[13]=ma9[13];  assign mad10[13]=mad9[13]; //(13)
assign ma10[4] =ma9[4];   assign mad10[4] =mad9[4];   //(4)
assign ma10[1] =ma9[1];   assign mad10[1] =mad9[1];   //(1)
assign ma10[0] =ma9[0];   assign mad10[0] =mad9[0];   //(0)

// Depth=10
comp2_VQ18 comp2_N100(.In1(ma10[14]), .In0(ma10[13]), .Adi1(mad10[14]), .Adi0(mad10[13]), .Out1(ma11[14]), .Out0(ma11[13]), .Ado1(mad11[14]), .Ado0(mad11[13])); //(14,13)
comp2_VQ18 comp2_N101(.In1(ma10[12]), .In0(ma10[11]), .Adi1(mad10[12]), .Adi0(mad10[11]), .Out1(ma11[12]), .Out0(ma11[11]), .Ado1(mad11[12]), .Ado0(mad11[11])); //(12,11)
comp2_VQ18 comp2_N102(.In1(ma10[10]), .In0(ma10[9]),  .Adi1(mad10[10]), .Adi0(mad10[9]),  .Out1(ma11[10]), .Out0(ma11[9]),  .Ado1(mad11[10]), .Ado0(mad11[9]));  //(10,9)
comp2_VQ18 comp2_N103(.In1(ma10[8]),  .In0(ma10[7]),  .Adi1(mad10[8]),  .Adi0(mad10[7]),  .Out1(ma11[8]),  .Out0(ma11[7]),  .Ado1(mad11[8]),  .Ado0(mad11[7]));  //(8,7)
comp2_VQ18 comp2_N104(.In1(ma10[6]),  .In0(ma10[5]),  .Adi1(mad10[6]),  .Adi0(mad10[5]),  .Out1(ma11[6]),  .Out0(ma11[5]),  .Ado1(mad11[6]),  .Ado0(mad11[5]));  //(6,5)
comp2_VQ18 comp2_N105(.In1(ma10[4]),  .In0(ma10[3]),  .Adi1(mad10[4]),  .Adi0(mad10[3]),  .Out1(ma11[4]),  .Out0(ma11[3]),  .Ado1(mad11[4]),  .Ado0(mad11[3]));  //(4,3)
assign ma11[17]=ma10[17];  assign mad11[17]=mad10[17]; //(17)
assign ma11[16]=ma10[16];  assign mad11[16]=mad10[16]; //(16)
assign ma11[15]=ma10[15];  assign mad11[15]=mad10[15]; //(15)
assign ma11[2]=ma10[2];    assign mad11[2]=mad10[2]; //(2)
assign ma11[1]=ma10[1];    assign mad11[1]=mad10[1]; //(1)
assign ma11[0]=ma10[0];    assign mad11[0]=mad10[0]; //(0)

// Depth=11
comp2_VQ18 comp2_N110(.In1(ma11[13]), .In0(ma11[12]), .Adi1(mad11[13]), .Adi0(mad11[12]), .Out1(ma12[13]), .Out0(ma12[12]), .Ado1(mad12[13]), .Ado0(mad12[12])); //(13,12)
comp2_VQ18 comp2_N111(.In1(ma11[11]), .In0(ma11[10]), .Adi1(mad11[11]), .Adi0(mad11[10]), .Out1(ma12[11]), .Out0(ma12[10]), .Ado1(mad12[11]), .Ado0(mad12[10])); //(11,10)
comp2_VQ18 comp2_N112(.In1(ma11[9]),  .In0(ma11[8]),  .Adi1(mad11[9]),  .Adi0(mad11[8]),  .Out1(ma12[9]),  .Out0(ma12[8]),  .Ado1(mad12[9]),  .Ado0(mad12[8])); //(9,8)
comp2_VQ18 comp2_N113(.In1(ma11[7]),  .In0(ma11[6]),  .Adi1(mad11[7]),  .Adi0(mad11[6]),  .Out1(ma12[7]),  .Out0(ma12[6]),  .Ado1(mad12[7]),  .Ado0(mad12[6])); //(7,6)
comp2_VQ18 comp2_N114(.In1(ma11[5]),  .In0(ma11[4]),  .Adi1(mad11[5]),  .Adi0(mad11[4]),  .Out1(ma12[5]),  .Out0(ma12[4]),  .Ado1(mad12[5]),  .Ado0(mad12[4])); //(5,4)
assign ma12[17]=ma11[17];  assign mad12[17]=mad11[17]; //(17)
assign ma12[16]=ma11[16];  assign mad12[16]=mad11[16]; //(16)
assign ma12[15]=ma11[15];  assign mad12[15]=mad11[15]; //(15)
assign ma12[14]=ma11[14];  assign mad12[14]=mad11[14]; //(14)
assign ma12[3]=ma11[3];    assign mad12[3]=mad11[3];   //(3)
assign ma12[2]=ma11[2];    assign mad12[2]=mad11[2];   //(2)
assign ma12[1]=ma11[1];    assign mad12[1]=mad11[1];   //(1)
assign ma12[0]=ma11[0];    assign mad12[0]=mad11[0];   //(0)

// Output
assign b17=mad12[17];
assign b16=mad12[16];
assign b15=mad12[15];
assign b14=mad12[14];
assign b13=mad12[13];
assign b12=mad12[12];
assign b11=mad12[11];
assign b10=mad12[10];
assign b9=mad12[9];
assign b8=mad12[8];
assign b7=mad12[7];
assign b6=mad12[6];
assign b5=mad12[5];
assign b4=mad12[4];
assign b3=mad12[3];
assign b2=mad12[2];
assign b1=mad12[1];
assign b0=mad12[0];

// Partial VQ operation
/*assign b17=mad10[17];
assign b16=mad10[16];
assign b15=mad10[15];
assign b14=mad10[14];
assign b13=mad10[13];
assign b12=mad10[12];
assign b11=mad10[11];
assign b10=mad10[10];
assign b9=mad10[9];
assign b8=mad10[8];
assign b7=mad10[7];
assign b6=mad10[6];
assign b5=mad10[5];
assign b4=mad10[4];
assign b3=mad10[3];
assign b2=mad10[2];
assign b1=mad10[1];
assign b0=mad10[0];*/

endmodule
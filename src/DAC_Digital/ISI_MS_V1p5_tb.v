// ###############################
//#   Testbench for ISI_MS_V1p5   #
//# 0.ISI and MS Loop Combination #
//# 1.1st-order for ISI Loop      #
//# 2.2nd-order for MS Loop       #
//# 3.With ISI Bypass Function    #
//# 4.With MIS Bypass Function    #
//# 5.18-inputs ISI_MS operation  #
//# 6.6-inputs ISI_MS operation   #
//# 7.With Segmentation operation #
//#         Version 1.5           #
//#      Update: 2023/7/05        #
// ###############################


module ISI_MS_V1p5_tb;

parameter clock_period=2;
integer ISI_MS_DataOut_SVB;
integer ISI_MS_DataOut_SVC;
integer TBS17;
integer TBS16;
integer i=0;

reg clock;
reg rstn; //低电平有效
reg ISI_SEL, MIS_SEL;
reg signed [5:0] DataS_VB [81920:0]; //Input selected part B number
reg signed [3:0] DataS_VC [81920:0]; //Input selected part C number
reg signed [5:0] VB;
reg signed [3:0] VC;

wire [17:0] SVB;
wire [5:0]  SVC;
wire [17:0] STB;
wire [5:0]  STC;
wire signed [7:0] TBS [17:0];
wire signed [7:0] TCS [5:0];

ISI_MS_V1p5 ISI_MS_V1p5(.clk(clock), .rstn(rstn), .VB(VB), .VC(VC), .ISI_SEL(ISI_SEL), .MIS_SEL(MIS_SEL),
						.SVBout(SVB), .STBout(STB), .SVCout(SVC), .STCout(STC),
						.TBS17(TBS[17]), .TBS16(TBS[16]), .TBS15(TBS[15]), .TBS14(TBS[14]),
						.TBS13(TBS[13]), .TBS12(TBS[12]), .TBS11(TBS[11]), .TBS10(TBS[10]), .TBS9(TBS[9]),
						.TBS8(TBS[8]), .TBS7(TBS[7]), .TBS6(TBS[6]), .TBS5(TBS[5]), .TBS4(TBS[4]),
						.TBS3(TBS[3]), .TBS2(TBS[2]), .TBS1(TBS[1]), .TBS0(TBS[0]),
						.TCS5(TCS[5]), .TCS4(TCS[4]), .TCS3(TCS[3]), .TCS2(TCS[2]), .TCS1(TCS[1]), .TCS0(TCS[0]));
		          					
initial
	begin
		clock=0;
		$readmemb("C:/Work/1.Audio_DAC/5.Model/verilog_code/Data/ISI_MS_DataS_VB.txt",DataS_VB);
		$readmemb("C:/Work/1.Audio_DAC/5.Model/verilog_code/Data/ISI_MS_DataS_VC.txt",DataS_VC);
		ISI_MS_DataOut_SVB=$fopen("C:/Work/1.Audio_DAC/5.Model/verilog_code/Data/ISI_MS_DataOut_SVB.txt");
		ISI_MS_DataOut_SVC=$fopen("C:/Work/1.Audio_DAC/5.Model/verilog_code/Data/ISI_MS_DataOut_SVC.txt");
		TBS17=$fopen("C:/Work/1.Audio_DAC/5.Model/verilog_code/Data/TBS17.txt");
		TBS16=$fopen("C:/Work/1.Audio_DAC/5.Model/verilog_code/Data/TBS16.txt");
	end

always
	# (clock_period/2) clock=~clock;

initial
	begin
		rstn=0;
		@(negedge clock);
			rstn=0;
			ISI_SEL=1;
			MIS_SEL=1;
		# 4;
		@(negedge clock);
			rstn=1;
			ISI_SEL=0;
			MIS_SEL=0;
	end

always @(posedge clock)
	if(rstn==1)
		begin
			i=i+1;	
			VB=DataS_VB[i-1];
			VC=DataS_VC[i-1];
			$fdisplay(ISI_MS_DataOut_SVB, "%b", SVB);
			$fdisplay(ISI_MS_DataOut_SVC, "%b", SVC);
			$fdisplay(TBS17, "%d", TBS[17]);
			$fdisplay(TBS16, "%d", TBS[16]);
		end
	else begin
			VB=0;			
			VC=0;
		end

endmodule
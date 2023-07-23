module regmap (
    iic_regmap_wclk,
    rst_n,
    iic_regmap_wren,
    iic_regmap_wdata,
    iic_regmap_address,
    regmap_iic_bytes_num,
    regmap_iic_rdata,

	//regmap <> iis port
    regmap_iis_port_sel,
    regmap_iis_bitsnum,
    regmap_iis_offset,

	//regmap bypass en
	regmap_dsp_bypass_en,
	regmap_dac_mis_en,
	regmap_dac_isi_en,

	//regmap <> main channels
    regmap_mainch_alp_en,
    regmap_mainch_pre_scale,
    regmap_mainch_post_scale,
    regmap_mainch_drc1_coef,
    regmap_mainch_drc1_en,
    regmap_ch1_din_sel,
    regmap_ch1_bq0_coef,
    regmap_ch1_input_mixer,
    regmap_ch1_bq1_coef,
    regmap_ch1_bq2_coef,
    regmap_ch1_bq3_coef,
    regmap_ch1_bq4_coef,
    regmap_ch1_bq5_coef,
    regmap_ch1_bq6_coef,
    regmap_ch1_bq7_coef,
    regmap_ch1_bq8_coef,
    regmap_ch1_vol_coef,
    regmap_ch1_out_mixer,
    regmap_ch2_din_sel,
    regmap_ch2_bq0_coef,
    regmap_ch2_input_mixer,
    regmap_ch2_bq1_coef,
    regmap_ch2_bq2_coef,
    regmap_ch2_bq3_coef,
    regmap_ch2_bq4_coef,
    regmap_ch2_bq5_coef,
    regmap_ch2_bq6_coef,
    regmap_ch2_bq7_coef,
    regmap_ch2_bq8_coef,
    regmap_ch2_vol_coef,
    regmap_ch2_out_mixer,

	//regmap <> sub channels
    regmap_subch_vol_coef,
    regmap_subch_vol_sel,
    regmap_subch_drc2_coef,
    regmap_subch_drc2_en,
    regmap_ch3_input_mixer,
    regmap_ch3_bq_coef,
    regmap_ch4_input_mixer,
    regmap_ch4_input_sel,
    regmap_ch4_bq0_coef,
    regmap_ch4_bq1_coef

);

input              iic_regmap_wclk;
input              rst_n;
input              iic_regmap_wren;
input  [7:0]       iic_regmap_address;
input  [159:0]     iic_regmap_wdata;
output [4:0]       regmap_iic_bytes_num;
output [159:0]     regmap_iic_rdata;
output [1:0]       regmap_iis_port_sel;
output [1:0]       regmap_iis_bitsnum;
output             regmap_iis_offset;
output             regmap_mainch_alp_en;
output [31:0]      regmap_mainch_pre_scale;
output [31:0]      regmap_mainch_post_scale;
output [32*9-1:0]  regmap_mainch_drc1_coef;
output             regmap_mainch_drc1_en;
output [2:0]       regmap_ch1_din_sel;
output [32*5-1:0]  regmap_ch1_bq0_coef;
output [32*4-1:0]  regmap_ch1_input_mixer;
output [32*5-1:0]  regmap_ch1_bq1_coef;
output [32*5-1:0]  regmap_ch1_bq2_coef;
output [32*5-1:0]  regmap_ch1_bq3_coef;
output [32*5-1:0]  regmap_ch1_bq4_coef;
output [32*5-1:0]  regmap_ch1_bq5_coef;
output [32*5-1:0]  regmap_ch1_bq6_coef;
output [32*5-1:0]  regmap_ch1_bq7_coef;
output [32*5-1:0]  regmap_ch1_bq8_coef;
output [31:0]      regmap_ch1_vol_coef;
output [32*3-1:0]  regmap_ch1_out_mixer;
output [2:0]       regmap_ch2_din_sel;
output [32*5-1:0]  regmap_ch2_bq0_coef;
output [32*4-1:0]  regmap_ch2_input_mixer;
output [32*5-1:0]  regmap_ch2_bq1_coef;
output [32*5-1:0]  regmap_ch2_bq2_coef;
output [32*5-1:0]  regmap_ch2_bq3_coef;
output [32*5-1:0]  regmap_ch2_bq4_coef;
output [32*5-1:0]  regmap_ch2_bq5_coef;
output [32*5-1:0]  regmap_ch2_bq6_coef;
output [32*5-1:0]  regmap_ch2_bq7_coef;
output [32*5-1:0]  regmap_ch2_bq8_coef;
output [31:0]      regmap_ch2_vol_coef;
output [32*3-1:0]  regmap_ch2_out_mixer;
output             regmap_dsp_bypass_en;
output             regmap_dac_mis_en;
output             regmap_dac_isi_en;

output [31:0]      regmap_subch_vol_coef;
output [1:0]       regmap_subch_vol_sel;
output [32*9-1:0]  regmap_subch_drc2_coef;
output             regmap_subch_drc2_en;
output [32*3-1:0]  regmap_ch3_input_mixer;
output [32*5-1:0]  regmap_ch3_bq_coef;
output [32*2-1:0]  regmap_ch4_input_mixer;
output             regmap_ch4_input_sel;
output [32*5-1:0]  regmap_ch4_bq0_coef;
output [32*5-1:0]  regmap_ch4_bq1_coef;

reg    [4:0]       regmap_iic_bytes_num;
reg    [159:0]     regmap_iic_rdata;
wire   [159:0]     iic_regmap_wdata_aft_mask;
wire               clk_ctrl_wen;
wire               dev_id_wen;
wire               err_sta_wen;
wire               sys_ctrl1_wen;
wire               iis_config_wen;
wire               sys_ctrl2_wen;
wire               sft_mute_wen;
wire               mst_vol_wen;
wire               ch1_vol_wen;
wire               ch2_vol_wen;
wire               ch3_vol_wen;
wire               vol_config_wen;
wire               dac_config_wen;
wire               ch_shtdown_wen;
wire               st_period_wen;
wire               clk_sel_wen;
wire               input_mux_wen;
wire               ch4_sr_sel_wen;
wire               drc_ctrl_wen;
wire               irq_mask_wen;
wire               pll_ctrl_wen;
wire               sys_ctrl3_wen;
wire               ng_ctrl0_wen;
wire               ng_ctrl1_wen;
wire               ng_ctrl2_wen;
wire               ng_ctrl3_wen;
wire               ch1_bq0_wen;
wire               ch1_bq1_wen;
wire               ch1_bq2_wen;
wire               ch1_bq3_wen;
wire               ch1_bq4_wen;
wire               ch1_bq5_wen;
wire               ch1_bq6_wen;
wire               ch2_bq0_wen;
wire               ch2_bq1_wen;
wire               ch2_bq2_wen;
wire               ch2_bq3_wen;
wire               ch2_bq4_wen;
wire               ch2_bq5_wen;
wire               ch2_bq6_wen;
wire               drc1_eng_wen;
wire               drc1_atk_wen;
wire               drc1_rel_wen;
wire               drc2_eng_wen;
wire               drc2_atk_wen;
wire               drc2_rel_wen;
wire               drc1_th_wen;
wire               drc1_k_wen;
wire               drc1_ofset_wen;
wire               drc2_th_wen;
wire               drc2_k_wen;
wire               drc2_ofset_wen;
wire               ch1_o_mix_wen;
wire               ch2_o_mix_wen;
wire               ch1_i_mix_wen;
wire               ch2_i_mix_wen;
wire               ch3_i_mix_wen;
wire               post_scale_wen;
wire               pre_scale_wen;
wire               ch1_bq7_wen;
wire               ch1_bq8_wen;
wire               subch_bq0_wen;
wire               subch_bq1_wen;
wire               ch2_bq7_wen;
wire               ch2_bq8_wen;
wire               pse_ch2_bq_wen;
wire               ch4_i_mix_wen;
wire   [1:0]       regmap_iis_port_sel;
wire   [1:0]       regmap_iis_bitsnum;
wire               regmap_iis_offset;
wire   [31:0]      regmap_mainch_pre_scale;
wire   [31:0]      regmap_mainch_post_scale;
wire   [32*9-1:0]  regmap_mainch_drc1_coef;
wire   [32*9-1:0]  drc1_coef_pack;
wire               regmap_mainch_drc1_en;
wire   [2:0]       regmap_ch1_din_sel;
wire   [32*5-1:0]  regmap_ch1_bq0_coef;
wire   [32*4-1:0]  regmap_ch1_input_mixer;
wire   [32*5-1:0]  regmap_ch1_bq1_coef;
wire   [32*5-1:0]  regmap_ch1_bq2_coef;
wire   [32*5-1:0]  regmap_ch1_bq3_coef;
wire   [32*5-1:0]  regmap_ch1_bq4_coef;
wire   [32*5-1:0]  regmap_ch1_bq5_coef;
wire   [32*5-1:0]  regmap_ch1_bq6_coef;
wire   [32*5-1:0]  regmap_ch1_bq7_coef;
wire   [32*5-1:0]  regmap_ch1_bq8_coef;
wire   [31:0]      regmap_ch1_vol_coef;
wire   [32*3-1:0]  regmap_ch1_out_mixer;
wire   [2:0]       regmap_ch2_din_sel;
wire   [32*5-1:0]  regmap_ch2_bq0_coef;
wire   [32*4-1:0]  regmap_ch2_input_mixer;
wire   [32*5-1:0]  regmap_ch2_bq1_coef;
wire   [32*5-1:0]  regmap_ch2_bq2_coef;
wire   [32*5-1:0]  regmap_ch2_bq3_coef;
wire   [32*5-1:0]  regmap_ch2_bq4_coef;
wire   [32*5-1:0]  regmap_ch2_bq5_coef;
wire   [32*5-1:0]  regmap_ch2_bq6_coef;
wire   [32*5-1:0]  regmap_ch2_bq7_coef;
wire   [32*5-1:0]  regmap_ch2_bq8_coef;
wire   [31:0]      regmap_ch2_vol_coef;
wire   [32*3-1:0]  regmap_ch2_out_mixer;
wire   [31:0]      regmap_subch_vol_coef;
wire   [1:0]       regmap_subch_vol_sel;
wire   [32*9-1:0]  regmap_subch_drc2_coef;
wire   [32*9-1:0]  drc2_coef_pack;
wire               regmap_subch_drc2_en;
wire   [32*3-1:0]  regmap_ch3_input_mixer;
wire   [32*5-1:0]  regmap_ch3_bq_coef;
wire   [32*2-1:0]  regmap_ch4_input_mixer;
wire               regmap_ch4_input_sel;
wire   [32*5-1:0]  regmap_ch4_bq0_coef;
wire   [32*5-1:0]  regmap_ch4_bq1_coef;
wire               regmap_dsp_bypass_en;
wire               regmap_dac_mis_en;
wire               regmap_dac_isi_en;
reg    [7:0]       clk_ctrl;
reg    [7:0]       dev_id;
reg    [7:0]       err_sta;
reg    [7:0]       sys_ctrl1;
reg    [7:0]       iis_config;
reg    [7:0]       sys_ctrl2;
reg    [7:0]       sft_mute;
reg    [7:0]       mst_vol;
reg    [7:0]       ch1_vol;
reg    [7:0]       ch2_vol;
reg    [7:0]       ch3_vol;
reg    [7:0]       vol_config;
reg    [7:0]       dac_config;
reg    [7:0]       ch_shtdown;
reg    [7:0]       st_period;
reg    [7:0]       clk_sel;
reg    [31:0]      input_mux;
reg    [31:0]      ch4_sr_sel;
reg    [31:0]      drc_ctrl;
reg    [7:0]       irq_mask;
reg    [7:0]       pll_ctrl;
reg    [7:0]       sys_ctrl3;
reg    [7:0]       ng_ctrl0;
reg    [7:0]       ng_ctrl1;
reg    [7:0]       ng_ctrl2;
reg    [7:0]       ng_ctrl3;
reg    [159:0]     ch1_bq0;
reg    [159:0]     ch1_bq1;
reg    [159:0]     ch1_bq2;
reg    [159:0]     ch1_bq3;
reg    [159:0]     ch1_bq4;
reg    [159:0]     ch1_bq5;
reg    [159:0]     ch1_bq6;
reg    [159:0]     ch2_bq0;
reg    [159:0]     ch2_bq1;
reg    [159:0]     ch2_bq2;
reg    [159:0]     ch2_bq3;
reg    [159:0]     ch2_bq4;
reg    [159:0]     ch2_bq5;
reg    [159:0]     ch2_bq6;
reg    [63:0]      drc1_eng;
reg    [63:0]      drc1_atk;
reg    [63:0]      drc1_rel;
reg    [63:0]      drc2_eng;
reg    [63:0]      drc2_atk;
reg    [63:0]      drc2_rel;
reg    [31:0]      drc1_th;
reg    [31:0]      drc1_k;
reg    [31:0]      drc1_ofset;
reg    [31:0]      drc2_th;
reg    [31:0]      drc2_k;
reg    [31:0]      drc2_ofset;
reg    [95:0]      ch1_o_mix;
reg    [95:0]      ch2_o_mix;
reg    [127:0]     ch1_i_mix;
reg    [127:0]     ch2_i_mix;
reg    [95:0]      ch3_i_mix;
reg    [31:0]      post_scale;
reg    [31:0]      pre_scale;
reg    [159:0]     ch1_bq7;
reg    [159:0]     ch1_bq8;
reg    [159:0]     subch_bq0;
reg    [159:0]     subch_bq1;
reg    [159:0]     ch2_bq7;
reg    [159:0]     ch2_bq8;
reg    [159:0]     pse_ch2_bq;
reg    [63:0]      ch4_i_mix;
wire   [7:0]       ch1_vol_trans_in;
wire   [7:0]       ch2_vol_trans_in;
wire   [7:0]       ch3_vol_trans_in;
wire   [7:0]       mst_vol_trans_in;
wire   [31:0]      ch1_vol_aft_trans;
wire   [31:0]      ch2_vol_aft_trans;
wire   [31:0]      ch3_vol_aft_trans;
wire   [31:0]      mst_vol_aft_trans;
reg    [4:0]       reserve_bytes_num;
reg    [31:0]      ch1_vol_aft_trans_reg;
reg    [31:0]      ch2_vol_aft_trans_reg;
reg    [31:0]      ch3_vol_aft_trans_reg;
reg    [31:0]      mst_vol_aft_trans_reg;

parameter CLK_CTRL   = 8'h00;
parameter DEV_ID     = 8'h01;
parameter ERR_STA    = 8'h02;
parameter SYS_CTRL1  = 8'h03;
parameter IIS_CONFIG = 8'h04;
parameter SYS_CTRL2  = 8'h05;
parameter SFT_MUTE   = 8'h06;
parameter MST_VOL    = 8'h07;
parameter CH1_VOL    = 8'h08;
parameter CH2_VOL    = 8'h09;
parameter CH3_VOL    = 8'h0A;
parameter VOL_CONFIG = 8'h0E;
parameter DAC_CONFIG = 8'h0F;
parameter CH_SHTDOWN = 8'h19;
parameter ST_PERIOD  = 8'h1A;
parameter CLK_SEL    = 8'h1B;
parameter INPUT_MUX  = 8'h20;
parameter CH4_SR_SEL = 8'h21;
parameter DRC_CTRL   = 8'h46;
parameter IRQ_MASK   = 8'hC4;
parameter PLL_CTRL   = 8'hC5;
parameter SYS_CTRL3  = 8'hC8;
parameter NG_CTRL0   = 8'hD0;
parameter NG_CTRL1   = 8'hD1;
parameter NG_CTRL2   = 8'hD2;
parameter NG_CTRL3   = 8'hD3;
parameter CH1_BQ0    = 8'h29;
parameter CH1_BQ1    = 8'h2A;
parameter CH1_BQ2    = 8'h2B;
parameter CH1_BQ3    = 8'h2C;
parameter CH1_BQ4    = 8'h2D;
parameter CH1_BQ5    = 8'h2E;
parameter CH1_BQ6    = 8'h2F;
parameter CH2_BQ0    = 8'h30;
parameter CH2_BQ1    = 8'h31;
parameter CH2_BQ2    = 8'h32;
parameter CH2_BQ3    = 8'h33;
parameter CH2_BQ4    = 8'h34;
parameter CH2_BQ5    = 8'h35;
parameter CH2_BQ6    = 8'h36;
parameter DRC1_ENG   = 8'h3A;
parameter DRC1_ATK   = 8'h3B;
parameter DRC1_REL   = 8'h3C;
parameter DRC2_ENG   = 8'h3D;
parameter DRC2_ATK   = 8'h3E;
parameter DRC2_REL   = 8'h3F;
parameter DRC1_TH    = 8'h40;
parameter DRC1_K     = 8'h41;
parameter DRC1_OFSET = 8'h42;
parameter DRC2_TH    = 8'h43;
parameter DRC2_K     = 8'h44;
parameter DRC2_OFSET = 8'h45;
parameter CH1_O_MIX  = 8'h51;
parameter CH2_O_MIX  = 8'h52;
parameter CH1_I_MIX  = 8'h53;
parameter CH2_I_MIX  = 8'h54;
parameter CH3_I_MIX  = 8'h55;
parameter POST_SCALE = 8'h56;
parameter PRE_SCALE  = 8'h57;
parameter CH1_BQ7    = 8'h58;
parameter CH1_BQ8    = 8'h59;
parameter SUBCH_BQ0  = 8'h5A;
parameter SUBCH_BQ1  = 8'h5B;
parameter CH2_BQ7    = 8'h5C;
parameter CH2_BQ8    = 8'h5D;
parameter PSE_CH2_BQ = 8'h5E;
parameter CH4_I_MIX  = 8'h61;

parameter REG_MASK = 32'h03FFFFFF;

//-----------------------------------------------
//                    main logic
//-----------------------------------------------

//----------------mask data for 3-23 data format
assign iic_regmap_wdata_aft_mask = iic_regmap_wdata & {5{REG_MASK}};

always @(*) begin
	case(iic_regmap_address)
		8'h0x  : begin
			reserve_bytes_num = 5'd1;
		end
		8'h1x  : begin
			reserve_bytes_num = 5'd1;
		end
		default: begin
			reserve_bytes_num = 5'd4;
		end
	endcase
end

//this is generated by python script

always @ (*) begin
	case(iic_regmap_address)
		CLK_CTRL   : begin
			regmap_iic_rdata = {clk_ctrl[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		DEV_ID     : begin
			regmap_iic_rdata = {dev_id[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		ERR_STA    : begin
			regmap_iic_rdata = {err_sta[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		SYS_CTRL1  : begin
			regmap_iic_rdata = {sys_ctrl1[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		IIS_CONFIG : begin
			regmap_iic_rdata = {iis_config[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		SYS_CTRL2  : begin
			regmap_iic_rdata = {sys_ctrl2[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		SFT_MUTE   : begin
			regmap_iic_rdata = {sft_mute[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		MST_VOL    : begin
			regmap_iic_rdata = {mst_vol[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		CH1_VOL    : begin
			regmap_iic_rdata = {ch1_vol[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		CH2_VOL    : begin
			regmap_iic_rdata = {ch2_vol[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		CH3_VOL    : begin
			regmap_iic_rdata = {ch3_vol[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		VOL_CONFIG : begin
			regmap_iic_rdata = {vol_config[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		DAC_CONFIG : begin
			regmap_iic_rdata = {dac_config[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		CH_SHTDOWN : begin
			regmap_iic_rdata = {ch_shtdown[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		ST_PERIOD  : begin
			regmap_iic_rdata = {st_period[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		CLK_SEL    : begin
			regmap_iic_rdata = {clk_sel[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		INPUT_MUX  : begin
			regmap_iic_rdata = {input_mux[31:0], 128'b0};
			regmap_iic_bytes_num = 5'd4;
		end
		CH4_SR_SEL : begin
			regmap_iic_rdata = {ch4_sr_sel[31:0], 128'b0};
			regmap_iic_bytes_num = 5'd4;
		end
		DRC_CTRL   : begin
			regmap_iic_rdata = {drc_ctrl[31:0], 128'b0};
			regmap_iic_bytes_num = 5'd4;
		end
		IRQ_MASK   : begin
			regmap_iic_rdata = {irq_mask[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		PLL_CTRL   : begin
			regmap_iic_rdata = {pll_ctrl[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		SYS_CTRL3  : begin
			regmap_iic_rdata = {sys_ctrl3[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		NG_CTRL0   : begin
			regmap_iic_rdata = {ng_ctrl0[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		NG_CTRL1   : begin
			regmap_iic_rdata = {ng_ctrl1[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		NG_CTRL2   : begin
			regmap_iic_rdata = {ng_ctrl2[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		NG_CTRL3   : begin
			regmap_iic_rdata = {ng_ctrl3[7:0], 152'b0};
			regmap_iic_bytes_num = 5'd1;
		end
		CH1_BQ0    : begin
			regmap_iic_rdata = ch1_bq0[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH1_BQ1    : begin
			regmap_iic_rdata = ch1_bq1[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH1_BQ2    : begin
			regmap_iic_rdata = ch1_bq2[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH1_BQ3    : begin
			regmap_iic_rdata = ch1_bq3[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH1_BQ4    : begin
			regmap_iic_rdata = ch1_bq4[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH1_BQ5    : begin
			regmap_iic_rdata = ch1_bq5[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH1_BQ6    : begin
			regmap_iic_rdata = ch1_bq6[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH2_BQ0    : begin
			regmap_iic_rdata = ch2_bq0[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH2_BQ1    : begin
			regmap_iic_rdata = ch2_bq1[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH2_BQ2    : begin
			regmap_iic_rdata = ch2_bq2[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH2_BQ3    : begin
			regmap_iic_rdata = ch2_bq3[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH2_BQ4    : begin
			regmap_iic_rdata = ch2_bq4[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH2_BQ5    : begin
			regmap_iic_rdata = ch2_bq5[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH2_BQ6    : begin
			regmap_iic_rdata = ch2_bq6[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		DRC1_ENG   : begin
			regmap_iic_rdata = {drc1_eng[63:0], 96'b0};
			regmap_iic_bytes_num = 5'd8;
		end
		DRC1_ATK   : begin
			regmap_iic_rdata = {drc1_atk[63:0], 96'b0};
			regmap_iic_bytes_num = 5'd8;
		end
		DRC1_REL   : begin
			regmap_iic_rdata = {drc1_rel[63:0], 96'b0};
			regmap_iic_bytes_num = 5'd8;
		end
		DRC2_ENG   : begin
			regmap_iic_rdata = {drc2_eng[63:0], 96'b0};
			regmap_iic_bytes_num = 5'd8;
		end
		DRC2_ATK   : begin
			regmap_iic_rdata = {drc2_atk[63:0], 96'b0};
			regmap_iic_bytes_num = 5'd8;
		end
		DRC2_REL   : begin
			regmap_iic_rdata = {drc2_rel[63:0], 96'b0};
			regmap_iic_bytes_num = 5'd8;
		end
		DRC1_TH    : begin
			regmap_iic_rdata = {drc1_th[31:0], 128'b0};
			regmap_iic_bytes_num = 5'd4;
		end
		DRC1_K     : begin
			regmap_iic_rdata = {drc1_k[31:0], 128'b0};
			regmap_iic_bytes_num = 5'd4;
		end
		DRC1_OFSET : begin
			regmap_iic_rdata = {drc1_ofset[31:0], 128'b0};
			regmap_iic_bytes_num = 5'd4;
		end
		DRC2_TH    : begin
			regmap_iic_rdata = {drc2_th[31:0], 128'b0};
			regmap_iic_bytes_num = 5'd4;
		end
		DRC2_K     : begin
			regmap_iic_rdata = {drc2_k[31:0], 128'b0};
			regmap_iic_bytes_num = 5'd4;
		end
		DRC2_OFSET : begin
			regmap_iic_rdata = {drc2_ofset[31:0], 128'b0};
			regmap_iic_bytes_num = 5'd4;
		end
		CH1_O_MIX  : begin
			regmap_iic_rdata = {ch1_o_mix[95:0], 64'b0};
			regmap_iic_bytes_num = 5'd12;
		end
		CH2_O_MIX  : begin
			regmap_iic_rdata = {ch2_o_mix[95:0], 64'b0};
			regmap_iic_bytes_num = 5'd12;
		end
		CH1_I_MIX  : begin
			regmap_iic_rdata = {ch1_i_mix[127:0], 32'b0};
			regmap_iic_bytes_num = 5'd16;
		end
		CH2_I_MIX  : begin
			regmap_iic_rdata = {ch2_i_mix[127:0], 32'b0};
			regmap_iic_bytes_num = 5'd16;
		end
		CH3_I_MIX  : begin
			regmap_iic_rdata = {ch3_i_mix[95:0], 64'b0};
			regmap_iic_bytes_num = 5'd12;
		end
		POST_SCALE : begin
			regmap_iic_rdata = {post_scale[31:0], 128'b0};
			regmap_iic_bytes_num = 5'd4;
		end
		PRE_SCALE  : begin
			regmap_iic_rdata = {pre_scale[31:0], 128'b0};
			regmap_iic_bytes_num = 5'd4;
		end
		CH1_BQ7    : begin
			regmap_iic_rdata = ch1_bq7[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH1_BQ8    : begin
			regmap_iic_rdata = ch1_bq8[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		SUBCH_BQ0  : begin
			regmap_iic_rdata = subch_bq0[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		SUBCH_BQ1  : begin
			regmap_iic_rdata = subch_bq1[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH2_BQ7    : begin
			regmap_iic_rdata = ch2_bq7[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH2_BQ8    : begin
			regmap_iic_rdata = ch2_bq8[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		PSE_CH2_BQ : begin
			regmap_iic_rdata = pse_ch2_bq[159:0];
			regmap_iic_bytes_num = 5'd20;
		end
		CH4_I_MIX  : begin
			regmap_iic_rdata = {ch4_i_mix[63:0], 96'b0};
			regmap_iic_bytes_num = 5'd8;
		end
		default: begin
			regmap_iic_rdata = 160'b0;
			regmap_iic_bytes_num = reserve_bytes_num;
		end
	endcase
end

//reg clk_ctrl read and write logic (read only)
assign clk_ctrl_wen = iic_regmap_wren && (iic_regmap_address == CLK_CTRL) && 1'b0;
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		clk_ctrl <= 8'h6C;
	else if (clk_ctrl_wen)
		clk_ctrl <= iic_regmap_wdata[159:152];
	else
		clk_ctrl <= clk_ctrl;
end

//reg dev_id read and write logic (read only)
assign dev_id_wen = iic_regmap_wren && (iic_regmap_address == DEV_ID) && 1'b0;
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		dev_id <= 8'hA1;
	else if (dev_id_wen)
		dev_id <= iic_regmap_wdata[159:152];
	else
		dev_id <= dev_id;
end

//reg err_sta read and write logic (read only)
assign err_sta_wen = iic_regmap_wren && (iic_regmap_address == ERR_STA) && 1'b0;
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		err_sta <= 8'h00;
	else if (err_sta_wen)
		err_sta <= iic_regmap_wdata[159:152];
	else
		err_sta <= err_sta;
end

//reg sys_ctrl1 read and write logic
assign sys_ctrl1_wen = iic_regmap_wren && (iic_regmap_address == SYS_CTRL1);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		sys_ctrl1 <= 8'hA4;
	else if (sys_ctrl1_wen)
		sys_ctrl1 <= iic_regmap_wdata[159:152];
	else
		sys_ctrl1 <= sys_ctrl1;
end

//reg iis_config read and write logic
assign iis_config_wen = iic_regmap_wren && (iic_regmap_address == IIS_CONFIG);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		iis_config <= 8'h05;
	else if (iis_config_wen)
		iis_config <= iic_regmap_wdata[159:152];
	else
		iis_config <= iis_config;
end

//reg sys_ctrl2 read and write logic
assign sys_ctrl2_wen = iic_regmap_wren && (iic_regmap_address == SYS_CTRL2);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		sys_ctrl2 <= 8'h40;
	else if (sys_ctrl2_wen)
		sys_ctrl2 <= iic_regmap_wdata[159:152];
	else
		sys_ctrl2 <= sys_ctrl2;
end

//reg sft_mute read and write logic
assign sft_mute_wen = iic_regmap_wren && (iic_regmap_address == SFT_MUTE);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		sft_mute <= 8'h00;
	else if (sft_mute_wen)
		sft_mute <= iic_regmap_wdata[159:152];
	else
		sft_mute <= sft_mute;
end

//reg mst_vol read and write logic
assign mst_vol_wen = iic_regmap_wren && (iic_regmap_address == MST_VOL);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		mst_vol <= 8'hFF;
	else if (mst_vol_wen)
		mst_vol <= iic_regmap_wdata[159:152];
	else
		mst_vol <= mst_vol;
end

//reg ch1_vol read and write logic
assign ch1_vol_wen = iic_regmap_wren && (iic_regmap_address == CH1_VOL);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch1_vol <= 8'h30;
	else if (ch1_vol_wen)
		ch1_vol <= iic_regmap_wdata[159:152];
	else
		ch1_vol <= ch1_vol;
end

//reg ch2_vol read and write logic
assign ch2_vol_wen = iic_regmap_wren && (iic_regmap_address == CH2_VOL);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch2_vol <= 8'h30;
	else if (ch2_vol_wen)
		ch2_vol <= iic_regmap_wdata[159:152];
	else
		ch2_vol <= ch2_vol;
end

//reg ch3_vol read and write logic
assign ch3_vol_wen = iic_regmap_wren && (iic_regmap_address == CH3_VOL);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch3_vol <= 8'h30;
	else if (ch3_vol_wen)
		ch3_vol <= iic_regmap_wdata[159:152];
	else
		ch3_vol <= ch3_vol;
end

//reg vol_config read and write logic
assign vol_config_wen = iic_regmap_wren && (iic_regmap_address == VOL_CONFIG);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		vol_config <= 8'h91;
	else if (vol_config_wen)
		vol_config <= iic_regmap_wdata[159:152];
	else
		vol_config <= vol_config;
end

//reg dac_config read and write logic
assign dac_config_wen = iic_regmap_wren && (iic_regmap_address == DAC_CONFIG);
always @(posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		dac_config <= 8'h00;
	else if (dac_config_wen)
		dac_config <= iic_regmap_wdata[159:152];
	else
		dac_config <= dac_config;
end

//reg ch_shtdown read and write logic
assign ch_shtdown_wen = iic_regmap_wren && (iic_regmap_address == CH_SHTDOWN);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch_shtdown <= 8'h30;
	else if (ch_shtdown_wen)
		ch_shtdown <= iic_regmap_wdata[159:152];
	else
		ch_shtdown <= ch_shtdown;
end

//reg st_period read and write logic
assign st_period_wen = iic_regmap_wren && (iic_regmap_address == ST_PERIOD);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		st_period <= 8'h0F;
	else if (st_period_wen)
		st_period <= iic_regmap_wdata[159:152];
	else
		st_period <= st_period;
end

//reg clk_sel read and write logic (read only)
assign clk_sel_wen = iic_regmap_wren && (iic_regmap_address == CLK_SEL) && 1'b0;
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		clk_sel <= 8'h00;
	else if (clk_sel_wen)
		clk_sel <= iic_regmap_wdata[159:152];
	else
		clk_sel <= clk_sel;
end

//reg input_mux read and write logic
assign input_mux_wen = iic_regmap_wren && (iic_regmap_address == INPUT_MUX);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		input_mux <= 32'h00017772;
	else if (input_mux_wen)
		input_mux <= iic_regmap_wdata[159:128];
	else
		input_mux <= input_mux;
end

//reg ch4_sr_sel read and write logic
assign ch4_sr_sel_wen = iic_regmap_wren && (iic_regmap_address == CH4_SR_SEL);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch4_sr_sel <= 32'h00004303;
	else if (ch4_sr_sel_wen)
		ch4_sr_sel <= iic_regmap_wdata[159:128];
	else
		ch4_sr_sel <= ch4_sr_sel;
end

//reg drc_ctrl read and write logic
assign drc_ctrl_wen = iic_regmap_wren && (iic_regmap_address == DRC_CTRL);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		drc_ctrl <= 32'h00000000;
	else if (drc_ctrl_wen)
		drc_ctrl <= iic_regmap_wdata[159:128];
	else
		drc_ctrl <= drc_ctrl;
end

//reg irq_mask read and write logic
assign irq_mask_wen = iic_regmap_wren && (iic_regmap_address == IRQ_MASK);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		irq_mask <= 8'h00;
	else if (irq_mask_wen)
		irq_mask <= iic_regmap_wdata[159:152];
	else
		irq_mask <= irq_mask;
end

//reg pll_ctrl read and write logic
assign pll_ctrl_wen = iic_regmap_wren && (iic_regmap_address == PLL_CTRL);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		pll_ctrl <= 8'h02;
	else if (pll_ctrl_wen)
		pll_ctrl <= iic_regmap_wdata[159:152];
	else
		pll_ctrl <= pll_ctrl;
end

//reg sys_ctrl3 read and write logic
assign sys_ctrl3_wen = iic_regmap_wren && (iic_regmap_address == SYS_CTRL3);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		sys_ctrl3 <= 8'h00;
	else if (sys_ctrl3_wen)
		sys_ctrl3 <= iic_regmap_wdata[159:152];
	else
		sys_ctrl3 <= sys_ctrl3;
end

//reg ng_ctrl0 read and write logic
assign ng_ctrl0_wen = iic_regmap_wren && (iic_regmap_address == NG_CTRL0);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ng_ctrl0 <= 8'h02;
	else if (ng_ctrl0_wen)
		ng_ctrl0 <= iic_regmap_wdata[159:152];
	else
		ng_ctrl0 <= ng_ctrl0;
end

//reg ng_ctrl1 read and write logic
assign ng_ctrl1_wen = iic_regmap_wren && (iic_regmap_address == NG_CTRL1);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ng_ctrl1 <= 8'h03;
	else if (ng_ctrl1_wen)
		ng_ctrl1 <= iic_regmap_wdata[159:152];
	else
		ng_ctrl1 <= ng_ctrl1;
end

//reg ng_ctrl2 read and write logic
assign ng_ctrl2_wen = iic_regmap_wren && (iic_regmap_address == NG_CTRL2);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ng_ctrl2 <= 8'h04;
	else if (ng_ctrl2_wen)
		ng_ctrl2 <= iic_regmap_wdata[159:152];
	else
		ng_ctrl2 <= ng_ctrl2;
end

//reg ng_ctrl3 read and write logic
assign ng_ctrl3_wen = iic_regmap_wren && (iic_regmap_address == NG_CTRL3);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ng_ctrl3 <= 8'h62;
	else if (ng_ctrl3_wen)
		ng_ctrl3 <= iic_regmap_wdata[159:152];
	else
		ng_ctrl3 <= ng_ctrl3;
end

//reg ch1_bq0 read and write logic
assign ch1_bq0_wen = iic_regmap_wren && (iic_regmap_address == CH1_BQ0);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch1_bq0 <= 160'h0080000000000000000000000000000000000000;
	else if (ch1_bq0_wen)
		ch1_bq0 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch1_bq0 <= ch1_bq0;
end

//reg ch1_bq1 read and write logic
assign ch1_bq1_wen = iic_regmap_wren && (iic_regmap_address == CH1_BQ1);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch1_bq1 <= 160'h0080000000000000000000000000000000000000;
	else if (ch1_bq1_wen)
		ch1_bq1 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch1_bq1 <= ch1_bq1;
end

//reg ch1_bq2 read and write logic
assign ch1_bq2_wen = iic_regmap_wren && (iic_regmap_address == CH1_BQ2);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch1_bq2 <= 160'h0080000000000000000000000000000000000000;
	else if (ch1_bq2_wen)
		ch1_bq2 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch1_bq2 <= ch1_bq2;
end

//reg ch1_bq3 read and write logic
assign ch1_bq3_wen = iic_regmap_wren && (iic_regmap_address == CH1_BQ3);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch1_bq3 <= 160'h0080000000000000000000000000000000000000;
	else if (ch1_bq3_wen)
		ch1_bq3 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch1_bq3 <= ch1_bq3;
end

//reg ch1_bq4 read and write logic
assign ch1_bq4_wen = iic_regmap_wren && (iic_regmap_address == CH1_BQ4);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch1_bq4 <= 160'h0080000000000000000000000000000000000000;
	else if (ch1_bq4_wen)
		ch1_bq4 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch1_bq4 <= ch1_bq4;
end

//reg ch1_bq5 read and write logic
assign ch1_bq5_wen = iic_regmap_wren && (iic_regmap_address == CH1_BQ5);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch1_bq5 <= 160'h0080000000000000000000000000000000000000;
	else if (ch1_bq5_wen)
		ch1_bq5 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch1_bq5 <= ch1_bq5;
end

//reg ch1_bq6 read and write logic
assign ch1_bq6_wen = iic_regmap_wren && (iic_regmap_address == CH1_BQ6);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch1_bq6 <= 160'h0080000000000000000000000000000000000000;
	else if (ch1_bq6_wen)
		ch1_bq6 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch1_bq6 <= ch1_bq6;
end

//reg ch2_bq0 read and write logic
assign ch2_bq0_wen = iic_regmap_wren && (iic_regmap_address == CH2_BQ0);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch2_bq0 <= 160'h0080000000000000000000000000000000000000;
	else if (ch2_bq0_wen)
		ch2_bq0 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch2_bq0 <= ch2_bq0;
end

//reg ch2_bq1 read and write logic
assign ch2_bq1_wen = iic_regmap_wren && (iic_regmap_address == CH2_BQ1);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch2_bq1 <= 160'h0080000000000000000000000000000000000000;
	else if (ch2_bq1_wen)
		ch2_bq1 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch2_bq1 <= ch2_bq1;
end

//reg ch2_bq2 read and write logic
assign ch2_bq2_wen = iic_regmap_wren && (iic_regmap_address == CH2_BQ2);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch2_bq2 <= 160'h0080000000000000000000000000000000000000;
	else if (ch2_bq2_wen)
		ch2_bq2 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch2_bq2 <= ch2_bq2;
end

//reg ch2_bq3 read and write logic
assign ch2_bq3_wen = iic_regmap_wren && (iic_regmap_address == CH2_BQ3);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch2_bq3 <= 160'h0080000000000000000000000000000000000000;
	else if (ch2_bq3_wen)
		ch2_bq3 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch2_bq3 <= ch2_bq3;
end

//reg ch2_bq4 read and write logic
assign ch2_bq4_wen = iic_regmap_wren && (iic_regmap_address == CH2_BQ4);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch2_bq4 <= 160'h0080000000000000000000000000000000000000;
	else if (ch2_bq4_wen)
		ch2_bq4 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch2_bq4 <= ch2_bq4;
end

//reg ch2_bq5 read and write logic
assign ch2_bq5_wen = iic_regmap_wren && (iic_regmap_address == CH2_BQ5);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch2_bq5 <= 160'h0080000000000000000000000000000000000000;
	else if (ch2_bq5_wen)
		ch2_bq5 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch2_bq5 <= ch2_bq5;
end

//reg ch2_bq6 read and write logic
assign ch2_bq6_wen = iic_regmap_wren && (iic_regmap_address == CH2_BQ6);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch2_bq6 <= 160'h0080000000000000000000000000000000000000;
	else if (ch2_bq6_wen)
		ch2_bq6 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch2_bq6 <= ch2_bq6;
end

//reg drc1_eng read and write logic
assign drc1_eng_wen = iic_regmap_wren && (iic_regmap_address == DRC1_ENG);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		drc1_eng <= 64'h0080000000000000;
	else if (drc1_eng_wen)
		drc1_eng <= iic_regmap_wdata_aft_mask[159:96];
	else
		drc1_eng <= drc1_eng;
end

//reg drc1_atk read and write logic
assign drc1_atk_wen = iic_regmap_wren && (iic_regmap_address == DRC1_ATK);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		drc1_atk <= 64'h0080000000000000;
	else if (drc1_atk_wen)
		drc1_atk <= iic_regmap_wdata_aft_mask[159:96];
	else
		drc1_atk <= drc1_atk;
end

//reg drc1_rel read and write logic
assign drc1_rel_wen = iic_regmap_wren && (iic_regmap_address == DRC1_REL);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		drc1_rel <= 64'h0080000000000000;
	else if (drc1_rel_wen)
		drc1_rel <= iic_regmap_wdata_aft_mask[159:96];
	else
		drc1_rel <= drc1_rel;
end

//reg drc2_eng read and write logic
assign drc2_eng_wen = iic_regmap_wren && (iic_regmap_address == DRC2_ENG);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		drc2_eng <= 64'h0080000000000000;
	else if (drc2_eng_wen)
		drc2_eng <= iic_regmap_wdata_aft_mask[159:96];
	else
		drc2_eng <= drc2_eng;
end

//reg drc2_atk read and write logic
assign drc2_atk_wen = iic_regmap_wren && (iic_regmap_address == DRC2_ATK);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		drc2_atk <= 64'h0080000000000000;
	else if (drc2_atk_wen)
		drc2_atk <= iic_regmap_wdata_aft_mask[159:96];
	else
		drc2_atk <= drc2_atk;
end

//reg drc2_rel read and write logic
assign drc2_rel_wen = iic_regmap_wren && (iic_regmap_address == DRC2_REL);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		drc2_rel <= 64'h0080000000000000;
	else if (drc2_rel_wen)
		drc2_rel <= iic_regmap_wdata_aft_mask[159:96];
	else
		drc2_rel <= drc2_rel;
end

//reg drc1_th read and write logic
assign drc1_th_wen = iic_regmap_wren && (iic_regmap_address == DRC1_TH);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		drc1_th <= 32'hFDA21490;
	else if (drc1_th_wen)
		drc1_th <= iic_regmap_wdata[159:128];
	else
		drc1_th <= drc1_th;
end

//reg drc1_k read and write logic
assign drc1_k_wen = iic_regmap_wren && (iic_regmap_address == DRC1_K);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		drc1_k <= 32'h03842109;
	else if (drc1_k_wen)
		drc1_k <= iic_regmap_wdata_aft_mask[159:128];
	else
		drc1_k <= drc1_k;
end

//reg drc1_ofset read and write logic
assign drc1_ofset_wen = iic_regmap_wren && (iic_regmap_address == DRC1_OFSET);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		drc1_ofset <= 32'h00084210;
	else if (drc1_ofset_wen)
		drc1_ofset <= iic_regmap_wdata_aft_mask[159:128];
	else
		drc1_ofset <= drc1_ofset;
end

//reg drc2_th read and write logic
assign drc2_th_wen = iic_regmap_wren && (iic_regmap_address == DRC2_TH);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		drc2_th <= 32'hFDA21490;
	else if (drc2_th_wen)
		drc2_th <= iic_regmap_wdata[159:128];
	else
		drc2_th <= drc2_th;
end

//reg drc2_k read and write logic
assign drc2_k_wen = iic_regmap_wren && (iic_regmap_address == DRC2_K);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		drc2_k <= 32'h03842109;
	else if (drc2_k_wen)
		drc2_k <= iic_regmap_wdata_aft_mask[159:128];
	else
		drc2_k <= drc2_k;
end

//reg drc2_ofset read and write logic
assign drc2_ofset_wen = iic_regmap_wren && (iic_regmap_address == DRC2_OFSET);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		drc2_ofset <= 32'h00084210;
	else if (drc2_ofset_wen)
		drc2_ofset <= iic_regmap_wdata_aft_mask[159:128];
	else
		drc2_ofset <= drc2_ofset;
end

//reg ch1_o_mix read and write logic
assign ch1_o_mix_wen = iic_regmap_wren && (iic_regmap_address == CH1_O_MIX);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch1_o_mix <= 96'h008000000000000000000000;
	else if (ch1_o_mix_wen)
		ch1_o_mix <= iic_regmap_wdata_aft_mask[159:64];
	else
		ch1_o_mix <= ch1_o_mix;
end

//reg ch2_o_mix read and write logic
assign ch2_o_mix_wen = iic_regmap_wren && (iic_regmap_address == CH2_O_MIX);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch2_o_mix <= 96'h008000000000000000000000;
	else if (ch2_o_mix_wen)
		ch2_o_mix <= iic_regmap_wdata_aft_mask[159:64];
	else
		ch2_o_mix <= ch2_o_mix;
end

//reg ch1_i_mix read and write logic
assign ch1_i_mix_wen = iic_regmap_wren && (iic_regmap_address == CH1_I_MIX);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch1_i_mix <= 128'h00800000000000000000000000800000;
	else if (ch1_i_mix_wen)
		ch1_i_mix <= iic_regmap_wdata_aft_mask[159:32];
	else
		ch1_i_mix <= ch1_i_mix;
end

//reg ch2_i_mix read and write logic
assign ch2_i_mix_wen = iic_regmap_wren && (iic_regmap_address == CH2_I_MIX);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch2_i_mix <= 128'h00800000000000000000000000800000;
	else if (ch2_i_mix_wen)
		ch2_i_mix <= iic_regmap_wdata_aft_mask[159:32];
	else
		ch2_i_mix <= ch2_i_mix;
end

//reg ch3_i_mix read and write logic
assign ch3_i_mix_wen = iic_regmap_wren && (iic_regmap_address == CH3_I_MIX);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch3_i_mix <= 96'h008000000000000000000000;
	else if (ch3_i_mix_wen)
		ch3_i_mix <= iic_regmap_wdata_aft_mask[159:64];
	else
		ch3_i_mix <= ch3_i_mix;
end

//reg post_scale read and write logic
assign post_scale_wen = iic_regmap_wren && (iic_regmap_address == POST_SCALE);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		post_scale <= 32'h00800000;
	else if (post_scale_wen)
		post_scale <= iic_regmap_wdata_aft_mask[159:128];
	else
		post_scale <= post_scale;
end

//reg pre_scale read and write logic
assign pre_scale_wen = iic_regmap_wren && (iic_regmap_address == PRE_SCALE);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		pre_scale <= 32'h00020000;
	else if (pre_scale_wen)
		pre_scale <= iic_regmap_wdata_aft_mask[159:128];
	else
		pre_scale <= pre_scale;
end

//reg ch1_bq7 read and write logic
assign ch1_bq7_wen = iic_regmap_wren && (iic_regmap_address == CH1_BQ7);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch1_bq7 <= 160'h0080000000000000000000000000000000000000;
	else if (ch1_bq7_wen)
		ch1_bq7 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch1_bq7 <= ch1_bq7;
end

//reg ch1_bq8 read and write logic
assign ch1_bq8_wen = iic_regmap_wren && (iic_regmap_address == CH1_BQ8);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch1_bq8 <= 160'h0080000000000000000000000000000000000000;
	else if (ch1_bq8_wen)
		ch1_bq8 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch1_bq8 <= ch1_bq8;
end

//reg subch_bq0 read and write logic
assign subch_bq0_wen = iic_regmap_wren && (iic_regmap_address == SUBCH_BQ0);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		subch_bq0 <= 160'h0080000000000000000000000000000000000000;
	else if (subch_bq0_wen)
		subch_bq0 <= iic_regmap_wdata_aft_mask[159:0];
	else
		subch_bq0 <= subch_bq0;
end

//reg subch_bq1 read and write logic
assign subch_bq1_wen = iic_regmap_wren && (iic_regmap_address == SUBCH_BQ1);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		subch_bq1 <= 160'h0080000000000000000000000000000000000000;
	else if (subch_bq1_wen)
		subch_bq1 <= iic_regmap_wdata_aft_mask[159:0];
	else
		subch_bq1 <= subch_bq1;
end

//reg ch2_bq7 read and write logic
assign ch2_bq7_wen = iic_regmap_wren && (iic_regmap_address == CH2_BQ7);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch2_bq7 <= 160'h0080000000000000000000000000000000000000;
	else if (ch2_bq7_wen)
		ch2_bq7 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch2_bq7 <= ch2_bq7;
end

//reg ch2_bq8 read and write logic
assign ch2_bq8_wen = iic_regmap_wren && (iic_regmap_address == CH2_BQ8);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch2_bq8 <= 160'h0080000000000000000000000000000000000000;
	else if (ch2_bq8_wen)
		ch2_bq8 <= iic_regmap_wdata_aft_mask[159:0];
	else
		ch2_bq8 <= ch2_bq8;
end

//reg pse_ch2_bq read and write logic
assign pse_ch2_bq_wen = iic_regmap_wren && (iic_regmap_address == PSE_CH2_BQ);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		pse_ch2_bq <= 160'h0080000000000000000000000000000000000000;
	else if (pse_ch2_bq_wen)
		pse_ch2_bq <= iic_regmap_wdata_aft_mask[159:0];
	else
		pse_ch2_bq <= pse_ch2_bq;
end

//reg ch4_i_mix read and write logic
assign ch4_i_mix_wen = iic_regmap_wren && (iic_regmap_address == CH4_I_MIX);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n)
		ch4_i_mix <= 64'h0040000000400000;
	else if (ch4_i_mix_wen)
		ch4_i_mix <= iic_regmap_wdata_aft_mask[159:96];
	else
		ch4_i_mix <= ch4_i_mix;
end



//---------------- vol trans---------------------
assign ch1_vol_trans_in = iic_regmap_wdata[159:152] & {8{ch1_vol_wen}};
vol_trans                    ch1_vol_trans(
    .vol_in                  (ch1_vol_trans_in),
    .vol_out                 (ch1_vol_aft_trans)
);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n) 
		ch1_vol_aft_trans_reg <= 32'h00800000;
	else if (ch1_vol_wen)
		ch1_vol_aft_trans_reg <= ch1_vol_aft_trans;
	else
		ch1_vol_aft_trans_reg <= ch1_vol_aft_trans_reg;
end

assign ch2_vol_trans_in = iic_regmap_wdata[159:152] & {8{ch2_vol_wen}};
vol_trans                    ch2_vol_trans(
    .vol_in                  (ch2_vol_trans_in),
    .vol_out                 (ch2_vol_aft_trans)
);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n) 
		ch2_vol_aft_trans_reg <= 32'h00800000;
	else if (ch2_vol_wen)
		ch2_vol_aft_trans_reg <= ch2_vol_aft_trans;
	else
		ch2_vol_aft_trans_reg <= ch2_vol_aft_trans_reg;
end

assign ch3_vol_trans_in = iic_regmap_wdata[159:152] & {8{ch3_vol_wen}};
vol_trans                    ch3_vol_trans(
    .vol_in                  (ch3_vol_trans_in),
    .vol_out                 (ch3_vol_aft_trans)
);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n) 
		ch3_vol_aft_trans_reg <= 32'h00800000;
	else if (ch3_vol_wen)
		ch3_vol_aft_trans_reg <= ch3_vol_aft_trans;
	else
		ch3_vol_aft_trans_reg <= ch3_vol_aft_trans_reg;
end

assign mst_vol_trans_in = iic_regmap_wdata[159:152] & {8{mst_vol_wen}};
vol_trans                    mst_vol_trans(
    .vol_in                  (mst_vol_trans_in),
    .vol_out                 (mst_vol_aft_trans)
);
always @ (posedge iic_regmap_wclk or negedge rst_n) begin
	if (!rst_n) 
		mst_vol_aft_trans_reg <= 32'h00800000;
	else if (mst_vol_wen)
		mst_vol_aft_trans_reg <= mst_vol_aft_trans;
	else
		mst_vol_aft_trans_reg <= mst_vol_aft_trans_reg;
end

//------------------ coef pack ------------------
assign drc1_coef_pack = {drc1_eng,
                         drc1_atk,
						 drc1_rel,
						 drc1_th,
						 drc1_k,
                         drc1_ofset};

assign drc2_coef_pack = {drc2_eng,
                         drc2_atk,
						 drc2_rel,
						 drc2_th,
						 drc2_k,
                         drc2_ofset};

//------------------- coef output  --------------
assign regmap_iis_bitsnum = iis_config[1:0];
assign regmap_iis_port_sel = iis_config[5:4];
assign regmap_iis_offset = iis_config[7];
assign regmap_mainch_alp_en = drc_ctrl[5];
assign regmap_mainch_pre_scale = pre_scale;
assign regmap_mainch_post_scale = post_scale;
assign regmap_mainch_drc1_coef = drc1_coef_pack;
assign regmap_mainch_drc1_en = drc_ctrl[0];
assign regmap_ch1_din_sel = input_mux[22:20];
assign regmap_ch1_bq0_coef = ch1_bq0;
assign regmap_ch1_input_mixer = ch1_i_mix;
assign regmap_ch1_bq1_coef = ch1_bq1;
assign regmap_ch1_bq2_coef = ch1_bq2;
assign regmap_ch1_bq3_coef = ch1_bq3;
assign regmap_ch1_bq4_coef = ch1_bq4;
assign regmap_ch1_bq5_coef = ch1_bq5;
assign regmap_ch1_bq6_coef = ch1_bq6;
assign regmap_ch1_bq7_coef = ch1_bq7;
assign regmap_ch1_bq8_coef = ch1_bq8;
assign regmap_ch1_vol_coef = ch1_vol_aft_trans_reg;
assign regmap_ch1_out_mixer = ch1_o_mix;
assign regmap_ch2_din_sel = input_mux[18:16];
assign regmap_ch2_bq0_coef = ch2_bq0;
assign regmap_ch2_input_mixer = ch2_i_mix;
assign regmap_ch2_bq1_coef = ch2_bq1;
assign regmap_ch2_bq2_coef = ch2_bq2;
assign regmap_ch2_bq3_coef = ch2_bq3;
assign regmap_ch2_bq4_coef = ch2_bq4;
assign regmap_ch2_bq5_coef = ch2_bq5;
assign regmap_ch2_bq6_coef = ch2_bq6;
assign regmap_ch2_bq7_coef = ch2_bq7;
assign regmap_ch2_bq8_coef = ch2_bq8;
assign regmap_ch2_vol_coef = ch2_vol_aft_trans_reg;
assign regmap_ch2_out_mixer = ch2_o_mix;
assign regmap_subch_vol_coef = ch3_vol_aft_trans_reg;
assign regmap_subch_vol_sel = vol_config[6:5];
assign regmap_subch_drc2_coef = drc2_coef_pack;
assign regmap_subch_drc2_en = drc_ctrl[1];
assign regmap_ch3_input_mixer = ch3_i_mix;
assign regmap_ch3_bq_coef = pse_ch2_bq;
assign regmap_ch4_input_mixer = ch4_i_mix;
assign regmap_ch4_input_sel = ch4_sr_sel[8];
assign regmap_ch4_bq0_coef = subch_bq0;
assign regmap_ch4_bq1_coef = subch_bq1;
assign regmap_dsp_bypass_en = dac_config[0];
assign regmap_dac_isi_en = dac_config[1];
assign regmap_dac_mis_en = dac_config[2];

endmodule
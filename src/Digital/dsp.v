module dsp(
    clk,
    rst_n,
    dsp_en,

    full,
    write_en,
    ch1_dout,
    ch2_dout,

    left_din,
    right_din,
    empty,
    read_en,
    regmap_iis_bitsnum,
    regmap_iis_port_sel,
    regmap_iis_offset,

    iic_regmap_wclk,
    iic_regmap_wren,
    iic_regmap_wdata,
    iic_regmap_address,
    regmap_iic_bytes_num,
    regmap_iic_rdata,
    dsp_bypass_en,
    dsp_dac_mis_en,
    dsp_dac_isi_en

);



input              clk;
input              rst_n;
input              dsp_en;
input              full;
input  [31:0]      left_din;
input  [31:0]      right_din;
input              iic_regmap_wclk;
input              iic_regmap_wren;
input  [7:0]       iic_regmap_address;
input  [159:0]     iic_regmap_wdata;
input              empty;
output             read_en;
output             write_en;
output [31:0]      ch1_dout;
output [31:0]      ch2_dout;
output [1:0]       regmap_iis_bitsnum;
output [1:0]       regmap_iis_port_sel;
output             regmap_iis_offset;
output [4:0]       regmap_iic_bytes_num;
output [159:0]     regmap_iic_rdata;
output             dsp_bypass_en;
output             dsp_dac_mis_en;
output             dsp_dac_isi_en;

wire               write_en;
wire               read_en;
wire   [31:0]      ch1_dout;
wire   [31:0]      ch2_dout;
wire   [1:0]       regmap_iis_bitsnum;
wire   [1:0]       regmap_iis_port_sel;
wire               regmap_iis_offset;
wire   [4:0]       regmap_iic_bytes_num;
wire   [159:0]     regmap_iic_rdata;
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
reg    [31:0]      ch1_subch_post_bq0;
wire   [31:0]      ch1_subch_post_bq7;
reg    [31:0]      ch2_subch_post_bq0;
wire   [31:0]      ch2_subch_post_bq7;
wire   [31:0]      ch3_mainch_post_bq;
wire   [31:0]      ch3_mainch_post_drc;
wire   [31:0]      ch4_mainch_post_drc;
wire               dsp_bypass_en;
wire               dsp_dac_mis_en;
wire               dsp_dac_isi_en;

regmap                                 regmap (
    .rst_n                             (rst_n),
    .iic_regmap_wclk                   (iic_regmap_wclk),   
    .iic_regmap_wren                   (iic_regmap_wren),
    .iic_regmap_wdata                  (iic_regmap_wdata),
    .iic_regmap_address                (iic_regmap_address),
    .regmap_iic_bytes_num              (regmap_iic_bytes_num),
    .regmap_iic_rdata                  (regmap_iic_rdata),
    .regmap_iis_port_sel               (regmap_iis_port_sel),
    .regmap_iis_bitsnum                (regmap_iis_bitsnum),
    .regmap_iis_offset                 (regmap_iis_offset),
    .regmap_dsp_bypass_en              (dsp_bypass_en),
    .regmap_dac_mis_en                 (dsp_dac_mis_en),
    .regmap_dac_isi_en                 (dsp_dac_isi_en),
    .regmap_mainch_alp_en              (regmap_mainch_alp_en),
    .regmap_mainch_pre_scale           (regmap_mainch_pre_scale),
    .regmap_mainch_post_scale          (regmap_mainch_post_scale),
    .regmap_mainch_drc1_coef           (regmap_mainch_drc1_coef),
    .regmap_mainch_drc1_en             (regmap_mainch_drc1_en),
    .regmap_ch1_din_sel                (regmap_ch1_din_sel),
    .regmap_ch1_bq0_coef               (regmap_ch1_bq0_coef),
    .regmap_ch1_input_mixer            (regmap_ch1_input_mixer),
    .regmap_ch1_bq1_coef               (regmap_ch1_bq1_coef),
    .regmap_ch1_bq2_coef               (regmap_ch1_bq2_coef),
    .regmap_ch1_bq3_coef               (regmap_ch1_bq3_coef),
    .regmap_ch1_bq4_coef               (regmap_ch1_bq4_coef),
    .regmap_ch1_bq5_coef               (regmap_ch1_bq5_coef),
    .regmap_ch1_bq6_coef               (regmap_ch1_bq6_coef),
    .regmap_ch1_bq7_coef               (regmap_ch1_bq7_coef),
    .regmap_ch1_bq8_coef               (regmap_ch1_bq8_coef),
    .regmap_ch1_vol_coef               (regmap_ch1_vol_coef),
    .regmap_ch1_out_mixer              (regmap_ch1_out_mixer),
    .regmap_ch2_din_sel                (regmap_ch2_din_sel),
    .regmap_ch2_bq0_coef               (regmap_ch2_bq0_coef),
    .regmap_ch2_input_mixer            (regmap_ch2_input_mixer),
    .regmap_ch2_bq1_coef               (regmap_ch2_bq1_coef),
    .regmap_ch2_bq2_coef               (regmap_ch2_bq2_coef),
    .regmap_ch2_bq3_coef               (regmap_ch2_bq3_coef),
    .regmap_ch2_bq4_coef               (regmap_ch2_bq4_coef),
    .regmap_ch2_bq5_coef               (regmap_ch2_bq5_coef),
    .regmap_ch2_bq6_coef               (regmap_ch2_bq6_coef),
    .regmap_ch2_bq7_coef               (regmap_ch2_bq7_coef),
    .regmap_ch2_bq8_coef               (regmap_ch2_bq8_coef),
    .regmap_ch2_vol_coef               (regmap_ch2_vol_coef),
    .regmap_ch2_out_mixer              (regmap_ch2_out_mixer),
    .regmap_subch_vol_coef             (regmap_subch_vol_coef),
    .regmap_subch_vol_sel              (regmap_subch_vol_sel),
    .regmap_subch_drc2_coef            (regmap_subch_drc2_coef),
    .regmap_subch_drc2_en              (regmap_subch_drc2_en),
    .regmap_ch3_input_mixer            (regmap_ch3_input_mixer),
    .regmap_ch3_bq_coef                (regmap_ch3_bq_coef),
    .regmap_ch4_input_mixer            (regmap_ch4_input_mixer),
    .regmap_ch4_input_sel              (regmap_ch4_input_sel),
    .regmap_ch4_bq0_coef               (regmap_ch4_bq0_coef),
    .regmap_ch4_bq1_coef               (regmap_ch4_bq1_coef)
);


DspTop                                             DspTop(
    .clock                                         (clk),
    .reset                                         (!rst_n || !dsp_en || dsp_bypass_en),
    .io_din_bits_0                                 (left_din),
    .io_din_bits_1                                 (right_din),
    .io_din_valid                                  (!empty),
    .io_din_ready                                  (read_en),
    .io_dout_ready                                 (!full),
    .io_dout_bits_0                                (ch1_dout),
    .io_dout_bits_1                                (ch2_dout),
    .io_dout_valid                                 (write_en),
    .io_coefin_regmap_mainch_alp_en                (regmap_mainch_alp_en),
    .io_coefin_regmap_mainch_pre_scale             ({regmap_mainch_pre_scale[25:0],6'b0}),
    .io_coefin_regmap_mainch_post_scale            (regmap_mainch_post_scale),
    .io_coefin_regmap_mainch_drc1_coef             (regmap_mainch_drc1_coef),
    .io_coefin_regmap_mainch_drc1_en               (regmap_mainch_drc1_en),
    .io_coefin_regmap_mainch_ch1_din_sel           (regmap_ch1_din_sel),
    .io_coefin_regmap_mainch_ch1_bq0_coef          (regmap_ch1_bq0_coef),
    .io_coefin_regmap_mainch_ch1_input_mixer       (regmap_ch1_input_mixer),
    .io_coefin_regmap_mainch_ch1_bq1_coef          (regmap_ch1_bq1_coef),
    .io_coefin_regmap_mainch_ch1_bq2_coef          (regmap_ch1_bq2_coef),
    .io_coefin_regmap_mainch_ch1_bq3_coef          (regmap_ch1_bq3_coef),
    .io_coefin_regmap_mainch_ch1_bq4_coef          (regmap_ch1_bq4_coef),
    .io_coefin_regmap_mainch_ch1_bq5_coef          (regmap_ch1_bq5_coef),
    .io_coefin_regmap_mainch_ch1_bq6_coef          (regmap_ch1_bq6_coef),
    .io_coefin_regmap_mainch_ch1_bq7_coef          (regmap_ch1_bq7_coef),
    .io_coefin_regmap_mainch_ch1_bq8_coef          (regmap_ch1_bq8_coef),
    .io_coefin_regmap_mainch_ch1_vol_coef          (regmap_ch1_vol_coef),
    .io_coefin_regmap_mainch_ch1_out_mixer         (regmap_ch1_out_mixer),
    .io_coefin_regmap_mainch_ch2_din_sel           (regmap_ch2_din_sel),
    .io_coefin_regmap_mainch_ch2_bq0_coef          (regmap_ch2_bq0_coef),
    .io_coefin_regmap_mainch_ch2_input_mixer       (regmap_ch2_input_mixer),
    .io_coefin_regmap_mainch_ch2_bq1_coef          (regmap_ch2_bq1_coef),
    .io_coefin_regmap_mainch_ch2_bq2_coef          (regmap_ch2_bq2_coef),
    .io_coefin_regmap_mainch_ch2_bq3_coef          (regmap_ch2_bq3_coef),
    .io_coefin_regmap_mainch_ch2_bq4_coef          (regmap_ch2_bq4_coef),
    .io_coefin_regmap_mainch_ch2_bq5_coef          (regmap_ch2_bq5_coef),
    .io_coefin_regmap_mainch_ch2_bq6_coef          (regmap_ch2_bq6_coef),
    .io_coefin_regmap_mainch_ch2_bq7_coef          (regmap_ch2_bq7_coef),
    .io_coefin_regmap_mainch_ch2_bq8_coef          (regmap_ch2_bq8_coef),
    .io_coefin_regmap_mainch_ch2_vol_coef          (regmap_ch2_vol_coef),
    .io_coefin_regmap_mainch_ch2_out_mixer         (regmap_ch2_out_mixer),
    .io_coefin_regmap_subch_vol_coef               (regmap_subch_vol_coef),
    .io_coefin_regmap_subch_vol_sel                (regmap_subch_vol_sel),
    .io_coefin_regmap_subch_drc2_coef              (regmap_subch_drc2_coef),
    .io_coefin_regmap_subch_drc2_en                (regmap_subch_drc2_en),
    .io_coefin_regmap_subch_ch3_input_mixer        (regmap_ch3_input_mixer),
    .io_coefin_regmap_subch_ch3_bq_coef            (regmap_ch3_bq_coef),
    .io_coefin_regmap_subch_ch4_input_mixer        (regmap_ch4_input_mixer),
    .io_coefin_regmap_subch_ch4_input_sel          (regmap_ch4_input_sel),
    .io_coefin_regmap_subch_ch4_bq0_coef           (regmap_ch4_bq0_coef),
    .io_coefin_regmap_subch_ch4_bq1_coef           (regmap_ch4_bq1_coef)
);

endmodule
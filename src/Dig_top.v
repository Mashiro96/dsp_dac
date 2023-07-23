module Dig_top (
    m_clk,
    rst_n,

    i2s_sck,
    i2s_sdin,
    i2s_lrclk,

    i2c_scl,
    i2c_sdain,
    i2c_sdaout,
    i2c_sdaout_en,

    SVBout,
    STBout,
    SVCout,
    STCout
);

input                m_clk;
input                rst_n;
input                i2s_sck;
input                i2s_sdin;
input                i2s_lrclk;
input                i2c_scl;
input                i2c_sdain;

output               i2c_sdaout_en;
output               i2c_sdaout;
output [17:0]        SVBout;
output [5:0]         SVCout;
output [17:0]        STBout;
output [5:0]         STCout;

wire                 i2c_sdaout_en;
wire                 i2c_sdaout;
wire   [17:0]        SVBout;
wire   [5:0]         SVCout;
wire   [17:0]        STBout;
wire   [5:0]         STCout;

wire   [23:0]        dsp_dac_rdata;
wire                 dsp_dac_isi_en;
wire                 dsp_dac_mis_en;
wire                 dac_dsp_rclk;


processor            dsp_inst (
    .rst_n           (rst_n),
    .i2s_sck         (i2s_sck),
    .i2s_sdin        (i2s_sdin),
    .i2s_lrclk       (i2s_lrclk),
    .i2c_scl         (i2c_scl),
    .i2c_sdain       (i2c_sdain),
    .i2c_sdaout      (i2c_sdaout),
    .i2c_sdaout_en   (i2c_sdaout_en),
    .pclk            (m_clk),
    .outclk          (dac_dsp_rclk),
    .dout_en         (),
    .dout            (dsp_dac_rdata),
    .dsp_dac_isi_en  (dsp_dac_isi_en),
    .dsp_dac_mis_en  (dsp_dac_mis_en)
);

Audio_DAC_Dig_V1p0   dac_dig_top_inst (
    .clock           (m_clk),
    .rstn            (rst_n),
    .rclk            (dac_dsp_rclk),
    .ISI_SEL         (dsp_dac_isi_en),
    .MIS_SEL         (dsp_dac_mis_en),
    .Data_in         (dsp_dac_rdata),
    .SVBout          (SVBout),
    .STBout          (STBout),
    .SVCout          (SVCout),
    .STCout          (STCout)
);

endmodule
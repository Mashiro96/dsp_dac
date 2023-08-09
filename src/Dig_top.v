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

    analog_clk,
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
output               analog_clk;
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
wire                 analog_clk;

wire   [9:0]         div_cnt;
wire   [23:0]        dsp_dac_rdata;
wire                 dsp_dac_isi_en;
wire                 dsp_dac_mis_en;
wire                 div8_0_en;       // 49.152 Mhz / 8    = 6.144 Mhz
wire                 div8_2_en;       // 49.152 Mhz / 16   = 3.072 Mhz
wire                 div8_4_en;       // 49.152 Mhz / 32   = 1.536 Mhz
wire                 div8_8_en;       // 49.152 Mhz / 64   = 768   khz
wire                 div8_16_en;      // 49.152 Mhz / 128  = 384   khz
wire                 div8_32_en;      // 49.152 Mhz / 256  = 192   khz
wire                 div8_64_en;      // 49.152 Mhz / 512  = 96    khz
wire                 div8_128_en;     // 49.152 Mhz / 1024 = 48    khz
wire                 div8_0_neg_en;   // 6.144 Mhz negedge
wire                 div8_8_neg_en;   // 768   khz negedge
wire                 div8_32_neg_en;  // 192   khz negedge
wire                 div8_64_neg_en;  // 96    khz negedge


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
    .outclk          (div8_64_en),
    .dout_en         (),
    .dout            (dsp_dac_rdata),
    .dsp_dac_isi_en  (dsp_dac_isi_en),
    .dsp_dac_mis_en  (dsp_dac_mis_en)
);

clock_divider        clk_div (
    .clk             (m_clk),
    .rst_n           (rst_n),
    .div8_0_en       (div8_0_en),
    .div8_0_neg_en   (div8_0_neg_en),
    .div8_2_en       (div8_2_en),
    .div8_4_en       (div8_4_en),
    .div8_8_en       (div8_8_en),
    .div8_8_neg_en   (div8_8_neg_en),
    .div8_16_en      (div8_16_en),
    .div8_32_en      (div8_32_en),
    .div8_32_neg_en  (div8_32_neg_en),
    .div8_64_en      (div8_64_en),
    .div8_64_neg_en  (div8_64_neg_en),
    .div8_128_en     (div8_128_en),
    .clk_cnt         (div_cnt)
);

Audio_DAC_Dig_V1p0   dac_dig_top_inst (
    .clock           (m_clk),
    .div8_0_en       (div8_0_en),
    .div8_0_neg_en   (div8_0_neg_en),
    .div8_2_en       (div8_2_en),
    .div8_4_en       (div8_4_en),
    .div8_8_en       (div8_8_en),
    .div8_8_neg_en   (div8_8_neg_en),
    .div8_16_en      (div8_16_en),
    .div8_32_en      (div8_32_en),
    .div8_32_neg_en  (div8_32_neg_en),
    .div8_64_en      (div8_64_en),
    .div8_64_neg_en  (div8_64_neg_en),
    .div8_128_en     (div8_128_en),
    .div_cnt         (div_cnt),
    .rstn            (rst_n),
    .ISI_SEL         (dsp_dac_isi_en),
    .MIS_SEL         (dsp_dac_mis_en),
    .Data_in         (dsp_dac_rdata),
    .SVBout          (SVBout),
    .STBout          (STBout),
    .SVCout          (SVCout),
    .STCout          (STCout)
);

assign analog_clk = div_cnt[1];
endmodule
module processor (
    rst_n,
    
    i2s_sck,
    i2s_sdin,
    i2s_lrclk,
    
    i2c_scl,
    i2c_sdain,
    i2c_sdaout,
    i2c_sdaout_en,

    pclk,
    outclk,
    dout_en,
    dout,

    dsp_dac_isi_en,
    dsp_dac_mis_en
);

input                rst_n;
input                i2s_sck;
input                i2s_sdin;
input                i2s_lrclk;
input                i2c_scl;
input                i2c_sdain;
output               i2c_sdaout;
output               i2c_sdaout_en;
input                pclk;
input                outclk;
output               dout_en;
output [23:0]        dout;
output               dsp_dac_isi_en;
output               dsp_dac_mis_en;

wire                 i2c_sdaout;
wire                 read_en;
wire                 i2c_sdaout_en;
wire   [23:0]        dout;
wire   [47:0]        out_fifo_rdata;
wire   [7:0]         iic_regmap_address;
wire                 iic_regmap_wren;
wire                 iic_regmap_wclk;
wire   [32*5-1:0]    iic_regmap_wdata;
wire   [32*5-1:0]    regmap_iic_rdata;
wire   [4:0]         regmap_iic_bytes_num;
wire   [1:0]         regmap_iis_bitsnum;
wire   [1:0]         regmap_iis_port_sel;
wire                 regmap_iis_offset;
wire                 i2s_writefifo;
wire   [31:0]        i2s_leftdata;
wire   [31:0]        i2s_rightdata;
wire                 inputfifo_full;
wire                 inputfifo_empty;
wire   [31:0]        dsp_leftin;
wire   [31:0]        dsp_rightin;
wire                 dsp_readfifo;
wire                 inputfifo_ren;
wire                 dsp_writefifo;
wire                 outputfifo_full;
wire                 outputfifo_empty;
wire   [31:0]        dsp_leftout;
wire   [31:0]        dsp_rightout;
wire                 dout_en;
wire                 dsp_bypass_en;
wire                 out_fifo_wen;
wire   [47:0]        out_fifo_wdata;
wire   [47:0]        out_data;
wire                 dsp_dac_isi_en;
wire                 dsp_dac_mis_en;
wire                 outclk_rise_edge;
reg                  outclk_d;
reg                  out_cnt;
reg                  first_read;

sync_iic_port             iicport (
    .clk                  (pclk),
    .scl                  (i2c_scl),
    .rst_n                (rst_n),
    .sda_in               (i2c_sdain),
    .sda_out              (i2c_sdaout),
    .sda_out_en           (i2c_sdaout_en),
    .iic_regmap_address   (iic_regmap_address),
    .iic_regmap_wren      (iic_regmap_wren),
    .iic_regmap_wclk      (iic_regmap_wclk),
    .iic_regmap_wdata     (iic_regmap_wdata),
    .regmap_iic_rdata     (regmap_iic_rdata),
    .regmap_iic_bytes_num (regmap_iic_bytes_num)
);

async_iis_port            iis_port (
    .sck                  (i2s_sck),
    .sdin                 (i2s_sdin),
    .lrclk                (i2s_lrclk),
    .rst_n                (rst_n),
    .regmap_iis_bitsnum   (regmap_iis_bitsnum),
    .regmap_iis_port_sel  (regmap_iis_port_sel),
    .regmap_iis_offset    (regmap_iis_offset),
    .write_en             (i2s_writefifo),
    .iis_adsp_left_data   (i2s_leftdata),
    .iis_adsp_right_data  (i2s_rightdata)
);

asyncfifo #(
    64,
    2   
)                          inputfifo (
    .wdata                 ({i2s_leftdata, i2s_rightdata}),
    .write_en              (i2s_writefifo),
    .wclk                  (i2s_sck),
    .rst_n                 (rst_n),
    .full                  (inputfifo_full),
    .rdata                 ({dsp_leftin, dsp_rightin}),
    .read_en               (inputfifo_ren),
    .rclk                  (pclk),
    .empty                 (inputfifo_empty)
);

assign inputfifo_ren = dsp_bypass_en ? !inputfifo_empty : dsp_readfifo;

dsp                        dsp_processor (
    .clk                   (pclk),
    .rst_n                 (rst_n),
    .dsp_en                (1'b1),
    .full                  (outputfifo_full),
    .write_en              (dsp_writefifo),
    .ch1_dout              (dsp_leftout),
    .ch2_dout              (dsp_rightout),
    .left_din              (dsp_leftin),
    .right_din             (dsp_rightin),
    .empty                 (inputfifo_empty),
    .read_en               (dsp_readfifo),
    .regmap_iis_bitsnum    (regmap_iis_bitsnum),
    .regmap_iis_port_sel   (regmap_iis_port_sel),
    .regmap_iis_offset     (regmap_iis_offset),
    .iic_regmap_wclk       (iic_regmap_wclk),
    .iic_regmap_wren       (iic_regmap_wren),
    .iic_regmap_wdata      (iic_regmap_wdata),
    .iic_regmap_address    (iic_regmap_address),
    .regmap_iic_bytes_num  (regmap_iic_bytes_num),
    .regmap_iic_rdata      (regmap_iic_rdata),
    .dsp_bypass_en         (dsp_bypass_en),
    .dsp_dac_mis_en        (dsp_dac_mis_en),
    .dsp_dac_isi_en        (dsp_dac_isi_en)
);

assign out_fifo_wdata = dsp_bypass_en ? {dsp_leftin[31:8],  dsp_rightin[31:8]} 
                                      : {dsp_leftout[31:8], dsp_rightout[31:8]};

assign out_fifo_wen = dsp_bypass_en ? !inputfifo_empty : dsp_writefifo;

syncfifo #(
    48,
    2
)                         outputfifo (
    .wdata                 (out_fifo_wdata),
    .write_en              (out_fifo_wen),
    .rst_n                 (rst_n),
    .full                  (outputfifo_full),
    .rdata                 (out_fifo_rdata),
    .read_en               (read_en),
    .clk                   (pclk),
    .empty                 (outputfifo_empty)

);

assign dout_en = !outputfifo_empty;

always @ (posedge pclk or negedge rst_n) begin
    if (!rst_n)
        outclk_d <= 1'b0;
    else
        outclk_d <= outclk;
end

always @ (posedge pclk or negedge rst_n) begin
    if (!rst_n)
        out_cnt <= 1'b0;
    else if (outclk_rise_edge)
        out_cnt <= ~out_cnt;
    else
        out_cnt <= out_cnt;
end

always @ (posedge pclk or negedge rst_n) begin
    if (!rst_n)
        first_read <= 1'b0;
    else if (outclk_rise_edge && out_cnt)
        first_read <= 1'b0;
    else if (outclk_rise_edge)
        first_read <= !outputfifo_empty && !out_cnt;
    else 
        first_read <= first_read;
end

assign outclk_rise_edge = !outclk_d && outclk;

assign read_en = out_cnt && !outputfifo_empty && outclk_rise_edge && first_read;
assign out_data = out_fifo_rdata & {48{!outputfifo_empty}};
assign dout = out_cnt ? out_data[47:24] : out_data[23:0];

endmodule
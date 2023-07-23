module sync_iis_port (
    // i2s interface
    sck,
    sdin,
    lrclk,

    //config from register map
    regmap_iis_bitsnum,
    regmap_iis_port_sel,
    regmap_iis_offset,

    //port to inputfifo
    write_en,
    iis_adsp_left_data,
    iis_adsp_right_data,

    //clock port
    clk,
    rst_n
);

input              clk;
input              sck;
input              sdin;
input              lrclk;
input              rst_n;
input  [1:0]       regmap_iis_bitsnum;
input  [1:0]       regmap_iis_port_sel;
input              regmap_iis_offset;
output [31:0]      iis_adsp_left_data;
output [31:0]      iis_adsp_right_data;
output             write_en;


wire               port_iis;
wire               port_lj;
wire               port_rj;
wire               port_tdm;
wire               lrclk_rise_edge;
wire               lrclk_fall_edge;
wire               lrclk_final_edge;
wire               offset_en;
wire               out_en;
wire               shift_en;
wire   [31:0]      left_data32;
wire   [23:0]      left_data24;
wire   [19:0]      left_data20;
wire   [15:0]      left_data16;
wire   [31:0]      right_data32;
wire               default_lrclk;
reg                sck_d1;
reg                sck_d2;
reg                sck_d3;
reg                sdin_d1;
reg                sdin_d2;
reg                lrclk_d1;
reg                lrclk_d2;
reg                sclk_samp_lrclk;
reg    [31:0]      left_databits;
reg    [31:0]      right_databits;
reg    [23:0]      right_data24;
reg    [19:0]      right_data20;
reg    [15:0]      right_data16;
reg    [31:0]      iis_adsp_left_data;
reg    [31:0]      iis_adsp_right_data;
reg                write_en;
reg                offset_flg;
reg                final_edge_latch;
reg    [63:0]      data_shift;

parameter IIS = 2'd0;
parameter LEFT_JUST = 2'd1;
parameter RIGHT_JUST = 2'd2;
parameter TDM = 2'd3;

//------------------------------------------------------
//                     main logic
//------------------------------------------------------

//sample input data
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sck_d1 <= 1'b1;
        sck_d2 <= 1'b1;
        sck_d3 <= 1'b1;
        sdin_d1 <= 1'b0;
        sdin_d2 <= 1'b0;
        lrclk_d1 <= 1'b0;
        lrclk_d2 <= 1'b0;
    end
    else begin
        sck_d1 <= sck;
        sck_d2 <= sck_d1;
        sck_d3 <= sck_d2;
        sdin_d1 <= sdin;
        sdin_d2 <= sdin_d1;
        lrclk_d1 <= lrclk;
        lrclk_d2 <= lrclk_d1;
    end
end

//port config
assign port_iis = (regmap_iis_port_sel == IIS);
assign port_lj = (regmap_iis_port_sel == LEFT_JUST);
assign port_rj = (regmap_iis_port_sel == RIGHT_JUST);
assign port_tdm = (regmap_iis_port_sel == TDM);

assign left_data32[31:0] = data_shift[63:32];
assign left_data24[23:0] = port_rj ? data_shift[55:32] : data_shift[63:40];
assign left_data20[19:0] = port_rj ? data_shift[51:32] : data_shift[63:44];
assign left_data16[15:0] = port_rj ? data_shift[47:32] : data_shift[63:48];
assign right_data32[31:0] = data_shift[31:0];

always @(*) begin
    case({port_tdm, port_rj})
        2'b00: begin
            right_data24 = data_shift[31:8];
            right_data20 = data_shift[31:12];
            right_data16 = data_shift[31:16];
        end
        2'b01: begin
            right_data24 = data_shift[23:0];
            right_data20 = data_shift[19:0];
            right_data16 = data_shift[15:0];
        end
        2'b10: begin
            right_data24 = data_shift[39:16];
            right_data20 = data_shift[43:24];
            right_data16 = data_shift[47:32];
        end
        default: begin
            right_data24 = 24'bx;
            right_data20 = 20'bx;
            right_data16 = 16'bx;
        end
    endcase
end

always @(*) begin
    case(regmap_iis_bitsnum)
        2'b00: begin
            right_databits = {right_data16, 16'b0};
            left_databits = {left_data16, 16'b0};
        end
        2'b01: begin
            right_databits = {right_data20, 12'b0};
            left_databits = {left_data20, 12'b0};
        end
        2'b10: begin
            right_databits = {right_data24, 8'b0};
            left_databits = {left_data24, 8'b0};
        end
        2'b11: begin
            right_databits = right_data32;
            left_databits = left_data32;
        end
    endcase
end

//shift register
assign shift_en = sck_d2 && !sck_d3; //sck posedge

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_shift[63:0] <= 64'b0;
    end
    else if(shift_en) begin
        data_shift[63:0] <= {data_shift[62:0], sdin_d2};
    end
    else begin
        data_shift[63:0] <= data_shift[63:0];
    end
end

//data out
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sclk_samp_lrclk <= default_lrclk;
    else if (shift_en)
        sclk_samp_lrclk <= lrclk_d2;
    else
        sclk_samp_lrclk <= sclk_samp_lrclk;
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        final_edge_latch <= 1'b0;
    else if (shift_en && offset_flg)
        final_edge_latch <= 1'b0;
    else if (lrclk_final_edge)
        final_edge_latch <= 1'b1;
    else
        final_edge_latch <= final_edge_latch;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        offset_flg <= 1'b0;
    else if (!offset_en)
        offset_flg <= 1'b1;
    else if (final_edge_latch && shift_en)
        offset_flg <= !offset_flg;
    else
        offset_flg <= offset_flg;
end

assign lrclk_rise_edge = lrclk_d2 && !sclk_samp_lrclk;
assign lrclk_fall_edge = !lrclk_d2 && sclk_samp_lrclk;
assign lrclk_final_edge = port_iis ? lrclk_fall_edge : lrclk_rise_edge;
assign offset_en = port_iis || port_tdm && regmap_iis_offset;
assign out_en = final_edge_latch && offset_flg && shift_en;
assign default_lrclk = !port_iis;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        iis_adsp_left_data <= 32'b0;
        iis_adsp_right_data <= 32'b0;
    end
    else if (out_en) begin
        iis_adsp_left_data <= left_databits;
        iis_adsp_right_data <= right_databits;
    end
    else begin
        iis_adsp_left_data <= iis_adsp_left_data;
        iis_adsp_right_data <= iis_adsp_right_data;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        write_en <= 1'b0;
    else 
        write_en <= out_en;
end

endmodule
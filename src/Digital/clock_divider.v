module clock_divider(
    clk,
    rst_n,
    div8_0_en,
    div8_0_neg_en,
    div8_2_en,
    div8_4_en,
    div8_8_en,
    div8_8_neg_en,
    div8_16_en,
    div8_32_en,
    div8_32_neg_en,
    div8_64_en,
    div8_64_neg_en,
    div8_128_en,
    clk_cnt
);

input              clk;
input              rst_n;
output             div8_0_en;       // 49.152 Mhz / 8    = 6.144 Mhz
output             div8_2_en;       // 49.152 Mhz / 16   = 3.072 Mhz
output             div8_4_en;       // 49.152 Mhz / 32   = 1.536 Mhz
output             div8_8_en;       // 49.152 Mhz / 64   = 768   khz
output             div8_16_en;      // 49.152 Mhz / 128  = 384   khz
output             div8_32_en;      // 49.152 Mhz / 256  = 192   khz
output             div8_64_en;      // 49.152 Mhz / 512  = 96    khz
output             div8_128_en;     // 49.152 Mhz / 1024 = 48    khz
output             div8_0_neg_en;   // 6.144 Mhz negedge
output             div8_8_neg_en;   // 768   khz negedge
output             div8_32_neg_en;  // 192   khz negedge
output             div8_64_neg_en;  // 96    khz negedge
output [9:0]       clk_cnt;

wire               div4_en;
wire               div8_0_en;       // 49.152 Mhz / 8    = 6.144 Mhz
wire               div8_2_en;       // 49.152 Mhz / 16   = 3.072 Mhz
wire               div8_4_en;       // 49.152 Mhz / 32   = 1.536 Mhz
wire               div8_8_en;       // 49.152 Mhz / 64   = 768   khz
wire               div8_16_en;      // 49.152 Mhz / 128  = 384   khz
wire               div8_32_en;      // 49.152 Mhz / 256  = 192   khz
wire               div8_64_en;      // 49.152 Mhz / 512  = 96    khz
wire               div8_128_en;     // 49.152 Mhz / 1024 = 48    khz
wire               div8_0_neg_en;   // 6.144 Mhz negedge
wire               div8_8_neg_en;   // 768   khz negedge
wire               div8_32_neg_en;  // 192   khz negedge
wire               div8_64_neg_en;  // 96    khz negedge
reg   [9:0]        div_cnt;
reg   [9:0]        clk_cnt;

//**********************************************************
//                    main logic
//**********************************************************
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
        div_cnt <= 10'h0;
    else
        div_cnt <= div_cnt + 10'b1;
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_cnt[1] <= 10'b0;
    end
    else if (div4_en) begin
        clk_cnt[1] <= ~clk_cnt[2];
    end
end
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_cnt[2] <= 10'b0;
    end
    else if (div8_0_en) begin
        clk_cnt[2] <= ~clk_cnt[2];
    end
end
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_cnt[3] <= 10'b0;
    end
    else if (div8_2_en) begin
        clk_cnt[3] <= ~clk_cnt[3];
    end
end
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_cnt[4] <= 10'b0;
    end
    else if (div8_4_en) begin
        clk_cnt[4] <= ~clk_cnt[4];
    end
end
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_cnt[5] <= 10'b0;
    end
    else if (div8_8_en) begin
        clk_cnt[5] <= ~clk_cnt[5];
    end
end
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_cnt[6] <= 10'b0;
    end
    else if (div8_16_en) begin
        clk_cnt[6] <= ~clk_cnt[6];
    end
end
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_cnt[7] <= 10'b0;
    end
    else if (div8_32_en) begin
        clk_cnt[7] <= ~clk_cnt[7];
    end
end
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_cnt[8] <= 10'b0;
    end
    else if (div8_64_en) begin
        clk_cnt[8] <= ~clk_cnt[8];
    end
end
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_cnt[9] <= 10'b0;
    end
    else if (div8_128_en) begin
        clk_cnt[9] <= ~clk_cnt[9];
    end
end

assign div4_en         = (div_cnt[1:0] == 3'h1);
assign div8_0_en       = (div_cnt[2:0] == 3'h3);
assign div8_0_neg_en   = (div_cnt[2:0] == 3'h7);
assign div8_2_en       = div8_0_en && !div_cnt[3];
assign div8_4_en       = div8_2_en && !div_cnt[4];
assign div8_8_en       = div8_4_en && !div_cnt[5]; 
assign div8_8_neg_en   = div8_4_en && div_cnt[5]; 
assign div8_16_en      = div8_8_en && !div_cnt[6];
assign div8_32_en      = div8_16_en && !div_cnt[7]; 
assign div8_32_neg_en  = div8_16_en && div_cnt[7]; 
assign div8_64_en      = div8_32_en && !div_cnt[8]; 
assign div8_64_neg_en  = div8_32_en && div_cnt[8]; 
assign div8_128_en     = div8_64_en && !div_cnt[9]; 

endmodule
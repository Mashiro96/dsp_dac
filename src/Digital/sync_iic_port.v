module sync_iic_port (
    clk,
    rst_n,
    scl,
    sda_in,
    sda_out,
    sda_out_en,
    iic_regmap_address,
    iic_regmap_wren,
    iic_regmap_wclk,
    iic_regmap_wdata,
    regmap_iic_rdata,
    regmap_iic_bytes_num
);

input              clk;
input              scl;
input              rst_n;
input              sda_in;
input  [32*5-1:0]  regmap_iic_rdata;
input  [4:0]       regmap_iic_bytes_num;
output             iic_regmap_wclk;
output [7:0]       iic_regmap_address;
output             iic_regmap_wren;
output [32*5-1:0]  iic_regmap_wdata;
output             sda_out;
output             sda_out_en;

wire               iic_regmap_wclk;
wire   [32*5-1:0]  iic_regmap_wdata;
wire   [6:0]       dev_addr;
wire               scl_rise_edge;
wire               scl_fall_edge;
wire               sda_in_rise_edge;
wire               sda_in_fall_edge;
wire               start;
wire               stop;
wire               trans_byte;
wire               trans_done;
wire               dev_addr_hit;
wire               get_nack;
wire               data_shift_en;
wire               data_in_load;
wire               data_out_load;
wire               sub_addr_load;
wire   [7:0]       shift_cnt_load;
wire               data_shift_in_en;
wire               data_shift_out_en;
wire               write_load;
wire               bit_cnt_load;
wire               bit_cnt_dec;
wire               byte_cnt_load;
wire               byte_cnt_dec;
wire               sub_addr_inc;
wire   [7:0]       iic_regmap_address;
reg                bit_cnt_dec_reg;
reg    [7:0]       sda_out_load;
reg    [7:0]       sub_addr;
reg    [7:0]       data_shift;
reg    [2:0]       bit_cnt;
reg    [4:0]       byte_cnt;
reg                i2c_write;
reg                nxt_sda_out_en;
reg                sda_out_en;
reg                nxt_sda_out;
reg                sda_out;
reg                scl_d1;
reg                scl_d2;
reg                scl_d3;
reg                sda_in_d1;
reg                sda_in_d2;
reg                sda_in_d3;
reg                start_reg;
reg    [2:0]       cur_state;
reg    [2:0]       nxt_state;
reg    [159:0]     wdata_reg;

parameter IDLE            = 3'b000;
parameter DEV_ADDR        = 3'b001;
parameter DEV_ADDR_RESP   = 3'b010;
parameter R_SUB_ADDR      = 3'b011;
parameter SUB_ADDR_RESP   = 3'b100;
parameter S_RESP          = 3'b101;
parameter DATA            = 3'b110;
parameter R_RESP          = 3'b111;

assign dev_addr = 7'b0010110;

//-----------------------------------------------
//                  main logic
//-----------------------------------------------

//sample input
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        scl_d1 <= 1'b1;
        scl_d2 <= 1'b1;
        scl_d3 <= 1'b1;
        sda_in_d1 <= 1'b1;
        sda_in_d2 <= 1'b1;
        sda_in_d3 <= 1'b1;
    end
    else begin
        scl_d1 <= scl;
        scl_d2 <= scl_d1;
        scl_d3 <= scl_d2;
        sda_in_d1 <= sda_in;
        sda_in_d2 <= sda_in_d1;
        sda_in_d3 <= sda_in_d2;
    end
end

assign scl_rise_edge = scl_d2 && !scl_d3;
assign scl_fall_edge = !scl_d2 && scl_d3;
assign sda_in_rise_edge = sda_in_d2 && !sda_in_d3;
assign sda_in_fall_edge = !sda_in_d2 && sda_in_d3;
assign start = scl_d2 && sda_in_fall_edge;
assign stop = scl_d2 && sda_in_rise_edge;

// I2C FSM
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cur_state[2:0] <= IDLE;
        sda_out_en     <= 1'b0;
        sda_out        <= 1'b1;
    end
    else begin
        cur_state[2:0] <= nxt_state[2:0];
        sda_out_en     <= nxt_sda_out_en;
        sda_out        <= nxt_sda_out;
    end
end

always @(*) begin
    case (cur_state)
        IDLE: begin
            if (start_reg && scl_fall_edge) begin
                nxt_state = DEV_ADDR;
                nxt_sda_out_en = 1'b0;
                nxt_sda_out = 1'b1;
            end
            else begin
                nxt_state = IDLE;
                nxt_sda_out_en = 1'b0;
                nxt_sda_out = 1'b1;
            end
        end
        DEV_ADDR: begin
            if (trans_byte && scl_fall_edge) begin
                nxt_state = dev_addr_hit ? DEV_ADDR_RESP : IDLE;
                nxt_sda_out_en = dev_addr_hit;
                nxt_sda_out = !dev_addr_hit;
            end
            else begin
                nxt_state = DEV_ADDR;
                nxt_sda_out_en = 1'b0;
                nxt_sda_out = 1'b1;
            end
        end
        DEV_ADDR_RESP: begin
            if (scl_fall_edge) begin
                nxt_state = i2c_write ? R_SUB_ADDR : DATA;
                nxt_sda_out_en = !i2c_write;
                nxt_sda_out = i2c_write ? 1'b1 : data_shift[7];
            end
            else begin
                nxt_state = DEV_ADDR_RESP;
                nxt_sda_out_en = 1'b1;
                nxt_sda_out = 1'b0;
            end
        end
        R_SUB_ADDR: begin
            if (trans_byte && scl_fall_edge) begin
                nxt_state = SUB_ADDR_RESP;
                nxt_sda_out_en = 1'b1;
                nxt_sda_out = 1'b0;
            end
            else begin
                nxt_state = R_SUB_ADDR;
                nxt_sda_out_en = 1'b0;
                nxt_sda_out = 1'b1;
            end
        end
        SUB_ADDR_RESP: begin
            if (scl_fall_edge) begin
                nxt_state = DATA;
                nxt_sda_out_en = 1'b0;
                nxt_sda_out = 1'b1;
            end
            else begin
                nxt_state = SUB_ADDR_RESP;
                nxt_sda_out_en = 1'b1;
                nxt_sda_out = 1'b0;
            end
        end
        S_RESP: begin
            if (scl_fall_edge) begin
                nxt_state = DATA;
                nxt_sda_out_en = 1'b0;
                nxt_sda_out = 1'b1;
            end
            else begin
                nxt_state = S_RESP;
                nxt_sda_out_en = 1'b1;
                nxt_sda_out = 1'b0;
            end
        end
        DATA: begin
            if (stop) begin
                nxt_state = IDLE;
                nxt_sda_out_en = 1'b0;
                nxt_sda_out = 1'b1;
            end
            else if (start_reg && scl_fall_edge) begin
                nxt_state = DEV_ADDR;
                nxt_sda_out_en = 1'b0;
                nxt_sda_out = 1'b1;
            end
            else if (trans_byte && scl_fall_edge) begin
                nxt_state = i2c_write ? S_RESP : R_RESP;
                nxt_sda_out_en = !i2c_write;
                nxt_sda_out = i2c_write ? 1'b1 : data_shift[7];
            end
            else begin
                nxt_state = DATA;
                nxt_sda_out_en = !i2c_write;
                nxt_sda_out = i2c_write ? 1'b1 : data_shift[7];
            end
        end
        R_RESP: begin
            if (scl_fall_edge) begin
                nxt_state = get_nack ? IDLE : DATA;
                nxt_sda_out_en = !get_nack;
                nxt_sda_out = get_nack ? 1'b1 : data_shift[7];
            end
            else begin
                nxt_state = R_RESP;
                nxt_sda_out_en = 1'b0;
                nxt_sda_out = 1'b1;
            end
        end
    endcase
end

assign dev_addr_hit = (cur_state == DEV_ADDR) && (data_shift[7:1] == dev_addr[6:0]);
assign get_nack = (cur_state == R_RESP) && sda_in_d3;

//start signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        start_reg <= 1'b0;
    end
    else if (start) begin
        start_reg <= 1'b1;
    end
    else if (scl_fall_edge) begin
        start_reg <= 1'b0;
    end
    else begin
        start_reg <= start_reg;
    end
end

//data_shift
assign data_shift_in_en = ((cur_state == DEV_ADDR)
                        || (cur_state == R_SUB_ADDR)
                        || (cur_state == DATA) && i2c_write) && scl_rise_edge;

assign data_shift_out_en = (cur_state == DATA) && !i2c_write && scl_fall_edge;

assign data_shift_en = data_shift_in_en || data_shift_out_en;

assign data_out_load = scl_fall_edge && (nxt_state == DATA) && (cur_state != DATA) && !i2c_write;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_shift <= 8'b0;
    end
    else if(data_out_load) begin
        data_shift <= sda_out_load[7:0];
    end
    else if(data_shift_en) begin
        data_shift <= {data_shift[6:0], sda_in_d2};
    end
    else begin
        data_shift <= data_shift;
    end
end

//read write select
assign write_load = (cur_state == DEV_ADDR) && trans_byte && scl_fall_edge;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i2c_write = 1'b0;
    end
    else if(write_load) begin
        i2c_write = !sda_in_d3;
    end
    else begin
        i2c_write = i2c_write;
    end
end

//bit counter
assign bit_cnt_load = start_reg && scl_fall_edge;
assign bit_cnt_dec = (cur_state == DEV_ADDR)
                  || (cur_state == R_SUB_ADDR)
                  || (cur_state == DATA);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bit_cnt_dec_reg <= 1'b0;
    end
    else if (bit_cnt_dec && scl_rise_edge) begin
        bit_cnt_dec_reg <= 1'b1;
    end
    else if (bit_cnt_dec && scl_fall_edge) begin
        bit_cnt_dec_reg <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bit_cnt <= 3'b111;
    end
    else if(bit_cnt_load) begin
        bit_cnt <= 3'b111;
    end
    else if(bit_cnt_dec_reg && scl_fall_edge) begin
        bit_cnt <= bit_cnt - 3'b1;
    end
    else begin
        bit_cnt <= bit_cnt;
    end
end

//byte counter
assign byte_cnt_load = scl_rise_edge &&
                       (   (cur_state == DEV_ADDR_RESP) && !i2c_write
                        || (cur_state == SUB_ADDR_RESP) && i2c_write
                        || (cur_state == R_RESP)        && trans_done
                        || (cur_state == S_RESP)        && trans_done);

assign byte_cnt_dec = scl_fall_edge
                   && trans_byte
                   && (cur_state == DATA);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        byte_cnt <= 5'b0;
    end
    else if(bit_cnt_load) begin
        byte_cnt <= 5'b0;
    end
    else if(byte_cnt_load) begin
        byte_cnt <= regmap_iic_bytes_num;
    end
    else if(byte_cnt_dec) begin
        byte_cnt <= byte_cnt - 5'b1;
    end
    else begin
        byte_cnt <= byte_cnt;
    end
end

assign trans_byte = bit_cnt == 3'b000;
assign trans_done = byte_cnt == 5'd0;

//sub addr reg
assign sub_addr_load = (cur_state == R_SUB_ADDR) && trans_byte && scl_fall_edge;

assign sub_addr_inc = trans_done && scl_rise_edge &&
                    ( (cur_state == R_RESP) || (cur_state == S_RESP));

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sub_addr <= 8'b0;
    end
    else if(sub_addr_load) begin
        sub_addr <= data_shift;
    end
    else if(sub_addr_inc) begin
        sub_addr <= sub_addr + 8'b1;
    end
    else begin
        sub_addr <= sub_addr;
    end
end

//wdata load
generate
    genvar i;
    for (i=1; i<=20; i=i+1) begin
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                wdata_reg[8*i-1:8*i-8] <= 8'b0;
            end
            else if(byte_cnt_dec && (byte_cnt == i)) begin
                wdata_reg[8*i-1:8*i-8] <= data_shift;
            end
            else begin
                wdata_reg[8*i-1:8*i-8] <= wdata_reg[8*i-1:8*i-8];
            end
        end
    end
endgenerate

always @(*) begin
    case(byte_cnt)
        5'd20: sda_out_load[7:0] = regmap_iic_rdata[7:0];
        5'd19: sda_out_load[7:0] = regmap_iic_rdata[15:8];
        5'd18: sda_out_load[7:0] = regmap_iic_rdata[23:16];
        5'd17: sda_out_load[7:0] = regmap_iic_rdata[31:24];
        5'd16: sda_out_load[7:0] = regmap_iic_rdata[39:32];
        5'd15: sda_out_load[7:0] = regmap_iic_rdata[47:40];
        5'd14: sda_out_load[7:0] = regmap_iic_rdata[55:48];
        5'd13: sda_out_load[7:0] = regmap_iic_rdata[63:56];
        5'd12: sda_out_load[7:0] = regmap_iic_rdata[71:64];
        5'd11: sda_out_load[7:0] = regmap_iic_rdata[79:72];
        5'd10: sda_out_load[7:0] = regmap_iic_rdata[87:80];
        5'd9 : sda_out_load[7:0] = regmap_iic_rdata[95:88];
        5'd8 : sda_out_load[7:0] = regmap_iic_rdata[103:96];
        5'd7 : sda_out_load[7:0] = regmap_iic_rdata[111:104];
        5'd6 : sda_out_load[7:0] = regmap_iic_rdata[119:112];
        5'd5 : sda_out_load[7:0] = regmap_iic_rdata[127:120];
        5'd4 : sda_out_load[7:0] = regmap_iic_rdata[135:128];
        5'd3 : sda_out_load[7:0] = regmap_iic_rdata[143:136];
        5'd2 : sda_out_load[7:0] = regmap_iic_rdata[151:144];
        5'd1 : sda_out_load[7:0] = regmap_iic_rdata[159:152];
        default: sda_out_load[7:0] = 8'b0;
    endcase
end

//port with regmap
assign iic_regmap_wclk = clk;
assign iic_regmap_wren = scl_rise_edge && trans_done && (cur_state == S_RESP);
assign iic_regmap_address = sub_addr;
assign iic_regmap_wdata = {wdata_reg[7:0],
                           wdata_reg[15:8],
                           wdata_reg[23:16],
                           wdata_reg[31:24],
                           wdata_reg[39:32],
                           wdata_reg[47:40],
                           wdata_reg[55:48],
                           wdata_reg[63:56],
                           wdata_reg[71:64],
                           wdata_reg[79:72],
                           wdata_reg[87:80],
                           wdata_reg[95:88],
                           wdata_reg[103:96],
                           wdata_reg[111:104],
                           wdata_reg[119:112],
                           wdata_reg[127:120],
                           wdata_reg[135:128],
                           wdata_reg[143:136],
                           wdata_reg[151:144],
                           wdata_reg[159:152]
                           };
endmodule
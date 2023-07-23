module dsp_tb;


reg                adsp_clk;
reg                rst_n;
reg signed   [31:0]      left_din;
reg signed   [31:0]      right_din;
reg    [31:0]      left_din_d;
reg    [31:0]      right_din_d;
reg                wclk;
reg                wren;
reg    [7:0]       waddr;
reg    [159:0]     wdata;
reg                full;
reg                empty;
reg                empty_d;
wire   [159:0]     rdata;
wire   [31:0]      ch1_dout;
wire   [31:0]      ch2_dout;
wire               read_en;
wire               write_en;

parameter ADSP_CLK_PERIOD = 3333;
parameter REG_CLK_PERIOD = 1000;

integer            i;
integer            config_in;
integer            file_in;
integer            file_out;
integer            err;
integer            err_str;
integer            data_tmp;
integer            read_ptr;
integer            write_ptr;

dsp                          dut_inst (
    .clk                     (adsp_clk),
    .rst_n                   (rst_n),
    .dsp_en                  (1'b1),
    .ch1_dout                (ch1_dout),
    .ch2_dout                (ch2_dout),
    .full                    (full),
    .write_en                (write_en),

    .left_din                (left_din_d),
    .right_din               (right_din_d),
    .empty                   (empty),
    .read_en                 (read_en),
    .regmap_iis_bitsnum      (),
    .regmap_iis_offset       (),
    .regmap_iis_port_sel     (),

    .iic_regmap_wclk         (wclk),
    .iic_regmap_wren         (wren),
    .iic_regmap_address      (waddr),
    .iic_regmap_wdata        (wdata),
    .regmap_iic_bytes_num    (),
    .regmap_iic_rdata        (rdata)
);

always #ADSP_CLK_PERIOD adsp_clk = ~adsp_clk;

always @ (posedge adsp_clk or negedge rst_n) begin
    left_din_d <= left_din;
    right_din_d <= right_din;
    empty_d <= empty;
end

initial begin
    adsp_clk = 0;
    rst_n = 0;
    wclk = 0;
    wren = 0;
    waddr = 8'h00;
    wdata = 160'b0;
    left_din = 32'b0;
    right_din = 32'b0;
    full  = 1'b0;
    empty = 1'b1;
    # (20*ADSP_CLK_PERIOD);
    rst_n = 1;
end

initial begin
    # (30*ADSP_CLK_PERIOD);

//  start configure now
    fork
    config_in = $fopen("./results/config.txt", "r");
    err = $ferror(config_in, err_str);
    if (!err) begin
        while ($feof(config_in) == 0) begin
            wren = 1;
            $fscanf(config_in, "%d", waddr);
            $fscanf(config_in, "%b", wdata);
            # REG_CLK_PERIOD;
            wclk = 1;
            # REG_CLK_PERIOD;
            wren = 0;
            wclk = 0;
        end
    end
    join

//  after configure done , start simulation
    @ (posedge adsp_clk);
    file_in = $fopen("./results/in_data.txt", "r");
    file_out = $fopen("./out_data.txt", "w+");
    err = $ferror(file_in, err_str);
    write_ptr = 0;
    read_ptr = 0;
    empty = 1'b0;
    $fscanf(file_in, "%d", left_din);
    $fscanf(file_in, "%d", right_din);
    if (!err) begin
        while ($feof(file_in) == 0) begin
            wait(read_en) begin
                read_ptr = read_ptr + 1;
                $fscanf(file_in, "%d", left_din);
                $fscanf(file_in, "%d", right_din);
                empty = 1'b0;
            end
            wait(write_en) begin
                $fdisplay(file_out, $signed(ch1_dout));
                $fdisplay(file_out, $signed(ch2_dout));
                write_ptr = write_ptr + 1;
            end
        end
    end
    # 200000 $finish;
end

initial begin
    $dumpfile("dsp.vcd");
    $dumpvars(0, dsp_tb);
end


endmodule
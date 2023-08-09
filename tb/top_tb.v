module top_tb(
    SVBout,
    STBout,
    SVCout,
    STCout
);

// io for testbench
output [17:0]        SVBout;
output [5:0]         SVCout;
output [17:0]        STBout;
output [5:0]         STCout;
wire   [17:0]        SVBout;
wire   [5:0]         SVCout;
wire   [17:0]        STBout;
wire   [5:0]         STCout;
wire                 i2c_sdaout;
wire                 i2c_sdaout_en;

// variants in testbench
reg                  m_clk;
reg                  rst_n;
reg                  i2s_sck;
reg                  i2s_sdin;
reg                  i2s_lrclk;
reg                  i2c_scl;
reg                  i2c_sdain;
reg                  rm_data;
reg signed [31:0]    left_data;
reg signed [31:0]    right_data;
reg        [63:0]    frame_data;
reg        [7:0]     byte_data;

parameter D_CLK_PERIOD   = 10.17;     // 49.152 MHz MCLK
parameter I2S_BCLK_PERIOD = 162.76;   // 48 kHz * 64 = 3.072Mhz I2S BCLK
parameter I2S_HOLD_PERIOD = 60;       // negedge hold time for setup time
parameter I2C_SCLK_PERIOD = 5000;  // 100 kHz I2C SCLK
parameter I2C_HOLD_PERIOD = 2000;
parameter I2C_SLAVE_ADDR  = 7'b0010110;

integer            i;
integer            k;
integer            config_in;
integer            data_in;
integer            err;
integer            err_str;
integer            byte_num;

Dig_top                 top_dut (
    .m_clk              (m_clk),
    .rst_n              (rst_n),
    .i2s_sck            (i2s_sck),
    .i2s_sdin           (i2s_sdin),
    .i2s_lrclk          (i2s_lrclk),
    .i2c_scl            (i2c_scl),
    .i2c_sdain          (i2c_sdain),
    .i2c_sdaout         (i2c_sdaout),
    .i2c_sdaout_en      (i2c_sdaout_en),
    .SVBout             (SVBout),
    .STBout             (STBout),
    .SVCout             (SVCout),
    .STCout             (STCout)
);

always #D_CLK_PERIOD m_clk <= ~m_clk;

//************************************************
//         I2C Sim Functions
//************************************************
// send i2c start function
// sda fall edge when sck is 1
task start;
    i2c_sdain <= 'b0;
    #(I2C_HOLD_PERIOD);
    i2c_scl <= 'b0;
endtask

// send i2c stop function
// sda rise edge when sck is 1
task stop;
    #(I2C_SCLK_PERIOD);
    i2c_scl <= 'b1;
    #(I2C_HOLD_PERIOD);
    i2c_sdain <= 'b1;
    #5000;
endtask

task tx_byte(
    input [7:0]  data
);
    // send data
    for (i=7; i>=0; i=i-1) begin
    #(I2C_HOLD_PERIOD);
    i2c_sdain <= data[i];
    #(I2C_SCLK_PERIOD-I2C_HOLD_PERIOD);
    i2c_scl <= 'b1;
    #(I2C_SCLK_PERIOD);
    i2c_scl <= 'b0;
    end
    #(I2C_HOLD_PERIOD);
    i2c_sdain <= 'b0;
    // receive ack
    // dont check whether is correct here
    #(I2C_SCLK_PERIOD-I2C_HOLD_PERIOD);
    i2c_scl <= 'b1;
    #(I2C_SCLK_PERIOD);
    i2c_scl <= 'b0;
endtask;

// dont need rx byte here


//************************************************
//         I2S Sim Functions
//************************************************

task send_i2s_frame(
    input [63:0]    data,
    input           remainder
);
    i2s_sck <= 'b0;
    i2s_lrclk <= 'b0;
    #(I2S_HOLD_PERIOD);
    i2s_sdin <= remainder;
    #(I2S_BCLK_PERIOD-I2S_HOLD_PERIOD);
    i2s_sck <= 'b1;
    #(I2S_BCLK_PERIOD);
    i2s_sck <= 'b0;
    #(I2S_HOLD_PERIOD);
    
    for (i=30; i>=0; i=i-1) begin
    i2s_sdin <= data[33+i];
    #(I2S_BCLK_PERIOD-I2S_HOLD_PERIOD);
    i2s_sck <= 1'b1;
    #(I2S_BCLK_PERIOD);
    i2s_sck <= 'b0;
    #(I2S_HOLD_PERIOD);
    end

    i2s_lrclk <= 'b1;
    for (i=30; i>=0; i=i-1) begin
    i2s_sdin <= data[2+i];
    #(I2S_BCLK_PERIOD-I2S_HOLD_PERIOD);
    i2s_sck <= 1'b1;
    #(I2S_BCLK_PERIOD);
    i2s_sck <= 'b0;
    #(I2S_HOLD_PERIOD);
    end

    i2s_sdin <= data[1];
    #(I2S_BCLK_PERIOD-I2S_HOLD_PERIOD);
    i2s_sck <= 'b1;
    #(I2S_BCLK_PERIOD);
    i2s_sck <= 'b0;

endtask

// reset
initial begin
    m_clk <= 'b0;
    rst_n <= 'b0;
    i2c_scl <= 'b1;
    i2c_sdain <= 'b1;
    i2s_sck <= 'b1;
    i2s_sdin <= 'b1;
    i2s_lrclk <= 'b1;
    rm_data <= 'b0;

    // reset end
    #30000;
    rst_n <= 'b1;

    #200;

    //start configure now
    fork
        config_in = $fopen("../sim_script/config.txt", "r");
        while ($feof(config_in) == 0) begin
            $fscanf(config_in, "%d", byte_num);
            start;
            tx_byte({I2C_SLAVE_ADDR, 1'b0}); //send slave address and write
            for(k=0; k<byte_num; k=k+1) begin
                $fscanf(config_in, "%d", byte_data);
                tx_byte(byte_data);
            end
            byte_data = 'b0;
            stop;
        end
    join
    #100;

    data_in = $fopen("../sim_script/in_data.txt", "r");
    while (1) begin
        while ($feof(data_in) == 0) begin
            $fscanf(data_in, "%d", left_data);
            $fscanf(data_in, "%d", right_data);
            frame_data = {left_data, right_data};
            send_i2s_frame(frame_data, rm_data);
            rm_data = frame_data[0];
        end
        data_in = $fopen("../sim_script/in_data.txt", "r");
    end

end

// test main
initial begin
    #4000000;
    $finish;
end

initial begin
    $dumpfile("dsp.vcd");
    $dumpvars(0, top_tb);
end

endmodule
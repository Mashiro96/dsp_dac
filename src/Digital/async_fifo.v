module asyncfifo #(
    parameter DWIDTH = 32,
    parameter AWIDTH = 4
) (
    wdata,
    write_en,
    wclk,
    rst_n,
    full,
    rdata,
    read_en,
    rclk,
    empty
);

parameter DEPTH = 2 ** AWIDTH;

input                  rst_n;
// write port
input  [DWIDTH-1:0]    wdata;
input                  write_en;
input                  wclk;
output                 full;

// read port
output [DWIDTH-1:0]    rdata;
input                  rclk;
input                  read_en;
output                 empty;

reg                    empty;
reg                    full;
reg    [DWIDTH-1:0]    fifo_mem[0:DEPTH-1];
reg    [AWIDTH:0]      waddr;
reg    [AWIDTH:0]      raddr;
reg    [AWIDTH:0]      w_raddr_gre_d1;
reg    [AWIDTH:0]      w_raddr_gre_d2;
reg    [AWIDTH:0]      r_waddr_gre_d1;
reg    [AWIDTH:0]      r_waddr_gre_d2;

wire   [AWIDTH:0]      waddr_nxt;
wire   [AWIDTH:0]      raddr_nxt;
wire   [AWIDTH:0]      waddr_gre;
wire   [AWIDTH:0]      raddr_gre;
wire   [AWIDTH:0]      waddr_nxt_gre;
wire   [AWIDTH:0]      raddr_nxt_gre;
wire   [DWIDTH-1:0]    rdata;

//**********************************************************
//                    main logic
//**********************************************************

always @(posedge wclk or negedge rst_n) begin
    if(!rst_n)
        waddr <= 'b0;
    else
        waddr <= waddr_nxt;
end

always @(posedge wclk or negedge rst_n) begin
    if (!rst_n) begin
        w_raddr_gre_d1 <= 'b0;
        w_raddr_gre_d2 <= 'b0;
    end
    else begin
        w_raddr_gre_d1 <= raddr_gre;
        w_raddr_gre_d2 <= w_raddr_gre_d1;
    end
end

assign waddr_nxt = (write_en && !full) ? waddr + 'b1 : waddr;
assign waddr_gre = waddr ^ {1'b0, waddr[AWIDTH:1]};
assign waddr_nxt_gre = waddr_nxt ^ {1'b0, waddr[AWIDTH:1]};


always @(posedge wclk or negedge rst_n) begin
    if (!rst_n)
        full <= 1'b0;
    else
        full <= (waddr_nxt_gre[AWIDTH-2:0] == w_raddr_gre_d2[AWIDTH-2:0])
             && (waddr_nxt_gre[AWIDTH:AWIDTH-1] == ~w_raddr_gre_d2[AWIDTH:AWIDTH-1]);
end

always @(posedge wclk) begin
    if (write_en && !full)
        fifo_mem[waddr[AWIDTH-1:0]] <= wdata;
end

always @(posedge rclk or negedge rst_n) begin
    if(!rst_n)
        raddr <= 'b0;
    else
        raddr <= raddr_nxt;
end

always @(posedge rclk or negedge rst_n) begin
    if (!rst_n) begin
        r_waddr_gre_d1 <= 'b0;
        r_waddr_gre_d2 <= 'b0;
    end
    else begin
        r_waddr_gre_d1 <= waddr_gre;
        r_waddr_gre_d2 <= r_waddr_gre_d1;
    end
end

assign raddr_nxt = (read_en && !empty) ? raddr + 'b1 : raddr;
assign raddr_gre = raddr ^ {1'b0, raddr[AWIDTH:1]};
assign raddr_nxt_gre = raddr_nxt ^ {1'b0, raddr[AWIDTH:1]};

always @ (posedge rclk or negedge rst_n) begin
    if(!rst_n)
        empty <= 1'b1;
    else
        empty <= (raddr_nxt_gre == r_waddr_gre_d2);
end

assign rdata = fifo_mem[raddr[AWIDTH-1:0]];

endmodule
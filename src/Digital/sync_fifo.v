module syncfifo #(
    parameter DWIDTH = 32,
    parameter AWIDTH = 4
) (
    wdata,
    write_en,
    clk,
    rst_n,
    full,
    rdata,
    read_en,
    empty
);

parameter DEPTH = 2 ** AWIDTH;

input                  clk;
input                  rst_n;
// write port
input  [DWIDTH-1:0]    wdata;
input                  write_en;
output                 full;

// read port
output [DWIDTH-1:0]    rdata;
input                  read_en;
output                 empty;

reg                    empty;
reg                    full;
reg    [DWIDTH-1:0]    fifo_mem[0:DEPTH-1];
reg    [AWIDTH:0]      waddr;
reg    [AWIDTH:0]      raddr;

wire   [AWIDTH:0]      waddr_nxt;
wire   [AWIDTH:0]      raddr_nxt;
wire   [DWIDTH-1:0]    rdata;

//**********************************************************
//                    main logic
//**********************************************************

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        waddr <= 'b0;
        raddr <= 'b0;
    end
    else begin
        waddr <= waddr_nxt;
        raddr <= raddr_nxt;
    end
end

assign waddr_nxt = (write_en && !full) ? waddr + 'b1 : waddr;
assign raddr_nxt = (read_en && !empty) ? raddr + 'b1 : raddr;

always @(posedge clk) begin
    if (write_en && !full)
        fifo_mem[waddr[AWIDTH-1:0]] <= wdata;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        empty <= 1'b1;
        full <= 1'b0;
    end
    else begin
        empty <= waddr_nxt == raddr_nxt;
        full <= (waddr_nxt[AWIDTH] ^ raddr_nxt[AWIDTH]) && (waddr_nxt[AWIDTH-1:0] == raddr_nxt[AWIDTH-1:0]);
    end
end

assign rdata = fifo_mem[raddr[AWIDTH-1:0]];

endmodule
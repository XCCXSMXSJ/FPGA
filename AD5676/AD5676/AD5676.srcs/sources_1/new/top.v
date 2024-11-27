`timescale 1ns / 1ps


module top(
    input           sys_clk,

    output          rst_n,
    output          SCLK,
    output          SDI,   
    output          SYNC_n,
    output          LDAC_n

    );

    wire   [15:0]  ch_data0;
    wire   [15:0]  ch_data1;
    wire   [15:0]  ch_data2;
    wire   [15:0]  ch_data3;
    wire   [15:0]  ch_data4;
    wire   [15:0]  ch_data5;
    wire   [15:0]  ch_data6;
    wire   [15:0]  ch_data7;
    wire           data_valid;

vio_0 vio_0_inst (
  .clk(sys_clk),                // input wire clk
  .probe_out0(ch_data0),  // output wire [15 : 0] probe_out0
  .probe_out1(ch_data1),  // output wire [15 : 0] probe_out1
  .probe_out2(ch_data2),  // output wire [15 : 0] probe_out2
  .probe_out3(ch_data3),  // output wire [15 : 0] probe_out3
  .probe_out4(ch_data4),  // output wire [15 : 0] probe_out4
  .probe_out5(ch_data5),  // output wire [15 : 0] probe_out5
  .probe_out6(ch_data6),  // output wire [15 : 0] probe_out6
  .probe_out7(ch_data7),  // output wire [15 : 0] probe_out7
  .probe_out8(data_valid)  // output wire [0 : 0] probe_out8
);


 AD5676#
(
    .SYS_CLK_FREQ       (8'd50),
    .CHANNEL            (8'b1111_1111)
) ad5676_inst(
    .sys_clk           (sys_clk),
    .sys_rst_n         (1'b1),

    .rst_n             (rst_n),
    .SCLK              (SCLK),
    .SDI               (SDI),
    .SYNC_n            (SYNC_n),
    .LDAC_n            (LDAC_n),

    .ch_data0          (ch_data0),
    .ch_data1          (ch_data1),
    .ch_data2          (ch_data2),
    .ch_data3          (ch_data3),
    .ch_data4          (ch_data4),
    .ch_data5          (ch_data5),
    .ch_data6          (ch_data6),
    .ch_data7          (ch_data7),
    .data_valid        (data_valid)
    );











endmodule

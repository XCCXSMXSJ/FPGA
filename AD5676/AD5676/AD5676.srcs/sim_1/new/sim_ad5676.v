`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/28 15:46:50
// Design Name: 
// Module Name: sim_ad5676
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sim_ad5676(

    );

reg     sys_clk = 1'b0;
always #10 sys_clk <= ~sys_clk;

reg     data_valid = 1'b0;

initial begin
    data_valid <= 1'b0;

    #100
    data_valid <= 1'b1;

end

AD5676#
(
    .SYS_CLK_FREQ (8'd50),
    .CHANNEL (8'b1111_0110)
) ad5676_inst(
    .sys_clk        (sys_clk),
    .sys_rst_n      (1'b1),

    .rst_n(),
    .SCLK(),
    .SDI(),
    .SYNC_n(),
    .LDAC_n(),

    .ch_data0(16'h0000),
    .ch_data1(16'h1111),
    .ch_data2(16'h2222),
    .ch_data3(16'h3333),
    .ch_data4(16'h4444),
    .ch_data5(16'h5555),
    .ch_data6(16'h6666),
    .ch_data7(16'h7777),
    .data_valid(data_valid)
    );






endmodule

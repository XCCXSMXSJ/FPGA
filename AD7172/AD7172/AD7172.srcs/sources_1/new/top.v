module top(
    input           sys_clk,
    // input           sys_rst_n,

    output          SCLK,
    input           SDI,
    output          SDO,
    output          CS_n

);


    wire  [23:0]  AIN4;
    wire  [23:0]  AIN3;
    wire  [23:0]  AIN2;
    wire  [23:0]  AIN1;

    wire		  data4_valid;//ch3数据有效，同时可以表示ch0 -> ch3一个周期的循环结束

    wire          sys_rst_n;

vio_0 vio_0_inst (
  .clk(sys_clk),                // input wire clk
  .probe_out0(sys_rst_n)  // output wire [0 : 0] probe_out0
);


 AD7172#
(
    .SYS_CLK_FREQ(8'd50),
    //16bit CFG :1bit 使能； 1bit none； 2bit 选择寄存器组； 2bit none； 5bit 正端； 5bit 负端
    .CHANNEL0_CFG({1'b1, 1'b0, 2'b00, 2'b00, 5'b00001, 5'b00000}),//AIN1
    .CHANNEL1_CFG({1'b1, 1'b0, 2'b00, 2'b00, 5'b00010, 5'b00000}),//AIN2
    .CHANNEL2_CFG({1'b1, 1'b0, 2'b00, 2'b00, 5'b00011, 5'b00000}),//AIN3
    .CHANNEL3_CFG({1'b1, 1'b0, 2'b00, 2'b00, 5'b00100, 5'b00000})//AIN4
) ad7172_inst(

    .sys_clk 		(sys_clk),
    .sys_rst_n		(sys_rst_n),

    .SCLK 			(SCLK),
    .SDI 			(SDI ),
    .SDO 			(SDO ),
    .CS_n 			(CS_n),

    .AIN4			(AIN4),
    .AIN3			(AIN3),
    .AIN2			(AIN2),
    .AIN1			(AIN1),
    .data4_valid	(data4_valid)//ch3数据有效，同时可以表示ch0 -> ch3一个周期的循环结束
);


endmodule
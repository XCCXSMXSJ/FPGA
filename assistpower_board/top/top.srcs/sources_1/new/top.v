`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/19 09:10:45
// Design Name: 
// Module Name: top
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
// 辅助电源板的相关内容
//////////////////////////////////////////////////////////////////////////////////


module top(
        input       sys_clk,

        inout       tla2024_sda,
        output      tla2024_scl,

        output      ad5024_sclk_1,
        output      ad5024_sdin_1,
        output      ad5024_ldac_n_1,
        output      ad5024_sync_n_1,

        output      ad5024_sclk_2,
        output      ad5024_sdin_2,
        output      ad5024_ldac_n_2,
        output      ad5024_sync_n_2,

        output      ad5024_sclk_3,
        output      ad5024_sdin_3,
        output      ad5024_ldac_n_3,
        output      ad5024_sync_n_3,

        output      EN_LTM,
        output      EN_FIL1,
        output      EN_FIL2
    );






wire                scl_0;
wire                cs_2024_0;
wire                i_sda_2024_0;
wire                o_sda_2024_0;
wire                data_valid_0;
wire    [15:0]      data1_0;
wire    [15:0]      data2_0;
wire    [15:0]      data3_0;
wire    [15:0]      data4_0;

wire                scl_1;
wire                cs_2024_1;
wire                i_sda_2024_1;
wire                o_sda_2024_1;
wire                data_valid_1;
wire    [15:0]      data1_1;
wire    [15:0]      data2_1;
wire    [15:0]      data3_1;
wire    [15:0]      data4_1;

wire                scl_2;
wire                cs_2024_2;
wire                i_sda_2024_2;
wire                o_sda_2024_2;
wire                data_valid_2;
wire    [15:0]      data1_2;
wire    [15:0]      data2_2;
wire    [15:0]      data3_2;
wire    [15:0]      data4_2;


wire    [15:0]      daData1_1;
wire    [15:0]      daData2_1;
wire    [15:0]      daData3_1;
wire    [15:0]      daData4_1;
wire                da_valid_1;

wire    [15:0]      daData1_2;
wire    [15:0]      daData2_2;
wire    [15:0]      daData3_2;
wire    [15:0]      daData4_2;
wire                da_valid_2;

wire    [15:0]      daData1_3;
wire    [15:0]      daData2_3;
wire    [15:0]      daData3_3;
wire    [15:0]      daData4_3;
wire                da_valid_3;


vio_0 vio_0_inst (
  .clk(sys_clk),                  // input wire clk
  .probe_out0(daData1_1),    // output wire [15 : 0] probe_out0
  .probe_out1(daData2_1),    // output wire [15 : 0] probe_out1
  .probe_out2(daData3_1),    // output wire [15 : 0] probe_out2
  .probe_out3(daData4_1),    // output wire [15 : 0] probe_out3
  .probe_out4(da_valid_1),    // output wire [0 : 0] probe_out4
  .probe_out5(daData1_2),    // output wire [15 : 0] probe_out5
  .probe_out6(daData2_2),    // output wire [15 : 0] probe_out6
  .probe_out7(daData3_2),    // output wire [15 : 0] probe_out7
  .probe_out8(daData4_2),    // output wire [15 : 0] probe_out8
  .probe_out9(da_valid_2),    // output wire [0 : 0] probe_out9
  .probe_out10(daData1_3),  // output wire [15 : 0] probe_out10
  .probe_out11(daData2_3),  // output wire [15 : 0] probe_out11
  .probe_out12(daData3_3),  // output wire [15 : 0] probe_out12
  .probe_out13(daData4_3),  // output wire [15 : 0] probe_out13
  .probe_out14(da_valid_3),  // output wire [0 : 0] probe_out14
  .probe_out15(EN_LTM),    // output wire [0 : 0] probe_out15
  .probe_out16(EN_FIL1),    // output wire [0 : 0] probe_out16
  .probe_out17(EN_FIL2)    // output wire [0 : 0] probe_out17
);

ila_0 ila_0_inst (
    .clk(sys_clk), // input wire clk


    .probe0(data_valid_0), // input wire [0:0]  probe0  
    .probe1(data1_0), // input wire [15:0]  probe1 
    .probe2(data2_0), // input wire [15:0]  probe2 
    .probe3(data3_0), // input wire [15:0]  probe3 
    .probe4(data4_0), // input wire [15:0]  probe4 
    .probe5(data_valid_1), // input wire [0:0]  probe5 
    .probe6(data1_1), // input wire [15:0]  probe6 
    .probe7(data2_1), // input wire [15:0]  probe7 
    .probe8(data3_1), // input wire [15:0]  probe8 
    .probe9(data4_1), // input wire [15:0]  probe9 
    .probe10(data_valid_2), // input wire [0:0]  probe10 
    .probe11(data1_2), // input wire [15:0]  probe11 
    .probe12(data2_2), // input wire [15:0]  probe12 
    .probe13(data3_2), // input wire [15:0]  probe13 
    .probe14(data4_2) // input wire [15:0]  probe14
);
reg     [31:0]      cnt=32'd0;
reg                 start_sample_1 = 1'b0;
reg                 start_sample_2 = 1'b0;
reg                 start_sample_3 = 1'b0;
always@(posedge sys_clk)begin
    if(data_valid_0||data_valid_1||data_valid_2)begin
        cnt<=cnt+1'b1;
        start_sample_3<=1'b0;
    end else if(cnt>=4'd3)
        cnt<=4'd0;
    else if(cnt==4'd2)begin
        start_sample_1<=1'b0;
        start_sample_2<=1'b0;
        start_sample_3<=1'b1;
    end else if(cnt==4'd0)begin
        start_sample_1<=1'b1;
        start_sample_2<=1'b0;
        start_sample_3<=1'b0;
    end else if(cnt==4'd1)begin
        start_sample_1<=1'b0;
        start_sample_2<=1'b1;
        start_sample_3<=1'b0;
    end
end

   tla2024
#(
    .SYS_CLK_FREQ          ( 8'd50    ) ,                 
    .ADDR_CHIP             ( 7'b1001_000),           
    .WR                    ( 1'b0       ),                 
    .RD                    ( 1'b1       ),               
    .CHANNEL_NUM           ( 4'd4       ),                  
    .DATA_CONFIG_CHANEL1   ( 16'b1_100_010_0_111_00011),    
    .DATA_CONFIG_CHANEL2   ( 16'b1_101_010_0_111_00011),    
    .DATA_CONFIG_CHANEL3   ( 16'b1_110_010_0_111_00011),    
    .DATA_CONFIG_CHANEL4   ( 16'b1_111_010_0_111_00011)    
)
tla2024_0
(
    .sys_clk               (sys_clk),
    .i_rd_valid            ( start_sample_1),
    .o_data1               ( data1_0 ),  
    .o_data2               ( data2_0 ),  
    .o_data3               ( data3_0 ),  
    .o_data4               ( data4_0 ),  
                
    .i_sda                 (  i_sda_2024_0          ),
    .o_sda                 (  o_sda_2024_0          ),
    .o_cs                  (  cs_2024_0             ),
    .o_scl                 (  scl_0                 ),
    .o_valid               (  data_valid_0          )
    ); 
 

   tla2024
#(
    .SYS_CLK_FREQ          ( 8'd50     ) ,                 
    .ADDR_CHIP             ( 7'b1001_001),           
    .WR                    ( 1'b0       ),                 
    .RD                    ( 1'b1       ),               
    .CHANNEL_NUM           ( 4'd4       ),                  
    .DATA_CONFIG_CHANEL1   ( 16'b1_100_010_0_111_00011),    
    .DATA_CONFIG_CHANEL2   ( 16'b1_101_010_0_111_00011),    
    .DATA_CONFIG_CHANEL3   ( 16'b1_110_010_0_111_00011),    
    .DATA_CONFIG_CHANEL4   ( 16'b1_111_010_0_111_00011)    
)
tla2024_1
(
    .sys_clk               (sys_clk),
    .i_rd_valid            ( start_sample_2    ),
    .o_data1               ( data1_1 ),  
    .o_data2               ( data2_1 ),  
    .o_data3               ( data3_1 ),  
    .o_data4               ( data4_1 ),  
                
    .i_sda                 (  i_sda_2024_1          ),
    .o_sda                 (  o_sda_2024_1          ),
    .o_cs                  (  cs_2024_1             ),
    .o_scl                 (  scl_1                 ),
    .o_valid               (  data_valid_1          )
    ); 
 

   tla2024
#(
    .SYS_CLK_FREQ          ( 8'd50     ) ,                 
    .ADDR_CHIP             ( 7'b1001_011),           
    .WR                    ( 1'b0       ),                 
    .RD                    ( 1'b1       ),               
    .CHANNEL_NUM           ( 4'd4       ),                  
    .DATA_CONFIG_CHANEL1   ( 16'b1_100_010_0_111_00011),    
    .DATA_CONFIG_CHANEL2   ( 16'b1_101_010_0_111_00011),    
    .DATA_CONFIG_CHANEL3   ( 16'b1_110_010_0_111_00011),    
    .DATA_CONFIG_CHANEL4   ( 16'b1_111_010_0_111_00011)    
)
tla2024_2
(
    .sys_clk               (sys_clk),
    .i_rd_valid            ( start_sample_3    ),
    .o_data1               ( data1_2 ),  
    .o_data2               ( data2_2 ),  
    .o_data3               ( data3_2 ),  
    .o_data4               ( data4_2 ),  
                
    .i_sda                 (  i_sda_2024_2          ),
    .o_sda                 (  o_sda_2024_2          ),
    .o_cs                  (  cs_2024_2             ),
    .o_scl                 (  scl_2                 ),
    .o_valid               (  data_valid_2          )
    ); 
 
 wire tla2024_sdo;
 wire tla2024_sdi;
 wire tla2024_cs;


 assign tla2024_sdi =  (o_sda_2024_0 & o_sda_2024_1 & o_sda_2024_2);
 assign tla2024_cs =   (cs_2024_0 | cs_2024_1 |cs_2024_2);
 assign i_sda_2024_0  = tla2024_sdo;
 assign i_sda_2024_1  = tla2024_sdo;
 assign i_sda_2024_2  = tla2024_sdo;
 assign tla2024_scl = scl_0 & scl_1 & scl_2;
 IOBUF #(
      .DRIVE(12), // Specify the output drive strength
      .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE" 
      .IOSTANDARD("DEFAULT"), // Specify the I/O standard
      .SLEW("SLOW") // Specify the output slew rate
  ) IOBUF_power_iic1 (
      .O(tla2024_sdo),     // Buffer output
      .IO(tla2024_sda),   // Buffer inout port (connect directly to top-level port)
      .I(tla2024_sdi),     // Buffer input
      .T(tla2024_cs)      // 3-state enable input, high=input, low=output
  ); 


 ad5024 ad5024_1(
        .sys_clk        (sys_clk),
        .sys_rst_n      (),
        .i_data_a_1     (daData1_1),
        .i_data_a_2     (daData2_1),
        .i_data_a_3     (daData3_1),
        .i_data_a_4     (daData4_1),
        .data_valid     (da_valid_1), 
        
        .sclk           (ad5024_sclk_1),
        .sdin           (ad5024_sdin_1),
        .ldac_n         (ad5024_ldac_n_1),
        .sync_n         (ad5024_sync_n_1)
    );  

 ad5024 ad5024_2(
        .sys_clk        (sys_clk),
        .sys_rst_n      (),
        .i_data_a_1     (daData1_2),
        .i_data_a_2     (daData2_2),
        .i_data_a_3     (daData3_2),
        .i_data_a_4     (daData4_2),
        .data_valid     (da_valid_2), 
        
        .sclk           (ad5024_sclk_2),
        .sdin           (ad5024_sdin_2),
        .ldac_n         (ad5024_ldac_n_2),
        .sync_n         (ad5024_sync_n_2)
    );  


ad5024 ad5024_3(
        .sys_clk        (sys_clk),
        .sys_rst_n      (),
        .i_data_a_1     (daData1_3),
        .i_data_a_2     (daData2_3),
        .i_data_a_3     (daData3_3),
        .i_data_a_4     (daData4_3),
        .data_valid     (da_valid_3), 
        
        .sclk           (ad5024_sclk_3),
        .sdin           (ad5024_sdin_3),
        .ldac_n         (ad5024_ldac_n_3),
        .sync_n         (ad5024_sync_n_3)
    );  
endmodule

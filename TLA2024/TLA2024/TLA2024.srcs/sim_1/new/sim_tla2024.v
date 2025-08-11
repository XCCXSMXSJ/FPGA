`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/06 13:35:48
// Design Name: 
// Module Name: sim_tla2024
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


module sim_tla2024(

    );

wire sdi;
assign sdi = 1'b0;
reg sample_go = 1'b0;
reg sys_clk = 1'b0;
always #5 sys_clk <= ~sys_clk;
initial begin
    #200 sample_go = 1'b1;
    #30 sample_go = 1'b0;

end


reg     [3:0]       cnt=4'd0;
reg                 start_sample_1 = 1'b0;
reg                 start_sample_2 = 1'b0;
reg                 start_sample_3 = 1'b0;

 TLA2024#
(
    .CLK_RFEQ  (8'd100),
    .CHIP_ADDR (7'b1001000),
    .CHANNEL   (4'b1111),
    .AIN0_cfg  (16'b1_100_010_1_111_00111),
    .AIN1_cfg  (16'b1_101_010_1_111_00111),
    .AIN2_cfg  (16'b1_110_010_1_111_00111),
    .AIN3_cfg  (16'b1_111_010_1_111_00111)
)
tla2024_0
(      
    .sys_clk        (sys_clk),
    .scl            (scl_0),
    .sdi            (i_sda_2024_0),
    .sdo            (o_sda_2024_0),
    .sda_ctrl       (cs_2024_0),

    .sample_go      (sample_go || data_valid_2),
    .AIN0           (read_ux),
    .AIN1           (read_u9pb),
    .AIN2           (read_u6yz),
    .AIN3           (power_tempreture1),
    .data_valid     (data_valid_0)
    );

  TLA2024#
(
    .CLK_RFEQ  (8'd100),
    .CHIP_ADDR (7'b1001001),
    .CHANNEL   (4'b1111),
    .AIN0_cfg  (16'b1_100_010_1_111_00111),
    .AIN1_cfg  (16'b1_101_010_1_111_00111),
    .AIN2_cfg  (16'b1_110_010_1_111_00111),
    .AIN3_cfg  (16'b1_111_010_1_111_00111)
)
tla2024_1
(      
    .sys_clk        (sys_clk),
    .scl            (scl_1),
    .sdi            (i_sda_2024_1),
    .sdo            (o_sda_2024_1),
    .sda_ctrl       (cs_2024_1),

    .sample_go      (data_valid_0),
    .AIN0           (read_u8com),
    .AIN1           (read_u5yc),
    .AIN2           (read_u2lh),
    .AIN3           (),
    .data_valid     (data_valid_1)
    );



  TLA2024#
(
    .CLK_RFEQ  (8'd100),
    .CHIP_ADDR (7'b1001011),
    .CHANNEL   (4'b1111),
    .AIN0_cfg  (16'b1_100_010_1_111_00111),
    .AIN1_cfg  (16'b1_101_010_1_111_00111),
    .AIN2_cfg  (16'b1_110_010_1_111_00111),
    .AIN3_cfg  (16'b1_111_010_1_111_00111)
)
tla2024_2
(      
    .sys_clk        (sys_clk),
    .scl            (scl_2),
    .sdi            (i_sda_2024_2),
    .sdo            (o_sda_2024_2),
    .sda_ctrl       (cs_2024_2),

    .sample_go      (data_valid_1),
    .AIN0           (read_filament_current),
    .AIN1           (read_inner_cage_current),
    .AIN2           (),
    .AIN3           (),
    .data_valid     (data_valid_2)
    );
 
 wire tla2024_sdo;
 wire tla2024_sdi;
 wire tla2024_cs;


 assign tla2024_sdi =  (o_sda_2024_0 & o_sda_2024_1 & o_sda_2024_2);
 assign tla2024_cs =   (cs_2024_0 | cs_2024_1 |cs_2024_2);
// assign i_sda_2024_0  = tla2024_sdo;
// assign i_sda_2024_1  = tla2024_sdo;
// assign i_sda_2024_2  = tla2024_sdo;
 assign i_sda_2024_0  = 0;
 assign i_sda_2024_1  = 0;
 assign i_sda_2024_2  = 0;
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




//TLA2024#
//(
//    .CLK_RFEQ  (8'd50),
//    .CHIP_ADDR (7'b1001000),
//    .CHANNEL   (4'b1111),
//    .AIN0_cfg  (16'b1_100_010_1_111_00111),
//    .AIN1_cfg  (16'b1_101_010_1_111_00111),
//    .AIN2_cfg  (16'b1_110_010_1_111_00111),
//    .AIN3_cfg  (16'b1_111_010_1_111_00111)
//)
//TLA2024
//(      
//    .sys_clk        (sys_clk),
//    .scl            (scl),
//    .sdi            (sdi),
//    .sdo            (sdo),
//    .sda_ctrl       (sda_ctrl),

//    .sample_go      (sample_go),
//    .AIN0           (),
//    .AIN1           (),
//    .AIN2           (),
//    .AIN3           (),
//    .data_valid     ()
//    );
endmodule

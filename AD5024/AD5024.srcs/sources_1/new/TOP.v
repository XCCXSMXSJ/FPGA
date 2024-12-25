`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/07 08:58:05
// Design Name: 
// Module Name: TOP
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


module TOP(
    input                           sys_clk,
    
    output						    sclk,//======����ʱ��,
	output						    sdin,//=====�����====
	output						    ldac_n,//=====������Ĵ����е����ݸ��µ�DAC�Ĵ�����(���;͸���);���͡�
	
	output						    sync_n
    
    
    );
    
    wire            [15:0]          i_data_a_1;
    wire            [15:0]          i_data_a_2;
    wire            [15:0]          i_data_a_3;
    wire            [15:0]          i_data_a_4;
    wire                                data_valid;
    
    vio_0 your_instance_name (
  .clk(sys_clk),                // input wire clk
  .probe_out0(i_data_a_1),  // output wire [15 : 0] probe_out0
  .probe_out1(i_data_a_2),  // output wire [15 : 0] probe_out1
  .probe_out2(i_data_a_3),  // output wire [15 : 0] probe_out2
  .probe_out3(i_data_a_4),  // output wire [15 : 0] probe_out3
  .probe_out4(data_valid)  // output wire [0 : 0] probe_out4
);
    
    
    AD5024
     AD5024_inst(
	.sys_clk                    (sys_clk),
	.sys_rst_n                  (1'b1),
	.i_data_a_1                 (i_data_a_1),
	.i_data_a_2                 (i_data_a_2),
	.i_data_a_3                 (i_data_a_3),
	.i_data_a_4                 (i_data_a_4),
	.data_valid                 (data_valid), 
	
	.sclk                       (sclk),
	.sdin                       (sdin),
	.ldac_n                     (ldac_n),
	
	.sync_n                  	(sync_n)//=====�൱��CS
		
    );		
    
    
    
    
    
    
endmodule

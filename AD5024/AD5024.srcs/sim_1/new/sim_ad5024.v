`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/03 16:33:12
// Design Name: 
// Module Name: sim_ad5024
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


module sim_ad5024(

    );
    
    reg		sys_clk=1'b0;
    reg		data_valid=1'b0;
    
    always #10 sys_clk<=~sys_clk;
    
    initial begin
    #40000
    data_valid = 1'b1;
    
    
    end 
    
    
    
 AD5024 ad5024_inst(
.sys_clk(sys_clk),
.sys_rst_n(1'b1),
.i_data_a_1(16'h5555),
.i_data_a_2(16'h6666),//======
.i_data_a_3(16'h7777),
.i_data_a_4(16'h8888),//======
.data_valid(data_valid), 
       
.sclk(),
.sdin(),
.ldac_n(),
       
.sync_n()
		
    );		
    
    
    
    
    
endmodule

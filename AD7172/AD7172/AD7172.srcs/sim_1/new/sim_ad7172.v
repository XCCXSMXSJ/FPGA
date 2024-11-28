`timescale 1ns / 1ps


module sim_ad7172(

    );

reg sys_clk = 1'b0;
always #10 sys_clk <= ~sys_clk;
reg sdi = 1'b1;
reg sys_rst_n = 1'b1;
initial begin
#110000
sdi = 1'b0;
#5000
sys_rst_n = 1'b0;
#1000
sys_rst_n = 1'b1;


end


AD7172 ad7172_inst
(

    .sys_clk        (sys_clk),
    .sys_rst_n      (sys_rst_n),

    .SCLK           (),
    .SDI            (sdi),
    .SDO            (),
    .CS_n           (),

    .AIN4           (),
    .AIN3           (),
    .AIN2           (),
    .AIN1           ()

);












endmodule

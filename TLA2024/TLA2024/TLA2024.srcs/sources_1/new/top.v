`timescale 1ns / 1ps

module top(
        input       sys_clk,
        
        inout       sda,
        output      scl
    );
wire    rst_n;
wire    clk_100M;
wire    sdi;
wire    sdo;
wire    sda_ctrl;

reg [15:0]  cnt = 16'd0;
reg         sample_go = 1'b0;

always@(posedge sys_clk)begin
    if(rst_n)begin
        cnt <= 16'd0;
        sample_go <= 1'b0; 
    end else if(cnt >= 16'd60010)begin
        sample_go <= 1'b0; 
    end else if(cnt >= 16'd60000)begin
        cnt <= cnt + 1'b1;
        sample_go <= 1'b1; 
    end else begin
        cnt <= cnt + 1'b1;
        sample_go <= 1'b0;
    end 
end

TLA2024#
(
    .CLK_RFEQ  (8'd50),
    .CHIP_ADDR (7'b1001000),
    .CHANNEL   (4'b1111),
    .AIN0_cfg  (16'b1_100_010_1_111_00111),
    .AIN1_cfg  (16'b1_101_010_1_111_00111),
    .AIN2_cfg  (16'b1_110_010_1_111_00111),
    .AIN3_cfg  (16'b1_111_010_1_111_00111)
)
TLA2024
(      
    .sys_clk        (sys_clk),
    .scl            (scl),
    .sdi            (sdi),
    .sdo            (sdo),
    .sda_ctrl       (sda_ctrl),

    .sample_go      (1'b1),
    .AIN0           (),
    .AIN1           (),
    .AIN2           (),
    .AIN3           (),
    .data_valid     ()
    );
    
    
  IOBUF #(
    .DRIVE(12), // Specify the output drive strength
    .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE" 
    .IOSTANDARD("DEFAULT"), // Specify the I/O standard
    .SLEW("SLOW") // Specify the output slew rate
) IOBUF_Front_amplification (
    .O (sdi  ),     // Buffer output
    .IO(sda      ),   // Buffer inout port (connect directly to top-level port)
    .I (sdo  ),     // Buffer input
    .T (sda_ctrl   )      // 3-state enable input, high=input, low=output
); 
endmodule




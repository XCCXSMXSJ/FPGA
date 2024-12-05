module Top(
        input       sys_clk,
        
        inout       tla2024_sda,
        output      tla2024_scl,
        
        inout       pca9555_sda,
        output      pca9555_scl

);
wire        sda_ctrl;
wire        i_sda;
wire        o_sda;



wire                cs_2024;
wire                i_sda_2024;
wire                o_sda_2024;
wire                data_valid;
wire    [15:0]  data1;
wire    [15:0]  data2;
wire    [15:0]  data3;
wire    [15:0]  data4;


reg     [31:0]      cnt=32'd0;
reg                     ms=1'b0;
always@(posedge  sys_clk)begin
    if(cnt>=32'd50000)begin
        ms<=1'b1;
        cnt<=32'd0;
    end else begin
        ms<=1'b0;
        cnt<=cnt +1'b1;
    end

end 


pca9555 
VDB_IO(
.sys_clk         (sys_clk),

.i_sda           (i_sda),
.o_sda           (o_sda),
.scl                 (pca9555_scl),
.sda_ctrl        (sda_ctrl)
);

 IOBUF #(
	.DRIVE(12), // Specify the output drive strength
	.IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE" 
	.IOSTANDARD("DEFAULT"), // Specify the I/O standard
	.SLEW("SLOW") // Specify the output slew rate
) IOBUF_pca9555 (
	.O(i_sda),     // Buffer output
	.IO(pca9555_sda),   // Buffer inout port (connect directly to top-level port)
	.I(o_sda),     // Buffer input
	.T(sda_ctrl)      // 3-state enable input, high=input, low=output
);



   tla2024
#(
    .SYS_CLK_FREQ          ( 8'd100     ) ,                 
    .ADDR_CHIP             ( 7'b1001_000),           
    .WR                    ( 1'b0       ),                 
    .RD                    ( 1'b1       ),               
    .CHANNEL_NUM           ( 4'd4       ),                  
    .DATA_CONFIG_CHANEL1   ( 16'b1_100_010_0_111_00011),    
    .DATA_CONFIG_CHANEL2   ( 16'b1_101_010_0_111_00011),    
    .DATA_CONFIG_CHANEL3   ( 16'b1_110_010_0_111_00011),    
    .DATA_CONFIG_CHANEL4   ( 16'b1_111_010_0_111_00011)    
)
tla2024_inst
(
	.sys_clk               (sys_clk                   ),
	.i_rd_valid            ( ms      ),
    .o_tempre_data1               ( data1                ),  
    .o_tempre_data2               ( data2                  ),  
    .o_tempre_data3               (  data3              ),  
    .o_tempre_data4               (data4 ),  
                
	.i_sda                 (  i_sda_2024          ),
	.o_sda                 (  o_sda_2024          ),
	.o_cs                  (  cs_2024           ),
	.o_scl                 (    tla2024_scl        ),
    .o_valid               (data_valid          )
    ); 
 
 IOBUF #(
	.DRIVE(12), // Specify the output drive strength
	.IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE" 
	.IOSTANDARD("DEFAULT"), // Specify the I/O standard
	.SLEW("SLOW") // Specify the output slew rate
) IOBUF_tla2024 (
	.O(i_sda_2024),     // Buffer output
	.IO(tla2024_sda),   // Buffer inout port (connect directly to top-level port)
	.I(o_sda_2024),     // Buffer input
	.T(cs_2024)      // 3-state enable input, high=input, low=output
);


ila_0 ila_0_inst (
	.clk(sys_clk), // input wire clk


	.probe0(data1), // input wire [15:0]  probe0  
	.probe1(data2), // input wire [15:0]  probe1 
	.probe2(data3), // input wire [15:0]  probe2 
	.probe3(data4), // input wire [15:0]  probe3 
	.probe4(data_valid) // input wire [0:0]  probe4
);

endmodule
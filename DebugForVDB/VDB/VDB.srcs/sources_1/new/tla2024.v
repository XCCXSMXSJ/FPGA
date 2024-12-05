
module tla2024
#(
parameter [7:0] SYS_CLK_FREQ = 8'd50 ,                             //系统时钟频率，单位M
parameter [6:0] ADDR_CHIP = 7'b1001000,                            //器件地址
parameter       WR = 1'b0,                                         //读位配置，与器件地址合并在一起使用
parameter       RD = 1'b1,                                         //写位配置，与器件地址合并在一起使用
parameter [3:0] CHANNEL_NUM = 4'd4,                                //每一路IIC通道个数
parameter [15:0] DATA_CONFIG_CHANEL1 = 16'b0_100_010_0_111_00011,  //通道1配置参数
parameter [15:0] DATA_CONFIG_CHANEL2 = 16'b0_101_010_0_111_00011,  //通道2配置参数
parameter [15:0] DATA_CONFIG_CHANEL3 = 16'b0_110_010_0_111_00011,  //通道3配置参数
parameter [15:0] DATA_CONFIG_CHANEL4 = 16'b0_111_010_0_111_00011   //通道4配置参数
)
(
	input					sys_clk,
	input                   i_rd_valid,
    output      [15:0]      o_tempre_data1,
    output      [15:0]      o_tempre_data2,
    output      [15:0]      o_tempre_data3,
    output      [15:0]      o_tempre_data4,
   
    output                  o_busying,
	input                   i_sda,
	output                  o_sda,
	output                  o_cs,
	output reg              o_scl = 1,
    output                  o_valid 
    );
    reg		[17:0]		cnt_r;

localparam [7:0] addr_chip_w       = {ADDR_CHIP,WR};//8'h90;
localparam [7:0] addr_chip_r       = {ADDR_CHIP,RD};//8'h91;
localparam [7:0] addr_reg_r        = 8'h01;  
localparam [7:0] addr_reg_w        = 8'h00;  //==================修改
localparam [7:0] addr_reg          = 8'h01; 
 

reg	spi_sclk_orig_q1, spi_sclk_orig_q2, spi_sclk_orig_q3, spi_sclk_orig_q4 = 1'b0;
wire [8:0] cnt_clk ;
reg [8 :0] spi_sclk_orig_cnt = 8'd0;
reg spi_sclk_orig = 0;
reg [15:0] data_config = 16'b0_100_010_0_111_00011  ;
reg data_valid = 1'b0;
assign cnt_clk = {SYS_CLK_FREQ[7:0],1'b1};//,1'b1
assign o_valid = data_valid;


always @(posedge sys_clk)
begin
	if(spi_sclk_orig_cnt == (cnt_clk))begin		//将系统时钟分成固定250k的spi的配置时钟
		spi_sclk_orig <= ~spi_sclk_orig;
		spi_sclk_orig_cnt <= 0;
	end
	else begin
		spi_sclk_orig_cnt <= spi_sclk_orig_cnt + 1;
	end	
	spi_sclk_orig_q1 <= spi_sclk_orig;
	spi_sclk_orig_q2 <= spi_sclk_orig_q1;
	spi_sclk_orig_q3 <= spi_sclk_orig_q2;
	spi_sclk_orig_q4 <= spi_sclk_orig_q3;
end

wire sda_i ;
reg sda_cs = 0;
reg sda_o  = 1'b1;  
reg [7:0] iic_state = 8'd7;
reg       busying         = 1'b1;
reg [7:0] send_data_tmp   = 8'd0;
reg [15:0] data_in_tmp    = 8'd0;
reg [3:0] clk_cnt         = 4'd0;
reg [3:0] start_cnt       = 4'd0;
reg [3:0] rd_valid        = 4'd0;
reg       data_send_valid = 1'd0;

localparam [7:0] start     = 8'd1;
localparam [7:0] send_data = 8'd2;
localparam [7:0] ack_in    = 8'd3;
localparam [7:0] stop_iic  = 8'd4;
localparam [7:0] data_in   = 8'd5;
localparam [7:0] wait_iic  = 8'd6;
localparam [7:0] idle      = 8'd7;

reg [7:0]  send_data_state       = 8'd0;
reg        tempre_addr_transfer  = 1'b1;
reg [4:0]  bit_cnt               = 5'd0;
reg [15:0] tempre_data1          = 16'd0;
reg [15:0] tempre_data2          = 16'd0;
reg [15:0] tempre_data3          = 16'd0;
reg [15:0] tempre_data4          = 16'd0;

reg        stat_switch_iic       = 1'b0;
reg [5:0]  stop_cnt              = 6'd0;
reg        iic_ack               = 1'b1;

reg        data_ok               = 1'b0;
assign o_cs  = sda_cs;
assign o_sda = sda_o;
assign o_tempre_data1 = {4'd0,tempre_data1[15:4]};
assign o_tempre_data2 = {4'd0,tempre_data2[15:4]};
assign o_tempre_data3 = {4'd0,tempre_data3[15:4]};
assign o_tempre_data4 = {4'd0,tempre_data4[15:4]};
assign o_busying      = spi_sclk_orig;

always @(posedge sys_clk) begin
    rd_valid <= {rd_valid[2:0],i_rd_valid};
    if(rd_valid == 4'd1)begin
        data_send_valid <= 1'b1;
    end else if(busying == 1'b0)begin
        data_send_valid     <= 1'b0;
    end
end

always @(posedge sys_clk) begin    
    if((spi_sclk_orig_q1 ==2'b1) && (spi_sclk_orig_q2 == 1'b0))begin
        if(data_send_valid && busying)begin //for ready
            busying             <= 1'b0;
            tempre_addr_transfer<= 1'b1;
        end else if(iic_state == idle)begin 
            busying             <= 1'b1;
        end 

        case (iic_state)
        start : begin                           //start
            o_scl  <= 1'b1;
            sda_cs <= 1'b0;
            sda_o  <= 1'b0;
            clk_cnt        <= 4'd0;
            bit_cnt        <= 5'd0;
            stat_switch_iic<= 1'b0;
        end
        send_data : begin                           //enable clk
            if(clk_cnt >=4'd2)begin
                clk_cnt <= 4'd0;
            end else begin
                clk_cnt <= clk_cnt + 4'd1;
            end
            
            if(clk_cnt ==4'd0)begin             //时钟的下降沿
                o_scl  <= 1'b0;
            end else if(clk_cnt ==4'd1)begin    //数据的改变
                bit_cnt       <= bit_cnt + 5'd1;
                sda_o         <= send_data_tmp[7 - bit_cnt];
                stat_switch_iic <= 1'b0;        //置开关转换 0 置标志，1 清标志
            end else if(clk_cnt ==4'd2)begin    //时钟的上升沿
                o_scl  <= 1'b1;
            end
            
            if((bit_cnt >= 8'd8)&&(clk_cnt == 1'b0))begin 
                stat_switch_iic<= 1'b1; //置开关转换 0 置标志，1 清标志
                sda_cs         <= 1'b1;
                sda_o          <= 1'b0;
            end else begin
                sda_cs         <= 1'b0;
            end
        end
        ack_in : begin   //data ack bit
            if(clk_cnt >=4'd2)begin
                clk_cnt        <= 4'd0;
            end else begin
                clk_cnt <= clk_cnt + 4'd1;
            end
            
            if(clk_cnt ==4'd0)begin             //时钟的下降沿
                o_scl  <= 1'b0;
                stat_switch_iic<= 1'b1;         //置开关转换 0 置标志，1 清标志
                iic_ack <= i_sda;
            end else if(clk_cnt ==4'd1)begin    //数据的改变
                //状态改变，在下面
               stat_switch_iic<= 1'b0;          //置开关转换 0 置标志，1 清标志
            end else if(clk_cnt ==4'd2)begin    //时钟的上升沿
                o_scl  <= 1'b1;
            end
            bit_cnt        <= 5'd0;
         end
        stop_iic : begin          //stop
            if(clk_cnt >=4'd2)begin
                clk_cnt <= 4'd0;
            end else begin
                clk_cnt <= clk_cnt + 4'd1;
            end
            
            if(clk_cnt ==4'd0)begin             //时钟的下降沿
                sda_o  <= 1'b1;
                stat_switch_iic<= 1'b1;         //置开关转换 0 置标志，1 清标志
            end else if(clk_cnt ==4'd1)begin    //数据的改变
                sda_o  <= 1'b0;
                stat_switch_iic<= 1'b0;         //置开关转换 0 置标志，1 清标志
            end else if(clk_cnt ==4'd2)begin    //时钟的上升沿
                o_scl  <= 1'b1;
            end
            sda_cs         <= 1'b0;
            stop_cnt       <= 6'd0;
            data_ok        <= 1'b0;
        end
        data_in : begin  //data in
            if(clk_cnt >= 4'd2)begin
                clk_cnt <= 4'd0;
            end else begin
                clk_cnt <= clk_cnt + 4'd1;
            end
//            sda_cs      <= 1'b1;
            
            if(clk_cnt == 4'd0)begin             //时钟的下降沿
                o_scl  <= 1'b0;
            end else if(clk_cnt == 4'd1)begin    //数据的改变
                //状态改变，在下面
               stat_switch_iic<= 1'b0;          //置开关转换 0 置标志，1 清标志
               if(bit_cnt == 5'd8)begin
                    sda_o  <= 1'b0;
                    sda_cs <= 1'b0;
               end else if(bit_cnt == 5'd17) begin
                    sda_o  <= 1'b0;
                    sda_cs <= 1'b0;
               end else begin
                    sda_cs <= 1'b1;
                    sda_cs <= 1'b1;
               end
            end else if(clk_cnt == 4'd2)begin    //时钟的上升沿
                o_scl  <= 1'b1;
                if((bit_cnt == 5'd8)||(bit_cnt == 5'd17))begin
                    ;
                end else begin
                    data_in_tmp[15:0] <={data_in_tmp[14:0],i_sda} ;
                end
                bit_cnt          <= bit_cnt + 5'd1;
            end
            if((bit_cnt >= 5'd18)&&(clk_cnt == 1'b0))begin
                stat_switch_iic <= 1'b1;     //置开关转换 0 置标志，1 清标志
                data_ok         <= 1'b1;
            end else 
                data_ok         <= 1'b0;
            
        end
        wait_iic : begin  //wait
            if(clk_cnt >= 4'd2)begin
                clk_cnt <= 4'd0;
            end else begin
                clk_cnt <= clk_cnt + 4'd1;
            end
            stop_cnt <= stop_cnt + 6'd1;  
            if((clk_cnt == 4'd0))begin 
                if(send_data_state == 8'd6)begin
                     if((stop_cnt >=6'd50))begin
                        stat_switch_iic <= 1'b1;     //置开关转换 0 置标志，
                     end
                end else begin
                    if((stop_cnt >=6'd5))begin
                        stat_switch_iic <= 1'b1;     //置开关转换 0 置标志，
                    end
                end
            end else if((clk_cnt == 4'd1))begin 
               stat_switch_iic <= 1'b0;     //置开关转换 1 清标志
            end
        end
        idle : begin   //send data 高
            o_scl  <= 1'b1;
            sda_cs <= 1'b0;
            sda_o  <= 1'b1;
        end
        default : ;
        endcase
    end else begin
        data_ok <= 1'b0;
    end
    
end

reg [3:0] iic_chanel = 4'd0;
reg [1:0] start_iic = 2'b11;
always @(posedge sys_clk) begin
    //IIC状态之间的转换
    if((spi_sclk_orig_q2 ==1'b1) && (spi_sclk_orig_q3 == 1'b0))begin
        start_iic <= {start_iic[0],busying};
        if(start_iic == 2'b10)begin //for ready
            iic_state           <= start;
            send_data_state     <= 8'd1;
            start_cnt           <= 4'd0;
        end
        if(iic_state == start)begin
            start_cnt <= start_cnt + 4'd1;
            if(start_cnt > 0)
                iic_state      <= 8'd2;
        end
        if(stat_switch_iic == 1'b1)begin
            case(iic_state)
            send_data : begin
                if(bit_cnt == 8'd8)begin    //发送数据一个字节完成
                    iic_state <= ack_in;      //进入ack
                end  
            end
            ack_in : begin    //ack 后状态转变
                case(send_data_state)
                    1,2,3,5:begin       //继续发送数据
                        send_data_state <= send_data_state + 8'd1;
                        iic_state       <= send_data;
                    end
                    4:begin
                        iic_state  <= stop_iic;   //进入停止位
                    end
//                    5:begin
//                    	if(cnt_r>=18'd250_000)begin
//                    		send_data_state <= send_data_state + 8'd1;
//                        	iic_state       <= send_data;
//                        	cnt_r<=18'd0;
//                       end else 
//                       		cnt_r<=cnt_r+1'b1;
//                    end
                    6:begin
                        iic_state  <= stop_iic;   //进入停止位
                    end
                    7:begin                        //读数据，
                        iic_state    <= data_in;  
                    end
                default : ;
                endcase
                // 读取指令发送顺序： 90 ->01->  00  ->e3 写配置；90-> 00 -> 91 ->data1 -> data2；

            end
            stop_iic: begin //停止位完成后需要1、等待 
                iic_state <= wait_iic  ; 
            end
            data_in:begin
                if(bit_cnt == 8'd18)begin                 //读数据一个字节完成
                    iic_state <= stop_iic  ;                   //进入停止位
                end
            end
            wait_iic:begin 
                if(send_data_state <= 8'd6)begin
                    start_cnt <= 4'd0;
                    if(send_data_state == 8'd4)begin
//                    	if(cnt_r>=18'd250_000)begin//=================================
                        	send_data_state <= send_data_state + 8'd1;
                        	iic_state       <= start; 
//                        	cnt_r<=18'd0;
//                        end else 
//                        	cnt_r<=cnt_r+1'b1;
                    end if(send_data_state == 8'd6)begin
                        send_data_state <= send_data_state + 8'd1;
                        iic_state       <= start; 
                    end else begin
                        iic_state       <= 8'd1; 
                    end
                end else begin
                    if(iic_chanel < (CHANNEL_NUM -1))begin
                        iic_state           <= start;
                        send_data_state     <= 8'd1;
                    end else begin
                        iic_state           <= idle;   //idle
                    end
                end
            end
            default:;
            endcase
            
        end
        
    end
end

always @(posedge sys_clk) begin
    //设置需要发送到IIC的数据
    case(send_data_state)
    1:begin
        send_data_tmp  <= addr_chip_w;//先写器件地址 90
    end
    2:begin
        send_data_tmp  <= addr_reg_r; //写寄存器地址01
    end 
    3:begin
        send_data_tmp  <= data_config[15:8]; //设置寄存器值，
    end
    4:begin
        send_data_tmp  <= data_config[7:0];//设置寄存器值，
    end//配置完成
    5:begin
        send_data_tmp   <= addr_chip_w; // 写需要读状态寄存器地址
    end
    6:begin
        send_data_tmp  <= addr_reg_w;//读状态寄存器地址
    end 
    //上面已经将读取数据准备工作做完，完成后读取后面的数据
    7:begin
        send_data_tmp  <= addr_chip_r;//读状态寄存器地址
    end
    default:;
    endcase
end 

 //通道个数的累加，在等待间隙改变数据
always @(posedge sys_clk) begin
    if((spi_sclk_orig_q2 ==1'b1) && (spi_sclk_orig_q3 == 1'b0))begin
        if(stat_switch_iic == 1'b1)begin
            if(iic_state == wait_iic  )begin
                if(send_data_state > 8'd6)begin
                    iic_chanel <= iic_chanel + 4'd1;
                end
            end
        end else if(iic_state == idle)begin
            iic_chanel <=  4'd0;
        end
    end else if(iic_state == idle)begin
        iic_chanel <=  4'd0;
    end
end 
//通道配置参数赋值
always @(posedge sys_clk) begin
    case(iic_chanel)
    0:begin
        data_config <= DATA_CONFIG_CHANEL1;
    end
    1:begin
        data_config <= DATA_CONFIG_CHANEL2;
    end
    2:begin
        data_config <= DATA_CONFIG_CHANEL3;
    end
    3:begin
        data_config <= DATA_CONFIG_CHANEL4;
    end
    default :;
    endcase
end 
reg [7:0] iic_state_pre = 8'd0;
//设置发出数据的时刻，当四个通道都读完之后，产生数据有效标志
always @(posedge sys_clk) begin
    iic_state_pre <= iic_state;
    if(    (iic_state_pre  == wait_iic)&& (iic_state==idle))begin
        data_valid   <= 1'b1; 
    end else begin
        data_valid <= 1'b0;
    end
end
//四个通道中每次采集完成数据之后，将采集到的数据寄存到数据寄存器
always @(posedge sys_clk) begin
   if(data_ok == 1'b1)begin
        if(iic_chanel == 4'd0)begin
            tempre_data1 <= data_in_tmp;   
        end else if(iic_chanel == 4'd1)begin
            tempre_data2 <= data_in_tmp;   
        end else if(iic_chanel == 4'd2)begin
            tempre_data3 <= data_in_tmp;   
        end else if(iic_chanel == 4'd3)begin
            tempre_data4 <= data_in_tmp;  
        end 
    end 
end

                 
endmodule

`timescale 1ns / 1ps

//该芯片的使用较为复杂。
//该芯片是一个四输入口的ADC（AIN0，AIN1，AIN2，AIN3, AIN4），采样率最高达到31.25SPS
//采样通道有四个channel,分别是channel0，channel1，channel2，channel3，
//每个channel需要单独配置需执行的采样逻辑。例如：
//channel0，可以配置，是否使能，选择正端：AIN1，负端：AIN0。采样模式为单次采样。等等...
//
//当AD7172-2在启用多个通道的情况下运行时，channel排序器按顺序循环通过已启用的通道，从通道0到通道3。
//如果通道被禁用，则排序器跳过。
//
//说明，它的采样是从channel0 -> channel3的一个循环。（如果某个channel没有使能，则跳过）
//注：并不是从AIN0 -> AIN3的一个循环 .................................................
//
//
//通信逻辑：
//1.向通信寄存器发送数据信息，包含：下一次对寄存器的行为（读/写），寄存器地址。(这个也就是通讯逻辑图中的CMD)
//2.跟着发送目的寄存器的数据。
//配置逻辑：
//1.进行通道配置。（使能 + 正负端配置）
//2.配置寄存器：0x20(默认即可)，过滤器寄存器：0x28(默认即可,采样速率为31.25KSPS)，增益寄存器：0x38(默认即可)，偏置寄存器：0x30(默认即可,0x800000)
//3.ADC的工作模式，ADC模式寄存器：0x01(默认即可),接口模式寄存器：0x02(配置为：0x00c0，连续读取 + 通道对应)
//
//最后进行数据连续读取
//注意：在连续读取模式下保持SDO低。

module AD7172#
(   //V = (Vref * (D - offset)) / (2 ^ n);其中 n = 23(或者 16，需配置)该模式为差分模式，数据为24bit(或者16bit)
    //offset默认为0x800000， Vref是2.5V
    parameter   SYS_CLK_FREQ = 8'd50,
    //16bit CFG :1bit 使能； 1bit none； 2bit 选择寄存器组； 2bit none； 5bit 正端； 5bit 负端
    parameter   CHANNEL0_CFG = {1'b1, 1'b0, 2'b00, 2'b00, 5'b00001, 5'b00000},//AIN1
    parameter   CHANNEL1_CFG = {1'b1, 1'b0, 2'b00, 2'b00, 5'b00010, 5'b00000},//AIN2
    parameter   CHANNEL2_CFG = {1'b1, 1'b0, 2'b00, 2'b00, 5'b00011, 5'b00000},//AIN3
    parameter   CHANNEL3_CFG = {1'b1, 1'b0, 2'b00, 2'b00, 5'b00100, 5'b00000}//AIN4
) (

    input           sys_clk,
    input           sys_rst_n,

    output          SCLK,
    input           SDI,
    output          SDO,
    output          CS_n,

    output  [23:0]  AIN4,
    output  [23:0]  AIN3,
    output  [23:0]  AIN2,
    output  [23:0]  AIN1,

    output  reg     data4_valid = 1'b0//ch3数据有效，同时可以表示ch0 -> ch3一个周期的循环结束

);
//状态机状态
    parameter       IDLE = 8'd0;
    parameter       WAIT = 8'd1;
    parameter       INITIAL = 8'd2;
    parameter       WRITE = 8'd3;
    parameter       AWAIT = 8'd4;
    parameter       READ = 8'd5;
    
    
//时钟
    reg             sclk_r = 1'b1;
    reg             sclk_r_1 = 1'b0;
    wire            pos_sclk;
    wire            neg_sclk;
    wire            sdi_w;
    reg             sdi_w_1;
    wire            neg_sdi_w;
    reg             sdo_r = 1'b0;
    reg             cs_r = 1'b1;//cs片选
    reg             cs_t = 1'b1;//控制SCLK时钟

    wire    [7:0]   sclk_cnt_limit;
    reg     [7:0]   sclk_cnt = 8'd0;


    assign  SCLK = sclk_r;
    assign  sdi_w = SDI;
    assign  SDO = sdo_r;
    assign  CS_n = cs_r;
    assign  sclk_cnt_limit = SYS_CLK_FREQ;
    assign  pos_sclk = sclk_r&(~sclk_r_1);
    assign  neg_sclk = (~sclk_r)&sclk_r_1;
    assign  neg_sdi_w = (~sdi_w) & sdi_w_1;

    
//sclk时钟生成(rf/8)MHz
    always @(posedge sys_clk ) begin
        sclk_r_1 <= sclk_r;
        sdi_w_1 <= sdi_w;
        if(~cs_t)begin
            if (sclk_cnt >= sclk_cnt_limit[7:3]) begin
                sclk_cnt <= 8'd0;
                sclk_r <= ~sclk_r;
            end else begin
                sclk_cnt <= sclk_cnt + 1'b1;
                sclk_r <= sclk_r;
            end
        end else begin
            sclk_r <= 1'b1;
            sclk_cnt <= 8'd0;
        end 
    end


//状态机+数据赋值
    reg     [7:0]   cur_state = 8'd0;
    reg     [7:0]   next_state = 8'd0;
    reg             init_cycle = 1'b0;
    reg             go = 1'b0;
    reg             read_cycle = 1'b0;

    reg     [23:0]  send_data = 24'd0;
    reg     [7:0]   send_cnt = 8'd0;
    reg     [31:0]  read_data = 32'd0;
    reg     [7:0]   read_cnt = 8'd0;
    reg             data_valid = 1'b0;//读取一个通道完成
    reg     [3:0]   init_cnt = 4'd0;
    reg     [15:0]  wait_cnt = 16'd0;


    reg     [23:0]  data_ch0 = 24'd0;
    reg     [23:0]  data_ch1 = 24'd0;
    reg     [23:0]  data_ch2 = 24'd0;
    reg     [23:0]  data_ch3 = 24'd0;

    assign AIN1 = data_ch0;
    assign AIN2 = data_ch1;
    assign AIN3 = data_ch2;
    assign AIN4 = data_ch3;

    always @(posedge sys_clk) begin
        data4_valid <= 1'b0;
        if (data_valid) begin
            case(read_data[1:0])
                2'd0:begin
                    data_ch0 <= read_data[31:8];
                end 

                2'd1:begin
                    data_ch1 <= read_data[31:8];
                end 

                2'd2:begin
                    data_ch2 <= read_data[31:8];
                end 

                2'd3:begin
                    data_ch3 <= read_data[31:8];
                    data4_valid <= 1'b1;
                end 
            endcase
        end
    end



//三段式状态机
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (~sys_rst_n) 
            cur_state <= IDLE;
        else
            cur_state <= next_state;
    end

    always @(*) begin
        next_state = IDLE;
        case(cur_state)
            IDLE:begin
                if(go) next_state = WAIT;
                else next_state = IDLE;
            end
               
            WAIT:begin
                if(init_cycle) next_state = INITIAL;
                else next_state = WAIT;
            end

            INITIAL:begin
                if (go) next_state = WRITE;
                else next_state = INITIAL;
            end

            WRITE:begin
                if(read_cycle) next_state = AWAIT;
                else if(go) next_state = WAIT;
                else next_state = WRITE;
            end 

            AWAIT:begin
                if (go) next_state = READ;
                else next_state = AWAIT;
            end 

            READ:begin
                if(go) next_state = AWAIT;
                else next_state = READ;
            end

            default:next_state = IDLE;
        endcase
    end


    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(!sys_rst_n)begin
            go <= 1'b0;
            init_cnt <= 4'd0;
            wait_cnt <= 16'd0;
            init_cycle <= 1'b0;
            cs_r <= 1'b1;
            cs_t <= 1'b1;
        end else begin
            go <= 1'b0;
            init_cycle <= 1'b0;
            read_cycle <= 1'b0;
            data_valid <= 1'b0;
            case(next_state)
                IDLE:begin
                    go <= 1'b1;
                end 
    
                WAIT:begin
                    cs_r <= 1'b1;
                    if(init_cnt <= 4'd5)begin
                        if (wait_cnt >= 16'd500) begin
                            wait_cnt <= 16'd0;
                            init_cycle <= 1'b1;
                        end else begin
                            wait_cnt <= wait_cnt + 1'b1;
                            init_cycle <= 1'b0;
                        end
                    end 
                end 
    
                INITIAL:begin
                    case(init_cnt)
                    4'd0:begin//8 + 16 :(2bit读写使能；6bit寄存器地址；16bit对应寄存器数据)
                        send_data <= {2'b00, 6'b010000, CHANNEL0_CFG};
                    end 
    
                    4'd1:begin
                        send_data <= {2'b00, 6'b010001, CHANNEL1_CFG};
                    end 
    
                    4'd2:begin
                        send_data <= {2'b00, 6'b010010, CHANNEL2_CFG};
                    end 
    
                    4'd3:begin
                        send_data <= {2'b00, 6'b010011, CHANNEL3_CFG};
                    end 
    
                    4'd4:begin
                        send_data <= {2'b00, 6'b000001, 16'h8200};
                    end 
    
                    4'd5:begin
                        send_data <= {2'b00, 6'b000010, 16'h00c0};
                    end
    
                    default:;
                    endcase
                    if(init_cnt <= 4'd5) init_cnt <= init_cnt + 1'b1;
                    go <= 1'b1;
                    cs_r <= 1'b0;
                    cs_t <= 1'b0;
                end
    
                WRITE:begin
                   if(neg_sclk & send_cnt<=8'd23)begin
                        sdo_r <= send_data[23-send_cnt];
                        send_cnt <= send_cnt+1;
                    end else if(send_cnt==8'd24 && sclk_r)begin
                        sdo_r <= 1'b0;//在连续读取模式下保持SDO低。
                        cs_t <= 1'b1;//不论如何，时钟都要截至
                        send_cnt <= 8'd0;
                        if(init_cnt > 4'd5)begin //判断初始化是否结束
                            init_cnt <= 4'd0;
                            read_cycle <= 1'b1;
                        end else 
                            go <= 1'b1;
                    end 
                end
    
                AWAIT:begin
                    if (~sdi_w) begin//
                        cs_t <= 1'b0;
                        go <= 1'b1;
                    end
                end
    
                READ:begin
                    if (pos_sclk && read_cnt < 8'd31) begin
                        read_data <= {read_data[30:0], sdi_w};
                        read_cnt <= read_cnt + 1'b1;
                    end else if(pos_sclk && read_cnt >= 8'd31)begin
                        read_data <= {read_data[30:0], sdi_w};
                        read_cnt <= 8'd0;
                        cs_t <= 1'b1;
                        go <= 1'b1;
                        data_valid <= 1'b1;
                    end
                end 
    
                default:;
            endcase
        end 
    end 



ila_0 ila_0_inst (
    .clk(sys_clk), // input wire clk


    .probe0(data_ch0), // input wire [0:0]  probe0  
    .probe1(data_ch1), // input wire [0:0]  probe1 
    .probe2(data_ch2), // input wire [0:0]  probe2 
    .probe3(data_ch3), // input wire [0:0]  probe3 
    .probe4(cs_t), // input wire [0:0]  probe4 
    .probe5(next_state), // input wire [7:0]  probe5 
    .probe6(init_cycle), // input wire [0:0]  probe6 
    .probe7(go), // input wire [0:0]  probe7 
    .probe8(read_cycle), // input wire [0:0]  probe8 
    .probe9(send_data), // input wire [23:0]  probe9 
    .probe10(send_cnt), // input wire [7:0]  probe10 
    .probe11(read_data), // input wire [31:0]  probe11 
    .probe12(read_cnt), // input wire [7:0]  probe12 
    .probe13(data_valid), // input wire [0:0]  probe13 
    .probe14(init_cnt) ,// input wire [3:0]  probe14
    .probe15(sclk_r), // input wire [0:0]  probe0  
    .probe16(sdi_w), // input wire [0:0]  probe1 
    .probe17(sdo_r), // input wire [0:0]  probe2 
    .probe18(cs_r) // input wire [0:0]  probe3
);



endmodule

// ---------------------------------------------------------
// 开发逻辑
// 1、发送对应采样通道配置信息；
// 2、读取cfg配置寄存器，查看是否conversion完成；
// 3、若完成，则去读取conversion data寄存器；
// 4、上述逻辑循环4次，则完成此次芯片读取逻辑；

//--------------------------------------------------
module TLA2024#
(
    parameter           CLK_RFEQ = 8'd100,
    parameter           CHIP_ADDR = 7'b1001000,
    parameter           CHANNEL = 4'b0000,// 分别对应 AIN3 AIN2 AIN1 AIN0;
    parameter           AIN0_cfg = 16'b1_100_010_1_111_00111,
    parameter           AIN1_cfg = 16'b1_101_010_1_111_00111,
    parameter           AIN2_cfg = 16'b1_110_010_1_111_00111,
    parameter           AIN3_cfg = 16'b1_111_010_1_111_00111
)(      
    input               sys_clk,
        
    output reg          scl = 1'b1,
    input               sdi,
    output reg          sdo = 1'b1,
    output reg          sda_ctrl = 1'b0,// SDA的inout控制信号；1 读，0 写；

    input               sample_go,
    output reg [15:0]   AIN0 = 16'd0,
    output reg [15:0]   AIN1 = 16'd0,
    output reg [15:0]   AIN2 = 16'd0,
    output reg [15:0]   AIN3 = 16'd0,
    output reg          data_valid = 1'b0
    );

    localparam          conversion_reg = 8'h00;
    localparam          cfg_reg = 8'h01;

    localparam          IDLE = 8'd0;
    localparam          START = 8'd12;
    localparam          SEND_ADDR = 8'd1;
    localparam          SEND_POINTER = 8'd2;
    localparam          SEND_CFG_DATA1 = 8'd3;
    localparam          SEND_CFG_DATA2 = 8'd4;
    localparam          ACK1 = 8'd5;
    localparam          WAIT_FOR_READ = 8'd6;
    localparam          READ_ADDR = 8'd7;
    localparam          READ_HIGH = 8'd8;
    localparam          READ_LOW = 8'd9;
    localparam          ACK2 = 8'd10;
    localparam          OS = 8'd11;

    reg                 scl_en = 1'b0;
    reg                 scl_1 = 1'b0;
    wire                pos_scl;
    wire                neg_scl;
    reg         [15:0]  sclk_cnt = 16'd0;
    wire        [15:0]  sclk_cnt_limit;

    reg         [7:0]   cur_state = 8'd0;
    reg         [7:0]   next_state = 8'd0;
    reg         [3:0]   go_state = 4'd0;

    reg                 work_state = 1'b0; // 表示工作状态，1 读逻辑；0 写逻辑
    reg                 cfg_init = 1'b0; // 1 表示需要进行通道初始化；0 表示通道初始化完成；
    reg                 pre_rdpaddr = 1'b0; // 表示读数逻辑中，是否完成pointer发送逻辑；1 完成，0 未完成
    wire        [15:0]  channel_cfg [3:0];
    reg         [15:0]  cfg_data = 16'd0; // 将要发送的cfg数据
    reg         [3:0]   channel_cnt = 4'd0; //完成通道计数器
    reg         [7:0]   send_data = 8'd0;
    reg         [7:0]   send_cnt = 8'd0;
    reg                 conversion_ok = 1'b0; // OS标志位
    reg         [7:0]   recv_data = 8'd0;
    reg         [7:0]   recv_cnt = 8'd0;
    reg                 recv_valid = 1'b0;
    reg         [15:0]  wait_cnt = 16'd0; // 等待计数器
    reg         [15:0]  ack_cnt = 16'd0;
    reg         [15:0]  sample_data = 16'd0;

    assign pos_scl= scl && (~scl_1);
    assign neg_scl= (~scl) && scl_1;
    assign sclk_cnt_limit = {5'd0, CLK_RFEQ, 3'd0};

    assign channel_cfg[0] = AIN0_cfg;
    assign channel_cfg[1] = AIN1_cfg;
    assign channel_cfg[2] = AIN2_cfg;
    assign channel_cfg[3] = AIN3_cfg;

    always @(posedge sys_clk) begin
        scl_1 <= scl;

        if (scl_en) begin
            if (sclk_cnt >= sclk_cnt_limit) begin
                scl <= ~scl;
                sclk_cnt <= 16'd0;
            end else begin
                scl <= scl;
                sclk_cnt <= sclk_cnt + 1'b1;
            end
        end else begin
            scl <= 1'b1;
            sclk_cnt <= 16'd0;
        end
    end

    always @(posedge sys_clk) begin
        if (channel_cnt <= 4'd3) begin
            cfg_data <= channel_cfg[channel_cnt];
        end 

        if(channel_cnt >= 4'd4) 
            channel_cnt <= 4'd0;
        else if(~CHANNEL[channel_cnt])
            channel_cnt <= channel_cnt + 1'b1;
        else if (recv_valid) 
            channel_cnt <= channel_cnt + 1'b1;
        
    end


    always @(posedge sys_clk) begin
        data_valid <= 1'b0;
        if(recv_valid)begin
            case(channel_cnt)
                4'd0:begin
                    AIN0 <= {4'd0, sample_data[15:4]};
                end
                4'd1:begin
                    AIN1 <= {4'd0, sample_data[15:4]};
                end
                4'd2:begin
                    AIN2 <= {4'd0, sample_data[15:4]};
                end
                4'd3:begin
                    AIN3 <= {4'd0, sample_data[15:4]};
                    data_valid <= 1'b1;
                end
            endcase
        end
end

// --------------------------------------------------------

    always @(posedge sys_clk) begin
       if (1'b0) begin
           cur_state <= IDLE;
       end else begin
           cur_state <= next_state;
       end
    end

    always @(*) begin
        case(cur_state)
            IDLE:begin
                if (go_state == 4'd1) next_state = START;
                else next_state = IDLE;
            end

            START:begin
                if (go_state == 4'd1) next_state = SEND_ADDR;
                else next_state = START;
            end
            
            SEND_ADDR:begin
                if (go_state == 4'd1) next_state = SEND_POINTER;
                else next_state = SEND_ADDR;
            end

            SEND_POINTER:begin
                if (go_state == 4'd1) next_state = SEND_CFG_DATA1;
                else if(go_state == 4'd2) next_state = ACK1;
                else next_state = SEND_POINTER;
            end

            SEND_CFG_DATA1:begin
                if (go_state == 4'd1) next_state = SEND_CFG_DATA2;
                else next_state = SEND_CFG_DATA1;
            end

            SEND_CFG_DATA2:begin
                if (go_state == 4'd1) next_state = ACK1;
                else next_state = SEND_CFG_DATA2;
            end

            ACK1:begin
                if (go_state == 4'd1) next_state = WAIT_FOR_READ;
                else next_state = ACK1;
            end

            WAIT_FOR_READ:begin
                if (go_state == 4'd1) next_state = SEND_ADDR;
                else if (go_state == 4'd2) next_state = READ_ADDR;
                else next_state = WAIT_FOR_READ;
            end

            READ_ADDR:begin
                if (go_state == 4'd1) next_state = READ_HIGH;
                else next_state = READ_ADDR;
            end

            READ_HIGH:begin
                if (go_state == 4'd1) next_state = READ_LOW;
                else next_state = READ_HIGH;
            end

            READ_LOW:begin
                if (go_state == 4'd1) next_state = ACK2;
                else next_state = READ_LOW;
            end

            ACK2:begin
                if (go_state == 4'd1) next_state = OS;
                else next_state = ACK2;
            end

            OS:begin
                if (go_state == 4'd1) next_state = IDLE;
                else if (go_state == 4'd2) next_state = WAIT_FOR_READ;
                else next_state = OS;
            end
        endcase
    end


    always @(posedge sys_clk) begin
        if (1'b0) begin
            
        end else begin
            go_state <= 4'd0;
            recv_valid <= 1'b0;

            case(next_state)
                IDLE:begin
                    if(sample_go)begin
                        go_state <= 4'd1;
                    end else begin
                        go_state <= 4'd0;
                    end
                end

                START:begin
                    if (wait_cnt >= 16'd1000) begin
                        go_state <= 4'd1;
                        wait_cnt <= 16'd0;
                        send_data <= {CHIP_ADDR, 1'b0};
                        sda_ctrl <= 1'b0;
                        sdo <= 1'b0;
                    end else begin
                        go_state <= 4'd0;
                        wait_cnt <= wait_cnt + 1'b1;
                    end
                end 
                
                SEND_ADDR:begin
                    scl_en <= 1'b1;
                    if (~scl && (sclk_cnt == 16'd200) && send_cnt == 8'd0) begin
                        sdo <= send_data[7 - send_cnt];
                        send_cnt <= send_cnt + 1'b1;
                    end else if (neg_scl && send_cnt <= 8'd7 && send_cnt >= 8'd1) begin
                        sdo <= send_data[7 - send_cnt];
                        send_cnt <= send_cnt + 1'b1;
                    end else if (neg_scl && send_cnt == 8'd8) begin
                        send_cnt <= send_cnt + 1'b1;
                        sda_ctrl <= 1'b1;
                    end else if (send_cnt >= 8'd9) begin
                        if (pos_scl && (~sdi)) begin
                            go_state <= 4'd1;
                            send_cnt <= 8'd0;
                            if(~conversion_ok) send_data <= cfg_reg;
                            else send_data <= conversion_reg;
                        end
                    end
                end

                SEND_POINTER:begin
                    if (neg_scl && send_cnt == 8'd0) begin
                        sda_ctrl <= 1'b0;
                    end
                    if (neg_scl && send_cnt <= 8'd7) begin
                        sdo <= send_data[7 - send_cnt];
                        send_cnt <= send_cnt + 1'b1;
                    end else if (neg_scl && send_cnt == 8'd8) begin
                        sdo <= 1'b0;
                        send_cnt <= send_cnt + 1'b1;
                        sda_ctrl <= 1'b1;
                    end else if (send_cnt >= 8'd9) begin
                        if (pos_scl && (~sdi)) begin
                            if(~work_state) go_state <= 4'd1;
                            else go_state <= 4'd2;
                            send_cnt <= 8'd0;
                            send_data <= cfg_data[15:8];
                        end
                    end
                end

                SEND_CFG_DATA1:begin
                    if (neg_scl && send_cnt == 8'd0) begin
                        sda_ctrl <= 1'b0;
                    end
                    if (neg_scl && send_cnt <= 8'd7) begin
                        sdo <= send_data[7 - send_cnt];
                        send_cnt <= send_cnt + 1'b1;
                    end else if (neg_scl && send_cnt == 8'd8) begin
                        send_cnt <= send_cnt + 1'b1;
                        sda_ctrl <= 1'b1;
                    end else if (send_cnt >= 8'd9) begin
                        if (pos_scl && (~sdi)) begin
                            go_state <= 4'd1;
                            send_cnt <= 8'd0;
                            send_data <= cfg_data[7:0];
                        end
                    end
                end

                SEND_CFG_DATA2:begin
                    if (neg_scl && send_cnt == 8'd0) begin
                        sda_ctrl <= 1'b0;
                    end
                    if (neg_scl && send_cnt <= 8'd7) begin
                        sdo <= send_data[7 - send_cnt];
                        send_cnt <= send_cnt + 1'b1;
                    end else if (neg_scl && send_cnt == 8'd8) begin
                        sdo <= 1'b0;
                        send_cnt <= send_cnt + 1'b1;
                        sda_ctrl <= 1'b1;
                    end else if (send_cnt >= 8'd9) begin
                        if (pos_scl && (~sdi)) begin
                            go_state <= 4'd1;
                            send_cnt <= 8'd0;
                        end
                    end
                end

                ACK1:begin
                    if (pos_scl) begin
                        scl_en <= 1'b0;
                    end
                    if (neg_scl) begin
                        sda_ctrl <= 1'b0;
                    end

                    if (~scl_en) begin
                        if (ack_cnt >= 16'd1000) begin
                            go_state <= 4'd1;
                            ack_cnt <= 16'd0;
                            sdo <= 1'b1;
                        end else begin
                            ack_cnt <= ack_cnt + 1'b1;
                        end
                    end
                end

                WAIT_FOR_READ:begin
                    if (wait_cnt >= 16'd30000) begin
                        wait_cnt <= 16'd0;
                        work_state <= 1'b1;
                        sdo <= 1'b0;
                        if (cfg_init) begin
                            go_state <= 4'd1;
                            cfg_init <= 1'b0;
                            work_state <= 1'b0;
                            send_data <= {CHIP_ADDR, 1'b0};
                        end else if (~pre_rdpaddr) begin
                            go_state <= 4'd1;
                            send_data <= {CHIP_ADDR, 1'b0};
                            pre_rdpaddr <= 1'b1;
                        end else if(pre_rdpaddr) begin
                            go_state <= 4'd2;
                            send_data <= {CHIP_ADDR, 1'b1};
                        end 
                    end else begin
                        wait_cnt <= wait_cnt + 1'b1;
                    end
                end

                READ_ADDR:begin
                    scl_en <= 1'b1;
                    if (~scl && (sclk_cnt == 16'd200) && send_cnt == 8'd0) begin
                        sdo <= send_data[7 - send_cnt];
                        send_cnt <= send_cnt + 1'b1;
                    end else if (neg_scl && send_cnt <= 8'd7 && send_cnt >= 8'd1) begin
                        sdo <= send_data[7 - send_cnt];
                        send_cnt <= send_cnt + 1'b1;
                    end else if (neg_scl && send_cnt == 8'd8) begin
                        sdo <= 1'b0;
                        send_cnt <= send_cnt + 1'b1;
                        sda_ctrl <= 1'b1;
                    end else if (send_cnt >= 8'd9) begin
                        if (pos_scl && (~sdi)) begin
                            go_state <= 4'd1;
                            send_cnt <= 8'd0;
                        end
                    end
                end

                READ_HIGH:begin
                    if (pos_scl && recv_cnt <= 8'd7) begin
                        recv_data[7 - recv_cnt] <= sdi;
                        recv_cnt <= recv_cnt + 1'b1;
                    end else if(neg_scl && recv_cnt == 8'd8)begin
                        recv_cnt <= recv_cnt + 1'b1;
                        sda_ctrl <= 1'b0;
                        sdo <= 1'b0;
                    end else if(pos_scl && recv_cnt >= 8'd9)begin
                        sample_data[15:8] <= recv_data;
                        go_state <= 4'd1;
                        recv_cnt <= 8'd0;
                    end
                end

                READ_LOW:begin
                    if (neg_scl) sda_ctrl <= 1'b1;

                    if (pos_scl && recv_cnt <= 8'd7) begin
                        recv_data[7 - recv_cnt] <= sdi;
                        recv_cnt <= recv_cnt + 1'b1;
                    end else if(neg_scl && recv_cnt == 8'd8)begin
                        recv_cnt <= recv_cnt + 1'b1;
                        sda_ctrl <= 1'b0;
                        sdo <= 1'b1;
                    end else if(pos_scl && recv_cnt >= 8'd9)begin
                        sample_data[7:0] <= recv_data;
                        go_state <= 4'd1;
                        recv_cnt <= 8'd0;
                    end
                end

                ACK2:begin
                    if (neg_scl) begin
                        sdo <= 1'b0;
                    end

                    if (pos_scl) begin
                        scl_en <= 1'b0;
                    end

                    if (~scl_en) begin
                        if (ack_cnt >= 16'd1000) begin
                            go_state <= 4'd1;
                            ack_cnt <= 16'd0;
                            sdo <= 1'b1;
                        end else begin
                            ack_cnt <= ack_cnt + 1'b1;
                        end
                    end
                end

                OS:begin
                    if (~conversion_ok) begin
                        go_state <= 4'd2;// 
                        if (sample_data[15]) begin
                            conversion_ok <= 1'b1;
                            pre_rdpaddr <= 1'b0;
                        end else begin
                            conversion_ok <= 1'b0;
                            pre_rdpaddr <= 1'b1;
                        end
                    end else if(conversion_ok) begin
                        recv_valid <= 1'b1;
                        work_state <= 1'b0;
                        conversion_ok <= 1'b0;
                        pre_rdpaddr <= 1'b0;
                        if (channel_cnt >= 4'd3) begin// 四个通道全部执行完；回归IDLE
                            go_state <= 4'd1;
                            cfg_init <= 1'b0;   
                        end else begin// 未完成4通道读取，切换cfg信息，重复执行逻辑
                            go_state <= 4'd2;
                            cfg_init <= 1'b1;   
                        end
                    end

                end

            endcase
        end
    end
endmodule


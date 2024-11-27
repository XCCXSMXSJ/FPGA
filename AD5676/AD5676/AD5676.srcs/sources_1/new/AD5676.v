module AD5676#
(   //Vout = (Vref * D) / (2 ^ 16 - 1)
    parameter   SYS_CLK_FREQ = 8'd50,
    parameter   CHANNEL = 8'b0000_0000
) (
    input           sys_clk,
    input           sys_rst_n,
//芯片引脚名称
    output          rst_n,
    output          SCLK,
    output          SDI,
    output          SYNC_n,
    output          LDAC_n,

    input   [15:0]  ch_data0,
    input   [15:0]  ch_data1,
    input   [15:0]  ch_data2,
    input   [15:0]  ch_data3,
    input   [15:0]  ch_data4,
    input   [15:0]  ch_data5,
    input   [15:0]  ch_data6,
    input   [15:0]  ch_data7,
    input           data_valid//
    );

    parameter       COMMAND = {1'b0,1'b0,1'b1,1'b1};

    parameter       IDLE = 8'd0;
    parameter       CYCLE = 8'd1;
    parameter       SEND = 8'd2;
    parameter       END = 8'd3;


    reg             rst_nr  = 1'b1;
    reg             sclk_r = 1'b0;//
    reg             sclk_r_1 = 1'b0;
    wire            pos_sclk;
    wire            neg_sclk;
    reg             sdi_r  = 1'b0;//
    reg             sync_r = 1'b1;//
    reg             ldac_r = 1'b0;//
    wire    [7:0]   sclk_cnt_limit;
    reg     [7:0]   sclk_cnt = 8'd0;
    
    reg     [15:0]  data [7:0];
    reg             data_valid_1 = 1'b0;

    assign  rst_n = rst_nr;
    assign  SCLK = sclk_r;
    assign  SDI = sdi_r;
    assign  SYNC_n = sync_r;
    assign  LDAC_n = ldac_r;
    assign  sclk_cnt_limit = SYS_CLK_FREQ;
    assign  pos_sclk = sclk_r&(~sclk_r_1);
    assign  neg_sclk = (~sclk_r)&sclk_r_1;

//sclk时钟生成
    always @(posedge sys_clk ) begin
        sclk_r_1 <= sclk_r;
        if (sclk_cnt >= sclk_cnt_limit[7:3]) begin
            sclk_cnt <= 8'd0;
            sclk_r <= ~sclk_r;
        end else begin
            sclk_cnt <= sclk_cnt + 1'b1;
            sclk_r <= sclk_r;
        end
    end
//有效数据缓存
    always @(posedge sys_clk) begin
        data_valid_1 <= data_valid;
        if ( data_valid && ( ~data_valid_1 ) ) begin
            data[0] <= ch_data0;
            data[1] <= ch_data1;
            data[2] <= ch_data2;
            data[3] <= ch_data3;
            data[4] <= ch_data4;
            data[5] <= ch_data5;
            data[6] <= ch_data6;
            data[7] <= ch_data7;
        end else begin
            data[0] <= data[0];
            data[1] <= data[1];
            data[2] <= data[2];
            data[3] <= data[3];
            data[4] <= data[4];
            data[5] <= data[5];
            data[6] <= data[6];
            data[7] <= data[7];
        end
    end

    reg     [7:0]   cur_state = 8'd0;
    reg     [7:0]   next_state = 8'd0;//
    reg             return = 1'b0;
    reg             go = 1'b0;//
    reg             cycle = 1'b0;//
    reg     [23:0]  send_data = 24'd0;//
    reg     [7:0]   send_cnt = 8'd0;//
    reg     [3:0]   cycle_cnt = 4'd0;//

//三段式状态机
    always @(posedge sys_clk) begin
        if (!sys_rst_n) begin
            cur_state <= IDLE;
        end
            cur_state <= next_state;
    end

    always @(*) begin
        next_state = IDLE;
        case(cur_state)
            IDLE:begin
                if(go) next_state = CYCLE;
                else next_state = IDLE;
            end
               
            CYCLE:begin
                if(go) next_state = SEND;
                else next_state = CYCLE;
            end
            SEND:begin
                if(go) next_state = END;
                else next_state = SEND;
            end 
            END:begin
                if(go) next_state = IDLE ;
                else if(cycle) next_state = CYCLE;
                else next_state = END;
            end
            default:next_state = IDLE;
        endcase
    end

    always @(posedge sys_clk) begin
        go <= 1'b0;
        return <= 1'b0;
        cycle <= 1'b0;
        case(next_state)
            IDLE:begin
                send_cnt <= 8'd0;
                cycle_cnt <= 4'd0;
                send_data <= 24'd0;
                if(data_valid && ( ~data_valid_1 ))
                    go <= 1'b1;
            end

            CYCLE:begin
                if(cycle_cnt >= 4'd8)begin
                    return <= 1'b1;
                end else if(CHANNEL[cycle_cnt] ==1'b1)begin
                    send_data <= {COMMAND, cycle_cnt, data[cycle_cnt]};
                    cycle_cnt <= cycle_cnt + 1'b1;
                    go <= 1'b1;
                end else begin
                    cycle_cnt <= cycle_cnt + 1'b1;
                end
            end

            SEND:begin
                if(pos_sclk & send_cnt==8'd0)begin
                    sync_r <= 1'b0;
                    sdi_r <= send_data[23-send_cnt];
                    send_cnt <= send_cnt+1;
                end else if(pos_sclk & send_cnt<=8'd23)begin
                    sdi_r <= send_data[23-send_cnt];
                    send_cnt <= send_cnt+1;
                end else if(send_cnt==8'd24 && sclk_cnt==2'd1)begin
                    sync_r <= 1'b1;
                    send_cnt <= 8'd0;
                    go <= 1'b1;
                end
            end

            END:begin
                if (cycle_cnt <= 4'd7) begin
                    cycle <= 1'b1;
                end else begin
                    go <= 1'b1;
                end
                
            end
        endcase
    end




ila_0 ila_0_inst (
    .clk(sys_clk), // input wire clk


    .probe0(sclk_r), // input wire [0:0]  probe0  
    .probe1(sdi_r), // input wire [0:0]  probe1 
    .probe2(sync_r), // input wire [0:0]  probe2 
    .probe3(ldac_r), // input wire [0:0]  probe3 
    .probe4(data_valid), // input wire [0:0]  probe4 
    .probe5(next_state), // input wire [7:0]  probe5 
    .probe6(go), // input wire [0:0]  probe6 
    .probe7(cycle), // input wire [0:0]  probe7 
    .probe8(send_data), // input wire [23:0]  probe8 
    .probe9(send_cnt), // input wire [7:0]  probe9 
    .probe10(cycle_cnt) // input wire [3:0]  probe10
);










endmodule

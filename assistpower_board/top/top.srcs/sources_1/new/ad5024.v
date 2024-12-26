
module ad5024(
        input                       sys_clk,
        input                       sys_rst_n,
        input          [15:0]   i_data_a_1,
        input          [15:0]   i_data_a_2,//======
        input          [15:0]   i_data_a_3,
        input          [15:0]   i_data_a_4,//======
        input                       data_valid, 
        
        output      reg             sclk=1'b0,//=======驱动时钟,
        output      reg             sdin=1'b0,//=====输入口====
        output      reg             ldac_n=1'b0,//=====将输入寄存器中的数据更新到DAC寄存器中(拉低就更新)
        
        output      reg                 sync_n=1'b1


        
    );      
            
            parameter                   IDLE=4'd1;
            parameter                   POW_ON_DOWN=4'd2;
            parameter                   WAIT_FOR_VALID=4'd8;
            parameter                   SEND_A=4'd3;
            parameter                   SEND_B=4'd4;
            parameter                   SEND_C=4'd5;
            parameter                   SEND_D=4'd6;
            parameter                   END=4'd7;
    
            
            reg                 [3:0]   state=4'd0;
            reg                 [1:0]   sclk_cnt=2'd0;
            reg                 [3:0]   sclk_cnt_1=4'd0;
            reg                 [31:0]  send_data=32'd0;
            reg                 [7:0]   send_cnt=8'd0;
            


            reg                 [15:0]  data_a_1=16'd0;
            reg                 [15:0]  data_a_2=16'd0;
            reg                 [15:0]  data_a_3=16'd0;
            reg                 [15:0]  data_a_4=16'd0;
            


            
            
            //=======获取ready上升沿

            reg                         data_valid_1;
            wire                            pos_data_valid;
            assign pos_data_valid=(~data_valid_1)&data_valid;
            always@(posedge sys_clk )begin
                    data_valid_1<=data_valid;
                    if(pos_data_valid)begin
                             data_a_1<=i_data_a_1;
                             data_a_2<=i_data_a_2;
                             data_a_3<=i_data_a_3;
                             data_a_4<=i_data_a_4;
                    end 
            end
        
        //==========获得sclk驱动时钟(25M)

            always@(posedge sys_clk )begin
                  sclk_cnt_1<=sclk_cnt;
                  if(sclk_cnt<2'd2)begin
                        sclk<=1'b0;
                        sclk_cnt<=sclk_cnt+1'b1;
                  end else if(sclk_cnt<=2'd3) begin
                        sclk<=1'b1;
                        sclk_cnt<=sclk_cnt+1'b1;
                  end   
            end
        
        //===========获取sclk上升沿和下降沿

            wire                        pos_sclk;
            wire                        neg_sclk;
            reg                     sclk_1;
            assign pos_sclk=sclk&(~sclk_1);
            assign neg_sclk=(~sclk)&sclk_1;
        
            always@(posedge sys_clk )begin
                    sclk_1<=sclk;
            end
        
        
        
            reg        [7:0]       wait_cnt=8'd0;
            always@(posedge sys_clk )begin
                  if(wait_cnt<=8'd50)
                          wait_cnt<=wait_cnt+1'b1;
                  else
                          wait_cnt<=wait_cnt;
            end
            
            reg     [9:0]   sync_cnt=10'd0;
    
            //========================================================
            always@(posedge sys_clk )begin
                    case(state)
                        IDLE:begin
                                if(wait_cnt==8'd50)begin
                                        state<=POW_ON_DOWN;
                                        send_data<={4'd0,4'b0100,14'd0,2'b00,4'd0,4'b1111};
                                        sync_n<=1'b0;
                                end 
                        end
                        
                        POW_ON_DOWN:begin//========信号发送，选通第几号通道工作
    
                            if(pos_sclk&send_cnt==8'd0)begin
                                sdin<=send_data[31-send_cnt];
                                send_cnt<=send_cnt+1;
                            end else if(pos_sclk&send_cnt<=8'd31)begin
                                sdin<=send_data[31-send_cnt];
                                send_cnt<=send_cnt+1;
                            end else if(send_cnt==8'd32&&sclk_cnt==2'd1)begin
                                state<=WAIT_FOR_VALID;
                                send_cnt<=8'd0;
                                sync_n<=1'b1;//====================================拉高
                            end
                        end
                        
                        
                        WAIT_FOR_VALID:begin
    
                                if(pos_data_valid)begin
                                    state<=SEND_A;
                                    send_data<={4'd0,4'b0011,4'b0000,i_data_a_1[11:0],8'd0};
                                end else begin
                                    state<=WAIT_FOR_VALID;
    
                                end        
                        end
                        
                        
                        
                        SEND_A:begin//========
                            if(pos_sclk&&send_cnt==8'd0)begin
                                sync_n<=1'b0;
                                sdin<=send_data[31-send_cnt];
                                send_cnt<=send_cnt+1;
                            end else if(pos_sclk&send_cnt<=8'd31)begin
                                sdin<=send_data[31-send_cnt];
                                send_cnt<=send_cnt+1;
                            end else if(send_cnt==8'd32&&(sclk_cnt==2'd1))begin
                                sync_n<=1'b1;//============================拉高
                                send_data<={4'd0,4'b0011,4'b0001,i_data_a_2[11:0],8'd0};
                                if(sync_cnt>=10'd500)begin
                                    state<=SEND_B;
                                    sync_cnt<=10'd0;
                                    send_cnt<=8'd0;
                                end else begin
                                    send_cnt<=send_cnt;
                                    state<=SEND_A;
                                    sync_cnt<=sync_cnt+1'b1;
                                end
                                
                            end
                        end
                        
                        
                        SEND_B:begin//========
                            if(send_cnt==8'd0&&pos_sclk)begin
                                sync_n<=1'b0;
                                sdin<=send_data[31-send_cnt];
                                send_cnt<=send_cnt+1;
                            end else if(pos_sclk&send_cnt<=8'd31)begin
                                sdin<=send_data[31-send_cnt];
                                send_cnt<=send_cnt+1;
                            end else if(send_cnt==8'd32&&(sclk_cnt==2'd1))begin
                                send_data<={4'd0,4'b0011,4'b0010,i_data_a_3[11:0],8'd0};
                                sync_n<=1'b1;
                                if(sync_cnt>=10'd500)begin
                                    state<=SEND_C;
                                    sync_cnt<=10'd0;
                                    send_cnt<=8'd0;
                                end else begin
                                    send_cnt<=send_cnt;
                                    state<=SEND_B;
                                    sync_cnt<=sync_cnt+1'b1;
                                end
                            end
                        end
                        
                        SEND_C:begin//========
                            if(send_cnt==8'd0&&pos_sclk)begin
                                sync_n<=1'b0;
                                sdin<=send_data[31-send_cnt];
                                send_cnt<=send_cnt+1;
                            end else if(pos_sclk&send_cnt<=8'd31)begin
                                sdin<=send_data[31-send_cnt];
                                send_cnt<=send_cnt+1;
                            end else if(send_cnt==8'd32&&(sclk_cnt==2'd1))begin
                                send_data<={4'd0,4'b0011,4'b0011,i_data_a_4[11:0],8'd0};
                                sync_n<=1'b1;
                                if(sync_cnt>=10'd500)begin
                                    state<=SEND_D;
                                    sync_cnt<=10'd0;
                                    send_cnt<=8'd0;
                                end else begin
                                    send_cnt<=send_cnt;
                                    state<=SEND_C;
                                    sync_cnt<=sync_cnt+1'b1;
                                end
                            end
                        end
                        
                        
                        SEND_D:begin//========
                            if(send_cnt==8'd0&&pos_sclk)begin
                                sync_n<=1'b0;
                                sdin<=send_data[31-send_cnt];
                                send_cnt<=send_cnt+1;
                            end else if(pos_sclk&send_cnt<=8'd31)begin
                                sdin<=send_data[31-send_cnt];
                                send_cnt<=send_cnt+1;
                            end else if(send_cnt==8'd32&&(sclk_cnt==2'd1))begin
                                state<=END;
                                send_cnt<=8'd0;
                                sync_n<=1'b1;
                            end
                        end
                        
                        END:begin
                                state<=WAIT_FOR_VALID;
                        
                        end
                        default:state<=IDLE;
                        
                    endcase
                end
        
        
        
        
        
endmodule
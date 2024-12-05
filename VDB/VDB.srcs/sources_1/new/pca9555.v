
module pca9555#(
		parameter	[6:0]		iic_addr=7'b0100000
)
(
		input				sys_clk,
		
        input               sdi,
        output  reg         sdo=1'b1,
        output  reg         sda_ctrl=1'b0,
		output	reg			scl=1'b1,//fast mode max  400KHz;    standerd mode max 100KHz

		input				ready,
		input	[15:0]		port_data

    );
    reg	[7:0]		o_port_0=8'd0;
    reg	[7:0]		o_port_1=8'd0;

//    assign sda = sda_ctrl?1'bz:sdo;
//    assign sdi = sda;

    //====获取ready的上升沿
    	reg		ready_delay;
    	wire		pos_ready;
    	
    assign pos_ready=ready&&(~ready_delay);
    	
  
    //=====对状态机的开始与结束进行准备    
    
       reg		start=1'b0;//===开始配置
       wire		pos_down;
       wire		neg_down;
       reg		down=1'b0;//====发送结束
       reg		down_delay=1'b0;
       reg	[3:0]	stop_cnt=4'd0;
       
   assign pos_down=down&&(~down_delay);
   assign neg_down=(~down)&&down_delay;
       
   always@(posedge sys_clk)begin
    	ready_delay<=ready;
    	down_delay<=down;
   end
       
   always@(posedge sys_clk)begin
	   if(pos_ready)begin
	   	  o_port_0<=port_data[7:0];
	   	  o_port_1<=port_data[15:8];
	   	  start<=1'b1;
	   end else if(pos_down||neg_down)begin
	   	  start<=1'b0;	
	   end
   end
      
    //======时钟分频   <400KHz
        reg	[7:0]	scl_cnt=8'd0;
        reg		scl_en=1'b0;//==========时钟使能
    always@(posedge sys_clk)begin
    	if(scl_en)begin
    		if(scl_cnt==8'd63)begin
    			scl<=~scl;
    			scl_cnt<=8'd0;
    		end else begin
    		    	scl<=scl;
			scl_cnt<=scl_cnt+1'b1;
    		end 
    	end else begin
    		scl_cnt<=8'd0;
    		scl<=1'b1;
    	end
    end
      
    //======获取scl的上升下降沿
    reg		scl_dalay;
    wire		pos_scl;//===上升沿采集数据
    wire		neg_scl;//==下降沿改变数据
    
    assign pos_scl=scl&&(~scl_dalay);
    assign neg_scl=(~scl)&&scl_dalay;

    always@(posedge sys_clk)begin
    	scl_dalay<=scl;
    end
    
    //========
    reg	[15:0]	wait_cnt=16'd0;
    reg	[3:0]	state=4'd0;//===状态机状态
    reg	[7:0]	send_data=8'd0;//====发送的数据进行暂存
    reg	[3:0]	send_cnt=4'd0;//==发送个数计数
    
    reg	[7:0]	port_0=8'd0;
    reg	[7:0]	port_1=8'd0;
    
    always@(posedge sys_clk)begin
    	if(start)
    		case(state)
    			4'd0:begin//=====拉低，表示状态开始
    				scl_en<=1'b1;
    				if(scl_cnt>=8'd10)begin
    					sda_ctrl<=1'b0;
    					sdo<=1'b0;
    					state<=4'd1;
    					send_data<={iic_addr,1'b0};
    					send_cnt<=4'd0;
    				end else begin
    					sda_ctrl<=1'b0;
    					sdo<=1'b1;
    					state<=4'd0;
    				end
    			end

    			4'd1:begin//======发送地址
    				if(neg_scl&&(send_cnt<4'd8))begin
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(sdi==1'b0)begin
    							state<=4'd2;
    							send_cnt<=4'd0;
    							send_data<=8'h06;
    						end
    				end
    			end
    			
    			4'd2:begin//======发送指令(要先进行配置寄存器)
    				 if(neg_scl&&(send_cnt<4'd8))begin
    				     		sda_ctrl<=1'b0;
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(sdi==1'b0)begin
    							state<=4'd3;
    							send_cnt<=4'd0;
    							send_data<=8'h00;//====
    						end
    				end
    			end
    			
    			4'd3:begin//======= 将port0配置为输出
    				 if(neg_scl&&(send_cnt<4'd8))begin
    				     		sda_ctrl<=1'b0;
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(sdi==1'b0)begin
    							state<=4'd4;
    							send_cnt<=4'd0;
    							send_data<=8'h00;
    						end
    				end
    			end
    
    			4'd4:begin//=========将port1配置为输出
    				if(neg_scl&&(send_cnt<4'd8))begin
    				    		sda_ctrl<=1'b0;
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(sdi==1'b0)begin
    							state<=4'd5;
    							send_cnt<=4'd0;
    							send_data<=8'h00;
    						end
    				end
    			end
    			
    			4'd5:begin//========等待 间隔时间，
    			if(neg_scl)begin
    				sdo<=1'b1;
    				scl_en<=1'b0;
    				sda_ctrl<=1'b0;
    			end else if(wait_cnt>=16'd200) begin
    				wait_cnt<=16'd0;
    				state<=4'd6;
    			end else
    				wait_cnt<=wait_cnt+1'b1;
    		end
    			
    			//===================================================================================输出数据
    			
    			4'd6:begin//========
    				scl_en<=1'b1;
    				if(scl_cnt>=8'd10)begin
    					sda_ctrl<=1'b0;
    					sdo<=1'b0;
    					state<=4'd7;
    					send_data<={iic_addr,1'b0};
    					send_cnt<=4'd0;
    				end else begin
    					sda_ctrl<=1'b0;
    					sdo<=1'b1;
    					state<=4'd6;
    				end
    			end
    	
    			4'd7:begin//======发送地址
    				if(neg_scl&&(send_cnt<4'd8))begin
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(sdi==1'b0)begin
    							state<=4'd8;
    							send_cnt<=4'd0;
    							send_data<=8'h02;
    						end
    				end
    			end
    			
    			4'd8:begin//======发送指令（输出指令）
    				 if(neg_scl&&(send_cnt<4'd8))begin
    				     		sda_ctrl<=1'b0;
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(sdi==1'b0)begin
    							state<=4'd9;
    							send_cnt<=4'd0;
    							send_data<=o_port_0;//====port_data[7:0]
    						end
    				end
    			end
    			
    			4'd9:begin//=======发送port 0 的值, 
    				 if(neg_scl&&(send_cnt<4'd8))begin
    				     		sda_ctrl<=1'b0;
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(sdi==1'b0)begin
    							state<=4'd10;
    							send_cnt<=4'd0;
    							send_data<=o_port_1;//====port_data[15:8]
    						end
    				end
    			end
    
    			4'd10:begin//=========发送port 1 的值
    				if(neg_scl&&(send_cnt<4'd8))begin
    				    		sda_ctrl<=1'b0;
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						sdo<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(sdi==1'b0)begin
    							state<=4'd12;
    							send_cnt<=4'd0;
    							send_data<=8'd0;
    						end
    				end
    			end
    				
    			4'd12:begin
    				if(neg_scl)begin
    				  	sda_ctrl<=1'b0;
    					sdo<=1'b1;
    				    	scl_en<=1'b0;
    					down<=~down;
    					state<=4'd0;
    				end		
    			end
    			
    		endcase
    	else begin
    		state<=4'd0;
    		scl_en<=1'b0;
    	end
    end  
    
endmodule

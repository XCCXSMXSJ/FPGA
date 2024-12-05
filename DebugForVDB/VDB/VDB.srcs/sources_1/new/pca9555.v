
module pca9555#(
		parameter	[7:0]		devide_clk=8'd50
//		parameter	[6:0]		iic_addr=7'b0100001
)

(
		input				sys_clk,// 50MHz
		
		//===iic
//		inout				sda,
        input       i_sda,
        output reg  o_sda=1'b1,
		output	reg			scl=1'b1,//fast mode max  400KHz;    standerd mode max 100KHz
		output reg		sda_ctrl=1'b0
		//==user
//		input				ready//====准备信号

    );
//	reg		sda_ctrl=1'b0;
//	reg		o_sda=1'b1;
//	wire		i_sda;
//	assign sda=sda_ctrl?1'bz:o_sda;
//	assign i_sda=sda_ctrl?sda:1'bz;//=====ack  (应答)，拉低为应答有效


	wire			ready;
	wire	[7:0]		o_port_0;
	wire	[7:0]		o_port_1;
	wire [6:0]		iic_addr;
vio_9555 vio_9555_inst (
  .clk(sys_clk),                // input wire clk
  .probe_out0(ready),  // output wire [0 : 0] probe_out0
  .probe_out1(o_port_0),  // output wire [7 : 0] probe_out1
  .probe_out2(o_port_1),  // output wire [7 : 0] probe_out2
  .probe_out3(iic_addr)  // output wire [6 : 0] probe_out3
);



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
    					o_sda<=1'b0;
    					state<=4'd1;
    					send_data<={iic_addr,1'b0};
    					send_cnt<=4'd0;
    				end else begin
    					sda_ctrl<=1'b0;
    					o_sda<=1'b1;
    					state<=4'd0;
    				end
    			end
    			
    			
    			4'd1:begin//======发送地址
    				if(neg_scl&&(send_cnt<4'd8))begin
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(i_sda==1'b0)begin
    							state<=4'd2;
    							send_cnt<=4'd0;
    							send_data<=8'h06;
    						end
    				end
    			end
    			
    			
    			4'd2:begin//======发送指令(要先进行配置寄存器)
    				 if(neg_scl&&(send_cnt<4'd8))begin
    				     		sda_ctrl<=1'b0;
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(i_sda==1'b0)begin
    							state<=4'd3;
    							send_cnt<=4'd0;
    							send_data<=8'h00;//====
    						end
    				end
    			end
    			
    			
    			4'd3:begin//=======发送port 0 的配置数值, 将port0配置为输出
    				 if(neg_scl&&(send_cnt<4'd8))begin
    				     		sda_ctrl<=1'b0;
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(i_sda==1'b0)begin
    							state<=4'd4;
    							send_cnt<=4'd0;
    							send_data<=8'h00;
    						end
    				end
    			end
    
    
    			4'd4:begin//=========发送port 1的配置数值, 将port1配置为输出
    				if(neg_scl&&(send_cnt<4'd8))begin
    				    		sda_ctrl<=1'b0;
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(i_sda==1'b0)begin
    							state<=4'd5;
    							send_cnt<=4'd0;
    							send_data<=8'h00;
    						end
    				end
    			end
    			
    			
    			4'd5:begin//========等待 间隔时间，读取数据指令
    			if(neg_scl)begin
    				o_sda<=1'b1;
    				scl_en<=1'b0;
    				sda_ctrl<=1'b0;
    			end else if(wait_cnt>=16'd200) begin
    				wait_cnt<=16'd0;
    				state<=4'd6;
    			end else
    				wait_cnt<=wait_cnt+1'b1;
    		end
    			
    			//===================================================================================输出数据
    			
    			4'd6:begin//========读取发送寄存器的值的流程开始
    				scl_en<=1'b1;
    				if(scl_cnt>=8'd10)begin
    					sda_ctrl<=1'b0;
    					o_sda<=1'b0;
    					state<=4'd7;
    					send_data<={iic_addr,1'b0};
    					send_cnt<=4'd0;
    				end else begin
    					sda_ctrl<=1'b0;
    					o_sda<=1'b1;
    					state<=4'd6;
    				end
    			end
    			
    			
    			
    			4'd7:begin//======发送地址
    				if(neg_scl&&(send_cnt<4'd8))begin
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(i_sda==1'b0)begin
    							state<=4'd8;
    							send_cnt<=4'd0;
    							send_data<=8'h02;
    						end
    				end
    			end
    			
    			
    			4'd8:begin//======发送指令(要先进行配置寄存器)
    				 if(neg_scl&&(send_cnt<4'd8))begin
    				     		sda_ctrl<=1'b0;
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(i_sda==1'b0)begin
    							state<=4'd9;
    							send_cnt<=4'd0;
    							send_data<=8'h55;//====o_port_0
    						end
    				end
    			end
    			
    			
    			4'd9:begin//=======发送port 0 的值, 
    				 if(neg_scl&&(send_cnt<4'd8))begin
    				     		sda_ctrl<=1'b0;
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(i_sda==1'b0)begin
    							state<=4'd10;
    							send_cnt<=4'd0;
    							send_data<=8'haa;//o_port_1
    						end
    				end
    			end
    
    
    			4'd10:begin//=========发送port 1 的值
    				if(neg_scl&&(send_cnt<4'd8))begin
    				    		sda_ctrl<=1'b0;
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    				end else if(neg_scl&&(send_cnt==4'd8))begin
    						o_sda<=send_data[7-send_cnt];
    						send_cnt<=send_cnt+1'b1;
    						sda_ctrl<=1'b1;
    				end else if((scl==1'b1)&&(send_cnt==4'd9))begin
    						if(i_sda==1'b0)begin
    							state<=4'd12;
    							send_cnt<=4'd0;
    							send_data<=8'd0;
    						end
    				end
    			end
    			
    			4'd12:begin
    				if(neg_scl)begin
    					o_sda<=1'b1;
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
    
    
    
    ila_9555 ila_9555_inst (
	.clk(sys_clk), // input wire clk


	.probe0(sda), // input wire [0:0]  probe0  
	.probe1(scl), // input wire [0:0]  probe1 
	.probe2(sda_ctrl), // input wire [0:0]  probe2 
	.probe3(o_sda), // input wire [0:0]  probe3 
	.probe4(i_sda), // input wire [0:0]  probe4 
	.probe5(state), // input wire [3:0]  probe5 
	.probe6(send_data), // input wire [7:0]  probe6 
	.probe7(send_cnt) // input wire [3:0]  probe7
);
    
    
    
    
    
    
    
    
    
    
endmodule

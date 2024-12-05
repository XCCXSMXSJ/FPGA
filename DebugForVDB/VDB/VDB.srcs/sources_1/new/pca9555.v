
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
//		input				ready//====׼���ź�

    );
//	reg		sda_ctrl=1'b0;
//	reg		o_sda=1'b1;
//	wire		i_sda;
//	assign sda=sda_ctrl?1'bz:o_sda;
//	assign i_sda=sda_ctrl?sda:1'bz;//=====ack  (Ӧ��)������ΪӦ����Ч


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



    //====��ȡready��������
    	reg		ready_delay;
    	wire		pos_ready;
    	
    assign pos_ready=ready&&(~ready_delay);
    	
  
    //=====��״̬���Ŀ�ʼ���������׼��    
    
       reg		start=1'b0;//===��ʼ����
       wire		pos_down;
       wire		neg_down;
       reg		down=1'b0;//====���ͽ���
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
      
    //======ʱ�ӷ�Ƶ   <400KHz
        reg	[7:0]	scl_cnt=8'd0;
        reg		scl_en=1'b0;//==========ʱ��ʹ��
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
      
    //======��ȡscl�������½���
    reg		scl_dalay;
    wire		pos_scl;//===�����زɼ�����
    wire		neg_scl;//==�½��ظı�����
    
    assign pos_scl=scl&&(~scl_dalay);
    assign neg_scl=(~scl)&&scl_dalay;

    always@(posedge sys_clk)begin
    	scl_dalay<=scl;
    end
    
    //========
    reg	[15:0]	wait_cnt=16'd0;
    reg	[3:0]	state=4'd0;//===״̬��״̬
    reg	[7:0]	send_data=8'd0;//====���͵����ݽ����ݴ�
    reg	[3:0]	send_cnt=4'd0;//==���͸�������
    
    reg	[7:0]	port_0=8'd0;
    reg	[7:0]	port_1=8'd0;
    
    always@(posedge sys_clk)begin
    	if(start)
    		case(state)
    			4'd0:begin//=====���ͣ���ʾ״̬��ʼ
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
    			
    			
    			4'd1:begin//======���͵�ַ
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
    			
    			
    			4'd2:begin//======����ָ��(Ҫ�Ƚ������üĴ���)
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
    			
    			
    			4'd3:begin//=======����port 0 ��������ֵ, ��port0����Ϊ���
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
    
    
    			4'd4:begin//=========����port 1��������ֵ, ��port1����Ϊ���
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
    			
    			
    			4'd5:begin//========�ȴ� ���ʱ�䣬��ȡ����ָ��
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
    			
    			//===================================================================================�������
    			
    			4'd6:begin//========��ȡ���ͼĴ�����ֵ�����̿�ʼ
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
    			
    			
    			
    			4'd7:begin//======���͵�ַ
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
    			
    			
    			4'd8:begin//======����ָ��(Ҫ�Ƚ������üĴ���)
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
    			
    			
    			4'd9:begin//=======����port 0 ��ֵ, 
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
    
    
    			4'd10:begin//=========����port 1 ��ֵ
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

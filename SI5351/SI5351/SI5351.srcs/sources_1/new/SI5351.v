
module SI5351(
        input                           sys_clk,//75M
//        input                           rst_n,
        
        output      reg             scl=1'b1,
        inout                           sda
        
//        input	[15:0]	    data,
//        input			    data_valid

    );
    
    
    wire		[15:0]	data;
    wire				data_valid;
    vio_0 vio_0_inst (
  .clk(sys_clk),              // input wire clk
  .probe_in0(data),  // input wire [15 : 0] probe_in0
  .probe_in1(data_valid)  // input wire [0 : 0] probe_in1
);
    
    
    parameter       chip_addr = 7'h60;
    
    parameter		IDLE = 4'd0;
    parameter		state1 = 4'd1;
    parameter		state2 = 4'd2;
    parameter		state3 = 4'd3;
    parameter		state4 = 4'd4;
    parameter		state5 = 4'd5;
    parameter		state6 = 4'd6;
    parameter		state7 = 4'd7;
    parameter		state8 = 4'd8;
    
    reg	[15:0]	wait_cnt=16'd0;
    reg	[7:0]		reg_cnt=8'd0;
    wire	[7:0]		reg_addr [18:0];		
    wire	[7:0]		reg_data [18:0];
    
    assign reg_addr[0] = 8'd3;		    assign reg_data[0] = 8'hfe;    
    assign reg_addr[1] = 8'd15;             assign reg_data[1] = 8'h00;    
    assign reg_addr[2] = 8'd16;             assign reg_data[2] = 8'h0f;    
    assign reg_addr[3] = 8'd26;             assign reg_data[3] = 8'h00;    
    assign reg_addr[4] = 8'd27;             assign reg_data[4] = 8'h01;    
    assign reg_addr[5] = 8'd28;             assign reg_data[5] = 8'h00;    
    assign reg_addr[6] = 8'd29;             assign reg_data[6] = data[15:8];//data[7:0];    
    assign reg_addr[7] = 8'd30;             assign reg_data[7] = data[7:0];//data[15:8];
    assign reg_addr[8] = 8'd31;             assign reg_data[8] = 8'h00;    
    assign reg_addr[9] = 8'd32;             assign reg_data[9] = 8'h00;    
    assign reg_addr[10] = 8'd33;           assign reg_data[10] = 8'h00;   
    assign reg_addr[11] = 8'd42;           assign reg_data[11] = 8'h00;   
    assign reg_addr[12] = 8'd43;           assign reg_data[12] = 8'h01;   
    assign reg_addr[13] = 8'd44;           assign reg_data[13] = 8'h00;   
    assign reg_addr[14] = 8'd45;           assign reg_data[14] = 8'hff;   
    assign reg_addr[15] = 8'd46;           assign reg_data[15] = 8'hff;   
    assign reg_addr[16] = 8'd47;           assign reg_data[16] = 8'h00;   
    assign reg_addr[17] = 8'd48;           assign reg_data[17] = 8'h00;   
    assign reg_addr[18] = 8'd49;           assign reg_data[18] = 8'h00;   
    
    reg             sda_ctrl = 1'b0;//==========用做iic的inout切换=====1读/0写
    reg             sdo = 1'b1;
    wire           sdi;
    
    reg  [9:0]    scl_cnt=10'd0;
    reg	       scl_en=1'b0;//==========时钟使能
    reg	       scl_dalay;
    wire	       pos_scl;//===上升沿采集数据
    wire	       neg_scl;//==下降沿改变数据
    
    reg	      data_valid_delay=1'b0;
    wire	      pos_valid;
    
    assign sda = sda_ctrl ? 1'bz : sdo;
    assign sdi = sda_ctrl ? sda : 1'bz;	
    assign pos_valid=data_valid&&(~data_valid_delay);
    assign pos_scl=scl&&(~scl_dalay);
    assign neg_scl=(~scl)&&scl_dalay;


    always@(posedge sys_clk)begin
    	scl_dalay<=scl;
    	data_valid_delay<=data_valid;
    end
    
//======时钟分频   
    always@(posedge sys_clk)begin
    	if(scl_en)begin
    		if(scl_cnt>=10'd63)begin
    			scl<=~scl;
    			scl_cnt<=10'd0;
    		end else begin
    		    	scl<=scl;
			scl_cnt<=scl_cnt+1'b1;
    		end 
    	end else begin
    		scl_cnt<=8'd0;
    		scl<=1'b1;
    	end
    end
    
    //============
    reg	[3:0]	state=4'd0;//===状态机状态
    reg	[3:0]	bit_cnt=4'd0;
    reg	[7:0] send_data=8'd0;
    
    always@(posedge sys_clk)begin
    	case(state)
    		IDLE:begin
    			if(pos_valid)begin
    				state<=state1;
    			end else begin
    				state<=IDLE;
    			end 
    		end
    
    		state1:begin
    			scl_en<=1'b1;
    			sda_ctrl<=1'b0;
    			sdo<=1'b0;
    			send_data<={chip_addr,1'b0};
    			state<=state2;
    		end
    
    		state2:begin//===========发送芯片地址
			if(neg_scl&&(bit_cnt<4'd8))begin
    				sdo<=send_data[7-bit_cnt];
    				bit_cnt<=bit_cnt+1'b1;
    			end else if(neg_scl&&(bit_cnt==4'd8))begin
    				sdo<=send_data[7-bit_cnt];
    				bit_cnt<=bit_cnt+1'b1;
    				sda_ctrl<=1'b1;
    			end else if((scl==1'b1)&&(bit_cnt==4'd9))begin
    				if(sdi==1'b0)begin
    					state<=state3;
    					bit_cnt<=4'd0;
    					send_data<=reg_addr[reg_cnt];
    				end
    			end
    		end
    
    		state3:begin//======发送寄存器地址
			if(neg_scl&&(bit_cnt<4'd8))begin
    				sdo<=send_data[7-bit_cnt];
    				bit_cnt<=bit_cnt+1'b1;
    			end else if(neg_scl&&(bit_cnt==4'd8))begin
    				sdo<=send_data[7-bit_cnt];
    				bit_cnt<=bit_cnt+1'b1;
    				sda_ctrl<=1'b1;
    			end else if((scl==1'b1)&&(bit_cnt==4'd9))begin
    				if(sdi==1'b0)begin
    					state<=state4;
    					bit_cnt<=4'd0;
    					send_data<=reg_data[reg_cnt];
    				end
    			end
    		end
    
    		state4:begin//=======发送对应的寄存器数据
			if(neg_scl&&(bit_cnt<4'd8))begin
    				sdo<=send_data[7-bit_cnt];
    				bit_cnt<=bit_cnt+1'b1;
    			end else if(neg_scl&&(bit_cnt==4'd8))begin
    				sdo<=send_data[7-bit_cnt];
    				bit_cnt<=bit_cnt+1'b1;
    				sda_ctrl<=1'b1;
    			end else if((scl==1'b1)&&(bit_cnt==4'd9))begin
    				if(sdi==1'b0)begin
    					state<=state5;
    					bit_cnt<=4'd0;
    					send_data<=8'd0;
    				end
    			end
    		end
    		
    		state5:begin//=======iic结束
    			if(scl_cnt >= 8'd60)begin
    				sdo<=1'b1;
    				scl_en<=1'b0;
    				state<=state6;
    			end
    		end
    		
    		state6:begin
    			if(wait_cnt>=16'd300)begin
    				wait_cnt<=16'd0;
    				state<=state7;
    			end else begin
    				wait_cnt<=wait_cnt +1'b1;
    				state<=state6;
    			end 
    		end 
    		
    		state7:begin
    			if(reg_cnt <= 8'd17)begin
    				state<=state1;
    				reg_cnt <= reg_cnt+1'b1;
    			end else begin
    				state<=IDLE;
    				reg_cnt<=8'd0;
    			end 
    		end 
    	endcase
    
    end 
    
    ila_0 ila_0_inst (
	.clk(sys_clk), // input wire clk


	.probe0(scl), // input wire [0:0]  probe0  
	.probe1(data_valid), // input wire [0:0]  probe1 
	.probe2(state), // input wire [3:0]  probe2 
	.probe3(reg_cnt), // input wire [7:0]  probe3 
	.probe4(sdo), // input wire [0:0]  probe4 
	.probe5(sdi), // input wire [0:0]  probe5 
	.probe6(sda_ctrl), // input wire [0:0]  probe6 
	.probe7(bit_cnt), // input wire [3:0]  probe7 
	.probe8(send_data) // input wire [7:0]  probe8
);
    
    
    
endmodule

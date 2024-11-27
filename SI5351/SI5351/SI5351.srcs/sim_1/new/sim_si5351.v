

module sim_si5351(

    );
    reg		sys_clk = 1'b0;
    wire		sda;
    wire		scl;
    reg		valid=1'b0;
    
    assign sda = 1'b0;
    always #10 sys_clk <= ~sys_clk;
    
    
    initial begin
    valid = 1'b0;
    # 100
    valid = 1'b1;
    
    
    end 
    
    
    
    
    SI5351 SI5351_inst(
    
       .  sys_clk(sys_clk),
       .  rst_n(1'b1),
       
       . scl(scl),
       . sda(sda),
       . data_valid(valid)

    );
    
    
    
    
endmodule

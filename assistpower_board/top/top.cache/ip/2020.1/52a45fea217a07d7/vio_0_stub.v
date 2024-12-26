// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Wed Dec 25 10:02:25 2024
// Host        : DESKTOP-1M5ID73 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ vio_0_stub.v
// Design      : vio_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a50tftg256-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2020.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk, probe_out0, probe_out1, probe_out2, 
  probe_out3, probe_out4, probe_out5, probe_out6, probe_out7, probe_out8, probe_out9, 
  probe_out10, probe_out11, probe_out12, probe_out13, probe_out14, probe_out15, probe_out16, 
  probe_out17)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_out0[15:0],probe_out1[15:0],probe_out2[15:0],probe_out3[15:0],probe_out4[0:0],probe_out5[15:0],probe_out6[15:0],probe_out7[15:0],probe_out8[15:0],probe_out9[0:0],probe_out10[15:0],probe_out11[15:0],probe_out12[15:0],probe_out13[15:0],probe_out14[0:0],probe_out15[0:0],probe_out16[0:0],probe_out17[0:0]" */;
  input clk;
  output [15:0]probe_out0;
  output [15:0]probe_out1;
  output [15:0]probe_out2;
  output [15:0]probe_out3;
  output [0:0]probe_out4;
  output [15:0]probe_out5;
  output [15:0]probe_out6;
  output [15:0]probe_out7;
  output [15:0]probe_out8;
  output [0:0]probe_out9;
  output [15:0]probe_out10;
  output [15:0]probe_out11;
  output [15:0]probe_out12;
  output [15:0]probe_out13;
  output [0:0]probe_out14;
  output [0:0]probe_out15;
  output [0:0]probe_out16;
  output [0:0]probe_out17;
endmodule

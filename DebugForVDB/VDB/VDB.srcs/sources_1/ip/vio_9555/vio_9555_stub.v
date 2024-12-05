// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Wed Aug  7 11:30:25 2024
// Host        : DESKTOP-1M5ID73 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/project/vivado_2020_prj/RGA/DebugForVDB/VDB/VDB.srcs/sources_1/ip/vio_9555/vio_9555_stub.v
// Design      : vio_9555
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a50tftg256-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2020.1" *)
module vio_9555(clk, probe_out0, probe_out1, probe_out2, 
  probe_out3)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_out0[0:0],probe_out1[7:0],probe_out2[7:0],probe_out3[6:0]" */;
  input clk;
  output [0:0]probe_out0;
  output [7:0]probe_out1;
  output [7:0]probe_out2;
  output [6:0]probe_out3;
endmodule

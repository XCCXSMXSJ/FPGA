
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2$
create_project: 2default:default2
00:00:022default:default2
00:00:062default:default2
1070.6882default:default2
0.0002default:defaultZ17-268h px� 
p
Command: %s
53*	vivadotcl2?
+synth_design -top top -part xc7a50tftg256-22default:defaultZ4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xc7a50t2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xc7a50t2default:defaultZ17-349h px� 
V
Loading part %s157*device2#
xc7a50tftg256-22default:defaultZ21-403h px� 
�
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
22default:defaultZ8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
a
#Helper process launched with PID %s4824*oasys2
1092202default:defaultZ8-7075h px� 
�
Pparameter declaration becomes local in %s with formal parameter declaration list2507*oasys2
AD71722default:default2r
\D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/AD7172.v2default:default2
552default:default8@Z8-2507h px� 
�
Pparameter declaration becomes local in %s with formal parameter declaration list2507*oasys2
AD71722default:default2r
\D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/AD7172.v2default:default2
562default:default8@Z8-2507h px� 
�
Pparameter declaration becomes local in %s with formal parameter declaration list2507*oasys2
AD71722default:default2r
\D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/AD7172.v2default:default2
572default:default8@Z8-2507h px� 
�
Pparameter declaration becomes local in %s with formal parameter declaration list2507*oasys2
AD71722default:default2r
\D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/AD7172.v2default:default2
582default:default8@Z8-2507h px� 
�
Pparameter declaration becomes local in %s with formal parameter declaration list2507*oasys2
AD71722default:default2r
\D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/AD7172.v2default:default2
592default:default8@Z8-2507h px� 
�
Pparameter declaration becomes local in %s with formal parameter declaration list2507*oasys2
AD71722default:default2r
\D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/AD7172.v2default:default2
602default:default8@Z8-2507h px� 
�
%s*synth2�
wStarting RTL Elaboration : Time (s): cpu = 00:00:08 ; elapsed = 00:00:08 . Memory (MB): peak = 1070.688 ; gain = 0.000
2default:defaulth px� 
�
synthesizing module '%s'%s4497*oasys2
top2default:default2
 2default:default2o
YD:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/top.v2default:default2
12default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2
vio_02default:default2
 2default:default2�
�D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.runs/synth_1/.Xil/Vivado-104276-DESKTOP-1M5ID73/realtime/vio_0_stub.v2default:default2
62default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
vio_02default:default2
 2default:default2
12default:default2
12default:default2�
�D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.runs/synth_1/.Xil/Vivado-104276-DESKTOP-1M5ID73/realtime/vio_0_stub.v2default:default2
62default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
AD71722default:default2
 2default:default2r
\D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/AD7172.v2default:default2
272default:default8@Z8-6157h px� 
[
%s
*synth2C
/	Parameter SYS_CLK_FREQ bound to: 8'b00110010 
2default:defaulth p
x
� 
d
%s
*synth2L
8	Parameter CHANNEL0_CFG bound to: 16'b1000000000100000 
2default:defaulth p
x
� 
d
%s
*synth2L
8	Parameter CHANNEL1_CFG bound to: 16'b1000000001000000 
2default:defaulth p
x
� 
d
%s
*synth2L
8	Parameter CHANNEL2_CFG bound to: 16'b1000000001100000 
2default:defaulth p
x
� 
d
%s
*synth2L
8	Parameter CHANNEL3_CFG bound to: 16'b1000000010000000 
2default:defaulth p
x
� 
S
%s
*synth2;
'	Parameter IDLE bound to: 8'b00000000 
2default:defaulth p
x
� 
S
%s
*synth2;
'	Parameter WAIT bound to: 8'b00000001 
2default:defaulth p
x
� 
V
%s
*synth2>
*	Parameter INITIAL bound to: 8'b00000010 
2default:defaulth p
x
� 
T
%s
*synth2<
(	Parameter WRITE bound to: 8'b00000011 
2default:defaulth p
x
� 
T
%s
*synth2<
(	Parameter AWAIT bound to: 8'b00000100 
2default:defaulth p
x
� 
S
%s
*synth2;
'	Parameter READ bound to: 8'b00000101 
2default:defaulth p
x
� 
�
evariable '%s' is written by both blocking and non-blocking assignments, entire logic could be removed4426*oasys2

next_state2default:default2r
\D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/AD7172.v2default:default2
1982default:default8@Z8-6090h px� 
�
evariable '%s' is written by both blocking and non-blocking assignments, entire logic could be removed4426*oasys2

next_state2default:default2r
\D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/AD7172.v2default:default2
1992default:default8@Z8-6090h px� 
�
Fall outputs are unconnected for this instance and logic may be removed3605*oasys2r
\D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/AD7172.v2default:default2
3152default:default8@Z8-4446h px� 
�
synthesizing module '%s'%s4497*oasys2
ila_02default:default2
 2default:default2�
�D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.runs/synth_1/.Xil/Vivado-104276-DESKTOP-1M5ID73/realtime/ila_0_stub.v2default:default2
62default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
ila_02default:default2
 2default:default2
22default:default2
12default:default2�
�D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.runs/synth_1/.Xil/Vivado-104276-DESKTOP-1M5ID73/realtime/ila_0_stub.v2default:default2
62default:default8@Z8-6155h px� 
�
fMark debug on the nets applies keep_hierarchy on instance '%s'. This will prevent further optimization4399*oasys2

ila_0_inst2default:default2r
\D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/AD7172.v2default:default2
3152default:default8@Z8-6071h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
AD71722default:default2
 2default:default2
32default:default2
12default:default2r
\D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/AD7172.v2default:default2
272default:default8@Z8-6155h px� 
�
fMark debug on the nets applies keep_hierarchy on instance '%s'. This will prevent further optimization4399*oasys2

vio_0_inst2default:default2o
YD:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/top.v2default:default2
222default:default8@Z8-6071h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
top2default:default2
 2default:default2
42default:default2
12default:default2o
YD:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/new/top.v2default:default2
12default:default8@Z8-6155h px� 
�
%s*synth2�
wFinished RTL Elaboration : Time (s): cpu = 00:00:10 ; elapsed = 00:00:11 . Memory (MB): peak = 1070.688 ; gain = 0.000
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:10 ; elapsed = 00:00:12 . Memory (MB): peak = 1070.688 ; gain = 0.000
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 1 : Time (s): cpu = 00:00:10 ; elapsed = 00:00:12 . Memory (MB): peak = 1070.688 ; gain = 0.000
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0192default:default2
1070.6882default:default2
0.0002default:defaultZ17-268h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
>

Processing XDC Constraints
244*projectZ1-262h px� 
=
Initializing timing engine
348*projectZ1-569h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2�
sd:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/ip/ila_0/ila_0/ila_0_in_context.xdc2default:default2,
ad7172_inst/ila_0_inst	2default:default8Z20-848h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2�
sd:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/ip/ila_0/ila_0/ila_0_in_context.xdc2default:default2,
ad7172_inst/ila_0_inst	2default:default8Z20-847h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2�
sd:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/ip/vio_0/vio_0/vio_0_in_context.xdc2default:default2 

vio_0_inst	2default:default8Z20-848h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2�
sd:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/sources_1/ip/vio_0/vio_0/vio_0_in_context.xdc2default:default2 

vio_0_inst	2default:default8Z20-847h px� 
�
Parsing XDC File [%s]
179*designutils2q
[D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/constrs_1/new/top.xdc2default:default8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2q
[D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/constrs_1/new/top.xdc2default:default8Z20-178h px� 
�
�Implementation specific constraints were found while reading constraint file [%s]. These constraints will be ignored for synthesis but will be used in implementation. Impacted constraints are listed in the file [%s].
233*project2o
[D:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.srcs/constrs_1/new/top.xdc2default:default2)
.Xil/top_propImpl.xdc2default:defaultZ1-236h px� 
H
&Completed Processing XDC Constraints

245*projectZ1-263h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0012default:default2
1161.9142default:default2
0.0002default:defaultZ17-268h px� 
~
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common24
 Constraint Validation Runtime : 2default:default2
00:00:002default:default2 
00:00:00.0362default:default2
1161.9142default:default2
0.0002default:defaultZ17-268h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
~Finished Constraint Validation : Time (s): cpu = 00:00:21 ; elapsed = 00:00:25 . Memory (MB): peak = 1161.914 ; gain = 91.227
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
V
%s
*synth2>
*Start Loading Part and Timing Information
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Loading part: xc7a50tftg256-2
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:21 ; elapsed = 00:00:25 . Memory (MB): peak = 1161.914 ; gain = 91.227
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Z
%s
*synth2B
.Start Applying 'set_property' XDC Constraints
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:21 ; elapsed = 00:00:25 . Memory (MB): peak = 1161.914 ; gain = 91.227
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:21 ; elapsed = 00:00:26 . Memory (MB): peak = 1161.914 ; gain = 91.227
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
� 
:
%s
*synth2"
+---Adders : 
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    8 Bit       Adders := 3     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    5 Bit       Adders := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    3 Bit       Adders := 1     
2default:defaulth p
x
� 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               32 Bit    Registers := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               24 Bit    Registers := 5     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                8 Bit    Registers := 4     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                4 Bit    Registers := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                1 Bit    Registers := 11    
2default:defaulth p
x
� 
9
%s
*synth2!
+---Muxes : 
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   32 Bit        Muxes := 4     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   24 Bit        Muxes := 3     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   7 Input   24 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input   24 Bit        Muxes := 4     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    8 Bit        Muxes := 8     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    4 Bit        Muxes := 5     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   7 Input    4 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    3 Bit        Muxes := 3     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    2 Bit        Muxes := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    1 Bit        Muxes := 26    
2default:defaulth p
x
� 
X
%s
*synth2@
,	   7 Input    1 Bit        Muxes := 13    
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input    1 Bit        Muxes := 1     
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Finished RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2k
WPart Resources:
DSPs: 120 (col length:60)
BRAMs: 150 (col length: RAMB18 60 RAMB36 30)
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
W
%s
*synth2?
+Start Cross Boundary and Area Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:25 ; elapsed = 00:00:30 . Memory (MB): peak = 1161.914 ; gain = 91.227
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
R
%s
*synth2:
&Start Applying XDC Timing Constraints
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Applying XDC Timing Constraints : Time (s): cpu = 00:00:34 ; elapsed = 00:00:39 . Memory (MB): peak = 1161.914 ; gain = 91.227
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
F
%s
*synth2.
Start Timing Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
|Finished Timing Optimization : Time (s): cpu = 00:00:35 ; elapsed = 00:00:40 . Memory (MB): peak = 1166.422 ; gain = 95.734
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-
Start Technology Mapping
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
|Finished Technology Mapping : Time (s): cpu = 00:00:36 ; elapsed = 00:00:41 . Memory (MB): peak = 1171.457 ; gain = 100.770
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
?
%s
*synth2'
Start IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Q
%s
*synth29
%Start Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
T
%s
*synth2<
(Finished Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
vFinished IO Insertion : Time (s): cpu = 00:00:43 ; elapsed = 00:00:48 . Memory (MB): peak = 1177.242 ; gain = 106.555
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Start Renaming Generated Instances
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:00:43 ; elapsed = 00:00:48 . Memory (MB): peak = 1177.242 ; gain = 106.555
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start Rebuilding User Hierarchy
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:43 ; elapsed = 00:00:48 . Memory (MB): peak = 1177.242 ; gain = 106.555
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Renaming Generated Ports
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:00:43 ; elapsed = 00:00:48 . Memory (MB): peak = 1177.242 ; gain = 106.555
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:43 ; elapsed = 00:00:48 . Memory (MB): peak = 1177.242 ; gain = 106.555
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Start Renaming Generated Nets
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:00:43 ; elapsed = 00:00:48 . Memory (MB): peak = 1177.242 ; gain = 106.555
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Writing Synthesis Report
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
A
%s
*synth2)

Report BlackBoxes: 
2default:defaulth p
x
� 
O
%s
*synth27
#+------+--------------+----------+
2default:defaulth p
x
� 
O
%s
*synth27
#|      |BlackBox name |Instances |
2default:defaulth p
x
� 
O
%s
*synth27
#+------+--------------+----------+
2default:defaulth p
x
� 
O
%s
*synth27
#|1     |ila_0         |         1|
2default:defaulth p
x
� 
O
%s
*synth27
#|2     |vio_0         |         1|
2default:defaulth p
x
� 
O
%s
*synth27
#+------+--------------+----------+
2default:defaulth p
x
� 
A
%s*synth2)

Report Cell Usage: 
2default:defaulth px� 
D
%s*synth2,
+------+-------+------+
2default:defaulth px� 
D
%s*synth2,
|      |Cell   |Count |
2default:defaulth px� 
D
%s*synth2,
+------+-------+------+
2default:defaulth px� 
D
%s*synth2,
|1     |ila    |     1|
2default:defaulth px� 
D
%s*synth2,
|2     |vio    |     1|
2default:defaulth px� 
D
%s*synth2,
|3     |BUFG   |     1|
2default:defaulth px� 
D
%s*synth2,
|4     |CARRY4 |     3|
2default:defaulth px� 
D
%s*synth2,
|5     |LUT1   |     8|
2default:defaulth px� 
D
%s*synth2,
|6     |LUT2   |   158|
2default:defaulth px� 
D
%s*synth2,
|7     |LUT3   |    91|
2default:defaulth px� 
D
%s*synth2,
|8     |LUT4   |   169|
2default:defaulth px� 
D
%s*synth2,
|9     |LUT5   |    45|
2default:defaulth px� 
D
%s*synth2,
|10    |LUT6   |    73|
2default:defaulth px� 
D
%s*synth2,
|11    |MUXF7  |     3|
2default:defaulth px� 
D
%s*synth2,
|12    |FDCE   |    99|
2default:defaulth px� 
D
%s*synth2,
|13    |FDCP   |     2|
2default:defaulth px� 
D
%s*synth2,
|14    |FDCPE  |    73|
2default:defaulth px� 
D
%s*synth2,
|15    |FDPE   |    77|
2default:defaulth px� 
D
%s*synth2,
|16    |FDRE   |   107|
2default:defaulth px� 
D
%s*synth2,
|17    |LDC    |    75|
2default:defaulth px� 
D
%s*synth2,
|18    |IBUF   |     2|
2default:defaulth px� 
D
%s*synth2,
|19    |OBUF   |     3|
2default:defaulth px� 
D
%s*synth2,
+------+-------+------+
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:00:43 ; elapsed = 00:00:48 . Memory (MB): peak = 1177.242 ; gain = 106.555
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
r
%s
*synth2Z
FSynthesis finished with 0 errors, 0 critical warnings and 0 warnings.
2default:defaulth p
x
� 
�
%s
*synth2�
~Synthesis Optimization Runtime : Time (s): cpu = 00:00:29 ; elapsed = 00:00:42 . Memory (MB): peak = 1177.242 ; gain = 15.328
2default:defaulth p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:00:43 ; elapsed = 00:00:48 . Memory (MB): peak = 1177.242 ; gain = 106.555
2default:defaulth p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0182default:default2
1188.1482default:default2
0.0002default:defaultZ17-268h px� 
g
-Analyzing %s Unisim elements for replacement
17*netlist2
1562default:defaultZ29-17h px� 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0012default:default2
1188.6482default:default2
0.0002default:defaultZ17-268h px� 
�
!Unisim Transformation Summary:
%s111*project2�
�  A total of 150 instances were transformed.
  FDCP => FDCP (FDCE, FDPE, LDCE, LUT3, VCC): 2 instances
  FDCPE => FDCPE (FDCE, FDPE, LDCE, LUT3, VCC): 73 instances
  LDC => LDCE: 75 instances
2default:defaultZ1-111h px� 
U
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
252default:default2
92default:default2
02default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
synth_design2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
synth_design: 2default:default2
00:00:542default:default2
00:01:062default:default2
1188.6482default:default2
117.9612default:defaultZ17-268h px� 
�
4The following parameters have non-default value.
%s
395*common24
 tcl.collectionResultDisplayLimit2default:defaultZ17-600h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2i
UD:/project/vivado_2020_prj/Chip_development/AD7172/AD7172/AD7172.runs/synth_1/top.dcp2default:defaultZ17-1381h px� 
�
%s4*runtcl2p
\Executing : report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb
2default:defaulth px� 
�
Exiting %s at %s...
206*common2
Vivado2default:default2,
Thu Nov 28 11:05:34 20242default:defaultZ17-206h px� 


End Record
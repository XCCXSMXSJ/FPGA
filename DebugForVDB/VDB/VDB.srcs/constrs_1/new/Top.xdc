set_property PACKAGE_PIN D13 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property PACKAGE_PIN H11 [get_ports tla2024_sda]
set_property PACKAGE_PIN G12 [get_ports tla2024_scl]
set_property PACKAGE_PIN F13 [get_ports pca9555_sda]
set_property PACKAGE_PIN H12 [get_ports pca9555_scl]
set_property IOSTANDARD LVCMOS33 [get_ports pca9555_scl]
set_property IOSTANDARD LVCMOS33 [get_ports pca9555_sda]
set_property IOSTANDARD LVCMOS33 [get_ports tla2024_scl]
set_property IOSTANDARD LVCMOS33 [get_ports tla2024_sda]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets sys_clk_IBUF_BUFG]
create_clock -period 20 -name sys_clk -add [get_ports sys_clk]
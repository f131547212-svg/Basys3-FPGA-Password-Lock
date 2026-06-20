# ----------------------------------------------------------------------------
# Basys 3 管腳約束檔 (XDC) - 期末專題：互動式硬體密碼鎖專用
# ----------------------------------------------------------------------------

# 系統時脈 (Clock signal) - 100MHz (W5 腳位)
set_property PACKAGE_PIN W5 [get_ports clk]							
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# 指撥開關 (Switches) - SW3 ~ SW0 (密碼輸入用)
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]

# LED 指示燈 - LD15 (鎖死指示燈)
set_property PACKAGE_PIN L1 [get_ports {led[15]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[15]}]

# 七段顯示器字型控制 (7 Segment Displays - seg[6:0])
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {sw_temp[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_temp[0]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

# 七段顯示器位數致能 (Digit Enables - an[3:0])
set_property PACKAGE_PIN U2 [get_ports {an[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

# 按鈕 (Buttons)
# 正中央按鈕 BTN-C (驗證密碼)
set_property PACKAGE_PIN U18 [get_ports btnC]						
set_property IOSTANDARD LVCMOS33 [get_ports btnC]
# 最右側按鈕 BTN-R (系統非同步重置)
set_property PACKAGE_PIN T17 [get_ports rst]						
set_property IOSTANDARD LVCMOS33 [get_ports rst]

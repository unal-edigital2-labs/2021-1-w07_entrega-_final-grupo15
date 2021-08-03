################################################################################
# IO constraints
################################################################################
# serial:0.tx
set_property LOC D4 [get_ports {serial_tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {serial_tx}]

# serial:0.rx
set_property LOC C4 [get_ports {serial_rx}]
set_property IOSTANDARD LVCMOS33 [get_ports {serial_rx}]

# clk:0
set_property LOC E3 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]

# cpu_reset:0
set_property LOC C12 [get_ports {cpu_reset}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_reset}]

# btnc:0
set_property LOC N17 [get_ports {btnc}]
set_property IOSTANDARD LVCMOS33 [get_ports {btnc}]

# btnr:0
set_property LOC M17 [get_ports {btnr}]
set_property IOSTANDARD LVCMOS33 [get_ports {btnr}]

# btnl:0
set_property LOC P17 [get_ports {btnl}]
set_property IOSTANDARD LVCMOS33 [get_ports {btnl}]

# servo_out:0
set_property LOC H4 [get_ports {servo_out}]
set_property IOSTANDARD LVCMOS33 [get_ports {servo_out}]

# trigger:0
set_property LOC H1 [get_ports {trigger}]
set_property IOSTANDARD LVCMOS33 [get_ports {trigger}]

# echo:0
set_property LOC G1 [get_ports {echo}]
set_property IOSTANDARD LVCMOS33 [get_ports {echo}]

# infrarojoc:0
set_property LOC K1 [get_ports {infrarojoc}]
set_property IOSTANDARD LVCMOS33 [get_ports {infrarojoc}]

# infrarojor:0
set_property LOC F6 [get_ports {infrarojor}]
set_property IOSTANDARD LVCMOS33 [get_ports {infrarojor}]

# infrarojol:0
set_property LOC J2 [get_ports {infrarojol}]
set_property IOSTANDARD LVCMOS33 [get_ports {infrarojol}]

# motorA:0
set_property LOC J3 [get_ports {motorA0}]
set_property IOSTANDARD LVCMOS33 [get_ports {motorA0}]

# motorA:1
set_property LOC J4 [get_ports {motorA1}]
set_property IOSTANDARD LVCMOS33 [get_ports {motorA1}]

# motorB:0
set_property LOC E6 [get_ports {motorB0}]
set_property IOSTANDARD LVCMOS33 [get_ports {motorB0}]

# motorB:1
set_property LOC G3 [get_ports {motorB1}]
set_property IOSTANDARD LVCMOS33 [get_ports {motorB1}]

# pwm1:0
set_property LOC G6 [get_ports {pwm1}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm1}]

# pwm2:0
set_property LOC E7 [get_ports {pwm2}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm2}]

# Aclock:0
set_property LOC G13 [get_ports {Aclock0}]
set_property IOSTANDARD LVCMOS33 [get_ports {Aclock0}]

# vsync:0
set_property LOC B12 [get_ports {vsync0}]
set_property IOSTANDARD LVCMOS33 [get_ports {vsync0}]

# hsync:0
set_property LOC B11 [get_ports {hsync0}]
set_property IOSTANDARD LVCMOS33 [get_ports {hsync0}]

# vga:0
set_property LOC A3 [get_ports {vga0}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga0}]

# vga:1
set_property LOC B4 [get_ports {vga1}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga1}]

# vga:2
set_property LOC C5 [get_ports {vga2}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga2}]

# vga:3
set_property LOC A4 [get_ports {vga3}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga3}]

# vga:4
set_property LOC C6 [get_ports {vga4}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga4}]

# vga:5
set_property LOC A5 [get_ports {vga5}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga5}]

# vga:6
set_property LOC B6 [get_ports {vga6}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga6}]

# vga:7
set_property LOC A6 [get_ports {vga7}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga7}]

# vga:8
set_property LOC B7 [get_ports {vga8}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga8}]

# vga:9
set_property LOC C7 [get_ports {vga9}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga9}]

# vga:10
set_property LOC D7 [get_ports {vga10}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga10}]

# vga:11
set_property LOC D8 [get_ports {vga11}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga11}]

# XClock:0
set_property LOC G16 [get_ports {XClock0}]
set_property IOSTANDARD LVCMOS33 [get_ports {XClock0}]

# Data:0
set_property LOC E18 [get_ports {Data0}]
set_property IOSTANDARD LVCMOS33 [get_ports {Data0}]

# Data:1
set_property LOC F18 [get_ports {Data1}]
set_property IOSTANDARD LVCMOS33 [get_ports {Data1}]

# Data:2
set_property LOC G17 [get_ports {Data2}]
set_property IOSTANDARD LVCMOS33 [get_ports {Data2}]

# Data:3
set_property LOC G18 [get_ports {Data3}]
set_property IOSTANDARD LVCMOS33 [get_ports {Data3}]

# Data:4
set_property LOC D14 [get_ports {Data4}]
set_property IOSTANDARD LVCMOS33 [get_ports {Data4}]

# Data:5
set_property LOC E16 [get_ports {Data5}]
set_property IOSTANDARD LVCMOS33 [get_ports {Data5}]

# Data:6
set_property LOC F16 [get_ports {Data6}]
set_property IOSTANDARD LVCMOS33 [get_ports {Data6}]

# Data:7
set_property LOC F13 [get_ports {Data7}]
set_property IOSTANDARD LVCMOS33 [get_ports {Data7}]

# Vsync_cam:0
set_property LOC H16 [get_ports {Vsync_cam0}]
set_property IOSTANDARD LVCMOS33 [get_ports {Vsync_cam0}]

# Href:0
set_property LOC H14 [get_ports {Href0}]
set_property IOSTANDARD LVCMOS33 [get_ports {Href0}]

# UARTB1:0
set_property LOC G2 [get_ports {UARTB10}]
set_property IOSTANDARD LVCMOS33 [get_ports {UARTB10}]

# UARTB1:1
set_property LOC F3 [get_ports {UARTB11}]
set_property IOSTANDARD LVCMOS33 [get_ports {UARTB11}]

# UARTA1:0
set_property LOC H2 [get_ports {UARTA10}]
set_property IOSTANDARD LVCMOS33 [get_ports {UARTA10}]

# UARTA1:1
set_property LOC G4 [get_ports {UARTA11}]
set_property IOSTANDARD LVCMOS33 [get_ports {UARTA11}]

################################################################################
# Design constraints
################################################################################

set_property INTERNAL_VREF 0.750 [get_iobanks 34]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Aclock0_IBUF]

################################################################################
# Clock constraints
################################################################################


################################################################################
# False path constraints
################################################################################


set_false_path -quiet -through [get_nets -hierarchical -filter {mr_ff == TRUE}]

set_false_path -quiet -to [get_pins -filter {REF_PIN_NAME == PRE} -of_objects [get_cells -hierarchical -filter {ars_ff1 == TRUE || ars_ff2 == TRUE}]]

set_max_delay 2 -quiet -from [get_pins -filter {REF_PIN_NAME == C} -of_objects [get_cells -hierarchical -filter {ars_ff1 == TRUE}]] -to [get_pins -filter {REF_PIN_NAME == D} -of_objects [get_cells -hierarchical -filter {ars_ff2 == TRUE}]]
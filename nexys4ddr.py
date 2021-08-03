from litex.build.generic_platform import *
from litex.build.xilinx import XilinxPlatform, VivadoProgrammer

# IOs ----------------------------------------------------------------------------------------------

_io = [
    ("led",  0, Pins("H17"), IOStandard("LVCMOS33")),
    ("led",  1, Pins("K15"), IOStandard("LVCMOS33")),
    ("led",  2, Pins("J13"), IOStandard("LVCMOS33")),
    ("led",  3, Pins("N14"), IOStandard("LVCMOS33")),
    ("led",  4, Pins("R18"), IOStandard("LVCMOS33")),
    ("led",  5, Pins("V17"), IOStandard("LVCMOS33")),
    ("led",  6, Pins("U17"), IOStandard("LVCMOS33")),
    ("led",  7, Pins("U16"), IOStandard("LVCMOS33")),
    ("led",  8, Pins("V16"), IOStandard("LVCMOS33")),
    ("led",  9, Pins("T15"), IOStandard("LVCMOS33")),
    ("led", 10, Pins("U14"), IOStandard("LVCMOS33")),
    ("led", 11, Pins("T16"), IOStandard("LVCMOS33")),

    ("sw",  0, Pins("J15"), IOStandard("LVCMOS33")),
    ("sw",  1, Pins("L16"), IOStandard("LVCMOS33")),
    ("sw",  2, Pins("M13"), IOStandard("LVCMOS33")),
    ("sw",  3, Pins("R15"), IOStandard("LVCMOS33")),
    ("sw",  4, Pins("R17"), IOStandard("LVCMOS33")),
    ("sw",  5, Pins("T18"), IOStandard("LVCMOS33")),
    ("sw",  6, Pins("U18"), IOStandard("LVCMOS33")),
    ("sw",  7, Pins("R13"), IOStandard("LVCMOS33")),
    
    ("btnc", 0, Pins("N17"), IOStandard("LVCMOS33")),
    ("btnr", 0, Pins("M17"), IOStandard("LVCMOS33")),
    ("btnl", 0, Pins("P17"), IOStandard("LVCMOS33")),

    ("ledRGB", 1,
        Subsignal("r", Pins("N15")),
        Subsignal("g", Pins("M16")),
        Subsignal("b", Pins("R12")),
        IOStandard("LVCMOS33")),

    ("ledRGB", 2,
        Subsignal("r", Pins("N16")),
        Subsignal("g", Pins("R11")),
        Subsignal("b", Pins("G14")),
        IOStandard("LVCMOS33")),
       
    ("display_digit",  0, Pins("J17"), IOStandard("LVCMOS33")),
    ("display_digit",  1, Pins("J18"), IOStandard("LVCMOS33")),
    ("display_digit",  2, Pins("T9"), IOStandard("LVCMOS33")),
    ("display_digit",  3, Pins("J14"), IOStandard("LVCMOS33")),
    ("display_digit",  4, Pins("P14"), IOStandard("LVCMOS33")),
    ("display_digit",  5, Pins("T14"), IOStandard("LVCMOS33")),
    ("display_digit",  6, Pins("K2"), IOStandard("LVCMOS33")),
    ("display_digit",  7, Pins("U13"), IOStandard("LVCMOS33")),
    ("display_segment", 0, Pins("T10"), IOStandard("LVCMOS33")),
    ("display_segment", 1, Pins("R10"), IOStandard("LVCMOS33")),
    ("display_segment", 2, Pins("K16"), IOStandard("LVCMOS33")),
    ("display_segment", 3, Pins("K13"), IOStandard("LVCMOS33")),
    ("display_segment", 4, Pins("P15"), IOStandard("LVCMOS33")),
    ("display_segment", 5, Pins("T11"), IOStandard("LVCMOS33")),
    ("display_segment", 6, Pins("L18"), IOStandard("LVCMOS33")),
    ("display_segment", 7, Pins("H15"), IOStandard("LVCMOS33")),
    

    ("vga", 0, Pins("A3"), IOStandard("LVCMOS33")),
    ("vga", 1, Pins("B4"), IOStandard("LVCMOS33")),
    ("vga", 2, Pins("C5"), IOStandard("LVCMOS33")),
    ("vga", 3, Pins("A4"), IOStandard("LVCMOS33")),

    ("vga", 4, Pins("C6"), IOStandard("LVCMOS33")),
    ("vga", 5, Pins("A5"), IOStandard("LVCMOS33")),
    ("vga", 6, Pins("B6"), IOStandard("LVCMOS33")),
    ("vga", 7, Pins("A6"), IOStandard("LVCMOS33")),

    ("vga", 8, Pins("B7"), IOStandard("LVCMOS33")),
    ("vga", 9, Pins("C7"), IOStandard("LVCMOS33")),
    ("vga", 10, Pins("D7"), IOStandard("LVCMOS33")),
    ("vga", 11, Pins("D8"), IOStandard("LVCMOS33")),

    ("hsync", 0, Pins("B11"), IOStandard("LVCMOS33")),
    ("vsync", 0, Pins("B12"), IOStandard("LVCMOS33")),
    

    ("btnu", 0, Pins("M18"), IOStandard("LVCMOS33")),
 

    
# Servo
    ("servo_out", 0, Pins("H4"), IOStandard("LVCMOS33")),
#---------------    
    
    
# Ultrasonido
    ("trigger", 0, Pins("H1"), IOStandard("LVCMOS33")),
    ("echo", 0, Pins("G1"), IOStandard("LVCMOS33")),
#---------------    

# Infrarojo
    ("infrarojoc", 0, Pins("K1"), IOStandard("LVCMOS33")),
    ("infrarojor", 0, Pins("F6"), IOStandard("LVCMOS33")),
    ("infrarojol", 0, Pins("J2"), IOStandard("LVCMOS33")),
#---------------

# Motores
    ("pwm1", 0, Pins("G6"), IOStandard("LVCMOS33")),
    ("pwm2", 0, Pins("E7"), IOStandard("LVCMOS33")),
    ("motorA", 0, Pins("J3"), IOStandard("LVCMOS33")),
    ("motorA", 1, Pins("J4"), IOStandard("LVCMOS33")),
    ("motorB", 0, Pins("E6"), IOStandard("LVCMOS33")),
    ("motorB", 1, Pins("G3"), IOStandard("LVCMOS33")),


#Camara :3
   ("XClock", 0, Pins("G16"), IOStandard("LVCMOS33")),
   ("Vsync_cam", 0, Pins("H16"), IOStandard("LVCMOS33")),    

   ("Data", 0, Pins("E18"), IOStandard("LVCMOS33")),
   ("Data", 1, Pins("F18"), IOStandard("LVCMOS33")),
   ("Data", 2, Pins("G17"), IOStandard("LVCMOS33")),
   ("Data", 3, Pins("G18"), IOStandard("LVCMOS33")),
   ("Data", 4, Pins("D14"), IOStandard("LVCMOS33")),
   ("Data", 5, Pins("E16"), IOStandard("LVCMOS33")),
   ("Data", 6, Pins("F16"), IOStandard("LVCMOS33")),
   ("Data", 7, Pins("F13"), IOStandard("LVCMOS33")),

   ("Href", 0, Pins("H14"), IOStandard("LVCMOS33")),
   ("Aclock", 0, Pins("G13"), IOStandard("LVCMOS33")),
   
   
 # Motores
    ("pwm1", 0, Pins("G6"), IOStandard("LVCMOS33")),
    ("pwm2", 0, Pins("E7"), IOStandard("LVCMOS33")),
    ("motorA", 0, Pins("J3"), IOStandard("LVCMOS33")),
    ("motorA", 1, Pins("J4"), IOStandard("LVCMOS33")),
    ("motorB", 0, Pins("E6"), IOStandard("LVCMOS33")),
    ("motorB", 1, Pins("G3"), IOStandard("LVCMOS33")),

 # DFPlayer
    ("UARTA1", 0, Pins("H2"), IOStandard("LVCMOS33")),
    ("UARTA1", 1, Pins("G4"), IOStandard("LVCMOS33")),

 # Bluetooth
    ("UARTB1", 0, Pins("G2"), IOStandard("LVCMOS33")),
    ("UARTB1", 1, Pins("F3"), IOStandard("LVCMOS33")),


#---------------



    ("cpu_reset", 0, Pins("C12"), IOStandard("LVCMOS33")),
    ("clk", 0, Pins("E3"), IOStandard("LVCMOS33")),

    ("serial", 0,
        Subsignal("tx", Pins("D4")),
        Subsignal("rx", Pins("C4")),
        IOStandard("LVCMOS33"),
    ),

    ("ddram", 0,
        Subsignal("a", Pins(
            "M4 P4 M6 T1 L3 P5 M2 N1",
            "L4 N5 R2 K5 N6"),
            IOStandard("SSTL18_II")),
        Subsignal("ba", Pins("P2 P3 R1"), IOStandard("SSTL18_II")),
        Subsignal("ras_n", Pins("N4"), IOStandard("SSTL18_II")),
        Subsignal("cas_n", Pins("L1"), IOStandard("SSTL18_II")),
        Subsignal("we_n", Pins("N2"), IOStandard("SSTL18_II")),
        Subsignal("dm", Pins("T6 U1"), IOStandard("SSTL18_II")),
        Subsignal("dq", Pins(
            "R7 V6 R8 U7 V7 R6 U6 R5",
            "T5 U3 V5 U4 V4 T4 V1 T3"),
            IOStandard("SSTL18_II"),
            Misc("IN_TERM=UNTUNED_SPLIT_50")),
        Subsignal("dqs_p", Pins("U9 U2"), IOStandard("DIFF_SSTL18_II")),
        Subsignal("dqs_n", Pins("V9 V2"), IOStandard("DIFF_SSTL18_II")),
        Subsignal("clk_p", Pins("L6"), IOStandard("DIFF_SSTL18_II")),
        Subsignal("clk_n", Pins("L5"), IOStandard("DIFF_SSTL18_II")),
        Subsignal("cke", Pins("M1"), IOStandard("SSTL18_II")),
        Subsignal("odt", Pins("M3"), IOStandard("SSTL18_II")),
        Subsignal("cs_n", Pins("K6"), IOStandard("SSTL18_II")),
        Misc("SLEW=FAST"),
    ),

    ("eth_clocks", 0,
        Subsignal("ref_clk", Pins("D5")),
        IOStandard("LVCMOS33"),
    ),

    ("eth", 0,
        Subsignal("rst_n", Pins("B3")),
        Subsignal("rx_data", Pins("C11 D10")),
        Subsignal("crs_dv", Pins("D9")),
        Subsignal("tx_en", Pins("B9")),
        Subsignal("tx_data", Pins("A10 A8")),
        Subsignal("mdc", Pins("C9")),
        Subsignal("mdio", Pins("A9")),
        Subsignal("rx_er", Pins("C10")),
        Subsignal("int_n", Pins("D8")),
        IOStandard("LVCMOS33")
     ),
]

# Platform -----------------------------------------------------------------------------------------

class Platform(XilinxPlatform):
    default_clk_name = "clk"
    default_clk_period = 1e9/100e6

    def __init__(self):
        XilinxPlatform.__init__(self, "xc7a100t-CSG324-1", _io, toolchain="vivado")
        self.add_platform_command("set_property INTERNAL_VREF 0.750 [get_iobanks 34]")
        self.add_platform_command("set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Aclock0_IBUF]")

    def create_programmer(self):
        return VivadoProgrammer()

    def do_finalize(self, fragment):
        XilinxPlatform.do_finalize(self, fragment)

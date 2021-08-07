
from litex.build.generic_platform import *
from litex.build.altera import AlteraPlatform
from litex.build.altera.programmer import USBBlaster

# IOs ----------------------------------------------------------------------------------------------

_io = [
    # Clk
    ("Clock", 0, Pins("E1"), IOStandard("3.3-V LVTTL")),
    
    #General_Input_Output
    ("GPIO", 0,  Pins("L13"),  IOStandard("3.3-V LVTTL")),
    ("GPIO", 1,  Pins("L16"),  IOStandard("3.3-V LVTTL")),
    ("GPIO", 2,  Pins("L15"),  IOStandard("3.3-V LVTTL")),
    ("GPIO", 3,  Pins("K16"),  IOStandard("3.3-V LVTTL")),
    ("GPIO", 4,  Pins("P16"),  IOStandard("3.3-V LVTTL")),
    ("GPIO", 5,  Pins("R16"),  IOStandard("3.3-V LVTTL")),
    ("GPIO", 6,  Pins("N16"),  IOStandard("3.3-V LVTTL")),
    ("GPIO", 7,  Pins("N15"),  IOStandard("3.3-V LVTTL")),
    ("GPIO", 8,  Pins("N14"),  IOStandard("3.3-V LVTTL")),
    ("GPIO", 9,  Pins("P15"),  IOStandard("3.3-V LVTTL")),
    ("GPIO", 10, Pins("N8"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 11, Pins("P8"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 12, Pins("M8"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 13, Pins("L8"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 14, Pins("R7"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 15, Pins("T7"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 16, Pins("L7"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 17, Pins("M7"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 18, Pins("R6"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 19, Pins("T6"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 20, Pins("T2"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 21, Pins("M6"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 22, Pins("R5"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 23, Pins("T5"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 24, Pins("N5"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 25, Pins("N6"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 26, Pins("R4"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 27, Pins("T4"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 28, Pins("N3"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 29, Pins("P3"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 30, Pins("R3"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 31, Pins("T3"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 32, Pins("P6"),   IOStandard("3.3-V LVTTL")),
    ("GPIO", 33, Pins("P2"),   IOStandard("3.3-V LVTTL")),


    #HyperRam
    ("hyperram", 0,
       # Subsignal("clk_n",   Pins("R14")),
       # Subsignal("clk_p",   Pins("P14")),
        Subsignal("clk",   Pins("P14")),
        Subsignal("rst_n", Pins("N9")),
        Subsignal("dq",    Pins("T12 T13 T11 R10 T10 R11 R12 R13")),#("T12 T13 T11 R10 T10 R11 R12 R13")("R13 R12 R11 T10 R10 T11 T13 T12")
        Subsignal("cs_n",  Pins("P9")),
        Subsignal("rwds",  Pins("T14")),
        IOStandard("3.3-V LVTTL")
    ),

    
    #PMOD
    ("PMOD", 0, Pins("D16"),   IOStandard("3.3-V LVTTL")),
    ("PMOD", 1, Pins("F13"),   IOStandard("3.3-V LVTTL")),
    ("PMOD", 2, Pins("D15"),   IOStandard("3.3-V LVTTL")),
    ("PMOD", 3, Pins("F16"),   IOStandard("3.3-V LVTTL")),
    ("PMOD", 4, Pins("C16"),   IOStandard("3.3-V LVTTL")),
    ("PMOD", 5, Pins("F15"),   IOStandard("3.3-V LVTTL")),
    ("PMOD", 6, Pins("C15"),   IOStandard("3.3-V LVTTL")),
    ("PMOD", 7, Pins("B16"),   IOStandard("3.3-V LVTTL")),
    
    # User_Led
    ("LED", 0, Pins("L14"), IOStandard("3.3-V LVTTL")),
    ("LED", 1, Pins("K15"), IOStandard("3.3-V LVTTL")),
    ("LED", 2, Pins("J14"), IOStandard("3.3-V LVTTL")),
    ("LED", 3, Pins("J13"), IOStandard("3.3-V LVTTL")), 

    #Button
    ("cpu_reset", 0, Pins("E15"), IOStandard("3.3-V LVTTL")),
    ("BUTTON", 0, Pins("F14"), IOStandard("3.3-V LVTTL")),
    ("BUTTON", 1, Pins("C11"), IOStandard("3.3-V LVTTL")),
    ("BUTTON", 2, Pins("D9"),  IOStandard("3.3-V LVTTL")),
    
    # Switches
    ("SW", 0, Pins("M16"), IOStandard("3.3-V LVTTL")),
    ("SW", 1, Pins("A8"),  IOStandard("3.3-V LVTTL")),
    ("SW", 2, Pins("A9"),  IOStandard("3.3-V LVTTL")),
    
     # Serial
    ("serial", 0,
        # Compatible with cheap FT232 based cables (ex: Gaoominy 6Pin Ftdi Ft232Rl Ft232)
        # GND on JP1 Pin 12.
        Subsignal("tx", Pins("P1"), IOStandard("3.3-V LVTTL")), # GPIO_07 (JP1 Pin 10)
        Subsignal("rx", Pins("R1"), IOStandard("3.3-V LVTTL"))  # GPIO_05 (JP1 Pin 8)
    ),
    
    
    #Arduino I_O
    ("ArduinoIO", 0,  Pins("B1"),  IOStandard("3.3-V LVTTL")),
    ("ArduinoIO", 1,  Pins("C2"),  IOStandard("3.3-V LVTTL")),
    ("ArduinoIO", 2,  Pins("F3"),  IOStandard("3.3-V LVTTL")),
    ("ArduinoIO", 3,  Pins("D1"),  IOStandard("3.3-V LVTTL")),
    ("ArduinoIO", 4,  Pins("G2"),  IOStandard("3.3-V LVTTL")),
    ("ArduinoIO", 5,  Pins("G1"),  IOStandard("3.3-V LVTTL")),
    ("ArduinoIO", 6,  Pins("J2"),  IOStandard("3.3-V LVTTL")),
    ("ArduinoIO", 7,  Pins("J1"),  IOStandard("3.3-V LVTTL")),
    ("ArduinoIO", 8,  Pins("K2"),  IOStandard("3.3-V LVTTL")),
    ("ArduinoIO", 9,  Pins("K5"),  IOStandard("3.3-V LVTTL")),
    ("ArduinoIO", 10, Pins("L4"),  IOStandard("3.3-V LVTTL")),
    ("ArduinoIO", 11, Pins("K1"),  IOStandard("3.3-V LVTTL")),
    ("ArduinoIO", 12, Pins("L2"),  IOStandard("3.3-V LVTTL")),
    ("ArduinoIO", 13, Pins("L1"),  IOStandard("3.3-V LVTTL")),
    

]
 

# Platform -----------------------------------------------------------------------------------------

class Platform(AlteraPlatform):
    default_clk_name   = "Clock"
    default_clk_period = 1e9/50e6

    def __init__(self):
        AlteraPlatform.__init__(self, "10CL025YU256I7G", _io)
                                      
    def create_programmer(self):
        return USBBlaster()

    def do_finalize(self, fragment):
        AlteraPlatform.do_finalize(self, fragment)
        self.add_period_constraint(self.lookup_request("Clock", loose=True), 1e9/50e6)

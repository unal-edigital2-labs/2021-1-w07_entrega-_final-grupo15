from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *

# Modulo Principal
class MOTOR(Module,AutoCSR):
    def __init__(self, pwm1, pwm2, motorA, motorB):
    
        self.clk = ClockSignal()  
        self.rst = ResetSignal()
        
        self.movimiento = CSRStorage(3)
        
        self.pwm1 = pwm1
        self.pwm2 = pwm2
        
        self.motorA = motorA
        self.motorB = motorB

       

        self.specials +=Instance("motores",
            i_clk = self.clk,
            i_rst = self.rst,
            i_movimiento = self.movimiento.storage,
            
            o_pwm1 = self.pwm1,
            o_pwm2 = self.pwm2,
            
            o_motorA = self.motorA,
	    o_motorB = self.motorB,
)

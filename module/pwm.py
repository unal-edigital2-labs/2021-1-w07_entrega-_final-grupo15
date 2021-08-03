from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *

# Modulo Principal
class PWM(Module,AutoCSR):
    def __init__(self, pwm):
    
        self.clk = ClockSignal()   
        self.pwm_out = pwm

        self.enable = CSRStorage(1)
        self.dutty = CSRStorage(16)
        self.period = CSRStorage(16)
       

        self.specials +=Instance("pwm",
            i_clk = self.clk,
            i_enable = self.enable.storage,
            i_dutty = self.dutty.storage,
            i_period = self.period.storage,

         #   o_done = self.done.status,
            o_pwm_out = self.pwm_out,
        
)

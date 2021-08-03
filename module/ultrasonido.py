from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *

# Modulo Principal
class Ultrasonido(Module,AutoCSR):
    def __init__(self, trigger, echo):
        self.clk = ClockSignal()   
        self.init = CSRStorage(1)
        
        self.trigger = trigger
        self.echo = echo

        self.tiempo = CSRStatus(16)
        self.done = CSRStatus(1)

        self.specials +=Instance("ultrasonido",
            i_clk = self.clk,
            i_init = self.init.storage,
            
            o_trigger = self.trigger,

            i_eco = self.echo,
            
            o_tiempo = self.tiempo.status,
            o_done = self.done.status
        )

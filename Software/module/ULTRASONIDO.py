from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *


# Modulo Principal

class _ULTRASONIDO(Module,AutoCSR):
    def __init__(self,Echo,Trigger):
    
        self.Clock = ClockSignal()  
        self.Reset = ResetSignal()
        self.Inicio = CSRStorage()

        self.Trigger = Trigger        
        self.Echo = Echo

        self.Done=CSRStatus()
        self.Distancia=CSRStatus(9)
        
        self.submodules.ev = EventManager()
        self.ev.DONE = EventSourceProcess(edge="rising")
        self.ev.finalize()

        self.comb += self.ev.DONE.trigger.eq(self.Done.status == 1)
     
 
        self.specials +=Instance("Ultrasonido", 
	   i_Clock = self.Clock,
	   i_Reset = self.Reset,
	   i_Inicio= self.Inicio.storage,
	   i_Echo = self.Echo,
	   o_Done= self.Done.status,
	   o_Trigger= self.Trigger,
	   o_Distancia= self.Distancia.status

	)
	


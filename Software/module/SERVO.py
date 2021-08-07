from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *


# Modulo Principal

class _SERVO(Module,AutoCSR):
    def __init__(self,Out):
    
        self.Clock = ClockSignal()  
        self.Reset = ResetSignal()
        
        self.Out = Out
        self.Periodo=CSRStorage(16)
        self.Ciclo=CSRStorage(12)
        
      
 
        self.specials +=Instance("Servomotor", 
	   i_Clock = self.Clock,
	   i_Reset = self.Reset,
	   
	   i_Periodo = self.Periodo.storage,
	   i_Ciclo = self.Ciclo.storage,
	   o_Out   = self.Out
	)
	


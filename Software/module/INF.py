from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *


# Modulo Principal

class _INF(Module,AutoCSR):
    def __init__(self,inout):
    
        self.Datain = CSRStorage()  
        self.Control = CSRStorage()
        
        self.Dataout = CSRStatus()
        self.inout=inout
        
        self.submodules.ev = EventManager()
        self.ev.REFLECT = EventSourceProcess(edge="rising")
        self.ev.finalize()

        self.comb += self.ev.REFLECT.trigger.eq(self.Dataout.status == 0)      
 
        self.specials +=Instance("GPIO", 
	   i_Datain = self.Datain.storage,
	   i_Control = self.Control.storage,
	   
	   o_Dataout = self.Dataout.status,

	   io_Salida   = self.inout
	)
	


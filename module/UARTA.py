from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *


# Modulo Principal

class _UARTA(Module,AutoCSR):
    def __init__(self,Rx1,Tx1):
    
        self.Clock = ClockSignal()  
        self.Reset = ResetSignal()
        
        self.Baudios = CSRStorage(16)
        self.TxInit=CSRStorage(1)
        self.TxData=CSRStorage(8)
        
        self.Rx1=Rx1
        self.RxData=CSRStatus(8)
        self.Tx1=Tx1
        self.TxDone=CSRStatus(1)
        self.RxAvailable=CSRStatus(1)


        self.submodules.ev = EventManager()
        self.ev.TXDONE = EventSourceProcess(edge="rising")
        self.ev.RXAVAILABLE = EventSourceProcess(edge="rising")
        self.ev.finalize()

        self.comb += self.ev.TXDONE.trigger.eq(self.TxDone.status == 1)
        self.comb += self.ev.RXAVAILABLE.trigger.eq(self.RxAvailable.status == 1)

        


 
        self.specials +=Instance("Uart", 
	   i_Clock = self.Clock,
	   i_Reset = self.Reset,
	   
	   i_Baudios=self.Baudios.storage,
	   i_TxInit=self.TxInit.storage,
	   i_TxData=self.TxData.storage,
	   i_Rx    =self.Rx1,
	   
	   o_RxData=self.RxData.status,
	   o_Tx    =self.Tx1,
	   o_TxDone=self.TxDone.status,
	   o_RxAvailable=self.RxAvailable.status
	  
	)
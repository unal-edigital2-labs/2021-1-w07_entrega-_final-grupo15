from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *


# Modulo Principal

class _UARTA(Module,AutoCSR):
    def __init__(self,Rx1,Tx1):
    
        self.Clock = ClockSignal()  #reloj del sistema
        self.Reset = ResetSignal()  #reinicio del sistema
        
        self.Baudios = CSRStorage(16)   #registro W-R de baudios
        self.TxInit=CSRStorage(1)       #registro W-R inicio de envio
        self.TxData=CSRStorage(8)       #registro W-R Datos de envio
        
        self.Rx1=Rx1                    #entrada fisica - RX
        self.RxData=CSRStatus(8)        #registro only-R Datos de llegada 
        self.Tx1=Tx1                    #salida fisica - TX
        self.TxDone=CSRStatus(1)        #registro only-R envio finalizado
        self.RxAvailable=CSRStatus(1)   #registro only-R 


        self.submodules.ev = EventManager()        #Inicio interrupciones
        self.ev.TXDONE = EventSourceProcess(edge="rising")  #flanco de subida - envio finalizado
        self.ev.RXAVAILABLE = EventSourceProcess(edge="rising") #flanco de subida - dato disponible
        self.ev.finalize()  #final interrupciones

        self.comb += self.ev.TXDONE.trigger.eq(self.TxDone.status == 1) #condicion de interrupcion - envio finalizado
        self.comb += self.ev.RXAVAILABLE.trigger.eq(self.RxAvailable.status == 1) #condicion de interrupcion - dato disponible

        



        self.specials +=Instance("Uart",    #instanciacion modulo uart - verilog 
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
	


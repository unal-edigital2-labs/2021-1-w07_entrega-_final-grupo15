from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *


# Modulo Principal

class _MOTORES(Module,AutoCSR):
    def __init__(self,PWM1,PWM2,MotorA,MotorB):
    
        self.Clock = ClockSignal()  
        self.Reset = ResetSignal()
        self.Movimiento = CSRStorage(3)
        self.Duty1 = CSRStorage(7)
        self.Duty2 = CSRStorage(7)
        self.PWM1 = PWM1        
        self.PWM2 = PWM2        
        self.MotorA = MotorA        
        self.MotorB = MotorB        

        
      
 
        self.specials +=Instance("Motores", 
	   i_Clock = self.Clock,
	   i_Reset = self.Reset,
	   i_Movimiento= self.Movimiento.storage,
	   i_Duty1= self.Duty1.storage,
	   i_Duty2= self.Duty2.storage,
	   
	   o_PWM1 = self.PWM1,
	   o_PWM2= self.PWM2,
	   o_MotorA= self.MotorA,
	   o_MotorB= self.MotorB

	)
	


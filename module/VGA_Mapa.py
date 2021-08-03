from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *


# Modulo Principal

class _VGA_Mapa(Module,AutoCSR):
    def __init__(self,RGB,Hsync,Vsync,Pclock,Href,Vsync_cam,Data,XClock):
    
        self.Clock = ClockSignal()  
        self.Reset = ResetSignal()
        
        self.Pclock=Pclock
        self.Href=Href
        self.Vsync_cam=Vsync_cam
        self.Data=Data
        self.XClock=XClock

        self.Forma = CSRStatus(2)
        self.PromedioColor = CSRStatus(2)

        self.MapaData = CSRStorage(4)
        self.MapaAddr = CSRStorage(6)
        self.MapaWrite = CSRStorage()
        
        
        self.RGB = RGB        
        self.Hsync = Hsync        
        self.Vsync = Vsync        


 
        self.specials +=Instance("CamaraVGADriver", 
	   i_Clock = self.Clock,
	   i_Reset = self.Reset,

	   i_Pclock = self.Pclock,
	   i_Href = self.Href,
	   i_Vsync_cam = self.Vsync_cam,
	   i_Data = self.Data,
	   o_XClock = self.XClock,

	   o_Forma = self.Forma.status,
	   o_PromedioColor = self.PromedioColor.status,

	   i_MapaData= self.MapaData.storage,
	   i_MapaAddr= self.MapaAddr.storage,
	   i_MapaWrite= self.MapaWrite.storage,
	   
	   o_RGB = self.RGB,
	   o_Hsync= self.Hsync,
	   o_Vsync= self.Vsync

	)
	


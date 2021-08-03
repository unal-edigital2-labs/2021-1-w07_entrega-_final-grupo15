#!/usr/bin/env python3

from migen import *
from migen.genlib.io import CRG
from migen.genlib.cdc import MultiReg

import nexys4ddr as tarjeta
#import c4e6e10 as tarjeta

from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *
from litex.soc.interconnect.csr import *

from litex.soc.cores import gpio

#from module import camara
from module import pwm
from module import ultrasonido
from module import motores
from module import VGA_Mapa
from module import UARTA
from module import UARTB




# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
	def __init__(self):
		platform = tarjeta.Platform()
		
		## add source verilog

		platform.add_source("module/verilog/radar/clk_div.v" )
		platform.add_source("module/verilog/radar/counter.v" )
		platform.add_source("module/verilog/radar/pwm.v" )	
		platform.add_source("module/verilog/radar/ultrasonido.v" )
		platform.add_source("module/verilog/motor/motores.v" )
		platform.add_source("module/verilog/motor/direcciones.v" )
		platform.add_source("module/verilog/motor/pwm.v" )

		platform.add_source("module/verilog/VGA100/CamaraVGADriver.v" )
		platform.add_source("module/verilog/VGA100/DivisorFrecuencia.v" )
		platform.add_source("module/verilog/VGA100/Im.mem" )
		platform.add_source("module/verilog/VGA100/ImBuffer.v" )
		platform.add_source("module/verilog/VGA100/ImBufferv2.v" )
		platform.add_source("module/verilog/VGA100/Mapa.mem" )
		platform.add_source("module/verilog/VGA100/Mapa2.mem" )
		platform.add_source("module/verilog/VGA100/OV7670.v" )
		platform.add_source("module/verilog/VGA100/VGA_driver.v" )
		platform.add_source("module/verilog/VGA100/clk24_25_nexys4.v" )

		#UART-Proposito General
		platform.add_source("module/verilog/UART/GeneradorBaudios.v" )
		platform.add_source("module/verilog/UART/Uart.v" )
		platform.add_source("module/verilog/UART/UartRx.v" )
		platform.add_source("module/verilog/UART/UartTx.v" )


		# SoC with CPU
		SoCCore.__init__(self, platform,
 			cpu_type="picorv32",
#			cpu_type="vexriscv",
			clk_freq=100e6,
			integrated_rom_size=0x8000,
			integrated_main_ram_size=13*1024)

		# Clock Reset Generation
		self.submodules.crg = CRG(platform.request("clk"), ~platform.request("cpu_reset"))

		# Buttons
		SoCCore.add_csr(self,"buttons")
		user_buttons = Cat(*[platform.request("btn%c" %c) for c in ['c','r','l']])
		self.submodules.buttons = gpio.GPIOIn(user_buttons)


               # servo :3
		SoCCore.add_csr(self,"servo_cntrl")
		self.submodules.servo_cntrl = pwm.PWM(platform.request("servo_out"))
		
		# ultrasonido
		SoCCore.add_csr(self, "ultrasonido")
		self.submodules.ultrasonido = ultrasonido.Ultrasonido(platform.request("trigger"), platform.request("echo"))
		
		# infrarojo
		SoCCore.add_csr(self,"infrarojo")
		user_infrarojos = Cat(*[platform.request("infrarojo%c" %c) for c in ['c','r','l']])
		self.submodules.infrarojo = gpio.GPIOIn(user_infrarojos)
		
		#motores
		SoCCore.add_csr(self, "motores")
		MotorA = Cat(*[platform.request("motorA", i) for i in range(2)])
		MotorB = Cat(*[platform.request("motorB", i) for i in range(2)])
		self.submodules.motores = motores.MOTOR(platform.request("pwm1"), platform.request("pwm2"), MotorA, MotorB)

		     
		 #VGA_Driver
		SoCCore.add_csr(self,"VGA_Mapa")
		Pclock = platform.request("Aclock",0)
		Vsync = platform.request("vsync",0)
		Hsync = platform.request("hsync",0)
		RGB = Cat(*[platform.request("vga",i) for i in range(0,12)])
		XClock = platform.request("XClock",0)
		Data = Cat(*[platform.request("Data",i) for i in range(0,8)])
		Vsync_cam = platform.request("Vsync_cam",0)
		Href = platform.request("Href",0)
		self.submodules.VGA_Mapa = VGA_Mapa._VGA_Mapa(RGB, Hsync, Vsync, Pclock, Href, Vsync_cam, Data, XClock)

		# UART-Bluetooth
		SoCCore.add_csr(self,"UARTB")
		Rx = platform.request("UARTB1",0)
		Tx = platform.request("UARTB1",1)
		self.submodules.UARTB = UARTB._UARTB(Rx, Tx)
		self.irq.add("UARTB", use_loc_if_exists=True)
		
		# UART-DFPLayerMini
		SoCCore.add_csr(self,"UARTA")
		Rx1 = platform.request("UARTA1",0)
		Tx1 = platform.request("UARTA1",1)
		self.submodules.UARTA = UARTA._UARTA(Rx1, Tx1)
		self.irq.add("UARTA", use_loc_if_exists=True)

		     
# Build --------------------------------------------------------------------------------------------
if __name__ == "__main__":
	builder = Builder(BaseSoC(),csr_csv="Soc_MemoryMap.csv")
	builder.build()


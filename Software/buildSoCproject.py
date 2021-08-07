#!/usr/bin/env python3

from migen import *

from migen.genlib.io import CRG
from migen.genlib.cdc import MultiReg

import C10LPRefKit as tarjeta

from litex.soc.interconnect.csr_eventmanager import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *
from litex.soc.interconnect.csr import *
from litehyperbus.core.hyperbus import HyperRAM

from module import VGA_Mapa
from module import UARTA
from module import UARTB
from module import SERVO
from module import INF
from module import ULTRASONIDO
from module import MOTORES




# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
	mem_map = {
         "hyperram": 0x20000000,
	}
	mem_map.update(SoCCore.mem_map)



	def __init__(self):
		platform = tarjeta.Platform()
		
		
		#VGA - CAMARA - MAPA
		platform.add_source("module/Verilog/VGA/CamaraVGADriver.v" )
		platform.add_source("module/Verilog/VGA/DivisorFrecuencia.v" )
		platform.add_source("module/Verilog/VGA/Im.mem" )
		platform.add_source("module/Verilog/VGA/ImBuffer.v" )
		platform.add_source("module/Verilog/VGA/ImBufferv2.v" )
		platform.add_source("module/Verilog/VGA/Mapa.mem" )
		platform.add_source("module/Verilog/VGA/Mapa2.mem" )
		platform.add_source("module/Verilog/VGA/OV7670.v" )
		platform.add_source("module/Verilog/VGA/VGA_driver.v" )
		
		#UART-Proposito General
		platform.add_source("module/Verilog/UART/GeneradorBaudios.v" )
		platform.add_source("module/Verilog/UART/Uart.v" )
		platform.add_source("module/Verilog/UART/UartRx.v" )
		platform.add_source("module/Verilog/UART/UartTx.v" )
		
		#Servomotor		
		platform.add_source("module/Verilog/SERVO/Servomotor.v" )
		
		#GPIO
		platform.add_source("module/Verilog/INF/GPIO.v" )
		
		#Ultrasonido
		platform.add_source("module/Verilog/ULTRASONIDO/ContadorDistanciaFix.v" )
		platform.add_source("module/Verilog/ULTRASONIDO/DivisorFrecuencia1.v" )
		platform.add_source("module/Verilog/ULTRASONIDO/GeneradorPulsos.v" )
		platform.add_source("module/Verilog/ULTRASONIDO/Ultrasonido.v" )
		platform.add_source("module/Verilog/ULTRASONIDO/UnidadControl.v" )
		
		
		#Motores
		platform.add_source("module/Verilog/MOTORES/Motores.v" )
		platform.add_source("module/Verilog/MOTORES/Direcciones.v" )
		platform.add_source("module/Verilog/MOTORES/PWM.v" )
		

		# SoC with CPU
		SoCCore.__init__(self, platform,
 			cpu_type="picorv32",
#			cpu_type="vexriscv",
			clk_freq=50e6,
			integrated_rom_size=8*1024*3,
			integrated_main_ram_size=(8*1024*2)
		)
		
		self.submodules.hyperram = HyperRAM(platform.request("hyperram"))
		self.add_wb_slave(self.mem_map["hyperram"], self.hyperram.bus)
		self.add_memory_region("hyperram", self.mem_map["hyperram"], 8*8440)
        	

		# Clock Reset Generation
		self.submodules.crg = CRG(platform.request("Clock"), ~platform.request("cpu_reset"))
		
		# UART-Bluetooth
		SoCCore.add_csr(self,"UARTB")
		Rx = platform.request("GPIO",26)
		Tx = platform.request("GPIO",27)
		self.submodules.UARTB = UARTB._UARTB(Rx, Tx)
		self.irq.add("UARTB", use_loc_if_exists=True)
		
		# UART-DFPLayerMini
		SoCCore.add_csr(self,"UARTA")
		Rx1 = platform.request("GPIO",28)
		Tx1 = platform.request("GPIO",29)
		self.submodules.UARTA = UARTA._UARTA(Rx1, Tx1)
		self.irq.add("UARTA", use_loc_if_exists=True)

		# Servomotor
		SoCCore.add_csr(self,"SERVO")
		Out = platform.request("GPIO",30)
		self.submodules.SERVO = SERVO._SERVO(Out)
		
		# Infrarrojo
		SoCCore.add_csr(self,"INF")
		inout = platform.request("GPIO",31)
		self.submodules.INF = INF._INF(inout)
		self.irq.add("INF", use_loc_if_exists=True)

		# Ultrasonido
		SoCCore.add_csr(self,"ULTRASONIDO")
		Echo = platform.request("ArduinoIO",0)
		Trigger = platform.request("ArduinoIO",1)
		self.submodules.ULTRASONIDO = ULTRASONIDO._ULTRASONIDO(Echo,Trigger)
		self.irq.add("ULTRASONIDO", use_loc_if_exists=True)
		
		# Motores
		SoCCore.add_csr(self,"MOTORES")
		PWM1 = platform.request("PMOD",0)
		PWM2 = platform.request("PMOD",4)
		MotorA = Cat(*[platform.request("PMOD",i) for i in range(1,3)])
		MotorB = Cat(*[platform.request("PMOD",i) for i in range(5,7)])
		self.submodules.MOTORES = MOTORES._MOTORES(PWM1,PWM2,MotorA,MotorB)
					
		# VGA_Driver
		SoCCore.add_csr(self,"VGA_Mapa")
		Vsync = platform.request("GPIO",0)
		Hsync = platform.request("GPIO",1)
		RGB = Cat(*[platform.request("GPIO",i) for i in range(2,14)])
		XClock = platform.request("GPIO",17)
		Data = Cat(*[platform.request("GPIO",i) for i in range(25,17,-1)])
		Vsync_cam = platform.request("GPIO",14)
		Href = platform.request("GPIO",15)
		Pclock = platform.request("GPIO",16)
		self.submodules.VGA_Mapa = VGA_Mapa._VGA_Mapa(RGB, Hsync, Vsync, Pclock, Href, Vsync_cam, Data, XClock)
		

# Build --------------------------------------------------------------------------------------------
if __name__ == "__main__":
	builder = Builder(BaseSoC(),csr_csv="Soc_memoryMap.csv")
	builder.build()


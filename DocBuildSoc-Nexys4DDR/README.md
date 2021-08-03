# ETAPA 2


### Pre requisitos 
- Realizar y probar los modulos diseñados en verilog
- Descargar el paquete de trabajo 5. 

### ¿Qué se realiza en esta etapa? 

En la etapa dos ya tenemos nuestro modulos de verilog y los hemos probado previamente, de manera que sabemos que estos funcionan por seprarado. En la ETAPA 2 ha llegado el momento de integrarlos todos en un System on Chip, que pueda tener acceso a ellos y permita la grupación en un solos procesador. Inicialmente es necesario que sea descargado LITEX y que el procesador halla sido generado según el paquete de trabajo 5 proporcionado por el profesor, inicialmente puede parecer un poco confuso el procesos, sin embargo esperamos que la información de aquí sea de útilidad. 

A continuación se evidencia el mapa completo del SoC donde se muestran las conexiónes de perifericos, drivers y el bus. 

![Image text](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/firmware/figuras/SOC-Map.jpg)


### ¿Cómo se realiza esto? 

Se ha dividido el proceso en 3 pasos que se muestran a continuación.

- Paso 0: Paquete de trabajo 5.
- Paso 1: Generar los archivos .py que serviran para que Lites los reconozca, estos archivos estan conectados con nuestros módulos de verilog. 
- Paso 2: Instanciar en nuestro SoC a nuestro archivos .py y a los modulos de verilog
- Paso 3: Syntetizar nuestros modulos y se compila el firmware y se sube al procesador mediante el puerto uart. 

Previo al inicio del trabajo con los archivos .py es necesario que el grupo descargue los archivos del paquete de trabajo 5 y descargue por ende LITEX y Migen. Posteriormente se realiza el paso 1: Generar los archivos .py que serviran para que Lites los reconozca, estos archivos estan conectados con nuestros módulos de verilog, a continuación se explica de que manera se pueden generar estos archivos, adicionalmente se ejemplifica haciendo uso de uno de los modulos .py .

En este proyecto se desarrollaron los siguientes modulos. 
- UARTA.py
- UARTB.py
- VGA_Mapa.py
- camara.py
- motores.py
- pwm.py
- ultrasonido.py


## Creación de los archivos .py

A continuación se ejemplificará el procesos usando el modulo ultrasonido.py, este mismo proceso se realizo con el resto de modulos. 

Inicialmente importamos nuestras librerías tanto de MIGEN como de LITEX, las cuales nos permiten realizar el proceso de adaptación del módulo. 

~~~
from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *

~~~

Posteriormente generamos nuestra función que nos permitira definir nuestros pines virtuales y nuestros pines físicos. En un SoC accedemos a las entradas y salidas de los modulos ayudados por registros internos que son accedidos por el procesador mediante un bus de datos (Wishbone). En los parametros de entrada declararemos un self (usado posteriormente para los pines "virtuales"), y definiremos el resto de señales para pines físicos. Por ejemplo en nuestro ultrasonido, las señales que se conectaran con pines físicos son trigger y eco. 

~~~
class Ultrasonido(Module,AutoCSR):
    def __init__(self, trigger, echo):
        self.clk = ClockSignal()   
        self.init = CSRStorage(1)
        
        self.trigger = trigger
        self.echo = echo

        self.tiempo = CSRStatus(16)
        self.done = CSRStatus(1)
~~~

Las señales que no aparecen como entradas de la función, son señales internas, por ejemplo:

- self.clk = ClockSignal()   --> El clk es el nombre que le asignamos nosotros en python
- self.init = CSRStorage(1)  --> El CSRStorage es una denominación que indica que esta señal es posible leerla y escribirla
- self.tiempo = CSRStatus(16) --> El CSRStatus es una denominación que indica que esta señal unicamente es posible leerla, además se define esta señal de 16 bits. 

Por otra parte:

- self.trigger = trigger
- self.echo = echo

Son señales que iran o vienen de pines físicos.

Finalmente instanciamos (relacionamos) nuestras señales de salida o entrada de verilog, con las señales definidas en nuestro archivo, para esto instanciamos el nombre de nuestro modulo de verilog.  

~~~
        self.specials +=Instance("ultrasonido",
            i_clk = self.clk,
            i_init = self.init.storage,
            
            o_trigger = self.trigger,

            i_eco = self.echo,
            
            o_tiempo = self.tiempo.status,
            o_done = self.done.status
        )
~~~

## Integrando nuestros módulos en el SoC

Una vez hemos realizado esto con todos nuestros modulos de verilog, pasamos a hacer uso de los archivos BuildSocProject y Nexys4DDR, en el primero agreparemos nuestros modulos a nuestro SoC y en la segunda definiremos los pines "físicos". A continuacicón se describe el procedimiento para integrar los modulos al SoC, nuevamente con un ejemplo, en este caso más general. 

~~~


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
~~~

Posteriormente debemos incluir y llamar todos los modulos de verilog. 

~~~
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
~~~


Finalmente definimos los pines de estos, les asignamos un nombre que sea facilmente reconocible por nosotros, una vez asignado el nombre ingresamos al archivo NexysDDR donde se encuentran los pines respectivos de la tarjeta y ahí modificamos el nombre de los pines de manera que coincidan con el nombre declarado en el buildSoCproject. 

~~~
		# ultrasonido - buildsoc
		SoCCore.add_csr(self, "ultrasonido")
		self.submodules.ultrasonido = ultrasonido.Ultrasonido(platform.request("trigger"), platform.request("echo"))

# Ultrasonido - Nexys4ddr
    ("trigger", 0, Pins("H1"), IOStandard("LVCMOS33")),
    ("echo", 0, Pins("G1"), IOStandard("LVCMOS33")),
#---------------    

~~~

Ahora resta únicamente dirigirnos a la ETAPA 3, donde en el main.c definiremos las funciones y el comportamiento del robot y generaremos el firmware, es decir el SoC ya sabrá como proceder, cuando y como interactuar con los modulos. 

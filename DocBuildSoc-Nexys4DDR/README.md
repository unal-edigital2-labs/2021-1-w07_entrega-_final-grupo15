# ETAPA 2


### Pre requisitos 
- Realizar y probar los modulos diseñados en verilog
- Descargar el paquete de trabajo 5. 

### ¿Qué se realiza en esta etapa? 

En la etapa dos ya tenemos nuestro modulos de verilog y los hemos probado previamente, de manera que sabemos que estos funcionan por seprarado. En la ETAPA 2 ha llegado el momento de integrarlos todos en un System on Chip, que pueda tener acceso a ellos y permita la grupación en un solos procesador. Inicialmente es necesario que sea descargado LITEX y que el procesador halla sido generado según el paquete de trabajo 5 proporcionado por el profesor, inicialmente puede parecer un poco confuso el procesos, sin embargo esperamos que la información de aquí sea de útilidad. 


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

![Image text](https://github.com/unal-edigital2/Grupo-5-proyecto/blob/Master/module/Imag%C3%A9nes/import.PNG)

Posteriormente generamos nuestra función que nos permitira definir nuestros pines virtuales y nuestros pines físicos. En un SoC accedemos a las entradas y salidas de los modulos ayudados por registros internos que son accedidos por el procesador mediante un bus de datos (Wishbone). En los parametros de entrada declararemos un self (usado posteriormente para los pines "virtuales"), y definiremos el resto de señales para pines físicos. Por ejemplo en nuestro ultrasonido, las señales que se conectaran con pines físicos son trigger y eco. 

![Image text](https://github.com/unal-edigital2/Grupo-5-proyecto/blob/Master/module/Imag%C3%A9nes/Funci%C3%B3n.PNG)

Las señales que no aparecen como entradas de la función, son señales internas, por ejemplo:

- self.clk = ClockSignal()   --> El clk es el nombre que le asignamos nosotros en python
- self.init = CSRStorage(1)  --> El CSRStorage es una denominación que indica que esta señal es posible leerla y escribirla
- self.tiempo = CSRStatus(16) --> El CSRStatus es una denominación que indica que esta señal unicamente es posible leerla, además se define esta señal de 16 bits. 

Por otra parte:

- self.trigger = trigger
- self.echo = echo

Son señales que iran o vienen de pines físicos.

Finalmente instanciamos (relacionamos) nuestras señales de salida o entrada de verilog, con las señales definidas en nuestro archivo, para esto instanciamos el nombre de nuestro modulo de verilog.  

![Image text](https://github.com/unal-edigital2/Grupo-5-proyecto/blob/Master/module/Imag%C3%A9nes/Funci%C3%B3nf.PNG)

## Integrando nuestros módulos en el SoC

Una vez hemos realizado esto con todos nuestros modulos de verilog, pasamos a hacer uso de los archivos BuildSocProject y Nexys4DDR, en el primero agreparemos nuestros modulos a nuestro SoC y en la segunda definiremos los pines "físicos". A continuacicón se describe el procedimiento para integrar los modulos al SoC, nuevamente con un ejemplo, en este caso más general. 

![Image text](https://github.com/unal-edigital2/Grupo-5-proyecto/blob/Master/module/Imag%C3%A9nes/import1.PNG)

Posteriormente debemos incluir y llamar todos los modulos de verilog. 

![Image text](https://github.com/unal-edigital2/Grupo-5-proyecto/blob/Master/module/Imag%C3%A9nes/Funci%C3%B3n1.PNG)


Finalmente definimos los pines de estos, les asignamos un nombre que sea facilmente reconocible por nosotros, una vez asignado el nombre ingresamos al archivo NexysDDR donde se encuentran los pines respectivos de la tarjeta y ahí modificamos el nombre de los pines de manera que coincidan con el nombre declarado en el buildSoCproject. 

![Image text](https://github.com/unal-edigital2/Grupo-5-proyecto/blob/Master/module/Imag%C3%A9nes/Funci%C3%B3nf2.PNG)

![Image text](https://github.com/unal-edigital2/Grupo-5-proyecto/blob/Master/module/Imag%C3%A9nes/pines.PNG)

Ahora resta únicamente dirigirnos a la ETAPA 3, donde en el main.c definiremos las funciones y el comportamiento del robot y generaremos el firmware, es decir el SoC ya sabrá como proceder, cuando y como interactuar con los modulos. 

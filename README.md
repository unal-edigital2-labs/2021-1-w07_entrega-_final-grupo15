# Grupo-5-proyecto

## Consideraciones generales del proceso de diseño y construcción del proyecto.
El proyecto diseñado para este semestre es un robot cartografo que recorre un laberinto y en el proceso indica la solución de este, adicionalmente proporciona información sobre las figuras que se encuentran en las paredes del laberinto y los colores de estas. Para que el robot lograra cumplir con este objetivo se implementaron los siguientes periféricos:

- RADAR (ultrasonido + motor) 
    - Ultrasonido: Permite la detección de distancia, indica la distancia del frente y los laterales del robot a las paredes.
    - Motor: Cumple la función de rotar el modulo ultrasonido y la cámara para que estos pueda detectar la distancia a las paredes e identificar si hay alguna figura  en los alrrededores.
- Camara: La camara se utiliza para realizar la detección en tiempo real del laberinto, adicionalmente informa, al detectar una figura, la forma y color de esta.
- Infrarojo: El periférico infrarrojo en realidad esta compuesto por 3 modulos infrarojos, los cuales indican en que partes del recorrido hay una intersecciones (definidas por la cuadricula en el laberinto).
- DFplayer mini: Este periférico se utilizó para indicar de manera sonora las instrucciónes a seguir por el robot. 
- Motores para movilidad: Usados para permitir el movimiento del robot.
- Monitor: Se implementó haciendo uso de VGA para poder visualizar la información en pantalla. 

## Indice 
Para facilidad de los estudiantes de futuros semestres, se decidió que el proyecto (como se concibió por este grupo) se divide en 3 etapas, cada una describe un trabajo diferente al rededor del robot, la ETAPA 4: Implementación física final, no se realizo debido al tiempo. 

ETAPA 1. Desarrollo módulos/Driver Verilog

  -  Consiste en: Generar usando verilog, los driver de los perifericos, describiendo el funcionamiento de estos.

  -  Los drivers que se encontrarán son:
      - Servomotor
      - Ultrasonido
      - Motor
      - UART
      - VGA (incluye camara)

ETAPA 2. Diseño del procesador en el BuildSoCproject (Trabajo Hardware)

   - En la ETAPA 2 los archivos .py fueron generados para la creación del SoC, posteriormente se trabajo sobre el archivo BuildSoCproyect, donde los archivos .py, junto con los modulos de verilog son llamados para realizar las conexiónes físicas necesarias, esto en conjunto con la definición de los pines que se usan en la tarjeta Nexys4DDR. 
   
ETAPA 3.   Construcción de funciones en main.C  y uso de las funciones generadas en el archivo CSR.h (Trabajo Software)

  -  Finalmente la ETAPA 3 Consiste en: Trabajar con el firmware, desarrollar las funciones que son necesarias para el funcionamiento del robot, el desarrollo de estas se realiza en el archivo main.c, adicionalmente se usan las funciones generadas en el archivo CSR.h producto de la compilación del archivo Sistem On Chip.   
  -  Las funciones que se encontrarán en el main.c se realacionan con:
       - El movimiento del robot en el laberinto
       - El funcionamiento del dfplayer
       - El funcionamiento de los motores
       - El funcionamiento del radar
       - El procesamiento de imágen de la cámara.
     Entre otros.   



ETAPA 4. Implementación física final.



# DESARROLLO PROYECTO
### ETAPA 1 

Durante la etapa 1, se realizó el desarrollo de los drivers en Verilog, es decir archivos que permiten el control de los perifericos, en palabra simples estos archivos "hablan el idioma de los perifericos" y les indican de que manera funcionar (funcionamiento básico, no implementación). Adicionalmente se desarrollaron modulos cocmplementarios, divisores de clock, contadores, pwm, etc. 

[DOCUMENTACIÓN ETAPA 1](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/tree/main/module/verilog)

### ETAPA 2 

En la etapa 2, se crea el Soc, tambien llamado System on Chip, se usa el procesador AMD, el cual interactuará con los registro y los modulos que se desarrollaron en la ETAPA 1 en verilog. La construcción del SoC se realizo haciendo uso de Litex y Migen herramientas que nos permiten usar y unir los archivos/modulos de verilog en un procesador que tenga acceso a todos, sin embargo para esto es necesario "traducirlos" a lenguaje python (usado por litex). Una vez realizado esto nuestro SoC tendra integrados todos los modulos anteriormente generados en verilog y podra acceder a estos, sin embargo no irá más allá de eso. Para que nuestro software pueda realizar alguna acción relacionada con los modulos es necesario que definamos el funcionamiento y las acciones que se realizaran, todo esto es el software del proyecto el cual se trabajó en la ETAPA 3. 

[DOCUMENTACIÓN ETAPA 2](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/tree/main/DocBuildSoc-Nexys4DDR)

[LINK a archivo: Build SoC ProJect ](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/buildSoCproject.py)

[LINK a archivo: Nexys 4 DDR](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/nexys4ddr.py)



### ETAPA 3 

Durante la ETAPA 3 se trabajó con dos archivos principalmente, el archivo CSR.h y el main.c, en el primero se encuentran algunas funciones generadas automaticamente al compilar el SoC, estas funciones nos permiten escribir o leer los registros indicados dependiendo el modulo, en el segundo se generan funciones que determinan el funcionamiento del modulo. A continuación los links que conducen a la explicación respectiva del trabajo en cada uno.

[DOCUMENTACIÓN ETAPA 3](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/tree/main/firmware)

[LINK a archivo: CSR.h](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/build/nexys4ddr/software/include/generated/csr.h)

[LINK a archivo: MAIN.C](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/firmware/main.c)

### ETAPA 4 
La implementación física final no se realizó, es decir que el robot no cuenta con un chazis que sostenga los perifericos, sin embargo en el video de funcionamiento se puede observar como el robot funciona y cumple los requisitos establecidos. 

## Video de implementación y consejos para abordar esta documentación y la realización del proyecto
- Se sugiere a los lectores no dejarse abrumar por la cantidad de archivos que se encuentran en la documentación, si bien un alto porcentaje son desarrollados por nosotros, otro pocerntaje es generado automaticamente durante la construcción del procesador, sin embargo si es recomendable entender así sea a grandes rasgos la función de la mayoría de los archivos. 
- Durante el semestre (debido al paro presentado) no se realizó la implementación de interrupciones por lo cual en la documentación de proyecto no se encontrará esta información. 
- Es aconsejable avanzar lento pero constante, el trabajo en si no es extenuante si se avanza cada semana, sin embargo puede ser abrumador si al final del semestre no se ha desarrollado la mayor parte. 


[LINK video funcionamiento final](https://www.youtube.com/watch?v=sNGl_hLQYII)

[Carpeta que contiene el conjunto de videos y pruebas](https://drive.google.com/drive/folders/1BKVYntLTiYfyQTIR0QGxaN3RyDr95x0F)


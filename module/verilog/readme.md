# ETAPA 1

En esta etapa se desarrollaron los siguientes divers: 

- Radar
- Motor
- VGA (Incluye camara y procesamiento de imagen)
- UART

## MAPA DE MEMORÍA

Antes de iniciar la construcción se plantearon los mapas de memorpia que se muestran a continuación y que finalmente se cumplieron.  Para leer los mapas que se muestran a continuación se uso la siguiente nomenclatura: Si el especio esta subrayado se puede acceder para lectura, si no esta subrayado se puede aceeder para lectura y escritur. 

![Image text](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/module/verilog/figuras/M_como_leer_los_mapas.png)

Inicialmente tenemos nuestro mapa general de memoria, donde se muestran todos los espacios. 

![Image text](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/module/verilog/figuras/M_general.png)

Posteriormente tenemos nuestro mapa de registros de memoria, que nos indica la manera como la memoria general se divide.

![Image text](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/module/verilog/figuras/M_region_memoria.png)





## MODULOS GENERALES

Los modulos generales son aquellos que se usaron en varios de los Drivers especificos, por ejemplo el modulo Counter, PWM, entre otros.

### Código PWM

El modulo PWM es una señal conformada por una sucesión de pulsos periodicos que duran en un 1 lógico un cierto tiempo, este tiempo es considerado el ciclo de trabajo. 

![Image text](https://github.com/unal-edigital2/Grupo-5-proyecto/blob/Master/module/verilog/figuras/Ciclotrabajo.jpg)

Para implementar este módulo es necesario hacer uso de un divisor de clock y de un contador. 

### Código divisor de clock:

En el código se explica detalladamente la función de cada registro y del proceso que se siguió. 

~~~
module clk_div  #(parameter MAX_COUNT=50_000)
( 
  input clk,
  output reg clk_out
);

wire [15:0] count;
reg counter_reset;

initial begin
	clk_out<=0;
	counter_reset<=1;
end

always@(posedge clk)
  begin 
    counter_reset<=0;
    if(count==MAX_COUNT)
    begin
    	clk_out<=!clk_out;
    	counter_reset<=1;
    end
  end  

  counter counter1(.clk(clk), .count(count), .reset(counter_reset));
   

endmodule
  ~~~

### Código contador: 
En el código se explica detalladamente la función de cada registro y del proceso que se siguió.

~~~
module counter( 
  input clk, 
  input reset,
  output reg [15:0] count
);

initial  begin
count = 0; 
end 
always@(negedge clk)
begin 
    if(reset) count<=16'b0;
    else count<=count+16'b1;
end    
endmodule
~~~

### Código PWM: 

~~~
module pwm( 
  input clk, 
  input enable,
  input [15:0] dutty,  // dutty en microsegundos
  input [15:0] period, // periodo en microsegundos
  output reg pwm_out
);

wire clk_1M;

reg counter_reset;
wire [15:0] count;

reg [1:0] state;

initial begin
	pwm_out<=0;
	state<=0;
	
// máquina de estados

always@(posedge clk_1M)
begin
    if (!enable) begin
			pwm_out<=0;
            state <= 0;
    end
	case(state)
		0: begin
			pwm_out<=0;
			counter_reset<=1;
			
            if(enable)
    	       state<=1;
		end

		1: begin
		
			pwm_out<=1;
			counter_reset<=0;
			if(count>=dutty)
    	       state<=2;
  		end

		2: begin
			    pwm_out<=0;
				if(count>=period)begin
            	   state<=0;      	
            	end
    
		end
	endcase
end

clk_div #(.MAX_COUNT(50)) clk1_1M (.clk(clk), .clk_out(clk_1M));
counter counter1(.clk(clk_1M), .count(count), .reset(counter_reset));

endmodule

~~~


## DRIVER RADAR

El primer periférico en el cual se enfocó el grupo fue el radar (servo + ultrasonido), ya que se consideraba uno de los perifericos que nos eran más familiares, para este periférico se desarrolló un PDF donde se explica a grandes rasgos el funcionamiento de este, para complementar este desarrollo se explicará a continuación el código y se evidenciará su funcionamiento en un video .

Codigo Ultrasonido

En el codigo ultra sonido, se hace uso de los modulos explicados anteriormente, el contador (por ende el divisor de clock) y el pwm. 

~~~
module ultrasonido( 
        input clk,  //Entra la señal de cloc
        input init, //Señal que indica al ultrasonido que mande la señal
        output trigger,
        input eco, //
        output [15:0] tiempo, //para contar hasta 30ms (máx que dura eco)
        output reg done //Registro que informan en que momento la señal de retorno del ultra sonido se ha recibido. 
);

wire clk_1M; //Aquí ya entra el clock de 1M?

reg enable_trigger;
reg tiempo_reset;
reg  [1:0] state;

reg [15:0] period_trigger; //Para prueba
reg [15:0] dutty_trigger;  //Para prueba 
~~~

A continuación se evidencia la máquina de estados del ultrasonido, donde se evidencia el funcionamiento de los 3 estados que se definieron. 

~~~
initial begin
        state<=0;
        done<=0;
        period_trigger<=16'd60; //60 micros periodo
        dutty_trigger<=16'd12; // 12 micros ciclo útil
end


always@(posedge clk_1M) 
begin 
 
	case(state)
		0: begin  
		   tiempo_reset<=1; //No hemos iniciado a contar.
                   enable_trigger<=0; // Nuestra señal de disparo no se ha enviado
                   done<=0; // El done se encuentra en 0 ya que la señal de retorno no se ha recibido
			if(init) // Al dar la señal al ultrasonido de que inicie se pasa al estado 1
    	             state<=1;		
		end

		1: begin
		   tiempo_reset<=1; //Aun no estamos contando, tiempo_resete=1 quiere decir
			            //que constantemente estamos re iniciando el contador
                   enable_trigger<=1; //Mandamos nuestra señal de disparo.
                   done<=0; //Done en 0 ya que no hemos recibido la señal de retorno.		        
		
			if(eco)   //Si eco=1 (quiere decir que no se ha detectado la señal de retorno) 
				 // entonces pasamos al estado 2
    	             state<=2;
  		end

		2: begin
			tiempo_reset<=0; //El conteo inicia ya que se envió la señal de disparo 
			                 // (debe ir y volver para determinar la distancia)
                   enable_trigger<=0;  //El triger está en 0 ya que no se envia la señal nuevamente.
                   done<=0; 

			if(!eco)  //Una vez eco=0 quiere decir que la señal que se envió ha retornado
    	             state<=3;
  		end  

        3: begin 
		           tiempo_reset<=0; //Aún no se detiene el conteo sin embargo done es 1 ya que la señal ya se recibió.
                   enable_trigger<=0; 	
                   done<=1;
                   
		if (init==0) // Para volver a usar el ultrasonido, se asigna un 0 a la señal de init. 
                   state<=0;
        end


	endcase
end 



clk_div #(50) clk1_1M(.clk(clk),.clk_out(clk_1M)); 
counter counter1(.clk(clk_1M), .count(tiempo), .reset(tiempo_reset));
pwm trigger1(.clk(clk) ,  .enable(enable_trigger),  .dutty(dutty_trigger),  .period(period_trigger), .pwm_out(trigger) );

endmodule 
~~~

Finalmente recomendamos que se revise el PDF Ultrasonido, donde se presentan los diagramas gráficos que explican la interacción de las señales y registros, adicionalmente se presenta la máquina de esto de manera gráfica. *Se sugiere que descarguen el archivo ya que por el peso es posible que no sea visualizable en GitHub.*

[LINK PDF ultrasonido](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/Documentaci%C3%B3nPDFs/Ultrasonido.pdf)

Ver video de prueba de funcionamiento:  
[Video Ultrasonido](https://drive.google.com/file/d/1GypbvJ5c7eHzlJgD_kZBjsvUvxoFxT_j/view?usp=sharing)

# Motores
En este modulo se describe el comportamiento de los motores que van a ser la base para la movilidad del robot. Adicional al PWM que ya se ha explicado anteriormente se encuentra un modulo direcciónes y el modulo motor. EL primero es el modulo direcciones que se muestra a continuación.

En este modulo tenemos una entrada de 3 bits llamada movimiento, la cual le informa a los motores si moverse o no, adicionalmente tenemos dos salida de dos bits, una para cada motor (A y B), las cuales dependeran directamente de la entrada. 
~~~
module Direcciones(
	input [2:0] Movimiento,
	output [1:0] MotorA,
	output [1:0] MotorB
);

assign MotorA[1]=(Movimiento[0]&(Movimiento[2]));
assign MotorA[0]=(Movimiento[0]&(!Movimiento[2]));

assign MotorB[1]=(Movimiento[1]&(Movimiento[2]));
assign MotorB[0]=(Movimiento[1]&(!Movimiento[2]));


endmodule
~~~


A cada bit de cada motor le será asignado un 1 o un 0 dependiendo de la entrada de 3 bits (movimiento). A continuación se muestra la tabla que indica la dirección del giro o desplazamiento del robot dependiendo "movimiento".

![Image text](https://github.com/unal-edigital2/Grupo-5-proyecto/blob/Master/module/verilog/figuras/TablaMov.PNG)

Finalmente se encuentra el modulo Motores.


~~~
module motores(
	input clk,
	input rst,
	input [2:0] movimiento,
	output pwm1,
	output pwm2,
	output [1:0] motorA,
	output [1:0] motorB
);


PWM First(clk, !rst, 7'd20, pwm1);
PWM Second(clk, !rst, 7'd20, pwm2);
Direcciones Dir(movimiento, motorA, motorB);

endmodule 
~~~

Para detallar la representación gráfica de la maquina de estados, observar el diagrama de señales  y el funcionamiento de este modulo se reomienda ve el pdf de motores:

[LINK PDF motores](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/Documentaci%C3%B3nPDFs/Motores.pdf)

Y el video de prueba de funcionamiento: [Video Motores](https://drive.google.com/file/d/1YKebT5QkzJ59IInPWI5JwHerJdkrAPx3/view?usp=sharing)

# VGA  (Incluye Cámara)

[Documentación PDF VGA](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/Documentaci%C3%B3nPDFs/VGA.pdf)

El VGA es la abreviatura de Matriz de gráficos de vídeo, este nombre es asignado a varias cosas por ejemplo a la resolución de 640 × 480 píxeles y al conector de 15 contactos D subminiatura. Justamente este es el que se usa para el proyecto y el que usado por la Nexys 4DDR, como se muestra a continuación unicamente se usan 5 pines de este conector (RED, GREEN, BLUE, HSYNC, VSYNC). Adicionalmente es importante aclara que se cuenta con un archivo llamado clk24_25_nexys4.v  ya que tanto la Cámara como el VGA operan una frecuencia cuatro veces menor a la frecuencia del clock de la FPGA. 

![Image text](https://github.com/unal-edigital2/Grupo-5-proyecto/blob/Master/module/verilog/figuras/VGAn.png)


En nuestro caso el Modulo VGA cumple diferentes funciones relacionadas con el protocolo que lleva el mismo nombre y más especificamente con la cámara. A continuación se describe la función de cada uno de los modulos, sin embargo se sugiere que para un mejor entendimiento se remitan a los códigos encontrados en esta sección. 

*CamaraVGA_ driver*: Es el encargado de generar el protocolo VGA para enviarlo a los pines Href_n, Hsinc_n (Href y Hsin negadas), Xpos, Ypos (posición de barrido en la pantalla). Toma como ingreso un pixel de entrada que contiene la información del color en formato RGB 444, adicionalamente indica donde graficar la información de color y forma, para efectos prácticos se decidió mostrar esta información como fondo de pantalla (detrás del mapa), la mitad inferior de la pantalla tomará el color del color de la figura y la parte de arriba dependiendo de la figura tomará un color especifico:

- Azul--> Triangulo
- Verde--> Circulo
- Rojo--> Cuadrado

Así si tenemos un circulo rojo, la mitad superior de la pantalla tomara el color verde, mientras que la mitad inferior tomará el color rojo.

[LINK código comentado VGA_driver](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/module/verilog/VGA100/VGA_driver.v)

*ImBuffer*: Es una memoría donde se almacenan los datos de la camara, esta memoría es bastante grande  ya que debe almacenar la imagen proporcionada por la camara.

[LINK código ImBuffer](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/module/verilog/VGA100/ImBuffer.v)

*IMBufferv2*: Esta memoria es mucho más pequeña que la anterior, cumple la función de guardar la información del mapa, la información de color y el mapa en si mismo. 

[LINK código comentado ImBufferv2](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/module/verilog/VGA100/ImBufferv2.v)

*OVO7670*: En este modulo se adquiere la información de la camara, se lee la información que le llega  y almacena la información en ImBuffer, también realiza el procesamiento de imagen, en este último realizaremos enfásis a continuación. En pocas palabras el driver de la camara, en terminologías de los modulos aportados por el profesor este sería el cam_test.V. 

[LINK código comentado OVO7670](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/module/verilog/VGA100/OV7670.v)

Para el análisis de imagen se debe tener en cuenta que analizamos color y forma. El código comentado se encuentra en el link de arriba, sin embargo a continuación se explica el proceso general de funcionamiento. 

Para el color se decidio que se iban a realizar una agrupaciones de 3 pixeles, la agupación será valida si los 3 pixeles son del mismo color, de otra manera no la agrupación no es valida. Las agrupaciones se van a ir sumando en secuencia en la fila (Aumentando el colorprom), una vez la fila a terminado debemos tener la información del ancho de la fila (dado por el número de trio de pixeles validos), en la documentación contamos con ancho para color rojo, azul y verde. Al completar la fila el ancho actual se compara con el ancho medio (máximo, inicia en 0), si el ancho medio es mayor que el ancho actual no se cambia el valor del ancho medio, por el contrario si el ancho medio es menor que el ancho actual el ancho medio tomará el valor del ancho actual. Posteriormente el ancho actual se compara con el ancho anterior, si el ancho actual es mayor que el ancho anterior el ancho incremental aumenta, si no es así, el ancho incremental disminuye. Para finalizar,  los valores de ancho de cada fila se guardan en la varibale ancho anterior, y nuevamente se incia el proceso de determinar los trios de pixeles validos. Esto quiere decir que a cada fila el valor de Ancho se inicializa en 0, el ancho medio y el ancho incremental cambiará (generalmente). A continuación se evidencia el proceso a seguir de manera gráfica. 

![Image text](https://github.com/unal-edigital2/Grupo-5-proyecto/blob/Master/module/verilog/figuras/Procesamiento%20de%20im%C3%A1gen.PNG)

Al finalizar llegar a la última fila se compararán los promedios de color rojo, azul o verde, y el colorprom que sea mayor será el que nos indique cual es el color predominante en la figura. 

Para el anális de forma se realizó un proceso que involucra los mismo registro que el análisis de color, sin embargo se usaron de manera diferente. Nuestro registro Ancho incremental inicia en 100 y como se explicó en el procesamiento de color, este puede aumentar o disminuir dependiendo si la cantidad de trios de pixeles validos de un color aumentan o disminuyen. Al terminar la última fila, lo que se hará es comparar inicialmente nuestro ancho incremental inicial (100) con nuestro ancho incremental final (ancho incremental), si los dos son similares se puede dar por hecho que la figura es un cuadrado o un circulo, sin embargo para diferencicar entre estos dos nos ayudamos del registro Ancho med que nos ha guardado el valor del ancho mayor (fila con más trios de pixeles validos de un color), si este ancho es mucho mayor que el ancho incremental final podemos dar por hecho que es un circulo, mientras que si el ancho medio es similar al ancho incremental podemos deducir que se trata de un cuadrado. Finalmente si el ancho incremental final es mucho mayor o menor que el ancho incremental inicial (100) será un triangulo. 

- Circulo 2b'10
- Cuadrado 2b'01
- Triangulo 2b'11

   - ![Image text](https://github.com/unal-edigital2/Grupo-5-proyecto/blob/Master/module/verilog/figuras/Procesamiento%20de%20im%C3%A1gen2.PNG)

   - [Video camara y reconocimiento de imágenes](https://drive.google.com/file/d/1A5ViCRr3DoxvzhJ_PKTOhKA2XRoNO36x/view?usp=sharing)

   - [Indicamos en consola el color y forma ](https://drive.google.com/drive/folders/1BKVYntLTiYfyQTIR0QGxaN3RyDr95x0F)

   - [Dibujamos en mapa -VGA](https://drive.google.com/drive/folders/1BKVYntLTiYfyQTIR0QGxaN3RyDr95x0F)

# UART

El UART es un protocolo serial que permite la interacción entre dos dispositivos, como su nombre lo indica universal asynchronous receiver / transmitter es un protocolo de comunicacion basico en el cual el transmisor y el receptor se deben poner de acuerdo con la velocidad con la que recibiran los datos, ademas de que se cuenta con un canal dedicado para transmision y otro independiente dedicado para la recepcion por lo cual se puede usar en paralalelo (Aunque existe la posibilidad de utilizar un unico canal a traves de Tri-State). En este caso nos va a ayudar a transmitir información entre el procesador y algunos periféricos especificos, el modulo uart esta conformado por los siguientes submodulos. 

*Generador de baudios*: Indica a que velocidad se va a dar la transmisión de datos y envia esta señal de reloj a los demas perisfericos.

*Uart*: Conecta el modulo generador de baudios a los modulos de lectura y escritura para obtener un modulo funcional que realice ambas operaciones al tiempo.

*UartRx*: Define los protocolos de lectura

*UartTx*: Define los protocolos de escritura.  

Tambien ha de tenerse en cuenta que los modulos de lectura y escritura funcionan de manera independiente, de manera que para iniciar la transmision de datos se debe utilizar una señal INIT la cual se encargara de generar el protocolo a traves de RX con los datos cargados en TXData, una vez que se acabe el protocolo se cuenta con una señal TXDone que nos indica cuando este proceso ha finalizado y esta no se desactiva hasta que el INIT vuelva a 0, evitando el envio de multiples datos repetidos. Para el caso de la recepcion de datos se cuenta con la condicion RXAvailable que nos indica si ha llegado un dato (Cuando se esta recibiendo es 0) y este es valido por lo cual podemos leer lo que esta en RXData siendo este el mensaje que acaba de llegar. Este modulo se puede implementar con interrupciones debido a que el envio de multiples datos se puede hacer simplemente cada vez TXDone tiene un flanco de subida de 0 a 1, por lo cual esta sera nuestra señal de interrupcion en su implementacion en el software. en el caso de la recepcion de datos se aplica la misma condicion, cuando RXAvailable cambia de 0 a 1 indica que el dato que se estaba recibiendo ya es valido para su lectura por lo cual esta sera nuestra condicion de interrupcion en una etapa futura de la implementacion junto al SoC.

[Documentación PDF UART](https://github.com/unal-edigital2/w07_entrega-_final-grupo15/blob/main/Documentaci%C3%B3nPDFs/Uart.pdf)

   - [Prueba bluethoot](https://drive.google.com/file/d/1VBtyN9T0SIN_YiE5R5QapZ4dEZ4rJITJ/view?usp=sharing)
   - [Prueba dfplayer mini1](https://drive.google.com/file/d/1CVGVcrjW7LxUk5K06mhSqP3__PBNpGQt/view?usp=sharing)
   - [Prueba dfplayer mini2](https://drive.google.com/file/d/1naFO3XQtUFVfm5zCH8A6EpbjOqmFQAoW/view?usp=sharing)


# BlueThoot

hOLIS oscaR

# ETAPA 3 

### Pre requisitos
- Crear los drivers de los periféricos que se usarán en verilog
- Haber syntetizado el SoC y generado nuestros archivos.py que serán integrados por MIGEN y LITEX en nuestro SoC.
- Definir los pines físicos de salida en nuestro archivo Nexys4DDR y relacionar estos con los definidos en el archivo BuildSoCProyect. 

### ¿Qué se realiza en esta etapa? 

En la ETAPA 3 ya hemos pasado por 2/4 del proceso para generar nuestro robot cartógrafo, sin embargo resta lo más importante definir de que manera va a trabajar, para esto vamos a escribir nuestro Software, el cual va a indicar como deben trabajar los periféricos (en que orden, que funcion cumple cada uno, como interactuan entre ellos, etc). Esto es realmente lo que va a indicarle al robot de que manera resolver el laberinto. 

### ¿Cómo se escribe el software?

En primer lugar debemos definir las funciones para que nuestro robot trabaje (este proceso se realizará en el main.c), con ayuda del archivo SCR.h (archivo generado al ejecutar nustro SoC) donde se han definido funciones de lectura y escritura según lo que nosotros hemos indicado en nuestros archivos .py (Storage () o status () ). 


### FUNCIONES 

Para llegar a nuestra función final (Robot cartógrafo () ) se programaron varias funciones complementarias que fueron llamadas ahí y que permiten el movimiento del robot, el funcionamiento del radar y la lectura de ultrasonido, entre otros. A continuación las funciones que se encuentran en la documentación. 

- Servo
- Ultrasonido
- Radar
- Calcular_coordenadas
- Seguidor_de_linea
- Motores
- Dfplayer
- Robot Cartógrafo

A continuación estas funciones se describen explicando las entradas, las salidas, funcionmaiento y parámetros. 

### CONSIDERACIONES GENERALES

MOVIMIENTO DEL ROBOT EN EL LABERINTO

En nuestro caso se definió que el laberinto va a tener las siguientes dimensiones: 8x8, adicionalmente de decidió que en ningún momento el robot tenga que elegir entre dos caminos libres y el robot siempre iniciara en la esquina superior izquierda, esto para facilidad del mapeo y del posterior dibujo. 


## SERVO

Nuestra primera función es el servo, como parámetros de entrada se definio "Ubicación" y "enable", la ubicación se relaciona con el ciclo útil de la señal y dependiendo de este el servo generará una rotación a 0°, 90° o 180°, en otras palabras se quedara quieto rotará a la derecha o izquierda. Por otra parte el enable debe mantenerse en un 1 lógico para que nuestro dispositivo pueda recibir la señal pwm.  Nuestro periodo estandar se definió de 20000 teniendo en cuenta que es lo indicado por la documentación del servomotor. 

~~~
static void servo(uint32_t ubicacion, uint32_t enable)
{
	unsigned int periodo = 20000;
	unsigned int dutty = ubicacion; //rango es de 500 a 2500
	
	servo_cntrl_enable_write(enable);		
	servo_cntrl_period_write(periodo);
	servo_cntrl_dutty_write(dutty);
}

~~~


Observamos también que tenemos funcicones de escritura para "enable" , "period" y "dutty" estas funciones son generadas en el archivo csr.h. 

## ULTRASONIDO

Para el ultrasonido no es necesario un parámetro de entrada, definimos internamente un entero llamado distancia, en el cual se almacenará la información de la distancia del robot a las paredes encontrada por el ultrasonido.

Nuevamente realizamos uso de las funciones de lectura y escritua generadas en el scr.h, en este caso la funcion se relaciona con el init, una vez que hemos escrito en init 1, nuestro ultrasonido habrá enviado la señal de trigger y esperará hasta recibir la señal de eco (esto se controla mediante el while), una vez el ultrasonido reciba la señal eco, el done pasara a ser 1 y saldremos del while, escribiremos un 0 en init para evitar que el ultrasonido vuelva a enviar la señal de trigger y finalmente leeremeos la información almacenada en tiempo (realizando un pequeño ajuste para obtener la distancia en cm) y retornaremos los datos almacenados en distancia.

~~~
static int ultrasonido(void)
{
	unsigned int distancia;

	ultrasonido_init_write(1);
	while(!(ultrasonido_done_read()));
	ultrasonido_init_write(0);		
	distancia = ultrasonido_tiempo_read()*340/20000;	//distancia en centimetros
		
	return distancia;
}
~~~

## RADAR

El radar hace uso de las dos funciones descritas anteriormente, como parámetro se encuentra nuestro char via_libre que puede ser (r, l o c) dependiendo de la dirección donde el radar determine que hay una mayor distancia (como prioridad tomara el centro, luego derecha y finalmente izquierda). 

Definimos los enteros ubicación, distanciaC, distanciaR, distanciaL y enable, cómo se había visto anteriormente Ubicación y enable son usados para el servo motor, mientras que distanciaC, R y L, son enteros que almacenaran la información de la distancia en cm una vez el servomotor realice el giro en esa dirección y el ultrasonido haya realizado su proceso obteniendo distancia. 

~~~
static void radar(char* via_libre)
{	
	unsigned int ubicacion;
	unsigned int distanciaC, distanciaR, distanciaL;
	unsigned int enable;
	//movimiento del radar
	enable = 1;

	printf("Escaneando... \n\n");
~~~

La ubicación 500 indica que vamos a rotar a la izquierda, al servo le entran los parametro de Ubicación (500) y enables (1), es decir indicamos hacia donde debe girar y le decimos que este listo para recibir la señal pwm. Una vez el servo gira se produce un delay de 1000ms (para terminar el giro) y se usa el ultrasonido para hallar distanciaL, para finalizar se genera un nuevo delay de 2000ms para que el servo vuelva a su posición inicial. 

~~~
	ubicacion = 500;
	servo(ubicacion, enable);
	delay_ms(1000);
	distanciaL = ultrasonido();

	delay_ms(2000);
~~~

Esto mismo se repite para una Ubicación de 1500 (centro) y de 2500 (derecha), finalmente se solicta que escriba en pantalla la distancia que hay para cada lado e indicamos que tome una decición teniendo en cuenta que la distancia debe ser mayor a 25 para que decida elegir ese camino como mayor distancia. En esta parte final asignamos dependiendo de la mayor distancia nuestro char "c", "r" o "l". Si ninguna de las direcciónes es mayor a 25 se da por hecho que el laberinto ha terminado. 

~~~
	printf("Distancia left: %i\n", 
			distanciaL);
	printf("Distancia center: %i\n", 
	distanciaC);
	printf("Distancia right: %i\n", 
	distanciaR);

	//tomar decisión y devolver a donde se debe mover el robot
	//el robot considera el camino libre si la distancia detectada es mayor a 15cm
	if(distanciaC > 25) *via_libre = 'c';
	else if(distanciaR > 25) *via_libre = 'r';
	else if(distanciaL > 25) *via_libre = 'l';
	else *via_libre = 'n';
~~~

## CALCULAR COORDENADAS

En nuestra función calcular cordenadas se le indicará al robot su nueva coordenada, esto es importante para realizar la gráfica en el mapa, inicialmente nuestro robot se encontrará en la posición 0,0 es decir en la parte superior a la izquierda, como parámetros tenemos enteros : calc_x_new, calc_y_new, x_old, y_old, char:  dirección_robot_old, dirección robot_new, radar. 

Imaginemos un plano bidimencional en nuestras pantallas donde el robot esta en la esquina superior izquierda, inicialmente nuestro robot está mirando para abajo, si nuestro radar indica que la mejor distancia es down (hacia abjo) el robot se moverá una casilla en Y hacia abajo (sin embargo por cuestiones del mapa cada vez que el robot se mueva hacia abajo nuestras Y aumentan y si se mueve a la derecha nuestras X aumentan también). Así como se ve en el primer if --> 'd' caso 'c', la X permanecerá igual ya que no se ha movido horizontalmente y la Y aumentará en 1. Reiteramos que esta información es necesaria para graficar. 

~~~
static void calcular_coordenada(int* calc_x_new, int* calc_y_new, int x_old, int y_old, char direccion_robot_old, char* direccion_robot_new, char radar)
{
	if(direccion_robot_old == 'd'){
		switch(radar)
		{
			case 'c':
				*calc_x_new = x_old;
				*calc_y_new = y_old+1;
			break;
			case 'l':
				*direccion_robot_new = 'r';
				*calc_x_new = x_old+1;
				*calc_y_new = y_old;
			break;
			case 'r':
				*direccion_robot_new = 'l';
				*calc_x_new = x_old-1;
				*calc_y_new = y_old;
			break;
		}
	}
  ~~~

Es importante también aclarar que se debe tener en cuenta que una vez el robot realice un giro a la izquierda o la derecha, las direcciónes que el ve y que nosotros vemos son distintas, por ejemeplo si el robot gira a la derecha y luego le indicamos que gire a la izquierda, para nosotros se desplazara luego de este segundo giro para arriba, sin embargo para el se estará desplazando a la izquierda. Es por esta razón que se definieron 4 casos teniendo en cuenta la dirección anterior y la dirección nueva, para que se logre sintonizar lo que el ve con lo que nosotros vemos.  Cada uno de los if que se muestra en esta funcion se relaciona con un caso, cuando el robot ve arriba, abajo, derecha o izquierda, en cada caso  dependiendo de la indicación del radar se asigna la dirección nueva y se define la coordenada donde el robot se encuentra. 


## SEGUIDOR DE LINEA

Nuestro seguidor de linea es una de las funciones más sencillas, unicamente consiste en indicar cuando los 3 infrarojos han detectado una línea negra, esto es necesario para identificar los cruces, en los cuales la camara deberá realizar el análisis de imágen, se proporcionará un delay de 4s para que la imágen se interprete correctamente. 

~~~
static void seguidor_de_linea(void){
//Cuando los tres infrarojos se activan, se esta en una intersección y el robot se detendrá 4 segundos para analizar la imagen
	
	if(!(infrarojo_in_read()&1) && !(infrarojo_in_read()&(1<<1)) && !(infrarojo_in_read()&(1<<1)) ){
		printf("\nIntersección detectada... Analizando imagen\n");
		delay_ms(4000);
	}
}
~~~

Prueba de con un solo modulo infrarrojo: [modulo infrarrojo](https://drive.google.com/file/d/1NxraRsXtdAXLaYH7UcZWPtHweZSeEbbq/view?usp=sharing)

## MOTORES

Para el movimiento de motores, es necesario el parametro char que nos proporciona el radar, el cual nos indica la nueva dirección a tomar, inicialmente definimos los motores para estar quietos, siempre que el dadar nos indique una dirección se proorcionara 1 segundo para que los motores se muevan antes de realizar una nueva lectura de radar. 

~~~
static void motores(char radar){

	motores_movimiento_write(0);
	if(radar == 'c'){ 	
		motores_movimiento_write(3); //Avanzar 3 en la documentación
		delay_ms(1000);
		motores_movimiento_write(0);
		printf("\nResultado: Sigo derecho\n\n");
	}
~~~

Por ejemplo, cuando el radar detecte que es mejor seguir por el centro escribiremos movimiento un 3 esto indica que se debe avanzar, generaremos un delay de 1s en el cual los motores se moveran, posteriormente el movimiento de motores se detendra al escribir 0 en el e imprimiremos en pantalla "sigo derecho". 

Esto mismo es aplicable para derecha o izquierda, con la diferencia de que el motores_movimiento write se escribira un 1 para la derecha y un 2 para la izquierda (segun como se muestra en la documentación a continuación.)

![Image text](https://github.com/unal-edigital2/Grupo-5-proyecto/blob/Master/firmware/figuras/Mottab.PNG)


## DF PLAYER

Nuestro dfplayer indicará la nueva dirección que va a tomar el robot, inicialmente debemos saber si nuestro dfplayer se encuentra disponible u ocupado, si se encuentra disponible pasamos a identificar el caso que corresponda con la información guardada en radar. El dfplayer continen ya de por si un comando general que nos pemite informarle sobre la acción que debe realizar, el cual es el siguiente  dfplayer_command(XX,0x00,0x00,X), aquí se indica en el primer parámetro (XX) la función (leer canción, entrar a carpeta y leer canción, subir o bajar volumen, etc), el segundo (X) y tercer parámetro no son de interes, el último indica la canción que vamos a leer. Así el primer parámetro 0x03 indica que vamos a leer una canción y el último la canción que se va a leer.

~~~
static void dfplayer(char radar){

	int avaliable = dfplayer_send_available();
	if(avaliable == 1) return;
	else{

		if(radar == 'c'){ 	
			dfplayer_command(0x03,0x00,0x00,2);
		}
		else if(radar == 'r'){
			dfplayer_command(0x03,0x00,0x00,1);
		}
		else if(radar == 'l'){
			dfplayer_command(0x03,0x00,0x00,3);
		}
		else {
			printf("\ndfplayer: No se detecta una vía libre\n\n");
~~~

## ROBOT CARTÓGRAFO

Esta función es la que se usará en el main y abarca todas las funciones explicadas anteriormente. Deinimos enteros X_new, Y_new,x-old y y_old para la coordenadas, necesitamos tambien definir los char: dirección_robot_old, dirección_robot_new y radar_via_libre. 

~~~
static void robot_cartografo(void)
{
	int x_new=0, y_new=0, x_old, y_old;
	char direccion_robot_old, direccion_robot_new='d';
	char radar_via_libre;

	//inicializando
	x_old = 1;
	y_old = 1;
	direccion_robot_old = 'd';
	vga_draw(x_old, y_old);
~~~

AL inicializar los enteros x_old y y_old en 1, mientras que las direcciónes robot_ols y robot_new se inicializan en 'd', finalmente se da la instrucción a la VGA que grafique x_old y y_old (coordenadas en nuestro mapa gráfico). 

Y finalmente iniciamos nuestro recorrido, usamos nuestra función radar para conocer la dirección a seguir, con esto usamos "calcular coordenadas" para poder dibujar en el mapa y conocer la ubicación del robot en todo momento, posteriormente usamos nuestra función seguidor de linea para conocer si se debe detener el robot y realizar el análisis de imagen o continuar. Se llama también a nuestro dfplayer para que nos indique cual es el siguiente movimiento a realizar y finalmente se permite el movimiento de motores y se realiza el dibujo gracias a la información aportada por calcular coordenadas. 

~~~
while(1){

		printf(">> Continúe con el botón central\n \n");
		while(!(buttons_in_read()&1)){}

		radar(&radar_via_libre);

		calcular_coordenada(&x_new, &y_new, x_old, y_old, direccion_robot_old, &direccion_robot_new, radar_via_libre);
		x_old = x_new;
		y_old = y_new;
		direccion_robot_old = direccion_robot_new;

		seguidor_de_linea();

		dfplayer(radar_via_libre);

		motores(radar_via_libre);

		vga_draw(x_new, y_new);
~~~




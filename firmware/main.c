#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <irq.h>
#include <uart.h>
#include <console.h>
#include <generated/csr.h>

#include "delay.h"

#include "vga.h"
#include "dfplayer.h"
#include "bluetooth.h"


//Al servomotor se le inicializan datos indicados en la documentación del dispositivo para su correcto funcionamiento. Con esta función el servomotor recibirá
// una ubicación (ciclo útil del PWM) y un enable que debe mantenerse en alto para que el dispositivo reciba la señal PWM.

static void servo(uint32_t ubicacion, uint32_t enable)
{
	unsigned int periodo = 20000;
	unsigned int dutty = ubicacion; //rango es de 500 a 2500
	
	servo_cntrl_enable_write(enable);		
	servo_cntrl_period_write(periodo);
	servo_cntrl_dutty_write(dutty);
}

//El ultrasonido debe saber cuando realizar el trigger y posteriormente determinar cuando ha recibido echo para devolver el dato de tiempo.
// Este último se convierte a distancia en centímetros con la ecuación descrita
static int ultrasonido(void)
{
	unsigned int distancia;

	ultrasonido_init_write(1);
	while(!(ultrasonido_done_read()));
	ultrasonido_init_write(0);		
	distancia = ultrasonido_tiempo_read()*340/20000;	//distancia en centimetros
		
	return distancia;
}

//El radar junta el ultrasonido y el servomotor para escanear 3 ubiacaciones diferentes: centro, derecha e izquierda. Dependiendo de los obstáculos 
// encontrados se decide que dirección tomar dando prioridad al centro, luego a la derecha y finalmente a la izquierda.
static void radar(char* via_libre)
{	
	unsigned int ubicacion;
	unsigned int distanciaC, distanciaR, distanciaL;
	unsigned int enable;
	//movimiento del radar
	enable = 1;

	printf("Escaneando... \n\n");

	ubicacion = 500;
	servo(ubicacion, enable);
	delay_ms(1000);
	distanciaL = ultrasonido();

	delay_ms(2000);

	ubicacion = 1500;
	servo(ubicacion, enable);
	delay_ms(500);
	distanciaC = ultrasonido();

	delay_ms(2000);
	
	ubicacion = 2500;
	servo(ubicacion, enable);
	delay_ms(500);
	distanciaR = ultrasonido();

	delay_ms(2000);


	//mostrar en pantalla resultados de ubicación
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
	//si el camino no esta libre via_libre='n' indicando que terminó la ruta

}

// Calcula las coordenadas para hacer la representación en el monitor, dependiendo de la dirección del robot y la vía libre del radar 
// se definen las nuevas coordenadas donde debe ser pintado el cuadrado
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
	else if(direccion_robot_old == 'u'){
		switch(radar)
		{
			case 'c':
				*calc_x_new = x_old;
				*calc_y_new = y_old-1; 
			break;
			case 'l':
				*direccion_robot_new = 'l';
				*calc_x_new = x_old-1;
				*calc_y_new = y_old;
			break;
			case 'r':
				*direccion_robot_new = 'r';
				*calc_x_new = x_old+1;
				*calc_y_new = y_old;
			break;
		}
	}
	else if(direccion_robot_old == 'l'){
		switch(radar)
		{
			case 'c':
				*calc_x_new = x_old-1;
				*calc_y_new = y_old;
			break;
			case 'l':
				*direccion_robot_new = 'd';
				*calc_x_new = x_old;
				*calc_y_new = y_old+1;
			break;
			case 'r':
				*direccion_robot_new = 'u';
				*calc_x_new = x_old;
				*calc_y_new = y_old-1;
			break;
		}
	}
	else if(direccion_robot_old == 'r'){
		switch(radar)
		{
			case 'c':
				*calc_x_new = x_old+1;
				*calc_y_new = y_old;
			break;
			case 'l':
				*direccion_robot_new = 'u';
				*calc_x_new = x_old;
				*calc_y_new = y_old-1;
			break;
			case 'r':
				*direccion_robot_new = 'd';
				*calc_x_new = x_old;
				*calc_y_new = y_old+1;
			break;
		}
	}
}

//Si el seguidor de linea detecta una intersección se analiza la imagen
static void seguidor_de_linea(void){
//Cuando los tres infrarojos se activan, se esta en una intersección y el robot se detendrá 4 segundos para analizar la imagen
	
	if(!(infrarojo_in_read()&1) && !(infrarojo_in_read()&(1<<1)) && !(infrarojo_in_read()&(1<<1)) ){
		printf("\nIntersección detectada... Analizando imagen\n");
		delay_ms(4000);
	}
}


//Los motores serán guiados por la lectura del radar, sin embargo, habrá una excepción en donde si los 3 sensores infrarojos seguidores de linea se activan, 
// el robot esta en una intersección por lo que se detiene 4 segundos para analizar la imagen obtenida por la cámara
static void motores(char radar){
	//Seguidor de linea. infrarojo_in_read()=3' lrc

	//Inicializa movimiento quieto
	motores_movimiento_write(0);

	//Mueve los motores durante un corto periodo de tiempo dependiendo de la via libre que detecte el radar
	if(radar == 'c'){ 	
		motores_movimiento_write(3); //Avanzar 3 en la documentación
		delay_ms(1000);
		motores_movimiento_write(0);
		printf("\nResultado: Sigo derecho\n\n");
	}
	else if(radar == 'r'){
		motores_movimiento_write(1); //Rotar derecha y avanzar 1 en la documentación
		delay_ms(1000);
		motores_movimiento_write(0);
		printf("\nResultado: Giro a la derecha\n\n");
	}
	else if(radar == 'l'){
		motores_movimiento_write(2); //Rotar izquierda y avanzar 2 en la documentación
		delay_ms(1000);
		motores_movimiento_write(0);
		printf("\nResultado: Giro a la izquierda\n\n");
	}
	else {
		motores_movimiento_write(0);
		printf("\nResultado: No se detecta una vía libre\n\n");
	}
}

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
		}
	}
}


//robot_cartografo recopila las funcionalidades anteriormente descritas  e inicializa algunas variables para luego pasar a un ciclo en donde el robot realizará 
// continuos escaneos del entorno
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

	//aqui si empezamos a llamar el radar

	
	while(1){

		printf(">> Continúe con el botón central\n \n");
		while(!(buttons_in_read()&1)){}

		radar(&radar_via_libre);

		//Se calcula coordenada para pintar en el monitor
		calcular_coordenada(&x_new, &y_new, x_old, y_old, direccion_robot_old, &direccion_robot_new, radar_via_libre);
		x_old = x_new;
		y_old = y_new;
		direccion_robot_old = direccion_robot_new;

		//Se detecta si hay intersección
		seguidor_de_linea();

		//Se llama el reproductor de sonido
		dfplayer(radar_via_libre);

		//Se realiza el movimiento del robot
		motores(radar_via_libre);

		//Se dibuja el cuadrado de posición nueva en el monitor
		vga_draw(x_new, y_new);
		
	}

}


int main(void)
{
	irq_setmask(0);
	irq_setie(1);
	uart_init();
	vga_rst();

	uartB_init();
	uartA_init();

	puts("\nSoC - Digital Final Project UNAL 2021-- "__DATE__" "__TIME__"\n");

	robot_cartografo();

	return 0;
}

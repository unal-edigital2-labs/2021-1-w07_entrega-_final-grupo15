#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <irq.h>
#include <uart.h>
#include <console.h>
#include <generated/csr.h>

#include "delay.h"
#include "bluetooth.h"
#include "dfplayer.h"
#include "servomotor.h"
#include "infrarrojo.h"
#include "ultrasonido.h"



static char *readstr(void)
{
	char c[2];
	static char s[64];
	static int ptr = 0;

	if(readchar_nonblock()) {
		c[0] = readchar();
		c[1] = 0;
		switch(c[0]) {
			case 0x7f:
			case 0x08:
				if(ptr > 0) {
					ptr--;
					putsnonl("\x08 \x08");
				}
				break;
			case 0x07:
				break;
			case '\r':
			case '\n':
				s[ptr] = 0x00;
				putsnonl("\n");
				ptr = 0;
				return s;
			default:
				if(ptr >= (sizeof(s) - 1))
					break;
				putsnonl(c);
				s[ptr] = c[0];
				ptr++;
				break;
		}
	}
	return NULL;
}

static char *get_token(char **str)
{
	char *c, *d;

	c = (char *)strchr(*str, ' ');
	if(c == NULL) {
		d = *str;
		*str = *str+strlen(*str);
		return d;
	}
	*c = 0;
	d = *str;
	*str = c+1;
	return d;
}

static void prompt(void)
{
	printf("RUNTIME>");
}

static void help(void)
{
	// puts("Available commands:");
	// puts("help                            - this command");
	// puts("reboot                          - reboot CPU");
	// puts("BTest1                          - Bluetooth Test");
	// puts("BTest2                          - Bluetooth Test");
	// puts("BTest3                          - Bluetooth Test");
	// puts("Baud4                           - Bluetooth BaudRate: 115200 ");
	// puts("Baud0                           - Bluetooth BaudRate: 9600 ");
	// puts("BName                           - Bluetooth Name");
	// puts("BTestC                          - Bluetooth Test Comando");
	// puts("DSong                           - DF Player Mini Seleccion de Cancion");
	// puts("DVol                            - DF Player Mini Volumen (0-30)");
	// puts("DEQ                             - Equalizador");	
	// puts("DFolderSong                     - Reproducir una Cancion en una carpeta especifica");	
	// puts("DRe                             - Repeticion  Continua");	
	// puts("DFMP3                           - Cancion de la Carpeta MP3");	
	// puts("DFRe                            - Repeticion Continua en una carpeta");	
	// puts("DNext                           - DF Player Mini Siguiente");	
	// puts("DBack                           - DF Player Mini Anterior");	
	// puts("DPause                          - DF Player Mini Pausa");	
	// puts("DPlay                           - DF Player Mini Reproducir");		
	// puts("DStop                           - DF Player Mini Detener");		
	// puts("DRandom                         - DF Player Mini Cancion Aleatoria");	
	// puts("ServoT                          - Servomotor");	
	// puts("InfR                            - Lectura Sensor Infrarrojo");					
	// puts("InfE                            - Habilita/Deshabilita Infrarrojo");	
	// puts("USonidoI                         - Inicio Ultrasonido");
	// puts("USonidoD                         - Distancia del Ultrasonido");		
	// puts("MDir                            - Direcciones del Motor");
	// puts("MVel                            - Velocidad del Motor");	
	// puts("Mapa                            - Escribir Informacion Mapa (VGA)");		
	// puts("CColor                          - Color Promedio del objeto detectado por la camara");											
	// puts("CForma                          - Forma del objeto identificado por la camara");																				
}

static void reboot(void)
{
	ctrl_reset_write(1);
}



static int Bluetooth_Console(void){
	
	char *mensaje;
	char *token;
	
	mensaje = readstr();
	if(mensaje == NULL)return 0;
	token = get_token(&mensaje);
	
	while(bluetooth_send_available()==1){}

	bluetooth_send(strlen(token),token);
	
	return 1;

}







static void bluetooth_test_0(void){

	char *RX=0;
	int delay=uartB_get_Baudios()*2/25;
	int i=0;
	
	
	
	printf("Conecte el dispositivo");

	while(RX==0){
        RX=bluetooth_receive(7);
    }
	delay_us(delay);
	printf("%s\n",RX);

	printf("Comanmdo:");
	while(i==0){
		i=Bluetooth_Console();
	}

	delay_ms(30);
	RX=bluetooth_AT();
	printf("%s\n",RX);
	delay_us(delay);
}



static void bluetooth_test_1(void){

	char *RX=0;
	int delay=uartB_get_Baudios()*2/25;	
	
	
	printf("Conecte el dispositivo");

	while(RX==0){
        RX=bluetooth_receive(7);
    }
	delay_us(delay);
	printf("%s\n",RX);
	Clean_RX_Buffer();
	RX=0;
	printf("Envie mensaje desde el dispositivo (Espera 4 segundos):");\
	delay_ms(4000);
	while(RX==0){
        RX=bluetooth_receive_all();
    }
	printf("%s\n",RX);

	delay_ms(30);
	RX=bluetooth_AT();
	printf("%s\n",RX);
	delay_us(delay);
}



static int dfplayer_Console(char Comando){
	
	char *mensaje;
	char *token;
	
	mensaje = readstr();
	if(mensaje == NULL)return 0;
	token = get_token(&mensaje);
	
	int num = (int)strtol(token, NULL, 10);      

	while(dfplayer_send_available()==1){}

	dfplayer_command(Comando,0x00,(num>>8),((char)num));

	
	return 1;

}


static int ReadString_int(void){
	
	char *mensaje;
	char *token;
	
	mensaje = readstr();
	if(mensaje == NULL)return 0;
	token = get_token(&mensaje);
	
	int num = (int)strtol(token, NULL, 10);      

	return num;

}

static int servomotor_console(void){
	char *mensaje;
	char *token;
	
	mensaje = readstr();
	if(mensaje == NULL)return 0;
	token = get_token(&mensaje);
	
	int num = (int)strtol(token, NULL, 10);      

	servomotor_giro(num);

	
	return 1;


}



static int infrarrojo_Enable_console(void){
	char *mensaje;
	char *token;
	
	mensaje = readstr();
	if(mensaje == NULL)return 0;
	token = get_token(&mensaje);
	
	int num = (int)strtol(token, NULL, 10);      

	infrarrojo_disable(num);

	
	return 1;


}




static int motores_Dir_console(void){
	char *mensaje;
	char *token;
	
	mensaje = readstr();
	if(mensaje == NULL)return 0;
	token = get_token(&mensaje);
	
	int num = (int)strtol(token, NULL, 10);      

	MOTORES_Movimiento_write(num);
	
	return 1;


}


static int motores_Vel_console(void){
	char *mensaje;
	char *token;
	
	mensaje = readstr();
	if(mensaje == NULL)return 0;
	token = get_token(&mensaje);
	
	int num = (int)strtol(token, NULL, 10);      

	MOTORES_Duty1_write(num);
	MOTORES_Duty2_write(num);
	
	return 1;


}




static void Mapa_Console(void){



	int i=0;
	int x=0;
	int y=0;	
	printf("Casilla x:");			
	while(x==0){
		x=ReadString_int();
	}
	printf("Casilla y:");	
	while(y==0){
		y=ReadString_int();
	}
	printf("Informacion:");	
	while(i==0){
		i=ReadString_int();
	}	


	VGA_Mapa_MapaData_write(i-1);
	VGA_Mapa_MapaAddr_write((x-1)+(y-1)*8);
	VGA_Mapa_MapaWrite_write(1);
	VGA_Mapa_MapaWrite_write(0);

}





static void console_service(void)
{
	char *str;
	char *token;
	//static int Baudios=1302;
	

	str = readstr();
	if(str == NULL) return;
	token = get_token(&str);
	if(strcmp(token, "help") == 0){
		help();
	}
	else if(strcmp(token, "reboot") == 0)
		reboot();
	else if(strcmp(token, "BaudConfig") == 0){
		int i=0;
		while(i==0){
 			i=ReadString_int();
 		}
		Bluetooth_Config_Baudmode(i-1);
	}else if(strcmp(token, "BTest1") == 0){
		bluetooth_test_0();
	}else if(strcmp(token, "BTest2") == 0){
		bluetooth_test_1();
	}else if(strcmp(token, "BName") == 0){
			Bluetooth_Config_Name("PatataDoble");
	}else if(strcmp(token, "DSong") == 0){
			int i=0;
			printf("Cancion #:");
			while(i==0){
				i=dfplayer_Console(0x03);
			}
	}else if(strcmp(token, "DVol") == 0){
			int i=0;
			printf("Nivel de Volumen:");
			while(i==0){
				i=dfplayer_Console(0x06);
			}
	}else if(strcmp(token, "DEQ") == 0){
			int i=0;
			printf("Equalizador -> Normal/Pop/Rock/Jazz/Clasic/Base\n");
			printf("Equalizador:");			
			while(i==0){
				i=dfplayer_Console(0x07);
			}
	}else if(strcmp(token, "DFolderSong") == 0){
			int i=0;
			int k=0;			
			printf("Escuchar en la Carpeta #:");			
			while(i==0){
				i=ReadString_int();
			}
			printf("La cancion #:");	
			while(k==0){
				k=ReadString_int();
			}		
			dfplayer_command(0x0F,0,i,k);	
	}else if(strcmp(token, "DRe") == 0){
			int i=0;
			printf("Habilitar Repeticion Continua?:");
			while(i==0){
				i=dfplayer_Console(0x11);
			}
	}else if(strcmp(token, "DFMP3") == 0){
			int i=0;
			printf("Reproducir cancion # En la carpeta MP3");
			while(i==0){
				i=dfplayer_Console(0x12);
			}
	}else if(strcmp(token, "DFRe") == 0){
			int i=0;
			printf("Repeticion Continua de la Carpeta #:");
			while(i==0){
				i=dfplayer_Console(0x17);
			}
	}else if(strcmp(token, "DNext") == 0){
			printf("Siguiente Cancion");
			dfplayer_command(0x01,0,0,0);
			printf("\n");
	}else if(strcmp(token, "DBack") == 0){
			printf("Anterior Cancion");
			dfplayer_command(0x02,0,0,0);
			printf("\n");
	}else if(strcmp(token, "DPause") == 0){
			printf("Pausa");
			dfplayer_command(0x0E,0,0,0);
			printf("\n");
	}else if(strcmp(token, "DPlay") == 0){
			printf("Reproducir");
			dfplayer_command(0x0D,0,0,0);
			printf("\n");
	}else if(strcmp(token, "DStop") == 0){
			printf("Parar");
			dfplayer_command(0x16,0,0,0);
			printf("\n");
	}else if(strcmp(token, "DRandom") == 0){
			printf("Cancion Aleatoria");
			dfplayer_command(0x18,0,0,0);
			printf("\n");
	}
	else if(strcmp(token, "ServoT") == 0){
			printf("Angulo de Rotacion:");
			int i=0;
			while(i==0){
				i=servomotor_console();
			}
	}else if(strcmp(token, "InfR") == 0){
			
			if(infrarrojo_read()==1){
				printf("No Hay Reflejo");
				printf("\n");
			}else{
				printf("Objeto Reflejante Cercano");
				printf("\n");
			}
	}else if(strcmp(token, "InfE") == 0){
			printf("Deshabilitar Infrarrojo?:");
			int i=0;
			while(i==0){
				i=infrarrojo_Enable_console();
			}
	}
	else if(strcmp(token, "USonidoI") == 0){
			ultrasonido_inicio();
	}else if(strcmp(token, "USonidoD") == 0){
			printf("La Distancia Es:");
			int Distancia=0;
			Distancia=ultrasonido_get_distancia();
			printf("%d",Distancia);
			printf("\n");
	}else if(strcmp(token, "MDir") == 0){
			int i=0;
			printf("Direcciones -> Wait/Avanzar-Rotar-Derecha/Avanzar-Rotar-Izquierda/Avanzar/Wait/Retroceder-Rotar-Derecha/Retroceder-Rotar-Izquierda/Retroceder\n");
			printf("Direcciones:");
			while(i==0){
				i=motores_Dir_console();
			}
	}else if(strcmp(token, "MVel") == 0){
			int i=0;
			printf("Velocidad de Motores:");
			while(i==0){
				i=motores_Vel_console();
			}
	}else if(strcmp(token, "Mapa") == 0){
			Mapa_Console();
	}else if(strcmp(token, "CColor") == 0){
			if(VGA_Mapa_PromedioColor_read()==1)printf("El color del objeto es Rojo\n");
			if(VGA_Mapa_PromedioColor_read()==2)printf("El color del objeto es Verde\n");
			if(VGA_Mapa_PromedioColor_read()==3)printf("El color del objeto es Azul\n");			
			if(VGA_Mapa_PromedioColor_read()==0)printf("El color del objeto no se identifica\n");			
	}else if(strcmp(token, "CForma") == 0){
			if(VGA_Mapa_Forma_read()==1)printf("El objeto es un cuadrado\n");
			if(VGA_Mapa_Forma_read()==2)printf("El objeto es un circulo\n");
			if(VGA_Mapa_Forma_read()==3)printf("El objeto es un triangulo\n");			
			if(VGA_Mapa_Forma_read()==0)printf("La forma del objeto no se identifica\n");			
	}


	prompt();
}







int main(void)
{
	irq_setmask(0); 
	irq_setie(1);
	uart_init();

	uartB_init();
	uartA_init();
	infrarrojo_init();
	ultrasonido_init();

	puts("\nSoC - RiscV project UNAL 2021-1-- CPU testing software built "__DATE__" "__TIME__"\n");
	help();
	prompt();

	while(1) {
		console_service();
	}

	return 0;
}

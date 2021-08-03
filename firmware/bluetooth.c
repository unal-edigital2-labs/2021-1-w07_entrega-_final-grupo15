#include "bluetooth.h"
#include "delay.h"
#include <irq.h>
#include <generated/csr.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


static char RX_Buffer[32];
static char TX_Buffer[32];
static int TX_ocupado=0;
static int TX_Length=0;
static int RX_Receive=0;

static int Baudios=1302;

 
void uartB_init(void){
    
    UARTB_ev_pending_write(UARTB_ev_pending_read());
	UARTB_ev_enable_write(UARTB_EV_TXDONE | UARTB_EV_RXAVAILABLE);
	irq_setmask(irq_getmask() | (1 << UARTB_INTERRUPT));
    UARTB_Baudios_write(Baudios);

}

void uartB_Baudios(int baud){
    Baudios=baud;
	UARTB_Baudios_write(Baudios);
}

int uartB_get_Baudios(void){
    return Baudios;
}


void bluetooth_send(int length,char *Data){
	UARTB_Baudios_write(Baudios);
	
    if(TX_ocupado==TX_Length){
        TX_ocupado=0;
        for(int i=0;i<length;i++){
            TX_Buffer[i]=Data[i];
        }
        TX_Length=length;
        UARTB_TxData_write(TX_Buffer[0]);
	    UARTB_TxInit_write(1);
    }
    
    return;
	
}

int bluetooth_send_available(void){
    if(TX_ocupado==TX_Length){
        return 0;
    }else return 1;
}

char *bluetooth_receive(int lenght){

    if(RX_Receive>=lenght){
        for(int k=0;k<(32-RX_Receive);k++)RX_Buffer[RX_Receive+k]=0;
        RX_Receive=0;
	    return RX_Buffer;	
    }else return 0;
}

char *bluetooth_receive_all(void){

    RX_Receive=0;
	return RX_Buffer;	
}

void Clean_RX_Buffer(void){
    RX_Receive=0; 
    for(int k=0;k<32;k++)RX_Buffer[k]=0;
}

int bluetooth_receive_available(void){
    return RX_Receive;
}


char *bluetooth_AT(void){
    char *RX=0;
 	int delay=Baudios*2/25;

    Clean_RX_Buffer(); 
    while(bluetooth_send_available()==1){}
    bluetooth_send(strlen("AT"),"AT");
    while(RX==0){
        RX=bluetooth_receive(2);
    }

    delay_us(delay);

    return RX;


}

int bluetooth_Baud(int Baudmode){
    char *RX=0;
 	int delay=Baudios*2/25;
    int baud=1302;
    char Comando[8];
    char *BaudmodeCH=0;

    Clean_RX_Buffer(); 


    switch (Baudmode){
        case 0:
            baud=(50000000/(4*9600));
            BaudmodeCH="0";
        break;

        case 1:
            baud=(50000000/(4*19200));
            BaudmodeCH="1";
        break;

        case 2:
            baud=(50000000/(4*38400));
            BaudmodeCH="2";
        break;

        case 3:
            baud=(50000000/(4*57600));
            BaudmodeCH="3";
        break;

        case 4:
            baud=(50000000/(4*115200));
            BaudmodeCH="4";
        break;

        case 5:
            baud=(50000000/(4*4800));
            BaudmodeCH="5";
        break;

        case 6:
            baud=(50000000/(4*2400));
            BaudmodeCH="6";
        break;

        case 7:
            baud=(50000000/(4*1200));
            BaudmodeCH="7";
        break;

        case 8:
            baud=(50000000/(4*230400));
            BaudmodeCH="8";
        break;
        
    
    default:
        break;
    }

    if(baud==Baudios) return 0;

    strcat(strcpy(Comando, "AT+BAUD"), BaudmodeCH);

    while(bluetooth_send_available()==1){}
    bluetooth_send(strlen(Comando),Comando);
    while(RX==0){
        RX=bluetooth_receive(8);
    }

    delay_us(delay);
    printf("%s\n",RX);
    return baud;


}

void bluetooth_RESET(void){
    char *RX=0;
 	int delay=Baudios*2/25;

    Clean_RX_Buffer(); 
    while(bluetooth_send_available()==1){}
    bluetooth_send(strlen("AT+RESET"),"AT+RESET");
    while(RX==0){
        RX=bluetooth_receive(8);
    }

    delay_us(delay);
    return;


}

void bluetooth_NAME(char *Name){
    char *RX=0;
 	char sendName[7+strlen(Name)];
    strcat(strcpy(sendName, "AT+NAME"), Name);
 	int delay=Baudios*2/25;

    Clean_RX_Buffer(); 
    while(bluetooth_send_available()==1){}
    bluetooth_send(strlen(sendName),sendName);
    while(RX==0){
        RX=bluetooth_receive(7+strlen(Name));
    }
    printf("%s\n",RX);
    delay_us(delay);
    return;


}

void Bluetooth_Config_Baudmode(int Baudmode){
    char *RX=0;
    int baud=0;

    RX=bluetooth_AT();
    if(strcmp(RX, "OK") != 0){
	    printf("%s\n",RX);
	    return;
	}
    
    baud=bluetooth_Baud(Baudmode);
    if(baud==0){
        printf("Valor Actual");
        return;
    } 

    bluetooth_RESET();
    UARTB_Baudios_write(baud);
    Baudios=baud;

}

void Bluetooth_Config_Name(char *Name){
    char *RX=0;

    RX=bluetooth_AT();
    if(strcmp(RX, "OK") != 0){
	    printf("%s\n",RX);
	    return;
	}
    
    bluetooth_NAME(Name);

    bluetooth_RESET();

}

void uartB_isr(void){
	int stat;

	stat = UARTB_ev_pending_read();

	if(stat & UARTB_EV_RXAVAILABLE) {
    RX_Buffer[RX_Receive]=UARTB_RxData_read();
    RX_Receive=RX_Receive+1;
    if(RX_Receive==32)RX_Receive=0;
	UARTB_ev_pending_write(UARTB_EV_RXAVAILABLE);
	}

	if(stat & UARTB_EV_TXDONE) {

		UARTB_ev_pending_write(UARTB_EV_TXDONE);
        UARTB_TxInit_write(0);

        TX_ocupado=TX_ocupado+1;
        while(UARTB_TxDone_read()==1){

        }

        if(TX_ocupado!=TX_Length){
            UARTB_TxData_write(TX_Buffer[TX_ocupado]);
	        UARTB_TxInit_write(1);
        }else {
            TX_ocupado=0;
            TX_Length=0;
        }
	}

        

}

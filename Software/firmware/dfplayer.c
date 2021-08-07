#include "dfplayer.h"
#include "delay.h"
#include <irq.h>
#include <generated/csr.h>

static char RX_Buffer[32];
static char TX_Buffer[32];
static int TX_ocupado=0;
static int TX_Length=0;
static int RX_Receive=0;

static int Baudios=1302;

 
void uartA_init(void){
    
    UARTA_ev_pending_write(UARTA_ev_pending_read());
	UARTA_ev_enable_write(UARTA_EV_TXDONE | UARTA_EV_RXAVAILABLE);
	irq_setmask(irq_getmask() | (1 << UARTA_INTERRUPT));
    UARTA_Baudios_write(Baudios);

}




void dfplayer_send(char *Data){
	UARTA_Baudios_write(Baudios);
	
    if(TX_ocupado==TX_Length){
        TX_ocupado=0;
        for(int i=0;i<10;i++){
            TX_Buffer[i]=Data[i];
        }
        TX_Length=10;
        UARTA_TxData_write(TX_Buffer[0]);
	    UARTA_TxInit_write(1);
    }
    
    return;
	
}

int dfplayer_send_available(void){
    if(TX_ocupado==TX_Length){
        return 0;
    }else return 1;
}

char *dfplayer_receive(int lenght){

    if(RX_Receive>=lenght){
        for(int k=0;k<(32-RX_Receive);k++)RX_Buffer[RX_Receive+k]=0;
        RX_Receive=0;
	    return RX_Buffer;	
    }else return 0;
}

char *dfplayer_receive_all(void){

    RX_Receive=0;
	return RX_Buffer;	
}

void df_Clean_RX_Buffer(void){
    RX_Receive=0; 
    for(int k=0;k<32;k++)RX_Buffer[k]=0;
}

int dfplayer_receive_available(void){
    return RX_Receive;
}


int dfplayer_command(char Comando,char Feedback,char Param1,char Param2){
    char Arreglo[10]={0x7E,0xFF,0x06,0x00,0x00,0x00,0x00,0x00,0x00,0xEF};
	Arreglo[3]=Comando;
	Arreglo[4]=Feedback;
	Arreglo[5]=Param1;
	Arreglo[6]=Param2;

    int Checksum=0x10000;
	
	for(int i=1;i<8;i++){
		Checksum=Checksum-Arreglo[i];
	}
	
	Arreglo[7]=(char)(Checksum>>8);
	Arreglo[8]=(char)Checksum;	
	
    if(dfplayer_send_available()==0){
        dfplayer_send(Arreglo);
        return 1;
    }else return 0;

}

void uartA_isr(void){
	int stat;

	stat = UARTA_ev_pending_read();

	if(stat & UARTA_EV_RXAVAILABLE) {
    RX_Buffer[RX_Receive]=UARTA_RxData_read();
    RX_Receive=RX_Receive+1;
    if(RX_Receive==32)RX_Receive=0;
	UARTA_ev_pending_write(UARTA_EV_RXAVAILABLE);
	}

	if(stat & UARTA_EV_TXDONE) {

		UARTA_ev_pending_write(UARTA_EV_TXDONE);
        UARTA_TxInit_write(0);

        TX_ocupado=TX_ocupado+1;
        while(UARTA_TxDone_read()==1){

        }

        if(TX_ocupado!=TX_Length){
            UARTA_TxData_write(TX_Buffer[TX_ocupado]);
	        UARTA_TxInit_write(1);
        }else {
            TX_ocupado=0;
            TX_Length=0;
        }
	}

        

}
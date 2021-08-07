#ifndef _DFPLAYER
#define _DFPLAYER

#define UARTA_EV_TXDONE	        0x1
#define UARTA_EV_RXAVAILABLE	0x2

void uartA_init(void);

void dfplayer_send(char *Data);

int dfplayer_send_available(void);

char *dfplayer_receive(int lenght);

char *dfplayer_receive_all(void);

int dfplayer_receive_available(void);

void df_Clean_RX_Buffer(void);

int dfplayer_command(char Comando,char Feedback,char Param1,char Param2);

void uartA_isr(void);

#endif
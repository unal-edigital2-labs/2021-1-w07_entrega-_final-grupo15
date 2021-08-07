#ifndef _BLUETOOTH
#define _BLUETOOTH

#define UARTB_EV_TXDONE	        0x1
#define UARTB_EV_RXAVAILABLE	0x2

void uartB_init(void);

void uartB_Baudios(int baud);

int uartB_get_Baudios(void);

void bluetooth_send(int length,char *Data);

int bluetooth_send_available(void);

char *bluetooth_receive(int lenght);

char *bluetooth_receive_all(void);

int bluetooth_receive_available(void);

void Clean_RX_Buffer(void);

void Bluetooth_Config_Baudmode(int Baudmode);

char *bluetooth_AT(void);

int bluetooth_Baud(int baud);

void bluetooth_RESET(void);

void bluetooth_NAME(char *Name);

void Bluetooth_Config_Name(char *Name);

void uartB_isr(void);

#endif

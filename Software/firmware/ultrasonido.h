#ifndef _ULTRASONIDO
#define _ULTRASONIDO

#define ULTRASONIDO_EV_DONE        0x1

void ultrasonido_init(void);

int ultrasonido_get_distancia(void);

void ultrasonido_inicio(void);

void ultrasonido_isr(void);

#endif
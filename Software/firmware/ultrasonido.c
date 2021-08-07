#include "ultrasonido.h"
#include "delay.h"
#include <irq.h>
#include <generated/csr.h>

static int Distancia;
 
void ultrasonido_init(void){
    
    ULTRASONIDO_ev_pending_write(ULTRASONIDO_ev_pending_read());
	ULTRASONIDO_ev_enable_write(ULTRASONIDO_EV_DONE);
	irq_setmask(irq_getmask() | (1 << ULTRASONIDO_INTERRUPT));

}


void ultrasonido_inicio(void){
    ULTRASONIDO_Inicio_write(1);
}

int ultrasonido_get_distancia(void){
    return Distancia;
}



void ultrasonido_isr(void){
	int stat;

	stat = ULTRASONIDO_ev_pending_read();


	if(stat & ULTRASONIDO_EV_DONE) {
		ULTRASONIDO_ev_pending_write(ULTRASONIDO_EV_DONE);
        ULTRASONIDO_Inicio_write(0);
        Distancia=ULTRASONIDO_Distancia_read();
	}

        

}
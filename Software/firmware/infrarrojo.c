#include "infrarrojo.h"
#include "delay.h"
#include <irq.h>
#include <generated/csr.h>
#include <stdio.h>

void infrarrojo_init(void){
    
    INF_ev_pending_write(INF_ev_pending_read());
	INF_ev_enable_write(INF_EV_REFLECT);
	irq_setmask(irq_getmask() | (1 << INF_INTERRUPT));

}

void infrarrojo_disable(int disable){
	INF_Datain_write(disable);
	INF_Control_write(disable);
}

int infrarrojo_read(void){
	return INF_Dataout_read();
}


void infrarrojo_isr(void){
	int stat;
	irq_setie(0);
	stat = INF_ev_pending_read();

	

	if(stat & INF_EV_REFLECT) {

		INF_ev_pending_write(INF_EV_REFLECT);
        uart_write('x');
	}

        
		irq_setie(1);
}

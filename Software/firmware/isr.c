#include <generated/csr.h>
#include <irq.h>
#include <uart.h>
#include <stdio.h>

#include "bluetooth.h"
#include "dfplayer.h"
#include "infrarrojo.h"
#include "ultrasonido.h"

extern void periodic_isr(void);

void isr(void);
void isr(void)
{
	unsigned int irqs;

	irqs = irq_pending() & irq_getmask();


	if(irqs & (1 << UART_INTERRUPT))
		uart_isr();


	if(irqs & (1 << UARTB_INTERRUPT)){
		uartB_isr();
	}

	if(irqs & (1 << UARTA_INTERRUPT)){
		uartA_isr();
	}

	if(irqs & (1 << INF_INTERRUPT)){
		infrarrojo_isr();
	}

	if(irqs & (1 << ULTRASONIDO_INTERRUPT)){
		ultrasonido_isr();
	}
}

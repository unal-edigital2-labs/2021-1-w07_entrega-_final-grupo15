#include "servomotor.h"
#include <irq.h>
#include <generated/csr.h>


void servomotor_giro(int grados){
	SERVO_Periodo_write(250-1);
	SERVO_Ciclo_write(100-1+2*grados);
}
module Motores(
	input Clock,
	input Reset,
	input [2:0] Movimiento,
	input [6:0] Duty1,
	input [6:0] Duty2,
	output PWM1,
	output PWM2,
	output [1:0] MotorA,
	output [1:0] MotorB
);


PWM First(Clock, Reset, Duty1, PWM1);
PWM Second(Clock, Reset, Duty2, PWM2);
Direcciones Dir(Movimiento, MotorA, MotorB);

endmodule 
